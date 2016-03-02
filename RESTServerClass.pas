unit RESTServerClass;

interface

uses
  SysUtils,
  Classes,
  SynCommons,
  SynLog,
  mORMot,
  RESTData,
  SynDB,
  SynDBSQLite3,
  db,
  mORMotVCL,
  SynSQLite3Static,
  strUtils,
  SynZip,
  Tlhelp32,
  Winapi.Windows;

type
  ELideraRestServer = class(EORMException);

  TLideraRestServer = class(TSQLRestServerFullMemory)
  private
//    _fNomeArq: TFileName;
  //  _Params: TStrings;
  protected
    fRootFolder: TFileName;
    fBlobFolder: TFileName;
    fProps: TSQLDBSQLite3ConnectionProperties;
  public

    constructor Create(const aRootFolder: TFileName; const aRootURI: RawUTF8); reintroduce;
    destructor Destroy; override;
    function ExecQuery(prFileName: String; prParams: TStrings): RawUTF8; overload;
    function ExecQueryTxt(prFileName: String; prParams: TStrings): RawUTF8; overload;
    function ExecQuery(prFileName: String): Boolean; overload;
    property RootFolder: TFileName read fRootFolder;
  published
    procedure Rel(Ctxt: TSQLRestServerURIContext);
    procedure PING(Ctxt: TSQLRestServerURIContext);
    procedure PACOTE(Ctxt: TSQLRestServerURIContext);
    procedure OPEINSERT(Ctxt: TSQLRestServerURIContext);

    procedure SQL(Ctxt: TSQLRestServerURIContext);
    procedure EXIBEHTML(Ctxt: TSQLRestServerURIContext);
    procedure INSEREJSON(Ctxt: TSQLRestServerURIContext);
    //Servidor Foda pra Caralho
    procedure PROCESSOS(Ctxt: TSQLRestServerURIContext);
  end;


implementation


{ TNoteServer }

uses unServidorRestFr, unFuncSrvMormot;

constructor TLideraRestServer.Create(const aRootFolder: TFileName;
  const aRootURI: RawUTF8);
var
  Conn: TSQLDBSQLite3Connection;
begin
  fRootFolder := EnsureDirectoryExists(ExpandFileName(aRootFolder),true);
  fBlobFolder := EnsureDirectoryExists(fRootFolder,true);
  // define the log level
  with TSQLLog.Family do begin
    Level := LOG_VERBOSE; // LOG_STACKTRACE;
    DestinationPath := fRootFolder+'..\log\';
    if not FileExists(DestinationPath) then
      CreateDir(DestinationPath);
    PerThreadLog := ptIdentifiedInOnFile;
  end;
  // prepare the server in-memory storage
  inherited Create(DataModel(aRootURI),fRootFolder+'data.json',false,false);
  //UpdateToFile;

  //Conecta no Oracle
  fProps :=  TSQLDBSQLite3ConnectionProperties.Create(StringToUTF8(_sBancoDeDados),'','','');
  fProps.UseMormotCollations :=  true;
  Conn := fProps.MainConnection as TSQLDBSQLite3Connection;//fProps.ThreadSafeConnection;
  if not Conn.Connected then
    Conn.Connect;
end;

destructor TLideraRestServer.Destroy;
begin
  inherited;
  fModel.Free;
end;

procedure TLideraRestServer.REL(Ctxt: TSQLRestServerURIContext);
var
  fPath : string;
  fNomeArq: TFileName;
  stParams: TStrings;
begin
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn ', now) + '-' + UTF8ToString(VariantToUTF8(Ctxt.Method)) + ' ' + UTF8ToString(VariantToUTF8(ctxt.URIWithoutSignature)) );
  //Relatorios
  fPath := 'relatoriossenior\';
  getParametrosEArquivo(ctxt.Parameters, stParams, fNomeArq );
  if (Ctxt.Table=TSQLRelatoriosSenior) then
  begin
    if not(FileExists(fPath+fNomeArq)) then
    begin
      if (fNomeArq <> '') and (stParams <> nil) then
        ctxt.ReturnsJson(GeraRelatorio(fNomeArq, stParams), HTML_SUCCESS, false, TTextWriterKind.twNone)
      else
        Ctxt.Error('',HTML_NOTFOUND);
    end
    else
      Ctxt.ReturnFile(fPath + fNomeArq);
  end;
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn ', now) + '-' + 'Processado!');
end;

procedure TLideraRestServer.SQL(Ctxt: TSQLRestServerURIContext);
var
  FN: RawUTF8;
  sMetodo : rawutf8;
  fNomeArq: TFileName;
  stParams: TStrings;

const
  fPath = 'Oracle\LideraSmart\SQL\';

  procedure retornaMetodo;
  begin
    case ctxt.Method of
      mNone:   sMetodo:= 'none';
      mGET:    sMetodo:= 'get';
      mPOST:   sMetodo:= 'post';
      mPUT:    sMetodo:= 'put';
      mDELETE: sMetodo:= 'delete';
      mHEAD:   sMetodo:= 'head';
      mBEGIN:  sMetodo:= 'begin';
      mEND:    sMetodo:= 'end';
      mABORT:  sMetodo:= 'abort';
      mLOCK:   sMetodo:= 'lock';
      mUNLOCK: sMetodo:= 'unlock';
      mSTATE:  sMetodo:= 'state';
    end;
  end;

begin
  retornaMetodo;
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn:ss ', now) + '-' +  sMetodo  + '   ' + UTF8ToString(VariantToUTF8(ctxt.URIWithoutSignature)) );

  if not IdemPChar(pointer(Ctxt.URIWithoutSignature),'ROOT/')  then begin
    Ctxt.Error('', HTML_NOTFOUND);
    exit;
  end;
 // FN := StringReplaceChars(UrlDecode(copy(Ctxt.URL,7,maxInt)),'/','\');
  FN := trim(StringReplaceChars(UrlDecode(Ctxt.URIWithoutSignature),'/','\'));
  if PosEx('..',UTF8ToString(FN))>0 then begin
   // circumvent obvious potential security leak
    ctxt.Error('', HTML_NOTFOUND);
    exit;
  end;

  getParametrosEArquivo(ctxt.Parameters, stParams, fNomeArq);
  if fNomeArq = '' then
  begin
    ctxt.Error('', HTML_NOTFOUND);
    exit;
  end;

  if DirectoryExists(fPath) then
  begin
    if (ctxt.Method = mGet) and (FileExists(fPath+fNomeArq + '.' + sMetodo)) then
    begin
      try

        if Assigned(stParams) and (stParams.IndexOf('TipoRet=txt') >= 0) then
        begin

          ctxt.Returns(ExecQueryTxt(fPath + fNomeArq + '.' + sMetodo,
                           stParams));

        end else
        begin



          ctxt.ReturnsJson(ExecQuery(fPath + fNomeArq + '.' + sMetodo,
                           stParams), HTML_SUCCESS, false, TTextWriterKind.twNone);
        end;
      except

      end;
    end
    else
    if (ctxt.Method = mPOST) then
    begin
      FileFromString(Ctxt.Call.InBody, 'Oracle\LideraSmart\TEMP_INSERT\' + fNomeArq);
      If ExecQuery('Oracle\LideraSmart\TEMP_INSERT\' + fNomeArq) then
        ctxt.Returns('OK')
      else
        ctxt.Returns('Falha no SQL - Favor entrar em contato com a TI da Matriz.');
    end
    else
      Ctxt.Error('Pagina não Encontrada', HTML_NOTFOUND);
  end;
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn:ss ', now) + '-' + 'Processado!');
end;
           (*
procedure TLideraRestServer.SQL(Ctxt: TSQLRestServerURIContext);
var
  FN: RawUTF8;
  sMetodo : rawutf8;
  fNomeArq: TFileName;
  stParams: TStrings;

const
  fPath = 'Oracle\LideraSmart\SQL\';

  procedure retornaMetodo;
  begin
    case ctxt.Method of
      mNone:   sMetodo:= 'none';
      mGET:    sMetodo:= 'get';
      mPOST:   sMetodo:= 'post';
      mPUT:    sMetodo:= 'put';
      mDELETE: sMetodo:= 'delete';
      mHEAD:   sMetodo:= 'head';
      mBEGIN:  sMetodo:= 'begin';
      mEND:    sMetodo:= 'end';
      mABORT:  sMetodo:= 'abort';
      mLOCK:   sMetodo:= 'lock';
      mUNLOCK: sMetodo:= 'unlock';
      mSTATE:  sMetodo:= 'state';
    end;
  end;

begin
  retornaMetodo;
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn:ss ', now) + '-' +  sMetodo  + '   ' + UTF8ToString(VariantToUTF8(ctxt.URIWithoutSignature)) );

  if not IdemPChar(pointer(Ctxt.URIWithoutSignature),'ROOT/')  then begin
    Ctxt.Error('', HTML_NOTFOUND);
    exit;
  end;
 // FN := StringReplaceChars(UrlDecode(copy(Ctxt.URL,7,maxInt)),'/','\');
  FN := trim(StringReplaceChars(UrlDecode(Ctxt.URIWithoutSignature),'/','\'));
  if PosEx('..',UTF8ToString(FN))>0 then begin
   // circumvent obvious potential security leak
    ctxt.Error('', HTML_NOTFOUND);
    exit;
  end;

  getParametrosEArquivo(ctxt.Parameters, stParams, fNomeArq);
  if fNomeArq = '' then
  begin
    ctxt.Error('', HTML_NOTFOUND);
    exit;
  end;

  if DirectoryExists(fPath) then
  begin
    if (ctxt.Method = mGet) and (FileExists(fPath+fNomeArq + '.' + sMetodo)) then
    begin
      try

        if stParams.IndexOf('TipoRet=txt') >= 0 then
        begin

          ctxt.Returns(ExecQueryTxt(fPath + fNomeArq + '.' + sMetodo,
                           stParams));

        end else
        begin



          ctxt.ReturnsJson(ExecQuery(fPath + fNomeArq + '.' + sMetodo,
                           stParams), HTML_SUCCESS, false, TTextWriterKind.twNone);
        end;
      except

      end;
    end
    else
    if (ctxt.Method = mPOST) then
    begin
      FileFromString(Ctxt.Call.InBody, 'Oracle\LideraSmart\TEMP_INSERT\' + fNomeArq);
      If ExecQuery('Oracle\LideraSmart\TEMP_INSERT\' + fNomeArq) then
        ctxt.Returns('OK')
      else
        ctxt.Returns('Falha no SQL - Favor entrar em contato com a TI da Matriz.');
    end
    else
      Ctxt.Error('Pagina não Encontrada', HTML_NOTFOUND);
  end;
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn:ss ', now) + '-' + 'Processado!');
end;
             *)
procedure TLideraRestServer.PACOTE(Ctxt: TSQLRestServerURIContext);
var
  sAux      : RawUTF8;
  fPath, fTempPath : RawUTF8;

  stArquivo : TStringList;
  stListTemp   : TRawUTF8List;
  nAux      : integer;
  ZipSync   : TFileName;
  ZipWrite  : TZipWrite;
  stParams  : TStrings;
  fNomeArq  : TFileName;
begin
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn:ss ', now) + '-' + UTF8ToString(VariantToUTF8(Ctxt.Method)) + ' ' + UTF8ToString(VariantToUTF8(ctxt.URIWithoutSignature)) );
  fTempPath := 'Oracle\LideraSmart\TEMP_ZIP\';
  if (ctxt.Method = mPOST) then
  begin
    stArquivo := TStringList.Create();
    stListTemp := TRawUTF8List.Create();
    ZipSync := ChangeFileExt(DecodeParam(Ctxt.Parameters, -1)[0] + '_'
                                     + fNomeArq + FormatDateTime('ddmmyy', now),'.zip');
    ZipWrite    := TZipWrite.Create(fTempPath + ZipSync);
    try
      stArquivo.Text := Ctxt.Call.InBody;

      for nAux := 0 to stArquivo.Count - 1 do
      begin
        stListTemp.Clear;
        if Pos('sql?',stArquivo.Strings[nAux]) > 0 then
        begin
          sAux := Copy(stArquivo.Strings[nAux], Pos('?',stArquivo.Strings[nAux])+1, maxint);
          getParametrosEArquivo(PUTF8Char(sAux), stParams, fNomeArq);
          fPath := 'Oracle\LideraSmart\SQL\';

          stListTemp.Add(ExecQuery(fPath+fNomeArq + '.get',
                           stParams));

          stArquivo.Strings[nAux] := fTempPath + FormatDateTime('ddmmyy', now)
                                     + DecodeParam(Ctxt.Parameters, -1)[0]
                                     + stParams.Strings[stParams.Count-1] + '.json';
          stListTemp.SaveToFile(stArquivo.Strings[nAux]);
          ZipWrite.AddDeflated(stArquivo.Strings[nAux]);
          DeleteFile(pchar(stArquivo.Strings[nAux]));
        end;
      end;
    finally
      stArquivo.Free;
      stListTemp.Free;
      ZipWrite.Free;
    end;
    ctxt.Returns(ZipSync);
  end;

  if (ctxt.Method = mGET) then
    ctxt.ReturnFile(fTempPath + DecodeParam(Ctxt.Parameters)[0]);

end;

procedure TLideraRestServer.Ping(Ctxt: TSQLRestServerURIContext);
begin
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn:ss ', now) + '-' + UTF8ToString(VariantToUTF8(Ctxt.Method)) + ' ' + UTF8ToString(VariantToUTF8(ctxt.URIWithoutSignature)) );
  ctxt.ReturnsJson('[{"SERVIDOR":"ONLINE"}]', HTML_SUCCESS, false, TTextWriterKind.twNone);
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn:ss ', now) + '-' + 'Processado! ');
end;

procedure TLideraRestServer.PROCESSOS(Ctxt: TSQLRestServerURIContext);
const
   PROCESS_TERMINATE = $0001;
var
  ContinueLoop: LongBool;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  stLista: TStringList;
  stParams: TStrings;
  sMata : string;
  sArquivoLog,
  sArquivoBat: string;

begin

  getParametros(ctxt.Parameters, stParams);
  if stParams.IndexOf('pro=CMD') >= 0 then
  begin
    sArquivoLog := 'CMD\CMD'+formatdatetime('ddmmss', now)+'.txt';
    sArquivoBat := 'CMD\CMD'+formatdatetime('ddmmss', now)+'.bat';
    ExecutaBat('('+StringReplaceAll(urldecode(stParams[1]), ';', sLineBreak)+') > '+
     sArquivoLog, sArquivoBat, false);
    Ctxt.Redirect('/root/qryDetran/0/PROCESSOS?pro=Lista&arqLog='+sArquivoLog);
  end
  else
  if stParams.IndexOf('Pro=Lista') >= 0 then
  begin
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := sizeof(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

    stLista := TStringList.Create;

    if  pos('arqLog=', stParams.Text) > 0 then
    begin
      stLista.LoadFromFile(copy(stParams[1], pos('arqLog=', stParams[1])+7, maxint));
      sArquivoLog := stLista.Text;
      stLista.Clear;
    end;


    stLista.Add(' <!DOCTYPE html>' +
      ' <html> ' +
      ' <body> ' +
      '<h1>CMD</h1>' +
      '<textarea rows="10" cols="100">'+sArquivoLog+'</textarea><br>' +
      '<textarea id="myTextArea" rows="10" cols="100">jhgf</textarea> ' +
      ' <button type="button" onclick="var myTextArea = document.getElementById(''myTextArea''); ' +
      ' window.location=''/root/qryDetran/0/PROCESSOS?pro=CMD&''+ myTextArea.value; ">Click Me!</button> ' +
      '<h1>Mata Processos </h1>');
    try
      sMata:= 'PROCESSOS?pro=Mata';
      while Integer(ContinueLoop) <> 0 do
      begin
        stLista.Add('<a href="'+sMata+ '&'+FProcessEntry32.szExeFile +'"> ' +
              ' <input type="button" class="button" value="'+FProcessEntry32.szExeFile+
              ' usage'+ExtractFilePath(string(FProcessEntry32.szExeFile))+ '" /></a><br> ');
        ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
      end;
      stLista.Add('    </body>     </html>      ');

      Ctxt.Returns(stLista.Text,HTML_SUCCESS,HTML_CONTENT_TYPE_HEADER);
    finally
     CloseHandle(FSnapshotHandle);
     stLista.Clear;
    end;
  end
  else
  if stParams.IndexOf('pro=Mata') >= 0 then
  begin
    KillTask(stParams[1]);
    Ctxt.Redirect('/root/qryDetran/0/PROCESSOS?pro=Lista');
//    Ctxt.Returns('/root/qryDetran/0/PROCESSOS?pro=Lista',HTML_SUCCESS,HTML_CONTENT_TYPE_HEADER);
  end;

end;

function TLideraRestServer.ExecQuery(prFileName: String; prParams: TStrings): RawUTF8;
var
  stFile: TStringList;
  qry: TQuery;
  i: Integer;
  sAux : string;
begin
  stFile:= TStringList.Create;
  qry := TQuery.Create(fProps.ThreadSafeConnection);
  try
    stFile.LoadFromFile(prFileName);
    qry.SQL.Clear;
    qry.SQL.Assign(stFile);

    if Assigned(prParams) then
    begin
      qry.ParamByName('where').AsVariant := '1=1';
      for I := 0 to prParams.Count -1 do
        qry.ParamByName(copy(prParams[I], 0, pos('=', prParams[I])-1)).AsVariant :=
           StringReplace(UTF8ToString(UrlDecode(copy(prParams[I], pos('=', prParams[I])+1, maxint))),'"','''',[rfReplaceAll]);
    end;

    try
      qry.Open;
  //    qry.PreparedSQLDBStatement.ExecutePrepared;
    //
//    |  Result := qry.PreparedSQLDBStatement.FetchAllAsJSON(True, nil, false);
//      qry.PreparedSQLDBStatement.ExecutePreparedAndFetchAllAsJSON(True, result);
      qry.First;
      while not(qry.Eof) do
      begin
        if Result <> '' then
          sAux := ',{'
        else
          sAux := '{';

        for I := 0 to qry.FieldCount-1 do
        begin
          sAux := sAux + '"' + qry.Fields[i].FieldName + '":"' + qry.Fields[i].AsString +'"';
          if i < qry.FieldCount-1 then
            sAux := sAux + ',';
        end;
        sAux := sAux + '}';
        Result := Result + sAux;
        qry.Next;
      end;
      Result :=  '[' + Result + ']';



    except on E: Exception do
      begin
        Result := '[{"SERVIDOR":"'+ StringToSynUnicode( E.Message) + '"}]';
      end;
    end;

  finally
    stFile.Free;
    qry.Free;
  end;
end;

function TLideraRestServer.ExecQueryTxt(prFileName: String; prParams: TStrings): RawUTF8;
var
  stFile: TStringList;
  qry: TQuery;
  i: Integer;
begin
  stFile:= TStringList.Create;
  qry := TQuery.Create(fProps.ThreadSafeConnection);
  try
    stFile.LoadFromFile(prFileName);
    qry.SQL.Clear;
    qry.SQL.Assign(stFile);

    for I := 0 to prParams.Count -1 do
    begin
      if (copy(prParams[I], 0, pos('=', prParams[I])-1) = 'WHERE') and (UrlDecode(copy(prParams[I], pos('=', prParams[I])+1, maxint)) = '') then
      begin
        qry.ParamByName(copy(prParams[I], 0, pos('=', prParams[I])-1)).AsVariant := '1=1'
      end
      else
        qry.ParamByName(copy(prParams[I], 0, pos('=', prParams[I])-1)).AsVariant := UrlDecode(copy(prParams[I], pos('=', prParams[I])+1, maxint));
    end;

    try
      qry.Open;
      //qry.PreparedSQLDBStatement.ExecutePrepared;
      //Result := qry.PreparedSQLDBStatement.FetchAllAsJSON(True, nil, True);
      qry.First;
      stFile.clear;
      while not qry.Eof do
      begin
        stFile.Add(qry.Fields[0].AsString);
        qry.Next;
      end;
      Result := stFile.Text;

    except on E: Exception do
      begin
        Result := '[{"SERVIDOR":"'+ StringToSynUnicode( E.Message) + '"}]';
      end;
    end;

  finally
    stFile.Free;
    qry.Free;
  end;
end;

procedure TLideraRestServer.EXIBEHTML(Ctxt: TSQLRestServerURIContext);
var
  stFile : TStringList;
  sArquivo : string;
begin
  sArquivo := 'HTML\'+ Ctxt.Parameters + '.html';
  if FileExists(sArquivo) then
  BEGIN
    stFile := TStringList.Create;
    try

       stFile.LoadFromFile(sArquivo);
       Ctxt.Returns(stFile.Text,HTML_SUCCESS, HTML_CONTENT_TYPE_HEADER);
    finally
      stFile.Free;
    end;
  END
  else
    ctxt.Returns('Arquivo Não Encontrado');
end;

procedure TLideraRestServer.INSEREJSON(Ctxt: TSQLRestServerURIContext);
var
  stFile: TRawUTF8List;
  list: TSQLTableJSON;
  sSaida,
  sTabela,
  sTipoOpe,
  sWhere: Variant;
  nAux: integer;
  stParams : TStrings;
begin
  stFile:= TRawUTF8List.Create;
  try
      try
      //Carrega body do html e Limpa sujeiras
      stFile.Text := Copy(Ctxt.Call.InBody, pos('[{',Ctxt.Call.InBody), maxInt);
      stFile.Text := Copy(stFile.Text, 0,  pos('"}]',stFile.Text)+10 );

      //carrega arquivo json
      list := TSQLTableJSON.Create('',pointer(stFile.Text),length(stFile.Text));
      getParametros(Ctxt.Parameters ,stParams);

      for nAux := 0 to stParams.Count-1 do
      begin
        if Pos('abela=', stParams[nAux]) > 0 then //é sem o T mesmo....
        begin
          sTabela := Copy(stParams[nAux], Pos('tabela=', stParams[nAux]) + 7, maxint);
        end
        else
        if Pos('ipoOpe=', stParams[nAux]) > 0 then
        begin
          sTipoOpe := Copy(stParams[nAux], Pos('tipoOpe=', stParams[nAux]) + 8, maxint);
        end
        else
        if Pos('here=', stParams[nAux]) > 0 then
        begin
          sWhere := Copy(stParams[nAux], Pos('where=', stParams[nAux]) + 6, maxint);
        end;
      end;

      for nAux := 1 to list.RowCount do
      begin
        //pega a linha JSON nAux e joga na variant sSaida
        list.ToDocVariant(nAux, sSaida);
        //Transforma a linha em SQL
        if sTipoOpe = 'Insert' then
        begin
          sSaida := GetJSONObjectAsSQL(sSaida,false,false);
          fProps.ExecuteInlined('Insert into ' + sTabela + ' ' + sSaida, false);
        end
        else
        begin
          sSaida := GetJSONObjectAsSQL(sSaida,true,false);
          fProps.ExecuteInlined('Update '+sTabela+' set ' + sSaida + ' where ' + sWhere, false);
        end;

      end;

      ctxt.Returns('JSON INSERIDO COM SUCESSO!');
    except
      ctxt.Returns('DEU MERDA, CORRIJA O ARQUIVO JSON E TENTE NOVAMENTE!');
    end;

  finally
    stFile.Free;
  end;

end;

function TLideraRestServer.ExecQuery(prFileName: String): Boolean;
var
  stFile: TRawUTF8List;
  batchOptions: TSQLRestBatchOptions;
begin
  stFile:= TRawUTF8List.Create;
  try
    byte(batchOptions) := 0;
    {ToDo: estudar o funcionamento desse batchstart}
   // InternalBatchStart(tsqlURImeTHOD.mPOST, batchOptions);
    stFile.LoadFromFile(prFileName);
    try
      fProps.ExecuteInlined(stFile.Text, false);
      result := True;
    except
      result := False;
    end;
  finally
    stFile.Free;
  end;
end;

procedure TLideraRestServer.OPEINSERT(Ctxt: TSQLRestServerURIContext);
var
  batchOptions: TSQLRestBatchOptions;
  sAux,
  sTel,
  sUF,
  sObs,
  sOpe : string;
begin
  ServidorRestFr.mmLogSrv.Lines.Add(FormatDateTime('dd/mm/yy hh:nn:ss ', now) + '-' + UTF8ToString(VariantToUTF8(Ctxt.Method)) + ' ' + UTF8ToString(VariantToUTF8(ctxt.URIWithoutSignature)) );

  try
    byte(batchOptions) := 0;
    sTel := StringReplace(urldecode(DecodeParam(ctxt.Parameters, 0).strings[0]),#39,' ',[rfReplaceAll]);  //StringReplace(S,'&nbsp;','',[rfReplaceAll]);
    sOpe := StringReplace(urldecode(DecodeParam(ctxt.Parameters, 0).strings[1]),#39,' ',[rfReplaceAll]);
    sUF  := StringReplace(urldecode(DecodeParam(ctxt.Parameters, 0).strings[2]),#39,' ',[rfReplaceAll]);
    sObs := StringReplace(urldecode(DecodeParam(ctxt.Parameters, 0).strings[3]),#39,' ',[rfReplaceAll]);

//    DecodeParam(prParametros, -1)
    {ToDo: estudar o funcionamento desse batchstart}
   // InternalBatchStart(tsqlURImeTHOD.mPOST, batchOptions);
    try
      fProps.ExecuteInlined(' insert into TEL_NUMERO_OPERADORA(numero, deoperadora, uf, observacao) values ('''+
             copy(sTel, pos('=', sTel)+1, maxInt) + ''', ''' + copy(sOpe, pos('=', sOpe)+1, maxInt) + ''', ''' +
             copy(sUF, pos('=', sUF)+1, maxInt) + ''', ''' + copy(sObs, pos('=', sObs)+1, maxInt) + ''');' , false);
      ctxt.Returns('INSERIDO COM SUCESSO')
    except on E: Exception do
      ctxt.Error('ERRO AO INSERIR' + e.Message, HTML_NOTFOUND);
    end;

  finally

  end;

end;

end.
