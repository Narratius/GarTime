unit gtUtils;

interface

Uses
 gtLogFile;

function MinutesToString(aMinutes: Int64): ShortString;

function DataFileName: string;

var
 gLog: TgtLogFile;

implementation

Uses
 SysUtils;

function MinutesToString(aMinutes: Int64): ShortString;
var
 l_Day, l_Hour, l_Min: Longint;
begin
  l_Day:= aMinutes div (24*60);
  l_Hour:= (aMinutes mod (24*60)) div 60;
  l_Min:=  (aMinutes mod (24*60)) mod 60;
  if l_Day > 1 then
   Result:= Format('%2d дня %2d час', [l_Day, Abs(l_Hour)])
  else
  if Abs(l_Hour) > 0 then
   Result:= Format('%2d час %2d мин', [l_Hour, Abs(l_Min)])
  else
  if Abs(l_Min) > 0 then
   Result:= Format('%2d мин', [l_Min])
  else
    Result:= 'меньше минуты';
end;

function DataFileName: string;
begin
 Result := ChangeFileExt(ParamStr(0), '.dat');
end;


initialization
 gLog:= TgtLogFile.Create;
finalization
 FreeAndNil(gLog);
end.
