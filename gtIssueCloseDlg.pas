unit gtIssueCloseDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TIssueCloseDialog = class(TForm)
    CommentEdit: TEdit;
    Label2: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    IssueClosedCheck: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IssueCloseDialog: TIssueCloseDialog;

function IssueCloseDlg(out aComment: String; out aClose: Boolean): Boolean;

implementation

{$R *.dfm}


function IssueCloseDlg(out aComment: String; out aClose: Boolean): Boolean;
begin
  with TIssueCloseDialog.Create(Application) do
  try
    Result:= IsPositiveResult(ShowModal);
    if Result then
    begin
     aComment:= CommentEdit.Text;
     aClose:= IssueClosedCheck.Checked;
    end;
  finally
    Free;
  end;
end;

end.
