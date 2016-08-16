unit uPessoa;

interface

uses uEndereco;

type
  TPessoa = class
  private
    fFone: String;
    fEndereco: TEndereco;
    fEmail: String;
  public
    constructor Create;
  published
    property Fone: String read fFone write fFone;
    property Endereco: TEndereco read fEndereco write fEndereco;
    property Email: String read fEmail write fEmail;
  end;

implementation

{ TPessoa }

constructor TPessoa.Create;
begin
  fEndereco := TEndereco.Create;
end;

end.
