unit gtSQL;
{ Классы для работы с MySQL }

interface
Uses
  gtIntfs,
  SQLiteTable3;


type
 IgtSQLTimer = interface
   ['{A3A957BA-DF92-4548-B8DC-AA213AD3EF85}']
   function GetSQLiteDatabase: TSQLiteDatabase;
   property DB: TSQLiteDatabase read GetSQLiteDatabase;
 end;


 TgtSQLTimer = class(TInterfacedObject, IgtTimer, IgtSQLTimer)
 private
  f_DB: TSQLiteDatabase;
  f_Started: Boolean;
  function GetIsStarted: Boolean;
  procedure MigrateFromXML;
  procedure StartPeriod(aDate: TDateTime);
  procedure StopPeriod(aDate: TDateTime);
  function GetSQLiteDatabase: TSQLiteDatabase;
 public
  constructor Create;
  destructor Destroy; override;
  function DaySheet(out theSheet, theGarSheet: Integer): string;
  function MonthSheet(out theSheet, theGarSheet: Integer; aTotal: Boolean): string;
  procedure Pause;
  procedure Start;
  procedure Stop;
  property IsStarted: Boolean read GetIsStarted;
 end;



implementation

Uses
 gtUtils,
 SysUtils, XMLDoc, XMLIntf, DateUtils, StrUtils;


function lp_MakeDate(aDate: TDateTime): String;
var
 l_D, l_M, l_Y: Word;
begin
  DecodeDate(aDate, l_Y, l_M, l_D);
  Result:= Format('%.4d-%.2d-%.2d', [l_Y, l_M, l_D]);
end;

function lp_MakeTime(aTime: TDateTime): String;
var
 l_H, l_M, l_S, l_SS: Word;
begin
  DecodeTime(aTime, l_H, l_M, l_S, l_SS);
  Result:= Format('%.2d:%.2d:%.2d', [l_H, l_M, l_S]);
end;



{ TgtSQLTimer }

constructor TgtSQLTimer.Create;
begin
  inherited;
  f_DB:= TSQLiteDatabase.Create(ChangeFileExt(ParamStr(0), '.db'));
  MigrateFromXML;
  f_Started:= False;
end;

function TgtSQLTimer.DaySheet(out theSheet, theGarSheet: Integer): string;
var
 l_SQL: String;
 l_Sheet: Int64;
 l_Table: TSQLiteTable;
begin
 Result:= '';
 theSheet:= 0;
 theGarSheet:= 0;
 l_SQL:= 'select SUM(strftime("%s",ifnull(FinishTime, time("now", "localtime")))-strftime("%s",[StartTime])) / 60 as WorkTime ' +
        'from TimeSheet where StartDate = date("now")';
 // Нужно получить l_Sheet
 l_Table:= f_DB.GetTable(l_SQL);
 try
   if l_Table.Count > 0 then
     l_Sheet:= l_Table.FieldAsInteger(0); //  Время, сохраненное в базе
 finally
   FreeAndNil(l_Table);
 end;
 Result:= MinutesToString(l_Sheet);
 theSheet:= l_Sheet;
 {$IFDEF GarTime}
 l_Min:= l_Sheet mod 60;
 Inc(l_Min, ifThen(l_Min >= 30, 60-l_Min, -l_Min));
 theGarSheet:= l_Min;
 {$ELSE}
 theGarSheet:= theSheet;
 {$ENDIF}
end;

destructor TgtSQLTimer.Destroy;
begin
  FreeAndNil(f_DB);
  inherited;
end;

function TgtSQLTimer.GetIsStarted: Boolean;
begin
  Result:= f_Started;
end;

function TgtSQLTimer.GetSQLiteDatabase: TSQLiteDatabase;
begin
  Result:= f_DB;
end;

function TgtSQLTimer.MonthSheet(out theSheet, theGarSheet: Integer;
  aTotal: Boolean): string;
var
 l_SQL: String;
 l_Month, l_Day: IXMLNode;
 i, l_Sheet, l_DayCount: Integer;
 l_Temp: String;
 l_Table: TSQLiteTable;
begin
// Количество минут за текущий месяц
  l_SQL:= 'select SUM(strftime("%s",ifnull(FinishTime, time("now", "localtime")))-strftime("%s",[StartTime])) / 60 as WorkTime from TimeSheet '+
 'where StartDate >= date("now","start of month") and StartDate <= date("now","start of month","+1 month","-1 day")';
 //получаем theSheet
 l_Table:= f_DB.GetTable(l_SQL);
 try
   if l_Table.Count > 0 then
    theSheet:= l_Table.FieldAsInteger(0);
 finally
   FreeAndNil(l_Table);
 end;
 // Посчитать количество долга: 8*60*Дней - Всего_минут_за_месяц
 Result := '';
 l_temp:= DaySheet(l_Sheet, theGarSheet);
 l_DayCount:= 1;

 // l_DayCount - количество строк запроса
 l_SQL:= 'select Distinct StartDate from TimeSheet where StartDate >= date("now","start of month") '+
          'and StartDate <= date("now","start of month","+1 month","-1 day")';
 l_Table:= f_DB.GetTable(l_SQL);
 try
   l_DayCount:= l_Table.Count;
 finally
   FreeAndNil(l_Table);
 end;

 if not aTotal then
  theSheet:= theSheet - l_dayCount*8*60;
 Result:= MinutesToString(theSheet);
end;

procedure TgtSQLTimer.Pause;
begin

end;


procedure TgtSQLTimer.Start;
begin
 StartPeriod(Now);
 f_Started:= True;
end;

procedure TgtSQLTimer.Stop;
begin
  StopPeriod(Now);
  f_Started:= False;
end;

procedure TgtSQLTimer.StartPeriod(aDate: TDateTime);
begin
  with f_DB do
  begin
    // Контроль закрытия
    StopPeriod(IncSecond(aDate, -1));
    BeginTransaction;
    try
      ParamsClear;
      AddParamText(':StartDate', lp_MakeDate(aDate));
      AddParamText(':StartTime', lp_MakeTime(aDate));
      ExecSQL('INSERT INTO TimeSheet (StartDate, StartTime) Values(:StartDate, :StartTime)');
      Commit;
    except
      Rollback;
    end;
  end;
end;

procedure TgtSQLTimer.StopPeriod(aDate: TDateTime);
begin
  with f_DB do
  begin
    BeginTransaction;
    try
      ParamsClear;
      AddParamText(':FinishDate', lp_MakeDate(aDate));
      AddParamText(':FinishTime', lp_MakeTime(aDate));
      ExecSQL('UPDATE TimeSheet SET FinishDate = :FinishDate, FinishTime = :FinishTime WHERE id = (SELECT ID FROM TimeSheet WHERE FinishDate is NULL ORDER BY id DESC LIMIT 1)');
      Commit;
    except
      Rollback;
    end;
  end;
end;


procedure TgtSQLTimer.MigrateFromXML;
var
  sSQL: String;
  l_XML: IXMLDocument;
  l_Root, l_Months, l_Month, l_Day, l_Node, l_Periods, l_Period: IXMLNode;
  i, j, k: Integer;
  l_Start: String;
  l_Stop: String;
  l_DatFile: String;
begin
  { 1. Создаем таблицу, если ее нет
    2. Проверяем есть ли данные, и переливаем их }
    // Создание
  if not f_db.TableExists('TimeSheet') then
  begin
    sSQL := 'CREATE TABLE TimeSheet ([ID] INTEGER PRIMARY KEY, [StartDate] DATE NOT NULL, [StartTime] TIME NOT NULL,';
    sSQL := sSQL + '[FinishDate] DATE NULL, [FinishTime] TIME NULL);';
    f_db.execsql(sSQL);
    f_db.execsql('CREATE INDEX TimeSheetIndex ON [TimeSheet]([StartDate]);');


    l_DatFile:= ChangeFileExt(ParamStr(0), '.dat');
    if FileExists(l_DatFile) then
    begin
      l_XML:= TXMLDocument.Create(nil);
      try
        l_XML.LoadFromFile(l_DatFile);
        l_XMl.Active:= True;
        l_Root:= l_XML.Node.ChildNodes.First;//l_XML.Node.ChildNodes.FindNode('GarTimeDataFile');
        if l_Root <> nil then
        begin
          l_Months:= l_Root.ChildNodes.FindNode('Months');
          if l_Months <> nil then
          begin
            for I := 0 to l_Months.ChildNodes.Count - 1 do
            begin
              l_Month:= l_Months.ChildNodes.Get(i);
              for j := 0 to l_Month.ChildNodes.Count - 1 do
              begin
                l_Day:= l_Month.ChildNodes.Get(j);
                if (l_Day.GetNodeType = ntElement) and AnsiStartsText('Day', l_Day.NodeName) then
                begin
                  l_Periods:= l_Day.ChildNodes.FindNode('Periods');
                  for k:= 0 to Pred(l_Periods.ChildNodes.Count) do
                  begin
                   l_Period:= l_Periods.ChildNodes[k];
                   if l_Period.NodeType = ntElement then
                   begin
                     l_Start:= l_Period.ChildNodes.FindNode('Start').Text;
                     StartPeriod(StrToDateTime(l_Start));
                     if l_Period.ChildNodes.FindNode('Stop') <> nil then
                       l_Stop:= l_Period.ChildNodes.FindNode('Stop').Text
                     else
                       l_Stop:= '';
                     if l_Stop <> '' then
                       StopPeriod(StrToDateTime(l_Stop));
                   end;
                  end; // for k;
                end; // StartsDay
              end; // for j
            end; // for i
          end; // l_Months <> nil
        end; // l_Root <> nil
      finally
        l_XML:= nil;
      end;
    end;
  end; // not exist table
end;

end.
