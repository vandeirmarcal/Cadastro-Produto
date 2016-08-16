{ ------------------------- INFORMAÇÕES GERAIS ---------------------------------
  bValidacaoUsusario; (Objeto responsável por autenticar e validar os usuários)

  09/06/2016
  Vandeir Roberto Marçal
  AJI - Sistemas
 ----------------------------------------------------------------------------- }
unit bValidacaoUsusario;

interface

uses db, System.Classes, bSelect;

 type TValidaUsuario = class
   private
     { --------------------------- ATRIBUTOS --------------------------------- }

     { -- ESTRUTURA --
      Objeto responsável pela execução das consultas
     }
     select : TSelect;

     { -- ESTRUTURA --
      Data Set
     }
     cds : TDataSet;


   protected

   public

     { -----------------------  MANUTENÇÃO OBJETOS --------------------------- }

     constructor create;

     destructor destroy;

     {
      Valida Ususário

        Parameters :
          usuario   - Nome do usuário
          senha     - Senha do usuário
          usuarioId - Identificador do usuario logado
          role      - Lista de funcionalidades para o usuario logado

        Return :
          True  - Usuario Autenticado
          Falso - Usuario não autenticado
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

  // Inicializo as variáveis locais
  sql                := '';
  sqlSenhaEncriptada := '';
  senha_normal       := '';

  // Inicilizo a variável
  Result := False;

  try
    try

      // Consulta para pegar o usuário
      select.Clear;
      select.addColuna('senusuari AS SENHA');
      select.addTable('trusuari','tr');
      select.addCriterio('logusuari',usuario,'=');
      select.Execute(cds);

      // Se usuário não foi encontrado
      if cds.IsEmpty then
      begin

        // Usuário não encontrado
        erro := 'Usuário não encontrado!';

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

      // Usuário tem autorização de administrador
      // Importante : Adicionar as autorizações dos usuários aqui
      role.Add('admin');

      // Senha foi processada com sucesso Autenticado!!!
      Result := True;
    Except on E: Exception do

      // Exceção mensagem de erro
      E.Message := 'Erro : Usuário não autorizado';
    end;
  finally

  end;
end;

end.