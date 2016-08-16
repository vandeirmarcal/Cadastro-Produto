{ ------------------------- INFORMA��ES GERAIS ---------------------------------
  bValidacaoUsusario; (Objeto respons�vel por autenticar e validar os usu�rios)

  09/06/2016
  Vandeir Roberto Mar�al
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bValidacaoUsusario;

interface

uses db, System.Classes, bSelect;

 type TValidaUsuario = class
   private
     { --------------------------- ATRIBUTOS --------------------------------- }

     { -- ESTRUTURA --
      Objeto respons�vel pela execu��o das consultas
     }
     select : TSelect;

     { -- ESTRUTURA --
      Data Set
     }
     cds : TDataSet;


   protected

   public

     { -----------------------  MANUTEN��O OBJETOS --------------------------- }

     constructor create;

     destructor destroy;

     {
      Valida Usus�rio

        Parameters :
          usuario   - Nome do usu�rio
          senha     - Senha do usu�rio
          usuarioId - Identificador do usuario logado
          role      - Lista de funcionalidades para o usuario logado

        Return :
          True  - Usuario Autenticado
          Falso - Usuario n�o autenticado
     }
     function validaUsuario(const usuario, senha : string;out erro:string; out role : TStrings) : boolean;
 end;

implementation

uses UfUncoes, SysUtils;


{ TValidaUsuario }

constructor  TValidaUsuario.create;
begin

  // Crio objeto
  select := TSelect.Create;
end;

destructor TValidaUsuario.destroy;
begin

  // Destruo objeto
  select.Free;
  cds.Free;
end;

function TValidaUsuario.validaUsuario(const usuario, senha : string;
                                out erro:string; out role : TStrings) : boolean;

var sql, sqlSenhaEncriptada, senha_normal : string;

begin

  // Inicializo as vari�veis locais
  sql                := '';
  sqlSenhaEncriptada := '';
  senha_normal       := '';

  // Inicilizo a vari�vel
  Result := False;

  try
    try

      // Consulta para pegar o usu�rio
      select.Clear;
      select.addColuna('senusuari AS SENHA');
      select.addTable('trusuari','tr');
      select.addCriterio('logusuari',usuario,'=');
      select.Execute(cds);

      // Se usu�rio n�o foi encontrado
      if cds.IsEmpty then
      begin

        // Usu�rio n�o encontrado
        erro := 'Usu�rio n�o encontrado!';

        // Sai
        exit;
      end;

      // Desincripto a senha do banco de dados
      senha_normal := AscCar(cds.FieldByName('SENHA').AsString);

      // Verifico se a senha esta correta
      if (senha_normal <> senha) then
      begin
        // Senha incorreta
        erro := 'Senha incorreta!';

        // Sai
        exit;
      end;

      // Usu�rio tem autoriza��o de administrador
      // Importante : Adicionar as autoriza��es dos usu�rios aqui
      role.Add('admin');

      // Senha foi processada com sucesso Autenticado!!!
      Result := True;
    Except on E: Exception do

      // Exce��o mensagem de erro
      E.Message := 'Erro : Usu�rio n�o autorizado';
    end;
  finally

  end;
end;

end.