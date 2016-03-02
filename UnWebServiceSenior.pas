unit UnWebServiceSenior;

interface

uses
  System.SysUtils, System.Classes, ActiveX, XMLintf, SOAPHTTPTrans, WSDLNode,
  WinInet, XMLDoc, StrUtils;

type
  TWebServiceSenior = class(TComponent)
  private
    GetUsuarioAdm,
    GetSenhaAdm,
    GetNomeServico,
    GetSoapAction,
    GetParametros,
    GetTipoPorta,
    GetOperacao,
    GetDiretorio,
    GetEnderecoServidor,
    GetUrl,
    GetSeparadorUrl     : String;
    GetTimeOut          : Integer;

    procedure SetUsuarioAdm(const Value : String);
    procedure SetSenhaAdm(const Value : String);
    procedure SetNomeServico(const Value : String);
    procedure SetSoapAction(const Value : String);
    procedure SetTimeOut(const Value : Integer);
    procedure SetDiretorio(const Value : String);
    procedure SetEnderecoServidor(const Value : String);
    procedure SetSeparadorUrl(const Value : String);
    procedure SetUrl;
  protected
    function ExecutarWebService : String;
  public
    constructor Create(AOwner : TComponent); override;
    function GerarRelatorio(const sEntrada,
                                  sNomeArquivo,
                                  sNomeRelatorio : String;
                            const bEhRelRubi     : Boolean
                           ) : String;
    function UsuarioSenhaValido(const sNomeUsuario, sSenhaUsuario : String) : Boolean;
    function TrocaSenhaUsuario(const sNomeUsuario,
                                     sSenhaUsuario,
                                     sNovaSenha : String;
                               const bEhSistemaRubi : Boolean
                              ) : String;
    function GerarNotaFiscalSaida(const sParametros : String) : String;
    function GerarBaixaPorLoteCR(const sParametros : String) : String;
    function GerarBaixaTituloCR(const sParametros: String): String;
    function AlterarFichaBasica(const sNumEmp,
                                      sTipCol,
                                      sNumCad : String;
                                      sModPag : String = '';
                                      sCodBan : String = '';
                                      sCodAge : String = '';
                                      sConBan : String = '';
                                      sDigBan : String = ''
                               ) : String;
    function TrocarEscala(const sNumEmp,
                                sTipCol,
                                sNumCad,
                                sDatAlt,
                                sCodEsc,
                                sCodTma : String
                         ) : String;
    function TrocarCargo(const sNumEmp,
                               sTipCol,
                               sNumCad,
                               sDatAlt,
                               sCodCar,
                               sCodMot : String
                        ) : String;
    function TrocarSalario(const sNumEmp,
                                 sTipCol,
                                 sNumCad,
                                 sDatAlt,
                                 sSeqAlt,
                                 sCodMot,
                                 sTipSal,
                                 sValSal : String
                          ) : String;
    function TrocarSindicato(const sNumEmp,
                                   sTipCol,
                                   sNumCad,
                                   sDatAlt,
                                   sCodSin,
                                   sSocSin : String
                            ) : String;
    function TrocarLocal(const sNumEmp,
                               sTipCol,
                               sNumCad,
                               sDatAlt,
                               sNumLoc : String
                        ) : String;
    function TrocarCentroCusto(const sNumEmp,
                                     sTipCol,
                                     sNumCad,
                                     sDatAlt,
                                     sCodCcu,
                                     sTipOpe : String
                              ) : String;
    function TrocarFilial(const sNumEmp,
                                sTipCol,
                                sNumCad,
                                sDatAlt,
                                sNovFil,
                                sTipAdm : String
                         ) : String;
  published
    property UsuarioAdm       : String  read GetUsuarioAdm       write SetUsuarioAdm;
    property SenhaAdm         : String  read GetSenhaAdm         write SetSenhaAdm;
    property NomeServico      : String  read GetNomeServico      write SetNomeServico;
    property SoapAction       : String  read GetSoapAction       write SetSoapAction;
    property TimeOut          : Integer read GetTimeOut          write SetTimeOut;
    property Diretorio        : String  read GetDiretorio        write SetDiretorio;
    property EnderecoServidor : String  read GetEnderecoServidor write SetEnderecoServidor;
    property SeparadorUrl     : String  read GetSeparadorUrl     write SetSeparadorUrl;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Web Service Senior', [TWebServiceSenior]);
end;

constructor TWebServiceSenior.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  GetNomeServico      := 'g5-senior-services';
  GetTimeOut          := 300000; //Configura TimeOut padrão da conexão em 5 Minutos
  GetDiretorio        := '\\127.0.0.1\xx\images\';
  GetEnderecoServidor := 'http://localhost:8080';
  GetSeparadorUrl     := '_';
end;

procedure TWebServiceSenior.SetUsuarioAdm(const Value : String);
begin
  GetUsuarioAdm := Value;
end;

procedure TWebServiceSenior.SetSenhaAdm(const Value : String);
begin
  GetSenhaAdm := Value;
end;

procedure TWebServiceSenior.SetNomeServico(const Value : String);
begin
  GetNomeServico := Value;
end;

procedure TWebServiceSenior.SetSoapAction(const Value : String);
begin
  GetSoapAction := Value;
end;

procedure TWebServiceSenior.SetTimeOut(const Value : Integer);
begin
  GetTimeOut := Value;
end;

procedure TWebServiceSenior.SetDiretorio(const Value : String);
begin
  GetDiretorio := Value;
end;

procedure TWebServiceSenior.SetEnderecoServidor(const Value : String);
begin
  GetEnderecoServidor := Value;
end;

procedure TWebServiceSenior.SetSeparadorUrl(const Value : String);
begin
  GetSeparadorUrl := Value;
end;

procedure TWebServiceSenior.SetUrl;
begin
  GetUrl := GetEnderecoServidor + '/' + GetNomeServico;
end;

function TWebServiceSenior.ExecutarWebService : String;
const
  cRequisicao = '';
var
  xConnectSender : THTTPReqResp;
  xWSDLAdr       : TWSDLView;
  StreamRetorno  : TMemoryStream;
  StreamString   : TStringStream;
  xDocumentoXML  : TXMLDocument;
  conntimeout,
  sendtimeout,
  recvtimeout    : Integer;
  mRetorno       : TStringList;
  sArqRetorno    : String;
begin
  xConnectSender := nil;
  xWSDLAdr       := nil;
  StreamRetorno  := nil;
  StreamString   := nil;
  xDocumentoXML  := nil;
  mRetorno       := TStringList.Create;

  conntimeout := GetTimeOut;
  sendtimeout := GetTimeOut;
  recvtimeout := GetTimeOut;
  try
    // Cria o objeto que fará a conversação com o Web Service (Classe Nativa Delphi).
    xConnectSender := SOAPHTTPTrans.THTTPReqResp.Create(nil);

   // Cria objeto de stream para receber o retorno da solicitação.
   StreamRetorno  := TMemoryStream.Create;
   StreamString   := TStringStream.Create('');

   // Configura especificação do Web Service.
   xWSDLAdr            := TWSDLView.Create(nil);
   xWSDLAdr.PortType   := GetTipoPorta;
   xWSDLAdr.Operation  := GetOperacao;
   xWSDLAdr.Service    := GetNomeServico;
   xWSDLAdr.Activate;

   // Configura a conexão.
   xConnectSender.URL        := GetUrl;
   xConnectSender.SoapAction := GetSoapAction;
   xConnectSender.WSDLView   := xWSDLAdr;

{
    // Se informou Proxy configura Proxy
    if (xProxy.Text <> '') then
    begin
      xConnectSender.Proxy     := xProxy.Text;
      xConnectSender.UserName  := xUsuarioProxy.Text;
      xConnectSender.Password  := xSenhaProxy.Text;
    end;
}
    // Configura o Timeout da conexão.
    InternetSetOption(nil, INTERNET_OPTION_CONNECT_TIMEOUT, Pointer(@conntimeout), SizeOf(conntimeout));
    InternetSetOption(nil, INTERNET_OPTION_SEND_TIMEOUT, Pointer(@sendtimeout), SizeOf(sendtimeout));
    InternetSetOption(nil, INTERNET_OPTION_RECEIVE_TIMEOUT, Pointer(@recvtimeout), SizeOf(recvtimeout));

    // Abre a Conexão
    xConnectSender.Connect(True);

    // Executa o Web Service.
    xConnectSender.Execute(Format(cRequisicao,
                                  [
                                   GetOperacao,
                                   GetUsuarioAdm,
                                   GetSenhaAdm,
                                   GetParametros,
                                   GetOperacao
                                  ]
                                 ),
                           StreamRetorno);

    // Fecha a Conexão
    xConnectSender.Connect(False);

    // Transforma o Retorno em Texto para Jogar para a Caixa de Texto.
    StreamString.CopyFrom(StreamRetorno, 0);
    mRetorno.Text := StreamString.DataString;

    sArqRetorno := GetDiretorio + '\RetornoWebService' + FormatDateTime('hhnnss', Time) + '.xml';
    mRetorno.SaveToFile(sArqRetorno);
    mRetorno.Clear;

    // Cria documento XML.
    xDocumentoXML          := TXMLDocument.Create(nil);
    CoInitialize(nil);
//    xDocumentoXML.LoadFromStream(StreamRetorno);
    xDocumentoXML.LoadFromFile(sArqRetorno);

    if FileExists(sArqRetorno) then
      DeleteFile(sArqRetorno);
//    xDocumentoXML.SaveToFile(GetDiretorio + '\Retorno_Web_Service.XML');

    Result := xDocumentoXML.XML.Text;
    CoUnInitialize;
  finally
    xWSDLAdr.Free;
    xConnectSender.Free;
    StreamRetorno.Free;
    StreamString.Free;
    FreeAndNil(mRetorno);
    {$IFNDEF CONSOLE}
      FreeAndNil(xDocumentoXML);
    {$ENDIF}
  end;
end;

function TWebServiceSenior.GerarBaixaPorLoteCR(
  const sParametros: String): String;
begin
  Result        := '';
end;

function TWebServiceSenior.GerarBaixaTituloCR(
  const sParametros: String): String;
begin
  Result        := '';
end;

function TWebServiceSenior.GerarNotaFiscalSaida(const sParametros : String) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.GerarRelatorio(const sEntrada,
                                                sNomeArquivo,
                                                sNomeRelatorio : String;
                                          const bEhRelRubi     : Boolean
                                         ) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.UsuarioSenhaValido(const sNomeUsuario, sSenhaUsuario : String) : Boolean;
var
  sRetorno : String;
begin
  Result        := True;
end;

function TWebServiceSenior.TrocaSenhaUsuario(const sNomeUsuario,
                                                   sSenhaUsuario,
                                                   sNovaSenha : String;
                                             const bEhSistemaRubi : Boolean
                                            ) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.AlterarFichaBasica(const sNumEmp,
                                                    sTipCol,
                                                    sNumCad : String;
                                                    sModPag : String = '';
                                                    sCodBan : String = '';
                                                    sCodAge : String = '';
                                                    sConBan : String = '';
                                                    sDigBan : String = ''
                                             ) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.TrocarEscala(const sNumEmp,
                                              sTipCol,
                                              sNumCad,
                                              sDatAlt,
                                              sCodEsc,
                                              sCodTma : String
                                       ) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.TrocarCargo(const sNumEmp,
                                             sTipCol,
                                             sNumCad,
                                             sDatAlt,
                                             sCodCar,
                                             sCodMot : String
                                      ) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.TrocarSalario(const sNumEmp,
                                               sTipCol,
                                               sNumCad,
                                               sDatAlt,
                                               sSeqAlt,
                                               sCodMot,
                                               sTipSal,
                                               sValSal : String
                                        ) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.TrocarSindicato(const sNumEmp,
                                                 sTipCol,
                                                 sNumCad,
                                                 sDatAlt,
                                                 sCodSin,
                                                 sSocSin : String
                                          ) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.TrocarCentroCusto(const sNumEmp,
                                                   sTipCol,
                                                   sNumCad,
                                                   sDatAlt,
                                                   sCodCcu,
                                                   sTipOpe : String
                                            ) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.TrocarLocal(const sNumEmp,
                                             sTipCol,
                                             sNumCad,
                                             sDatAlt,
                                             sNumLoc : String
                                      ) : String;
begin
  Result        := '';
end;

function TWebServiceSenior.TrocarFilial(const sNumEmp,
                                              sTipCol,
                                              sNumCad,
                                              sDatAlt,
                                              sNovFil,
                                              sTipAdm : String
                                       ) : String;
begin
  Result        := '';
end;

end.
