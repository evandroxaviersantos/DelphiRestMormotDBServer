unit RESTData;

interface

uses
  SynCommons,
  mORMot;

type
  TSQLRecordWithModTimeAndMetaData = class(TSQLRecord)
  protected
    fCreated: TCreateTime;
    fModified: TModTime;
    fMetaData: variant;
  published
    property Modified: TModTime read fModified write fModified;
    property Created: TCreateTime read fCreated write fCreated;
    property MetaData: variant read fMetaData write fMetaData;
  end;

          { Tabela Antiga -  deixei aqui como exemplo caso precise....
  TSQLNote = class(TSQLRecordWithModTimeAndMetaData)
  protected
    fIdent: RawUTF8;
    fKind: TSQLNoteKind;
    fParent: TSQLNote;
  published
    property Ident: RawUTF8 read fIdent write fIdent;
    property Kind: TSQLNoteKind read fKind write fKind;
    property Parent: TSQLNote read fParent write fParent;
  end;

   TSQLNoteKind = class(TSQLRecordWithModTimeAndMetaData)
  protected
    fName: RawUTF8;
  public
    class procedure InitializeTable(Server: TSQLRestServer;
      const FieldName: RawUTF8; Options: TSQLInitializeTableOptions); override;
  published
    property Name: RawUTF8 read fName write fName stored AS_UNIQUE;
  end;  }

{  TSQLNoteFile = class(TSQLRecordWithModTimeAndMetaData)
  protected
    fFileName: RawUTF8;
    fNote: TSQLNote;
  published
    property FileName: RawUTF8 read fFileName write fFileName;
    property Note: TSQLNote read fNote write fNote;
  end;                           }
  TSQLRelatoriosSenior = class(TSQLRecordVirtual)
  protected
    fFileName: RawUTF8;
  published
    property FileName: RawUTF8 read fFileName write fFileName;
  end;

  TSQLRelatoriosLidera = class(TSQLRecordVirtual)
  protected
    fFileName: RawUTF8;
  published
    property FileName: RawUTF8 read fFileName write fFileName;
  end;

  TSQLqryDetran = class(TSQLRecordVirtual)
  protected
    fFileName: RawUTF8;
  published
    property FileName: RawUTF8 read fFileName write fFileName;
  end;

  TSQLHtml = class(TSQLRecordVirtual)
  protected
    fFileName: RawUTF8;
  published
    property FileName: RawUTF8 read fFileName write fFileName;
  end;
        { Tabela Antiga -  deixei aqui como exemplo caso precise....
  TSQLUser = class(TSQLAuthUser)
  protected
    fMetaData: variant;
  published
    property MetaData: variant read fMetaData write fMetaData;
  end;              }


function DataModel(const RootURI: RawUTF8): TSQLModel;


implementation

function DataModel(const RootURI: RawUTF8): TSQLModel;
begin
  result := TSQLModel.Create(
    [TSQLAuthGroup,{TSQLUser,TSQLNoteKind,TSQLNote,}TSQLRelatoriosSenior, TSQLqryDetran,
    TSQLRelatoriosLidera, TSQLHtml], RootURI);
  //SQLNoteKind.AddFilterOrValidate('Name',TSynValidateText.Create('{MinLength:3}'));
  //TSQLNote.AddFilterOrValidate('Ident',TSynValidateText.Create('{MinLength:3}'));
  //Senior
  TSQLRelatoriosSenior.AddFilterOrValidate('FileName',TSynValidateNonVoidText.Create);
  TSQLRelatoriosSenior.AddFilterOrValidate('FileName',TSynValidateText.Create('{MaxPunctCount:0}'));
  //Lidera
  TSQLRelatoriosLidera.AddFilterOrValidate('FileName',TSynValidateNonVoidText.Create);
  TSQLRelatoriosLidera.AddFilterOrValidate('FileName',TSynValidateText.Create('{MaxPunctCount:0}'));
end;

{ TSQLNoteKind }

{class procedure TSQLNoteKind.InitializeTable(Server: TSQLRestServer;
  const FieldName: RawUTF8; Options: TSQLInitializeTableOptions);
var Kind: TSQLNoteKind;
begin
  inherited;
  Kind := TSQLNoteKind.Create;
  Kind.Name := 'PostIt';
  Server.Add(Kind,true);
  Kind.Name := 'Todo';
  Server.Add(Kind,true);
  Kind.Free;
end;         }

end.