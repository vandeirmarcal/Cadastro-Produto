unit UConexaoINI;

interface

uses Forms, Windows, Messages, Controls, SysUtils, Variants,
     StdCtrls, IniFiles;

type
  recArquivoINI = record
    NomeSistema  : string[50];
    ServidorTMS  : string[50];
    CaminhoTMS   : string[255];
    ServidorBANK : string[50];
    CaminhoBANK  : string[255];
    CaminhoServidor : String[255];
  end;
  procedure setINIConexao(precConfigINI : recArquivoINI);
  function ConectarBD : Boolean;
  function CarregarINI(psCaminhoINI : string) : recArquivoINI;
  function getCaminhoINI : string;
  procedure AbreParamGerais;

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

    // CARREGANDO AS CONFIGURAÇÕES DO ARQUIVO INI
    recConfigINI := CarregarINI(getCaminhoINI);

    // NOME DO SISTEMA
    gNomSis := recConfigINI.NomeSistema;

    // SETANDO A CONEXÃO DO TMS
    sServidorTMS := recConfigINI.ServidorTMS;
    sCaminhoTMS  := recConfigINI.CaminhoTMS;

    // SETANDO A CONEXÃO DO BANK
    sServidorBANK := recConfigINI.ServidorBANK;
    sCaminhoBANK  := recConfigINI.CaminhoBANK;


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
                                   'CONFIGURAÇÃO.INI');
    with fArquivoINI do
    begin
      // NOME DO SISTEMA
      WriteString('CONEXAO_BD', 'NomeSistema', precConfigINI.NomeSistema);
      // SETANDO NOVO SERVIDOR TMS
      WriteString('CONEXAO_BD', 'ServidorTMS', precConfigINI.ServidorTMS);
      // SETANDO NOVO CAMINHO BANCO DE DADOS TMS
      WriteString('CONEXAO_BD', 'CaminhoTMS',  precConfigINI.CaminhoTMS);
      // SETANDO NOVO SERVIDOR BANK
      WriteString('CONEXAO_BD','ServidorBANK', precConfigINI.ServidorBANK);
      // SETANDO NOVO CAMINHO BANCO DE DADOS BANK
      WriteString('CONEXAO_BD','CaminhoBANK',  precConfigINI.CaminhoBANK);
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
    Result.NomeSistema  := fArquivoINI.ReadString('CONEXAO_BD',Trim(UpperCase('NomeSistema')),'');
    Result.ServidorTMS  := fArquivoINI.ReadString('CONEXAO_BD',Trim(UpperCase('ServidorTMS')),'');
    Result.CaminhoTMS   := fArquivoINI.ReadString('CONEXAO_BD',Trim(UpperCase('CaminhoTMS')),'');
    Result.ServidorBANK := fArquivoINI.ReadString('CONEXAO_BD',Trim(UpperCase('ServidorBANK')),'');
    Result.CaminhoBANK  := fArquivoINI.ReadString('CONEXAO_BD',Trim(UpperCase('CaminhoBANK')),'');
    Result.CaminhoServidor := fArquivoINI.ReadString('CONEXAO_BD',Trim(UpperCase('CaminhoServidor')),'');
    FreeAndNil(fArquivoINI);
  except
    FreeAndNil(fArquivoINI);
//    ErroConexao(False, True, True, True);
    Abort;
  end;
end;

function getCaminhoINI : string;
Var
  sCaminhoINI : string;
begin
  // CARREGANDO ARQUIVO INI
  sCaminhoINI := ExtractFilePath(Application.ExeName) + 'CONFIGURAÇÃO.INI';
  if not FileExists(sCaminhoINI) then
  begin
    Result := '';
  end
  else
  begin
    Result := sCaminhoINI;
  end;  
end;

procedure AbreParamGerais;
begin
{  try
    if fParameG <> nil then
    begin
      FreeAndNil(fParameG);
    end;
    Application.CreateForm(TfParameG, fParameG);
    fParameG.ShowModal;
  except
    FreeAndNil(fParameG);
    MsgErro('Não foi possível abrir o formulário de Parâmetros Gerais. ' +
            'Por favor, acesse o arquivo CONFIGURAÇÃO.INI no diretório ' +
            'do sistema.');
  end;
}
end;

end.
