unit gtIssueOpenDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, gtIssues;

type
  TIssueOpenDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    IssuesCombo: TComboBox;
    Label2: TLabel;
    TitleEdit: TEdit;
    procedure IssuesComboChange(Sender: TObject);
  private
    { Private declarations }
    f_Issues: TgtIssues;
  public
    { Public declarations }
    function Execute(aIssues: TgtIssues; out aIssueNum, aIssueTitle: String): Boolean;
  end;

var
  IssueOpenDialog: TIssueOpenDialog;


implementation

{$R *.dfm}

procedure TIssueOpenDialog.IssuesComboChange(Sender: TObject);
begin
  TitleEdit.Text:= f_Issues.GetIssueTitle(IssuesCombo.Text)
end;

function TIssueOpenDialog.Execute(aIssues: TgtIssues; out aIssueNum,
  aIssueTitle: String): Boolean;
begin
 Result:= False;
 aIssueNum:= '';
 aIssueTitle:= '';
 if aIssues <> nil then
 begin
  f_Issues:= aIssues;
  aIssues.GetIssues(IssuesCombo.Items);
  IssuesCombo.ItemIndex:= IssuesCombo.Items.IndexOf(aIssues.GetActiveIssue);
  IssuesComboChange(Self);
  Result:= IsPositiveResult(ShowModal);
  if Result then
  begin
    aIssueNum:= IssuesCombo.Text;
    aIssueTitle:= TitleEdit.Text;
  end; // Result
 end; // aIssues <> nil
end;

end.
