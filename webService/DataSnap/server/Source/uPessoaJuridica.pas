unit uPessoaJuridica;

interface

uses uPessoa;

type
  TPessoaJuridica = class(TPessoa)
  private
    fCNPJ: String;
    fIE: String;
    fRazaoSocial: String;
    fNomeFantasia: String;
  published
    property CNPJ: String read fCNPJ write fCNPJ;
    property IE: String read fIE write fIE;
    property RazaoSocial: String read fRazaoSocial write fRazaoSocial;
    property NomeFantasia: String read fNomeFantasia write fNomeFantasia;
  end;

implementation

end.
