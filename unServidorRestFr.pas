unit unServidorRestFr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  SynCommons,
  SynZip,
  SynDB,
  SynDBOracle,
  SynCrtSock,
  SynLog,
  UnWebServiceSenior,
  mORMotHTTPServer,
  RESTData,
  RESTServerClass,
  mormot, Vcl.ExtCtrls;

type
  TServidorRestFr = class(TForm)
    mmLogSrv: TMemo;
    Panel1: TPanel;
    btnPararSvr: TButton;
    btnIniciarSrv: TButton;
    edtPorta: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    rdgBanco: TRadioGroup;
    tmrLog: TTimer;
    procedure btnIniciarSrvClick(Sender: TObject);
    procedure btnPararSvrClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtPortaChange(Sender: TObject);
    procedure tmrLogTimer(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    WebServiceSenior: TWebServiceSenior;

  end;

var
  ServidorRestFr: TServidorRestFr;
  fServer: TSQLHttpServer;
  ORMServer: TLideraRestServer;
  _nPorta : string;
  _sBancoDeDados : string;


implementation

{$R *.dfm}

uses unFuncSrvMormot;

procedure TServidorRestFr.btnIniciarSrvClick(Sender: TObject);
begin
  _nPorta := edtPorta.Text;
  _sBancoDeDados := rdgBanco.Items[rdgBanco.ItemIndex];
  try
    ORMServer := TLideraRestServer.Create(ExeVersion.ProgramFilePath+'relatorioslidera','root');
    fServer := TSQLHttpServer.Create(_nPorta,[ORMSERVER]);//,32, secNone);//, 'root');
   // fPath := IncludeTrailingPathDelimiter(Path);
    TSQLLog.Family.EchoToConsole := LOG_VERBOSE;

    WebServiceSenior := TWebServiceSenior.Create(nil);
    with WebserviceSenior do
    begin
      UsuarioAdm       := 'procaut';
      SenhaAdm         := 'curiosity2012#';
      NomeServico      := 'g5-senior-services';
      TimeOut          := 300000;
      Diretorio        := '\\ns242\domain1\applications\j2ee-modules\sapiensweb\imagens';
      EnderecoServidor := 'http://ns242:8080';
      SeparadorUrl     := '_';
    end;
    mmLogSrv.Lines.Add('Servidor Iniciado!');
  except on E: Exception do
    mmLogSrv.Lines.Add('Deu merda! Mensagem:' + e.Message);
  end;
end;

procedure TServidorRestFr.btnPararSvrClick(Sender: TObject);
begin
  try
    fServer.RemoveServer(ORMServer);
    fServer.Free;
    ORMServer.Destroy;
    WebServiceSenior.Destroy;
    mmLogSrv.Lines.Add('Servidor Parado!');
  except on E: Exception do
    mmLogSrv.Lines.Add('Deu merda! Mensagem:' + e.Message);
  end;
end;



procedure TServidorRestFr.edtPortaChange(Sender: TObject);
begin
  _nPorta := edtPorta.Text;
end;

procedure TServidorRestFr.FormCreate(Sender: TObject);
begin
  edtPorta.Text := '7098';
  _nPorta := edtPorta.Text;
  _sBancoDeDados := rdgBanco.Items[rdgBanco.ItemIndex];
  btnIniciarSrv.Click;
end;

procedure TServidorRestFr.tmrLogTimer(Sender: TObject);
begin
  mmLogSrv.Lines.SaveToFile('log\log'+ FormatDateTime('dd-MM-yyyy_hh-mm-ss', now)+'.txt');
  mmLogSrv.Clear;

end;

end.
