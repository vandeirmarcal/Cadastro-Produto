{ ------------------------ INFORMAÇÕES GERAIS ---------------------------------
 pDataModule (Data Module)

 Avisos:
 28/04/2016
 Vandeir Roberto Marçal
 AJI - Sistemas e distribuição
 ----------------------------------------------------------------------------- }
unit pDataModule;

interface

uses
  SysUtils, Classes, DB, IBX.IBDatabase, Controls, UConexaoINI;

type
  TUdmParame = class(TDataModule)
    trTrans: TIBTransaction;
    ciGtrans: TIBDatabase;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ConectarBD: Boolean;

  end;

Var
  UdmParame: TUdmParame;
  gDatLib: tdate;
  gTipoBD, gModulo: byte;
  gTrocaData, gRegistrou, gAltData, gModLib: boolean;
  gEmpDes, gNomSis, gDireto, gVersao, gSerie, gLibera, gHd: string;
  gLetra: string[1];
  gCodEmp: string;
  gMoedas: string[20];

  gLogUsu   : string[20];
  gSenhaUsu : String[50];

  gTipReg, gCodCri: integer;

  gSistema, gdescmodulo, sRelease, sCaminhoServidor : string;

implementation

{$R *.dfm}

procedure TUdmParame.DataModuleCreate(Sender: TObject);

var
  xModulo: string;

begin

  gTrocaData         := false;
  gTipReg            := 0;
  gCodCri            := 0;
  gRegistrou         := true;
  gSerie             := 'TR0000';
  ciGtrans.Connected := False;

  ConectarBD;
end;

function TUdmParame.ConectarBD: Boolean;
Var
  recConfigINI: recArquivoINI;
begin
  Result := False;
  try
    recConfigINI := CarregarINI(getCaminhoINI);
    gNomSis := recConfigINI.NomeSistema;

    ciGtrans.Connected := False;
    ciGtrans.DatabaseName := recConfigINI.Caminho;
    ciGtrans.Connected := True;

    if (Trim(recConfigINI.CaminhoServidor) <> '') then
      sCaminhoServidor := recConfigINI.CaminhoServidor + '\'
    else
     // sCaminhoServidor := ExtractFilePath(Application.ExeName);

    Result := True;
  except
    Result := False;
  end;
end;


end.
