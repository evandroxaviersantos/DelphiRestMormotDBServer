unit unRelatoriosLidera;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  Vcl.StdCtrls, frxClass, frxExportPDF, frxDBSet, frxFDComponents;

type
  TRelatoriosLidera = class(TForm)
    frxPDF: TfrxPDFExport;
    Button1: TButton;
    frxReport: TfrxReport;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RelatoriosLidera: TRelatoriosLidera;

implementation

{$R *.dfm}

procedure TRelatoriosLidera.Button1Click(Sender: TObject);
var
  sStr : string;
begin
  frxReport.LoadFromFile('RelatoriosLidera\ContraChequePortal.fr3');
  sStr := '11/2015';
  frxReport.Variables['dataComp'] := quotedStr(sStr);
  frxReport.Variables['matricula'] := 167428;//quotedstr('167428');
  frxReport.Variables['tipcal'] := 11;
  frxPdf.ShowDialog := false; //Turn off dialog
  frxPdf.FileName := 'aaa.pdf';
  frxPdf.DefaultPath := '';
  frxReport.PrepareReport();
  frxReport.Export(frxPdf);
  frxReport.ShowReport();
end;

end.



