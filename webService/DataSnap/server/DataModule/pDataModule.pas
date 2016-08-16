{ ------------------------ INFORMA��ES GERAIS ---------------------------------
 pDataModule (Data Module)

 Avisos:
 28/04/2016
 Vandeir Roberto Mar�al
 AJI - Sistemas e distribui��o
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

//  System.SysUtils.ShortDateFormat    := 'DD/MM/YYYY';
  gTrocaData         := false;
  gTipReg            := 0;
  gCodCri            := 0;
  gRegistrou         := true;
  gSerie             := 'TR0000';
  ciGtrans.Connected := False;

  { CARREGA O NOME DO SISTEMA, NOME DO SERVIDOR E OS DIRET�RIOS DOS BANCOS
    DE DADOS DO IGT E BANK A PARTIR DO ARQUIVO CONFIGURA��O.INI, PRESENTE NO
    DIRET�RIO DOS EXECUT�VEIS DO SISTEMA.
    LOGO EM SEGUIDA INICIA AS CONEX�ES }

  if ConectarBD then
  begin
    gTipoBd := 1;

    Case gModulo of
      1: begin
        xModulo := ' - M�dulo Configura��es';
        gdescmodulo := 'Configura��es';
        gLetra := 'P';
      end;
      2: begin
        xModulo := '';
        gdescmodulo := 'Financeiro';
        gLetra := 'P';
      end;
      3: begin
        xModulo := '';
        gdescmodulo := 'SpedFiscal';
        gLetra := 'P';
      end;

    end;
  end
  else
  begin
    AbreParamGerais;
    Abort;
  end;
end;

end.
