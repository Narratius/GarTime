unit gtLogFile;

interface
Uses
 Classes;

type
 TgtLogFile = class
 private
  f_Stream: TFileStream;
 public
   constructor Create(const aFileName: String = '');
   destructor Destroy; override;
   procedure Msg(const aText: String); overload;
   procedure Msg(aValue: Int64); overload;
   procedure Msg(const aFormat: String; const Args: array of const); overload;
 end;

implementation
Uses
 SysUtils, StrUtils, Math;

{ TgtLogFile }

constructor TgtLogFile.Create(const aFileName: String);
var
 l_FileName: String;
 l_Mode: Word;
begin
  inherited Create;
  l_FileName:= IfThen(aFileName = '', ChangeFileExt(ParamStr(0), '.log'), aFileName);
  l_Mode:= IfThen(FileExists(l_FileName), fmOpenWrite, fmCreate);
  f_Stream:= TFileStream.Create(l_FileName, l_Mode, fmShareDenyWrite or fmShareDenyNone);
  f_Stream.Seek(0, soEnd);
end;

destructor TgtLogFile.Destroy;
begin
  FreeAndNil(f_Stream);
  inherited;
end;

procedure TgtLogFile.Msg(const aFormat: String; const Args: array of const);
begin
  Msg(Format(aFormat, Args));
end;

procedure TgtLogFile.Msg(aValue: Int64);
begin
  Msg(IntToStr(aValue));
end;

procedure TgtLogFile.Msg(const aText: String);
var
 l_B: String;
begin
  l_B:= FormatDateTime('dd-mm-yyyy hh:nn:ss:zzz ', Now) + aText + #13#10;
  f_Stream.Write(l_B[1], Length(l_B));
end;

end.
