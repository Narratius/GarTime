program GarTime3;
{$UNDEF OVP}
uses
  Forms,
  GarTimeForm3 in 'GarTimeForm3.pas' {MainForm},
  gtIntfs in 'gtIntfs.pas',
  gtSQL in 'gtSQL.pas',
  gtUtils in 'gtUtils.pas',
  gtLogFile in 'gtLogFile.pas',
  gtIssues in 'gtIssues.pas',
  gtIssueCloseDlg in 'gtIssueCloseDlg.pas' {IssueCloseDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Gartime3';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TIssueCloseDialog, IssueCloseDialog);
  Application.Run;
end.
