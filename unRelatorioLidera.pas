unit unRelatorioLidera;

interface

uses
 frxClass, frxExportPDF, frxDBSet, frxFDComponents, SysUtils, Classes;

  procedure ProcessaRelatorioLidera(prNomeRel:string; prParametros:TStrings; prNomeArq: string; prPastaLocal: string);

implementation

procedure ProcessaRelatorioLidera(prNomeRel:string; prParametros:TStrings; prNomeArq: string; prPastaLocal: string);
var
  sStr : string;
  frxReport : TfrxReport;
  frxPdf : TfrxPDFExport;
  stParametros : TStringList;
  procedure passarPametros();
  var
    nAux : integer;
  begin
    stParametros.AddStrings(prParametros);
    for nAux := 0 to stParametros.Count-1 do
    begin
      if LowerCase(Copy(stParametros[nAux],0,1)) = 's' then
      begin
        frxReport.Variables[copy(stParametros[nAux], 0, Pos('=',stParametros[nAux])-1)] :=
          quotedStr(copy(stParametros[nAux], Pos('=',stParametros[nAux])+1, MaxInt));
      end
      else
      begin
        frxReport.Variables[copy(stParametros[nAux], 0, Pos('=',stParametros[nAux])-1)] :=
         copy(stParametros[nAux], Pos('=',stParametros[nAux])+1, MaxInt);
      end;
    end;
  end;
begin
  frxReport := TFrxReport.Create(nil);
  frxPdf    := TfrxPDFExport.Create(nil);
  stParametros := TStringList.Create;
  try
    frxReport.LoadFromFile(prNomeRel);

    passarPametros;

    frxPdf.ShowDialog := false; //Turn off dialog
    frxPdf.FileName := prNomeArq;
    frxPdf.DefaultPath := '';
    frxReport.PrepareReport();
    frxReport.Export(frxPdf);
  //  frxReport.ShowReport();
  finally
    frxReport.Free;
    frxPdf.Free;
    stParametros.Free;
  end;

end;
end.
