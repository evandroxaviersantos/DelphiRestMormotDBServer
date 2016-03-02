program HttpApiServer;

//crirar tela do dos
//{$APPTYPE CONSOLE}

//{$I Synopse.inc}

uses
  Vcl.Forms,
  unServidorRestFr in 'unServidorRestFr.pas' {ServidorRestFr},
  RESTData in 'RESTData.pas',
  RESTServerClass in 'RESTServerClass.pas',
  unFuncSrvMormot in 'unFuncSrvMormot.pas';

//{$WARN SYMBOL_PLATFORM OFF}

begin
{  with TTestServer.Create('Oracle\LideraSmart\SQL\') do
  try
    write('Server is now running on http://localhost:' + _nPorta + '/root'#13#10#13#10+
      'Press [Enter] to quit');
    readln;
  finally
    Free;
  end;}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServidorRestFr, ServidorRestFr);
  Application.Run;
end.