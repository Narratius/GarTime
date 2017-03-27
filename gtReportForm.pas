unit gtReportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TDailyReportForm = class(TForm)
    ReportMemo: TMemo;
    ClipButton: TButton;
    Button2: TButton;
    procedure ClipButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute;
  end;

var
  DailyReportForm: TDailyReportForm;

implementation

Uses
  Clipbrd,
  gtIssues;

{$R *.dfm}

procedure TDailyReportForm.ClipButtonClick(Sender: TObject);
begin
  // Забрать содержимое Мемо в буфер
  Clipboard.SetTextBuf(PAnsiChar(ReportMemo.Lines.Text));
end;

procedure TDailyReportForm.Execute;
begin
end;

end.
