program GarTime2;

uses
  Forms,
  GarTimeForm in 'GarTimeForm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Gartime';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
