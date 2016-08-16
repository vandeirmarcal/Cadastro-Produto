unit uInfCTe;

interface

type
  TInfCTe = class
  private
    fChave: String;
    fNumero: Integer;  
  published
    property Chave: String read fChave write fChave;
    property Numero: Integer read fNumero write fNumero;
  end;

implementation

end.
