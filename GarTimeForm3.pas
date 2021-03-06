unit GarTimeForm3;

interface
{$DEFINE GarTime} // ��� ������������� � Confluence ����� ��������
{.$DEFINE Issues}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ActnList, ImgList, AppEvnts,
  CoolTrayIcon, AutoRunner, gtIntfs, System.ImageList, System.Actions
  {$IFDEF Issues}
  , gtIssues
  {$ENDIF}
  {$IFDEF GarTime}
  , Propertys
  {$ENDIF};

type
  TMainForm = class(TForm)
    actExit: TAction;
    GTActions: TActionList;
    actShowStatistic: TAction;
    actStart: TAction;
    actStop: TAction;
    AppEvents: TApplicationEvents;
    IconImages: TImageList;
    itemExit: TMenuItem;
    itemStartStop: TMenuItem;
    timeUpdate: TTimer;
    TrayIcon: TCoolTrayIcon;
    TrayMenu: TPopupMenu;
    actConfig: TAction;
    DividerItem: TMenuItem;
    actStartIssue: TAction;
    actFinishIssue: TAction;
    actDailyReport: TAction;
    procedure actConfigExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actShowExecute(Sender: TObject);
    procedure actShowStatisticExecute(Sender: TObject);
    procedure AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure AppEventsMinimize(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure timeUpdateTimer(Sender: TObject);
    procedure TrayIconStartup(Sender: TObject; var ShowMainForm: Boolean);
    procedure actStartIssueExecute(Sender: TObject);
    procedure actFinishIssueExecute(Sender: TObject);
    procedure actDailyReportExecute(Sender: TObject);
  private
    f_AutoRunner: TAutoRunner;
    f_CanClose: Boolean;
    {$IFDEF GarTime}
    f_Config: TProperties;
    {$ENDIF}
    {$IFDEF Issues}
    f_Issues: TgtIssues;
    {$ENDIF}
    f_HomeStr: string;
    f_MonthTimeStr: string;
    f_RealTimeStr: string;
    f_ShowBalloon: Boolean;
    f_Timer: IgtTimer;
    procedure CreateConfig;
    procedure DestroyConfig;
    function GetHint: string;
    function getHoursStr(aHours: Word): string;
    procedure HideMainForm;
    procedure LoadDayInfo;
    procedure pause;
    procedure SaveDayInfo;
    procedure ShowMainForm;
    procedure Start;
    function Started: Boolean;
    procedure Stop;
    procedure SwitchMDPStatus(aStatus: Integer);
    procedure UpdateDayInfo;
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure CreateTrayMenu;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

Uses
 DateUtils, Math, StrUtils,
 IdHTTP,
 jwaWTSApi32,
 gtSQL, gtUtils,
 ddLogFile
 {$IFDEF Issues}
 ,gtIssueCloseDlg, gtReportForm, gtIssueOpenDlg
 {$ENDIF}
 {$IFDEF GarTime}
 , PropertyUtils
 {$ENDIF}
  ;

const
 mdpStart = 1;
 mdpStop  = 2;

procedure TMainForm.actConfigExecute(Sender: TObject);
begin
 {$IFDEF GarTime}
 if ShowPropDialog('��������� ����������', f_Config) then
  SaveToFile(ChangeFileExt(Application.ExeName, '.config'), f_Config, False);
 {$ENDIF}
end;

procedure TMainForm.actDailyReportExecute(Sender: TObject);
begin
  {$IFDEF Issues}
  // ������ � ���������� ����� �� ����
  with TDailyReportForm.Create(nil) do
  try
   Execute(f_Issues);
   //f_Issues.FillDayReport(ReportList.Items);
   //ShowModal;
  finally
    Free;
  end;
  {$ENDIF}
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
 f_CanClose:= True;
 Close;
end;

procedure TMainForm.actFinishIssueExecute(Sender: TObject);
var
 l_Comment: String;
 l_Close: Boolean;
begin
  {$IFDEF Issues}
  if IssueCloseDlg(l_Comment, l_Close) then
  begin
    f_Timer.Stop;
    f_Issues.Finish(l_Comment);
    f_Timer.Start;
  end;
  {$ENDIF}
end;

procedure TMainForm.actShowExecute(Sender: TObject);
begin
 ShowMainForm;
end;

procedure TMainForm.actShowStatisticExecute(Sender: TObject);
begin
 
 TrayIcon.ShowBalloonHint('���� �������� �������',
                          Format({$IFDEF Issues}'������: %s'#10'�������: %s'#10'%s'#10'����� �: %s'{$ELSE}'�������: %s'#10'%s'#10'����� �: %s'{$ENDIF},
                         [{$IFDEF Issues}f_Issues.GetActiveIssue,{$ENDIF} f_RealTimeStr, f_MonthTimeStr, f_HomeStr]), bitInfo, 30);
end;

procedure TMainForm.actStartIssueExecute(Sender: TObject);
var
 l_Issue, l_ActiveIssue, l_Title: String;
begin
 {$IFDEF Issues}
 with TIssueOpenDialog.Create(nil) do
 try
   if Execute(f_Issues, l_Issue, l_Title) then
   begin
    Stop;
    l_ActiveIssue:= f_Issues.GetActiveIssue;
    if (l_ActiveIssue <> '') and (l_Issue <> l_ActiveIssue) then
      f_Issues.Finish('������������ �� ������ ������');
    Start;
    f_Issues.Start(l_Issue, l_Title);
   end;
 finally
   Free;
 end;
 {$ENDIF}
end;

{$IFDEF Debug}
const
  WTS_NAMES : array[1..8] of String =
  ('WTS_CONSOLE_CONNECT', 'WTS_CONSOLE_DISCONNECT',
  'WTS_REMOTE_CONNECT','WTS_REMOTE_DISCONNECT',
  'WTS_SESSION_LOGON','WTS_SESSION_LOGOFF',
  'WTS_SESSION_LOCK','WTS_SESSION_UNLOCK');
{$ENDIF}
procedure TMainForm.AppEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);

procedure lp_Start;
begin
  Start;
  {$IFDEF Issues}f_Issues.ResumeIssue;{$ENDIF}
end;

var
  S : String;
begin
  {$IFDEF Debug}
  case Msg.WParam of
    //WTS_CONSOLE_CONNECT: S := 'A new session #%d was connected to the local console.';
    WTS_CONSOLE_DISCONNECT: S := 'The session #%d was removed from the local console.';

    WTS_REMOTE_CONNECT : S := 'A new session #%d was connected to the remote console.';
    WTS_REMOTE_DISCONNECT: S := 'The session #%d was removed from the remote console.';
    WTS_SESSION_LOGON: S := 'A user has logged on to the session #%d.';
    WTS_SESSION_LOGOFF: S := 'A user logged off. Session #%d';

    //These messages are not send, if the winlogon desktop is shown without
    //password input
    WTS_SESSION_LOCK: S := 'The session #%d is locked.';
    WTS_SESSION_UNLOCK: S := 'The session #%d is unlocked.';
    (*
    WTS_SESSION_REMOTE_CONTROL:
      begin
        S := 'The session #%d changed its remote status. New status is: ';
        if GetSystemMetrics(SM_REMOTECONTROL) = 0 then
          S := S + 'Session is locally controlled.'
        else
          S := S + 'Session is remotely controlled.';
      end;
    *)  
  else
    S := '';
  end;
  if Length(S) > 0 then
    Msg2Log(S,[Msg.LParam]);
 {$ENDIF}

 if Msg.message = WM_WTSSESSION_Change then
 begin
  {$IFDEF Debug}
  //gLog.Msg('WTS_XXXXX=%s', [WTS_NAMES[Msg.wParam]]);
  {$ENDIF}
  case Msg.wParam of
   //WTS_CONSOLE_CONNECT: lp_Start;
   WTS_CONSOLE_DISCONNECT: Stop;
   WTS_REMOTE_CONNECT: lp_Start;
   WTS_REMOTE_DISCONNECT: Stop;
   WTS_SESSION_LOGON: lp_Start;
   WTS_SESSION_LOGOFF: Stop;
   WTS_SESSION_LOCK: Stop;
   WTS_SESSION_UNLOCK: lp_Start;
  end;
 end
 else
  if Msg.message = WM_QUERYENDSESSION then
   Stop;
end;

procedure TMainForm.AppEventsMinimize(Sender: TObject);
begin
 HideMainForm;
end;

procedure TMainForm.btStartClick(Sender: TObject);
begin
 Start;
 {$IFDEF Issues}f_Issues.ResumeIssue;{$ENDIF}
end;

procedure TMainForm.btStopClick(Sender: TObject);
begin
 Stop;
end;

procedure TMainForm.CreateConfig;
begin
 {$IFDEF GarTime}
 f_Config := TProperties.Create(nil);
 with f_Config do
 begin
   DefineString('mdpURL', '����� MDP');
   Values['mdpURL']:= 'http://mdp.garant.ru/ru/garant/MDProcess/ConfluenceMDChange/RequestSupport/RequestXPlugin/RequestXPackage/changeactiveuserstate.action?type=%d&os_password=%s&os_username=%s';
   DefineString('mdpLogin', '��� ������������');
   DefinePassword('mdpPassword', '������');
 end;
 LoadFromFile(ChangeFileExt(Application.ExeName, '.config'), f_Config, False);
 {$ENDIF}
end;


procedure TMainForm.CreateTrayMenu;
var
 l_Index: Integer;
 l_Item: TMenuItem;
begin
 { TODO : ������� ��������� ������ ���� ��� ������ ������������ }
 with TrayMenu do
 begin
   l_Index:= Items.IndexOf(DividerItem);
 {$IFDEF Issues}
   // �����
   l_Item:= TMenuItem.Create(TrayMenu);
   l_Item.Action:= actStartIssue;
   Items.Insert(l_Index+1, l_Item);
   // ����
   l_Item:= TMenuItem.Create(TrayMenu);
   l_Item.Action:= actFinishIssue;
   Items.Insert(l_Index+2, l_Item);
   // �����
   l_Item:= TMenuItem.Create(TrayMenu);
   l_Item.Action:= actDailyReport;
   Items.Insert(l_Index+3, l_Item);
   // �����������
   l_Item:= TMenuItem.Create(TrayMenu);
   l_Item.Caption:= '-';
   Items.Insert(l_Index+4, l_Item);
 {$ENDIF}
 {$IFDEF GarTime}
   // ������������
   l_Item:= TMenuItem.Create(TrayMenu);
   l_Item.Action:= actConfig;
   Items.Insert(l_Index+1, l_Item);
 {$ENDIF}
 end;
end;

procedure TMainForm.DestroyConfig;
begin
 {$IFDEF GarTime}
 SaveToFile(ChangeFileExt(Application.ExeName, '.config'), f_Config, False);
 FreeAndNil(f_Config);
 {$ENDIF}
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if f_CanClose then
 begin
  Stop;
  Action:= caFree;
 end
 else
  Action:= caMinimize;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
 l_ISQLTimer: IgtSQLTimer;
begin
 f_CanClose:= True;
 f_AutoRunner:= TAutoRunner.Create(Self);
 f_AutoRunner.AutoRun:= True;
 WTSRegisterSessionNotification(Handle, 0);
 CreateConfig;
 CreateTrayMenu;
 try
  f_Timer := TgtSQLTimer.Create();
  timeUpdate.Interval:= 1000*60; // 1 ������
  f_ShowBalloon:= False;
  {$IFDEF Issues}
  if f_Timer.QueryInterface(IgtSQLTimer, l_ISQLTimer) = 0 then
    f_Issues:= TgtIssues.Create(l_ISQLTimer.DB);
  {$ENDIF}
  LoadDayInfo;
  Start;
  {$IFDEF Issues}
  f_Issues.ResumeIssue;
  {$ENDIF}
  f_CanClose:= False;
 except
  Application.Terminate;
 end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
 //SaveDayInfo;
 {$IFDEF Issues}
 FreeAndNil(f_Issues);
 {$ENDIF}
 DestroyConfig;
 f_Timer:= nil;
 FreeAndNil(f_AutoRunner);
 WTSUnRegisterSessionNotification(Handle);
end;

function TMainForm.GetHint: string;
begin
 Result := '' ;
end;

function TMainForm.getHoursStr(aHours: Word): string;
var
 l_Result, l_Remainder: Word;
begin
 DivMod(aHours, 10, l_Result, l_Remainder);
 if l_Result = 1 then
  Result:= '�����'
 else
  case l_Remainder of
   1: Result:= '���';
   2,3,4: Result:= '����'
  else
   Result:= '�����';
  end;
end;

procedure TMainForm.HideMainForm;
begin
    if Application.MainForm <> nil then
    begin
      // Hide the form itself (and thus any child windows)
      Application.MainForm.Visible := False;
    end;
end;

procedure TMainForm.LoadDayInfo;
begin
 UpdateDayInfo;
end;

procedure TMainForm.pause;
begin
 f_Timer.Pause;
 SaveDayInfo;
end;

procedure TMainForm.SaveDayInfo;
begin
 //f_Timer.SaveToFile(DataFilename);
end;

procedure TMainForm.ShowMainForm;
begin
    if Application.MainForm <> nil then
    begin
      // Restore the app, but don't automatically show its taskbar icon
      // Show application's TASKBAR icon (not the tray icon)
//      ShowWindow(Application.Handle, SW_RESTORE);
      Application.Restore;
      // Show the form itself
      if Application.MainForm.WindowState = wsMinimized then
        Application.MainForm.WindowState := wsNormal;    // Override minimized state
      Application.MainForm.Visible := True;
      // Bring the main form (or its modal dialog) to the foreground
      SetForegroundWindow(Application.Handle);
    end;
end;

procedure TMainForm.Start;
begin
 {$IFDEF Debug}
 Msg2Log('Start');
 {$ENDIF}
 {$IFDEF GarTime}
 if not IsRemoteSession then
 begin
 {$ENDIF}
  f_Timer.Start;
  timeUpdate.Enabled:= True;
  itemStartStop.Action:= actStop;
  {$IFDEF GarTime}
  SwitchMDPStatus(mdpStart);
  {$ENDIF}
  UpdateDayInfo;
 {$IFDEF GarTime}
 end; // not IsRemoteSession
 {$ENDIF}
end;

function TMainForm.Started: Boolean;
begin
 if f_Timer <> nil then
  Result := f_Timer.IsStarted
 else
  Result:= False;
end;

procedure TMainForm.Stop;
begin
 {$IFDEF Debug}
 Msg2Log('Stop');
 {$ENDIF}
 if Started then
 begin
  f_Timer.Stop;
  timeUpdate.Enabled:= False;
  SaveDayInfo;
  itemStartStop.Action:= actStart;
  {$IFDEF GarTime}
  SwitchMDPStatus(mdpStop);
  {$ENDIF}
  UpdateDayInfo;
 end;
end;

procedure TMainForm.SwitchMDPStatus(aStatus: Integer);
var
 l_Request: ShortString;
begin
 {$IFDEF GarTime}
 // 'http://mdp.garant.ru/ru/garant/MDProcess/ConfluenceMDChange/RequestSupport/RequestXPlugin/RequestXPackage/changeactiveuserstate.action?type=%d&os_password=%s&os_username=%s'
 if (f_Config.Values['mdpPassword'] <> '') and (f_Config.Values['mdpLogin'] <> '') then
 begin
   l_Request:= Format(f_Config.Values['mdpURL'],
                      [aStatus, f_Config.Values['mdpPassword'], f_Config.Values['mdpLogin']]);
   with TidHTTP.Create do
   try
    try
     Get(l_Request);
    except
     on E: Exception do
      Msg2Log(E.Message);
    end;
   finally
    Free;
   end
 end;
 {$ENDIF}
end;

procedure TMainForm.timeUpdateTimer(Sender: TObject);
begin
 UpdateDayInfo;
end;

procedure TMainForm.TrayIconStartup(Sender: TObject; var ShowMainForm: Boolean);
begin
 ShowmainForm:= False;
end;

procedure TMainForm.UpdateDayInfo;
var
 l_Minutes, l_GarMinutes, l_MonthMinutes: Integer;
 l_Min: Word;
 l_Hours: Word;
 l_Start: TDateTime;
 l_GarantTimeStr, l_MonthStr: String;
begin
 // ������� ���������� ������� ��-����������
 f_RealTimeStr:= f_Timer.DaySheet(l_Minutes, l_GarMinutes);
 l_MonthStr:= f_Timer.MonthSheet(l_MonthMinutes, l_GarMinutes, False);
 f_HomeStr:= TimeToStr(IncMinute(Time, -l_MonthMinutes {�+ 8*60 - l_Minutes}));          // 8 - ������������ ����� + ������
 {$IFDEF GarTime}
 // ������� ������� ���������� ��-�����������
 DivMod(l_Minutes, 60, l_Hours, l_Min);
 Inc(l_Hours, ifThen(l_Min > 30, 1, 0));
 l_GarantTimeStr:= Format('%d %s', [l_Hours, getHoursStr(l_Hours)]);
 // ������� �������� ���������� � ������ �����
 f_MonthTimeStr:= Format('��������: %s'#10'�� �����: (%s)', [l_GarantTimeStr, l_MonthStr]);
 TrayIcon.Hint:= IfThen(Started, Format('���������� %s (%s)', [l_GarantTimeStr, f_RealTimeStr]), '���� �������� ������� �� �����');
 {$ELSE}
 // ������� �������� ���������� � ������ �����
 f_MonthTimeStr:= Format('�� �����: (%s)', [l_MonthStr]);
 TrayIcon.Hint:= IfThen(Started, Format('���������� %s ', [f_RealTimeStr]), '���� �������� ������� �� �����');
 {$ENDIF}
 if Started then
  TrayIcon.IconIndex:= IfThen(l_MonthMinutes < 0, 0, 1)
 else
  TrayIcon.IconIndex:= IfThen(l_MonthMinutes < 0, 2, 3);
 if (l_MonthMinutes >= 0) and not f_ShowBalloon then
 begin
  TrayIcon.ShowBalloonHint('���� �������� �������', '����� ���� �����', bitInfo, 15);
  f_ShowBalloon:= True;
 end; // (l_Hours = 8) and not f_ShowBalloon
end;

procedure TMainForm.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
 Stop;
 Msg.Result:= 1;
end;


end.
