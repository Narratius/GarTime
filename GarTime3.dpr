program GarTime3;
{$UNDEF OVP}
uses
  Forms,
  GarTimeForm3 in 'GarTimeForm3.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Gartime3';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
