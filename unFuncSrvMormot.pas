unit unFuncSrvMormot;

interface

uses
  Classes,
  SysUtils,
  Syncommons,
  strUtils,
  Winapi.windows,
  Tlhelp32,
  Vcl.Forms,
  IdGlobal,
  IdHash,
  IdHashMessageDigest;

  function DecodeParam(prParams: String): TStrings; overload;
  function DecodeParam(prParams: String; prPos: Integer): TStrings; overload;
  function GeraRelatorio(prRelatorio: string; prParametros : TStrings): string;
  procedure getParametrosEArquivo(prParametros: PUTF8Char; var prParam : TStrings; var prNomeArq:TFileName);
  procedure getParametros(prParametros: PUTF8Char; var prParam: TStrings);
  function KillTask(ExeFileName: string): Integer;
  function ExecutaBat(const prComando: string; const prArq: string; const prDeleta: boolean): boolean;
  function Md5HashString(value: string): string;

implementation

uses unServidorRestFr;


function DecodeParam(prParams: String): TStrings;
begin
  Result:= TStringList.Create;
  if prParams<>'' then
  begin
    while Pos('&',prParams) > 0 do
    begin
      Result.Add(Copy(prParams,1,Pos('&',prParams)-1));
      prParams:= Copy(prParams, Pos('&',prParams)+1, Length(prParams));
    end;
    Result.Add(prParams);
  end;
end;

function DecodeParam(prParams: String; prPos: Integer): TStrings;
var
  nContador : integer;
begin
  Result:= TStringList.Create;
  if prParams<>'' then
  begin
    nContador := prPos;
    if (Pos('&',prParams) = 0) and (nContador < 0) then
      Result := nil
    else
    begin
      while (Pos('&',prParams) > 0)   do
      begin
        if nContador >= 0 then
          Result.Add(Copy(prParams,1,Pos('&',prParams)-1));

        prParams:= Copy(prParams, Pos('&',prParams)+1, Length(prParams));
        inc(nContador);
      end;
      Result.Add(prParams);
    end;

  end;
end;

function GeraRelatorio(prRelatorio: string; prParametros: TStrings): string;
var
  sNomeArq,
  sNomeRel,
  sPastaLocal: String;
  sParametros : String;
  nAux : integer;
begin

  sParametros := '';
  for nAux := 0 to prParametros.Count-1 do
  begin
    sParametros := sParametros + '<' + prParametros[nAux] + '>';
  end;

  sPastaLocal := 'relatoriossenior\';
  sNomeRel := ExtractFileName(prRelatorio);
  sNomeArq := 'smart' + sNomeRel + FormatDateTime('hhnnss', Time);


  result := servidorrestfr.WebServiceSenior.GerarRelatorio(sParametros, sNomeArq, sNomeRel, FALSE);

  CopyFile(pchar(servidorrestfr.WebServiceSenior.Diretorio + '\' +sNomeArq +'.pdf'),
           pchar(sPastaLocal +sNomeArq + '.pdf') ,true);
  if result = '' then
    result := '[{"RESPOSTA":"'+result+'","NOMEARQUIVO":"' + sNomeArq + '.pdf"}]'
  else
    result := '[{"RESPOSTA":"' + ReplaceStr(result,'"','') + '","NOMEARQUIVO":"0"}]'

end;

procedure getParametrosEArquivo(prParametros: PUTF8Char; var prParam: TStrings; var prNomeArq: TFileName);
begin
  if prParametros <> nil then
  begin
    prParam   := DecodeParam(prParametros, -1);
    prNomeArq := DecodeParam(prParametros, 1).Strings[0];
    if pos('=', prNomeArq) > 0 then
      prNomeArq := copy(prNomeArq, pos('=', prNomeArq)+1, maxInt);
  end;
end;

procedure getParametros(prParametros: PUTF8Char; var prParam: TStrings);
begin
  if prParametros <> nil then
  begin
    prParam   := DecodeParam(prParametros, 0);
  end;
end;

function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function ExecutaBat(const prComando: string; const prArq: string; const prDeleta: boolean): boolean;
var
   txt: TextFile;
   dir: string;
   ret: boolean;

  function WinExecAndWait32(FileName: String; WorkDir: String; Visibility: integer): integer;
  var
     zAppName: array[0..512] of char;
     zCurDir: array[0..255] of char;
     StartupInfo: TStartupInfo;
     ProcessInfo: TProcessInformation;
  begin
    StrPCopy(zAppName,FileName);
    StrPCopy(zCurDir,WorkDir);
    FillChar(StartupInfo,Sizeof(StartupInfo),#0);
    StartupInfo.cb:=Sizeof(StartupInfo);
    StartupInfo.dwFlags:=STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow:=Visibility;

    if not CreateProcess(nil,zAppName,nil,nil,False,CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil,zCurDir,StartupInfo,ProcessInfo) then
     Result:=-1
    else
    begin
     WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
     GetExitCodeProcess(ProcessInfo.hProcess,DWORD(Result));
    end;

  end;
begin
  ret:=False;
  try
	  dir:=ExtractFilePath(Application.ExeName);
	  AssignFile(txt, dir + prArq);
	  Rewrite(txt);
	  Write(txt, prComando);

	  CloseFile(txt);
	  if WinExecAndWait32(dir + prArq,dir,SW_ShowNormal) = 0 then
		  ret:=True;

    if prDeleta then
  	  DeleteFile(pwideChar(dir + prArq));
  finally
    ExecutaBat:=ret;
  end;
end;

function Md5HashString(value: string): string;
var
  hashMessageDigest5 : TIdHashMessageDigest5;
begin
  hashMessageDigest5 := nil;
  try
    hashMessageDigest5 := TIdHashMessageDigest5.Create;
    Result := IdGlobal.IndyLowerCase(hashMessageDigest5.HashStringAsHex(value));
  finally
    hashMessageDigest5.Free;
  end;
end;

end.
