unit gtIssues;

{ Разбивка рабочего времени по задачам }

interface

Uses
  Classes,
  SQliteTable3;

type
 TgtIssues = class
 private
   f_DB: TSQLiteDataBase;
 private
   procedure CheckDB;
 public
   constructor Create(aDB: TSQLiteDatabase);
   destructor Destroy; override;
   function GetActiveIssue: String;
   procedure Start(const IssueID: String);
   procedure Pause(const IssueID: String);
   procedure Finish(const IssueID: String; const Comment: String); overload;
   procedure Finish(const Comment: String); overload;
   procedure FillDayReport(aReport: TStrings);
   procedure ResumeIssue;
 end;

implementation

Uses
 SysUtils;

const
  IssueTable     = 'Issues';
  IssueTimeTable = 'IssuesTime';

{ TgtIssues }

procedure TgtIssues.CheckDB;
var
 l_SQL: String;
begin
  if not f_DB.TableExists(IssueTable) then
  begin
    // Задачи
    l_SQL := Format('CREATE TABLE %s ([ID] INTEGER PRIMARY KEY, [Issue] int not null, ', [IssueTable]);
    l_SQL := l_SQL + '[Active] int null, [Closed] int null);';
    f_db.execsql(l_SQL);
    f_db.execsql(Format('CREATE INDEX %sIndex ON [%s]([Issue]);', [IssueTable, IssueTable]));
    // Время по задачам
    l_SQL:= Format('CREATE TABLE %s ([ID] INTEGER PRIMARY KEY, [IssueID] int not null, [TimeID] int not null, [Comment] varchar(100))', [IssueTimeTable]);
    f_DB.ExecSQL(l_SQL);
  end; // not TableExists
end;

constructor TgtIssues.Create;
begin
  inherited Create;
  f_DB:= aDB;
  CheckDB;
end;

destructor TgtIssues.Destroy;
begin

  inherited;
end;

procedure TgtIssues.FillDayReport(aReport: TStrings);
var
 l_Table: TSQLiteTable;
 l_SQL: String;

begin
  // Построение списка задач за сегодня
  l_SQL:= 'select t.issueid as "Задача", CAST(Sum(t.worktime) as float) / 60  as "часы" from ' +
  '(Select it.Issueid, SUM(strftime("%s",ifnull(FinishTime, time("now", "localtime")))-strftime("%s",[StartTime])) / 60 as "WorkTime" ' +
  'from issuestime as it ' +
  'join timesheet as ts on ts.id = it.timeid ' +
  'where StartDate = date("now") ' +
  'group by it.issueid, it.timeid ' +
  'order by it.issueid) t ' +
  'group by t.issueid';
  aReport.Clear;
  with f_DB do
  begin
    l_Table:= GetTable(l_SQL);
    try
      while not l_Table.EOF do
      begin
       aReport.Add(Format('http://ws2.medwork.ru:33380/redmine/issues/%s %4.2f ч', [l_Table.FieldAsString(0), l_Table.FieldAsDouble(1)]));
       l_Table.Next;
      end; // while
    finally
      FreeAndNil(l_Table);
    end;
  end;
end;

procedure TgtIssues.Finish(const Comment: String);
begin
  Finish(GetActiveIssue, Comment);
end;

function TgtIssues.GetActiveIssue: String;
var
 l_Table: TSQLiteTable;
begin
  Result:= '';
  with f_DB do
  begin
    l_Table:= GetTable('SELECT Issue FROM Issues WHERE Active = 1');
    try
      if l_Table.Count > 0 then
        Result:= l_Table.FieldAsString(l_Table.FieldIndex['Issue']);
    finally
      FreeAndNil(l_Table);
    end;
  end;
end;

procedure TgtIssues.Finish(const IssueID, Comment: String);
var
 l_Table, l_Table2: TSQLiteTable;
 l_ID: Integer;
begin
  {
  1. Ищем активную задачу с IssueID
  2. Добавляем ей комментарий и сбрасываем Active
  }
  with f_DB do
  begin
    ParamsClear;
    AddParamText(':Issue', IssueID);
    l_Table:= GetTable('SELECT ID FROM Issues WHERE Issue = :Issue and Active = 1');
    if l_Table.Count > 0 then
    begin
      BeginTransaction;
      try
        ParamsClear;
        AddParamText(':ID', l_Table.FieldByName['ID']);
        ExecSQL('UPDATE Issues SET Active = 0 WHERE ID = :ID');
        // Комментарий в таблице IssuesTime. Нужно найти последний интервал у задачи
        ParamsClear;
        AddParamText(':Issue', IssueID);
        l_Table2:= GetTable('SELECT ID FROM IssuesTime WHERE IssueID = :Issue ORDER BY ID DESC LIMIT 1');
        try
          l_ID:= l_Table2.FieldAsInteger(l_Table2.FieldIndex['ID']);
        finally
          FreeAndNil(l_Table2);
        end;
        ParamsClear;
        AddParamText(':Comment', Comment);
        AddParamInt(':ID', l_ID);
        ExecSQL('UPDATE IssuesTime SET Comment = :Comment WHERE ID = :ID');
        Commit;
      except
        Rollback;
      end;
    end
    else
      raise Exception.CreateFmt('Задача %s неактивна', [IssueID]);
  end; // with f_DB
end;

procedure TgtIssues.Pause(const IssueID: String);
begin

end;

procedure TgtIssues.ResumeIssue;
var
 l_Issue: String;
begin
  l_Issue:= GetActiveIssue;
  if l_Issue <> '' then
   Start(l_Issue);
end;

procedure TgtIssues.Start(const IssueID: String);
var
  l_SQL: String;
  l_Table: TSQLiteTable;
  l_TimeID: String;
  l_NeedAdd: Boolean;
  l_ActiveIssue: String;
begin
  { 1. Ищем открытую задачу (Active = 1)
    2. Тормозим ее, если находим Active = 0
    3. Добавляем запись про переданную Active = 1
  }
  with f_DB do
  begin

    l_ActiveIssue:= GetActiveIssue;
    if (l_ActiveIssue <> '') and (l_ActiveIssue <> IssueID) then
      Finish(l_Table.FieldByName['Issue'], Format('Переключение на задачу %s', [IssueID]));

    l_SQL:= 'SELECT ID FROM TimeSheet ORDER BY id DESC LIMIT 1';
    l_Table:= GetTable(l_SQL);
    try
      if l_Table.Count > 0 then
       l_TimeID:= l_Table.FieldAsString(l_Table.FieldIndex['ID']);
    finally
      FreeAndNil(l_Table);
    end;
    // нельзя добавлять повторы задач
    BeginTransaction;
    try
      ParamsClear;
      AddParamText(':Issue', IssueID);
      l_SQL:= 'SELECT Issue FROM Issues where Issue = :Issue';
      l_Table:= GetTable(l_SQL);
      try
        if l_Table.Count = 0 then
        begin
          ParamsClear;
          AddParamText(':Issue', IssueID);
          l_SQL:= Format('INSERT INTO %s (Issue, Active) Values (:Issue, 1)', [IssueTable]);
          ExecSQL(l_SQL);
        end; // l_Table.Count = 0
      finally
        FreeAndNil(l_Table);
      end;
      ParamsClear;
      AddParamText(':Issue', IssueID);
      AddParamText(':Time', l_TimeID);
      l_SQL:= Format('INSERT INTO %s (IssueID, TimeID) Values(:Issue, :Time)', [IssueTimeTable]);
      ExecSQL(l_SQL);
      Commit;
    except
      Rollback;
    end;
  end; // with f_DB
end;

end.
