unit gtTypes;

interface

uses
 xmlIntf;

type
 TgtTimer = class(TObject)
 private
  f_TimeSheet: IXMLDocument;
  f_Root: IXMLNode;
  f_Started: Boolean;
  function AddDay: IXMLNode;
  function AddMonth: IXMLNode;
  procedure StartPeriod;
  procedure StopPeriod;
  function GetDayName: string;
  procedure GetDaySheet(aDay: IXMLNode; out theSheet: Integer);
  function GetMonthName: string;
  function pm_GetIsStarted: Boolean;
 public
  constructor Create;
  destructor Destroy; override;
  function DaySheet(out theSheet, theGarSheet: Integer): string;
  procedure LoadFromFile(const aFileName: String);
  function MonthSheet(out theSheet, theGarSheet: Integer; aTotal: Boolean): string;
  procedure Pause;
  procedure SaveToFile(const aFileName: String);
  procedure Start;
  procedure Stop;
  function MinutesToString(aMinutes: Int64): ShortString;
  property IsStarted: Boolean read pm_GetIsStarted;
 end;

implementation

uses
 XMLDoc, SysUtils, DateUtils, StrUtils;

constructor TgtTimer.Create;
begin
 inherited;
 f_TimeSheet:= TXMLDocument.Create(nil);
 f_TimeSheet.Options:= f_TimeSheet.Options + [doNodeAutoCreate, doNodeAutoIndent];
 f_TimeSheet.Active:= True;
 f_Root:= f_TimeSheet.AddChild('GarTimeDataFile');
 f_Started:= False;
end;

destructor TgtTimer.Destroy;
begin
 f_TimeSheet:= nil;
 inherited;
end;

function TgtTimer.AddDay: IXMLNode;
var
 l_Month: IXMLNode;
 l_Day: IXMLNode;
begin
 l_Month:= AddMonth;
 l_Day:= l_Month.ChildNodes.FindNode(GetDayName);
 if l_Day = nil then
 begin
  l_Day:= l_Month.AddChild(GetDayName);
  l_Day.AddChild('Periods');
 end;
 Result:= l_Day;
end;

function TgtTimer.AddMonth: IXMLNode;
var
 l_Months, l_Month, l_Name, l_N3: IXMLNode;
 i: Integer;
begin
 l_Months:= f_Root.ChildNodes.FindNode('Months'); { ������ ������ ������� }
 if l_Months = nil then
  l_Months:= f_Root.AddChild('Months');
 for i:= 0 to Pred(l_Months.ChildNodes.Count) do
 begin
  l_Month:= l_Months.ChildNodes[i];
  if l_Month.GetNodeType = ntElement then
  begin
   l_Name:= l_Month.ChildNodes.Nodes['Name'];
   if l_Name.Text = GetMonthName then
   begin
    Result:= l_Month;
    break;
   end;
  end;
 end; //for i
 if Result = nil then
 begin
  l_Month:= l_Months.AddChild('Month');
  l_Name:= l_Month.AddChild('Name');
  l_Name.Text:= GetMonthName;
  Result:= l_Month;
 end; // l_N = nil
end;

function TgtTimer.DaySheet(out theSheet, theGarSheet: Integer): string;
var
 l_Day: IXMLNode;
 l_Sheet, l_Min: Integer;
begin
 Result := '';
 theSheet:= 0;
 l_Day:= AddDay;
 GetDaySheet(l_Day, l_Sheet);
 l_day.SetAttribute('Worked', l_Sheet);
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

procedure TgtTimer.StartPeriod;
var
 l_Date: String;
begin
 l_date:= DateTimeToStr(Now);
 with AddDay.ChildNodes.FindNode('Periods').AddChild('Period') do
 begin
  AddChild('Start').Text:= l_Date;
  AddChild('Stop').Text:= '';
 end;
end;

procedure TgtTimer.StopPeriod;
var
 l_Date: String;
 l_Day, l_Period: IXMLNode;
 i: Integer;
begin
 l_Date:= DateTimeToStr(Now);
 l_Day:= AddDay.ChildNodes.FindNode('Periods');
 for i:= 0 to Pred(l_Day.ChildNodes.Count) do
 begin
  l_Period:= l_Day.ChildNodes[i];
  if l_Period.NodeType = ntElement then
  begin
   if l_Period.ChildNodes.FindNode('Stop').Text = '' then
   begin
    l_Period.ChildNodes.FindNode('Stop').Text:= l_Date;
    break;
   end;
  end;
 end; // for i
end;

function TgtTimer.GetDayName: string;
begin
 Result := Format('Day%d', [DayOf(Date)]);
end;

procedure TgtTimer.GetDaySheet(aDay: IXMLNode; out theSheet: Integer);
var
 i: Integer;
 l_Periods: IXMLNode;
 l_Period: IXMLNode;
 l_Start: String;
 l_Stop: String;
 l_StartDT: TDateTime;
 l_StopDT: TDateTime;
begin
 l_Periods:= aDay.ChildNodes.FindNode('Periods');
 theSheet:= 0;
 for i:= 0 to Pred(l_Periods.ChildNodes.Count) do
 begin
  l_Period:= l_Periods.ChildNodes[i];
  if l_Period.NodeType = ntElement then
  begin
   l_Start:= l_Period.ChildNodes.FindNode('Start').Text;
   l_StartDT:= StrToDateTime(l_Start);
   if l_Period.ChildNodes.FindNode('Stop') <> nil then
    l_Stop:= l_Period.ChildNodes.FindNode('Stop').Text
   else
    l_Stop:= '';
   if l_Stop = '' then
    if SameDate(Date, l_StartDT) then
     l_StopDT:= Now
    else
     l_StopDT:= l_StartDT
   else
    l_StopDT:= StrToDateTime(l_Stop);
   Inc(theSheet, MinutesBetween(l_StopDT, l_StartDT));
  end;
 end; // for i;
end;

function TgtTimer.GetMonthName: string;
begin
 Result := Format('%d-%d', [YearOf(Date), MonthOf(Date)]);
end;

function TgtTimer.pm_GetIsStarted: Boolean;
begin
 Result := f_Started;
end;

procedure TgtTimer.LoadFromFile(const aFileName: String);
begin
 f_TimeSheet.LoadFromFile(aFileName);
 f_Root:= f_TimeSheet.Node.ChildNodes.First;
end;

function TgtTimer.MonthSheet(out theSheet, theGarSheet: Integer; aTotal: Boolean): string;
var
 l_Month, l_Day: IXMLNode;
 i, l_Sheet, l_DayCount: Integer;
 l_Temp: String;
begin
 // ��������� ���������� �����: 8*60*���� - �����_�����_��_�����
 Result := '';
 l_temp:= DaySheet(theSheet, theGarSheet);
// theSheet:= 0;
 l_DayCount:= 1;
 l_Month:= AddMonth;
 for i:= 0 to Pred(l_Month.ChildNodes.Count) do
 begin
  l_Day:= l_Month.ChildNodes[i];
  if (l_Day.GetNodeType = ntElement) and AnsiStartsText('Day', l_Day.NodeName) and (l_Day.NodeName <> GetDayName) then
  begin
   GetDaySheet(l_Day, l_Sheet);
   if l_Sheet <> 0 then
   begin
    Inc(theSheet, l_Sheet);
    Inc(l_DayCount);
   end; // l_Sheet <> 0
  end;
 end; //for i
 if not aTotal then
  theSheet:= theSheet - l_dayCount*8*60;
 Result:= MinutesToString(theSheet);
end;

procedure TgtTimer.Pause;
begin
 StopPeriod;
end;

procedure TgtTimer.SaveToFile(const aFileName: String);
begin
 f_TimeSheet.SaveToFile(aFileName);
end;

procedure TgtTimer.Start;
begin
 AddMonth;
 AddDay;
 StartPeriod;
 f_Started:= True;
end;

procedure TgtTimer.Stop;
begin
 if IsStarted then
  StopPeriod;
 f_Started:= False;
end;

function TgtTimer.MinutesToString(aMinutes: Int64): ShortString;
var
 l_Day, l_Hour, l_Min: Longint;
begin
  l_Day:= aMinutes div (24*60);
  l_Hour:= (aMinutes mod (24*60)) div 60;
  l_Min:=  (aMinutes mod (24*60)) mod 60;
  if l_Day > 1 then
   Result:= Format('%2d ��� %2d ���', [l_Day, Abs(l_Hour)])
  else
  if Abs(l_Hour) > 0 then
   Result:= Format('%2d ��� %2d ���', [l_Hour, Abs(l_Min)])
  else
  if Abs(l_Min) > 0 then
   Result:= Format('%2d ���', [l_Min])
  else
    Result:= '������ ������';
end;

end.
