unit GarTimeForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ActnList, ImgList, AppEvnts,
  CoolTrayIcon, AutoRunner;

type
  TMainForm = class(TForm)
    btStart: TButton;
    btPause: TButton;
    btStop: TButton;
    lblDayInfo: TLabel;
    timeUpdate: TTimer;
    lblRealTime: TLabel;
    TrayMenu: TPopupMenu;
    ActionList1: TActionList;
    actStart: TAction;
    actStop: TAction;
    actPause: TAction;
    actExit: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    IconImages: TImageList;
    actShow: TAction;
    N5: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    TrayIcon: TCoolTrayIcon;
    procedure btStartClick(Sender: TObject);
    procedure btPauseClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure timeUpdateTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActionsUpdate(Sender: TObject);
    procedure actShowExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure TrayIconMinimizeToTray(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    f_AutoRunner: TAutoRunner;
    f_Start: TDateTime;
    f_Pause: TDateTime;
    f_ShowBalloon: Boolean;
    function DataFileName: string;
    function GetHint: string;
    function getHoursStr(aHours: Word): string;
    procedure LoadDayInfo;
    procedure pause;
    procedure SaveDayInfo;
    procedure Start;
    function Started: Boolean;
    procedure Stop;
    procedure UpdateDayInfo;
    procedure HideMainForm;
    procedure ShowMainForm;
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession); message WM_QUERYENDSESSION;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

Uses
 DateUtils, Math, StrUtils;



procedure TMainForm.btStartClick(Sender: TObject);
begin
 if Started then
  Stop
 else
  Start;
end;

procedure TMainForm.btPauseClick(Sender: TObject);
begin
 pause;
end;

procedure TMainForm.btStopClick(Sender: TObject);
begin
 Stop;
end;

function TMainForm.DataFileName: string;
begin
 Result := ChangeFileExt(Application.ExeName, '.dat');
end;

procedure TMainForm.timeUpdateTimer(Sender: TObject);
begin
 UpdateDayInfo;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
 f_AutoRunner:= TAutoRunner.Create(Self);
 f_AutoRunner.AutoRun:= True;
 timeUpdate.Interval:= 1000*60; // 1 ������
 f_Start:= 0;
 f_Pause:= 0;
 f_ShowBalloon:= False;
 ActionsUpdate(Self);
 LoadDayInfo;
 Start;
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

procedure TMainForm.LoadDayInfo;
var
 l_Start, l_Pause: TDateTime;
 l_Stream: TStream;
begin
 if FileExists(DataFileName) then
 begin
  l_Stream:= TFileStream.Create(DataFileName, fmOpenRead);
  with l_Stream do
  try
   if Size > 0 then
   begin
    Seek(-2*SizeOf(TDateTime), soFromEnd);
    Read(l_Start, SizeOf(TDateTime));
    Read(l_Pause, SizeOf(TDateTime));
    if IsToday(l_Pause) then
    begin
     f_Start:= l_Start;
     f_Pause:= l_Pause;
     //f_Start := l_Start - (Now - l_Pause);
     //f_Pause:= Now;
    end // IsToday
    else
    begin
     f_Start:= Now;
     f_Pause:= 0;
    end;
   end; // Size > 0
  finally
   Free;
  end;
 end;
 UpdateDayInfo;
end;

procedure TMainForm.SaveDayInfo;
begin
 with TFileStream.Create(DataFileName, ifThen(FileExists(DataFileName), fmOpenReadWrite, fmCreate)) do
 try
  Seek(0, soFromEnd);
  Write(f_Start, SizeOf(TDateTime));
  Write(f_Pause, SizeOf(TDateTime));
 finally
  Free;
 end;
end;

procedure TMainForm.ActionsUpdate(Sender: TObject);
begin
 actStart.Enabled:= not Started;
 actPause.Enabled:= Started;
 actStop.Enabled := Started;
 actExit.Enabled := True;
end;

function TMainForm.GetHint: string;
begin
 Result := '' ;
end;

procedure TMainForm.pause;
begin
 f_Pause:= Now;
end;

procedure TMainForm.Start;
begin
 if IsToday(f_Start) and (f_Pause <> 0) then
  f_Start := f_Start + (Now - f_Pause)
 else
  f_Start:= Now;
 f_Pause:= 0;
 timeUpdate.Enabled:= True;
 UpdateDayInfo;
end;

function TMainForm.Started: Boolean;
begin
 Result := (f_Pause = 0) and (f_Start <> 0);
end;

procedure TMainForm.Stop;
begin
 if f_Pause = 0 then
  f_Pause := Now;
 timeUpdate.Enabled:= False;
 SaveDayInfo;
 UpdateActions;
end;

procedure TMainForm.UpdateDayInfo;
var
 l_Min: Word;
 l_Hours: Word;
 l_Start: TDateTime;
begin
 l_Hours:= 0;
 l_Min:= 0;
 if f_Start > 0 then
 begin
  if f_Pause > 0 then
   l_Start:= f_Start + (Now - f_Pause)
  else
   l_Start:= f_Start;
  DivMod(MinutesBetween(Now, l_Start), 60, l_Hours, l_Min);
  lblRealTime.Caption:= TimeToStr(Now - l_Start);//, '������ h:mm');
 end;
 l_Hours:= l_Hours + ifThen(l_Min > 30, 1, 0);
 lblDayInfo.Caption:= Format('%d %s', [l_Hours, getHoursStr(l_Hours)]);
 lblDayInfo.Font.Color:= ifThen(l_Hours >= 8, clGreen, clBlack);
 TrayIcon.IconIndex:= IfThen(l_Hours < 8, 0, 1);
 TrayIcon.Hint:= IfThen(Started, Format('���������� %s (%s)', [lblDayInfo.Caption, lblRealTime.Caption]), '���� �������� ������� �� �����');
 if (l_Hours = 8) and not f_ShowBalloon then
 begin
  TrayIcon.ShowBalloonHint('���� �������� �������', '����� ���� �����', bitInfo, 15);
  f_ShowBalloon:= True;
 end;
end;

procedure TMainForm.actShowExecute(Sender: TObject);
begin
 ShowMainForm;
end;

procedure TMainForm.ApplicationEvents1Minimize(Sender: TObject);
begin
 HideMainForm;
 actShow.Enabled := True;
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
 Close;
end;

procedure TMainForm.TrayIconMinimizeToTray(Sender: TObject);
begin
 actShow.Enabled := True;
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


procedure TMainForm.HideMainForm;
begin
    if Application.MainForm <> nil then
    begin
      // Hide the form itself (and thus any child windows)
      Application.MainForm.Visible := False;
    end;
end;


procedure TMainForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
 if Msg.message = WM_WTSSESSION_Change then
 begin
  case Msg.wParam of
(*   WTS_CONSOLE_CONNECT: s:= 'A session was connected to the console terminal.';
   WTS_CONSOLE_DISCONNECT: S:= 'A session was disconnected from the console terminal.';
   WTS_REMOTE_CONNECT: S:= 'A session was connected to the remote terminal.';
   WTS_REMOTE_DISCONNECT: S:= 'A session was disconnected from the remote terminal.';
*)   WTS_SESSION_LOGON: Start;
   WTS_SESSION_LOGOFF: Stop;
   WTS_SESSION_LOCK: Pause;
   WTS_SESSION_UNLOCK: Start;
  end;
 end
 else
  if Msg.message = WM_QUERYENDSESSION then
   Stop;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
 FreeAndNil(f_AutoRunner);
 SaveDayInfo;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Stop;
end;

procedure TMainForm.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
 Stop;
 Msg.Result:= 1;
end;

end.
