program GarTime3;
{$UNDEF OVP}
uses
  Forms,
  GarTimeForm3 in 'GarTimeForm3.pas' {MainForm},
  gtIntfs in 'gtIntfs.pas',
  gtSQL in 'gtSQL.pas',
  gtUtils in 'gtUtils.pas',
  gtLogFile in 'gtLogFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Gartime3';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
