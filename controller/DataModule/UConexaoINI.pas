unit UConexaoINI;

interface

uses Forms, Windows, Messages, Controls, SysUtils, Variants,
     StdCtrls, IniFiles;

type
  recArquivoINI = record
    NomeSistema  : string;
    Servidor  : string;
    Caminho   : string;
    CaminhoServidor : String;
  end;
  procedure setINIConexao(precConfigINI : recArquivoINI);
  function ConectarBD : Boolean;
  function CarregarINI(psCaminhoINI : string) : recArquivoINI;
  function getCaminhoINI : string;

implementation

uses pDataModule;

function ConectarBD : Boolean;
Var
  sServidorTMS  : string;
  sServidorBANK : string;
  sCaminhoBANK  : string;
  sCaminhoTMS   : string;
  recConfigINI  : recArquivoINI;
begin
  try
    Result := False;

    // CARREGANDO AS CONFIGURA��ES DO ARQUIVO INI
    recConfigINI := CarregarINI(getCaminhoINI);

    // NOME DO SISTEMA
    gNomSis := recConfigINI.NomeSistema;

    // SETANDO A CONEX�O DO TMS
    sServidorTMS := recConfigINI.Servidor;
    sCaminhoTMS  := recConfigINI.Caminho;

    // SETANDO O CAMINHO DO SERVIDOR PARA SUBSTITUIR EXTRACTFILEPATH ( APPLICATION.EXENAME );
    if (Trim(recConfigINI.CaminhoServidor) <> '') then
    Begin
      sCaminhoServidor := recConfigINI.CaminhoServidor + '\';
    End
    Else
    Begin
      sCaminhoServidor := ExtractFilePath(Application.ExeName);
    End;


    Result := True;
  except
    Result := False;
  end;
end;

procedure setINIConexao(precConfigINI : recArquivoINI);
Var
  fArquivoINI : TIniFile;
begin
  try
    fArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName) +
                                   'CONFIGURA��O.INI');
    with fArquivoINI do
    begin
      // NOME DO SISTEMA
      WriteString('CONEXAO_BD', 'NomeSistema', precConfigINI.NomeSistema);

      // SETANDO NOVO SERVIDOR TMS
      WriteString('CONEXAO_BD', 'ServidorTMS', precConfigINI.Servidor);

      // SETANDO NOVO CAMINHO BANCO DE DADOS TMS
      WriteString('CONEXAO_BD', 'CaminhoTMS',  precConfigINI.Caminho);
    end;
    FreeAndNil(fArquivoINI);
  except
    FreeAndNil(fArquivoINI);
    Abort;
  end;
end;



function CarregarINI(psCaminhoINI : string) : recArquivoINI;
Var
  fArquivoINI : TIniFile;
begin
  try
    fArquivoINI := TIniFile.Create(psCaminhoINI);

    // CARREGANDO OS DADOS DO ARQUIVO INI
    Result.NomeSistema     := fArquivoINI.ReadString('CONEXAO_BD',
                                             Trim(UpperCase('NomeSistema')),'');

    Result.Servidor        := fArquivoINI.ReadString('CONEXAO_BD',
                                                Trim(UpperCase('Servidor')),'');

    Result.Caminho         := fArquivoINI.ReadString('CONEXAO_BD',
                                                 Trim(UpperCase('Caminho')),'');

    Result.CaminhoServidor := fArquivoINI.ReadString('CONEXAO_BD',
                                         Trim(UpperCase('CaminhoServidor')),'');
    FreeAndNil(fArquivoINI);
  except
    FreeAndNil(fArquivoINI);
    Abort;
  end;
end;

function getCaminhoINI : string;
Var
  sCaminhoINI : string;
begin

  // CARREGANDO ARQUIVO INI
  sCaminhoINI := ExtractFilePath(Application.ExeName) + 'CONFIGURA��O.INI';
  if not FileExists(sCaminhoINI) then
  begin
    Result := '';
  end
  else
  begin
    Result := sCaminhoINI;
  end;
end;

end.
