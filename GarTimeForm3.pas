unit GarTimeForm3;

interface
{.$DEFINE GarTime}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ActnList, ImgList, AppEvnts,
  CoolTrayIcon, AutoRunner, gtTypes
  {$IFDEF GarTime}
  , ddAppConfigTypes
  {$ENDIF};

type
  TMainForm = class(TForm)
    actExit: TAction;
    ActionList1: TActionList;
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
    N1: TMenuItem;
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
  private
    f_AutoRunner: TAutoRunner;
    f_CanClose: Boolean;
    {$IFDEF GarTime}
    f_Config: TddAppConfigNode;
    {$ENDIF}
    f_HomeStr: string;
    f_MonthTimeStr: string;
    f_RealTimeStr: string;
    f_ShowBalloon: Boolean;
    f_Timer: TgtTimer;
    procedure CreateConfig;
    function DataFileName: string;
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
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

Uses
 DateUtils, Math, StrUtils, IdHTTP
 {$IFDEF GarTime}
 , jwaWTSApi32, ddAppConfigUtils, l3String,  l3Base, ddConfigStorages, l3SysUtils
 {$ENDIF}
  ;

const
 mdpStart = 1;
 mdpStop  = 2;

procedure TMainForm.actConfigExecute(Sender: TObject);
begin
 {$IFDEF GarTime}
 if ExecuteNodeDialog(f_Config) then
  f_Config.Save(MakedefaultStorage);
 {$ENDIF}
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
 f_CanClose:= True;
 Close;
end;

procedure TMainForm.actShowExecute(Sender: TObject);
begin
 ShowMainForm;
end;

procedure TMainForm.actShowStatisticExecute(Sender: TObject);
begin
 TrayIcon.ShowBalloonHint('Учет рабочего времени',
                          Format('Сегодня: %s'#10'%s'#10'Домой в: %s', [f_RealTimeStr, f_MonthTimeStr, f_HomeStr]), bitInfo, 30);
end;

procedure TMainForm.AppEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
 if Msg.message = WM_WTSSESSION_Change then
 begin
  case Msg.wParam of
(*   WTS_CONSOLE_CONNECT: s:= 'A session was connected to the console terminal.';
   WTS_CONSOLE_DISCONNECT: S:= 'A session was disconnected from the console terminal.';
*) WTS_REMOTE_CONNECT: Stop;
   WTS_REMOTE_DISCONNECT: Stop;
   WTS_SESSION_LOGON: Start;
   WTS_SESSION_LOGOFF: Stop;
   WTS_SESSION_LOCK: Stop;
   WTS_SESSION_UNLOCK: Start;
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
end;

procedure TMainForm.btStopClick(Sender: TObject);
begin
 Stop;
end;

procedure TMainForm.CreateConfig;
{$IFDEF GarTime}
var
 l_Storage: IddConfigStorage;
{$ENDIF}
begin
 {$IFDEF GarTime}
 f_Config := MakeNode('Config', 'Конфигурация',
              //MakeDivider('Общие настройки',
              //MakeDivider('Confluence',
               MakeString('mdpLogin', 'Имя пользователя', '',
               MakeString('mdpPassword', 'Пароль', '', '*',
               nil))
              //))
             );
 l_Storage:= MakedefaultStorage;
 try
  f_Config.Load(l_Storage);
 finally
  l_Storage:= nil;
 end;
 {$ENDIF}
end;

function TMainForm.DataFileName: string;
begin
 Result := ChangeFileExt(Application.ExeName, '.dat');
end;

procedure TMainForm.DestroyConfig;
begin
 {$IFDEF GarTime}
 f_Config.Save(MakedefaultStorage);
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
begin
 f_CanClose:= True;
 f_AutoRunner:= TAutoRunner.Create(Self);
 f_AutoRunner.AutoRun:= True;
 {$IFDEF GarTime}
 WTSRegisterSessionNotification(Handle, 0);
 {$ENDIF}
 CreateConfig;
 try
  f_Timer := TgtTimer.Create();
  timeUpdate.Interval:= 1000*60; // 1 минута
  f_ShowBalloon:= False;
  LoadDayInfo;
  Start;
  f_CanClose:= False;
 except
  Application.Terminate;
 end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
 //SaveDayInfo;
 DestroyConfig;
 FreeAndNil(f_Timer);
 FreeAndNil(f_AutoRunner);
 {$IFDEF GarTime}
 WTSUnRegisterSessionNotification(Handle);
 {$ENDIF}
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
  Result:= 'часов'
 else
  case l_Remainder of
   1: Result:= 'час';
   2,3,4: Result:= 'часа'
  else
   Result:= 'часов';
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
 if FileExists(DataFileName) then
  f_Timer.LoadFromFile(DataFileName);
 UpdateDayInfo;
end;

procedure TMainForm.pause;
begin
 f_Timer.Pause;
 SaveDayInfo;
end;

procedure TMainForm.SaveDayInfo;
begin
 f_Timer.SaveToFile(DataFilename);
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
 {$IFDEF GarTime}
 if not l3IsRemoteSession then
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
 end; // not l3IsRemoteSession
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
 l_Request:= Format('http://mdp.garant.ru/ru/garant/MDProcess/ConfluenceMDChange/RequestSupport/RequestXPlugin/RequestXPackage/changeactiveuserstate.action?type=%d&os_password=%s&os_username=%s',
                    [aStatus, f_Config.AsString['mdpPassword'], f_Config.AsString['mdpLogin']]);
 with TidHTTP.Create do
 try
  try
   Get(l_Request);
  except
   on E: Exception do
    l3System.Msg2Log(E.Message);
  end;
 finally
  Free;
 end
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
 l_GarantTimeStr: String;
begin
 // Сколько отработано сегодня по-настоящему
 f_RealTimeStr:= f_Timer.DaySheet(l_Minutes, l_GarMinutes);
 f_HomeStr:= TimeToStr(IncMinute(Time, 8*60 - l_Minutes));          // 8 - отработанное время + сейчас
 {$IFDEF GarTime}
 // Сколько сегодня отработано по-гарантовски
 DivMod(l_Minutes, 60, l_Hours, l_Min);
 Inc(l_Hours, ifThen(l_Min > 30, 1, 0));
 l_GarantTimeStr:= Format('%d %s', [l_Hours, getHoursStr(l_Hours)]);
 // Сколько осталось отработать с учетом долга
 f_MonthTimeStr:= Format('Гарвремя: %s'#10'За месяц: (%s)', [l_GarantTimeStr, f_Timer.MonthSheet(l_MonthMinutes, False)]);
 TrayIcon.Hint:= IfThen(Started, Format('Отработано %s (%s)', [l_GarantTimeStr, f_RealTimeStr]), 'Учет рабочего времени не начат');
 {$ELSE}
 // Сколько осталось отработать с учетом долга
 f_MonthTimeStr:= Format('За месяц: (%s)', [f_Timer.MonthSheet(l_MonthMinutes, l_GarMinutes, False)]);
 TrayIcon.Hint:= IfThen(Started, Format('Отработано %s ', [f_RealTimeStr]), 'Учет рабочего времени не начат');
 {$ENDIF}
 if Started then
  TrayIcon.IconIndex:= IfThen(l_MonthMinutes < 0, 0, 1)
 else
  TrayIcon.IconIndex:= IfThen(l_MonthMinutes < 0, 2, 3);
 if (l_MonthMinutes >= 0) and not f_ShowBalloon then
 begin
  TrayIcon.ShowBalloonHint('Учет рабочего времени', 'Можно идти домой', bitInfo, 15);
  f_ShowBalloon:= True;
 end; // (l_Hours = 8) and not f_ShowBalloon
end;

procedure TMainForm.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
 Stop;
 Msg.Result:= 1;
end;


end.
