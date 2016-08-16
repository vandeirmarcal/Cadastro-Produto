unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBXJSON, System.JSON, Vcl.StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    IdHTTP1: TIdHTTP;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button10Click(Sender: TObject);
var
  lHTTP: TIdHTTP;
  lParamList: TStringList;

   LJSONObject : TJSONObject;

   j:integer;
   jSubPar: TJSONPair;


    jsonStringData : String;
begin



    // chamada a URL
    lParamList := TStringList.Create;
    lHTTP := TIdHTTP.Create(nil);
   try
      jsonStringData := lHTTP.Post('http://www.nif.pt/?json=1&q=509442013', lParamList);
   finally
     lHTTP.Free;
     lParamList.Free;
   end;

   //  obtendo valores
   LJSONObject := nil;
   try

      LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(jsonStringData), 0) as TJSONObject;


      for j := 0 to LJSONObject.Size - 1 do  begin
         jSubPar := LJSONObject.Get(j);  //pega o par no índice j
         if jSubPar.JsonString.Value = 'data' then begin
            jsonStringData :=  jSubPar.toString;
         end;
      end;


      LJSONObject := nil;
      LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(jsonStringData.
      Replace('"data":','',[rfReplaceAll])), 0) as TJSONObject;

//      Result := TTemp.Create;
      for j := 0 to LJSONObject.Size - 1 do  begin

        // NOME DO CAMPO
        jSubPar.JsonString.Value;


        // VALOR

            // {"result":"success"
        if (trim(jSubPar.JsonString.Value) = 'result') then
        begin
            jSubPar.JsonValue.Value; // RETORNO success

                  Memo1.Clear;
        Memo1.Lines.Add(jSubPar.JsonValue.Value);

        end;

      end;


   finally
      LJSONObject.Free;
   end;
end;
procedure TForm2.Button1Click(Sender: TObject);
var
   js: TJSONString;
   jn1: TJSONNumber;
   jn2: TJSONNumber;
   jt: TJSONTrue;
   jf: TJSONFalse;
begin
   Memo1.Clear;
   js  := TJSONString.Create('Esta é uma string JSON');
   jn1 := TJSONNumber.Create(15);
   jn2 := TJSONNumber.Create(1240.75);
   jt  := TJSONTrue.Create;
   jf  := TJSONFalse.Create;

   Memo1.Lines.Add(js.Value);

   Memo1.Lines.Add(jn1.Value); //pegando como string
   Memo1.Lines.Add(FloatToStr(jn1.AsDouble)); //pegando como Double

   Memo1.Lines.Add(jn2.Value); //pegando como string
   Memo1.Lines.Add(FloatToStr(jn2.AsDouble)); //pegando como Double

   Memo1.Lines.Add(jt.Value); //a função Value de um TJSONTrue retorna vazio pois invoca TJSONAncestor.Value o qual retorna uma string vazia
   Memo1.Lines.Add(jf.Value); //a função Value de um TJSONFalse retorna vazio pois invoca TJSONAncestor.Value o qual retorna uma string vazia
   Memo1.Lines.Add(jt.ToString); //portanto devemos usar a função ToString
   Memo1.Lines.Add(jf.ToString); //portanto devemos usar a função ToString
end;
procedure TForm2.Button2Click(Sender: TObject);
var
   jo : TJSONObject;
begin
   Memo1.Clear;

   jo := TJSONObject.Create;
   jo.AddPair('CNPJEmpresaEmitente', TJSONString.Create('CNPJEmpresaEmitente'));
   jo.AddPair(TJSONPair.Create('CNPJRemetente', 'CNPJRemetente000'));
   jo.AddPair(TJSONPair.Create('CNPJDestinatario', 'CNPJDestinatario000'));
   jo.AddPair(TJSONPair.Create('CNPJExpedidor', 'CNPJExpedidor000'));
   jo.AddPair(TJSONPair.Create('CNPJRecebedor', 'CNPJRecebedor000'));
   jo.AddPair(TJSONPair.Create('PagoPor', '2'));
   jo.AddPair(TJSONPair.Create('TipoModal', '1'));
   jo.AddPair(TJSONPair.Create('TipoServico', '3'));
   jo.AddPair(TJSONPair.Create('SituacaoCarga', '4'));
   jo.AddPair(TJSONPair.Create('SituacaoFrete', '5'));
   jo.AddPair(TJSONPair.Create('UFInicioPrestacao', 'UFInicioPrestacao'));
   jo.AddPair(TJSONPair.Create('IBGECidadeInicioPrestacao', '10'));
   jo.AddPair(TJSONPair.Create('UFFimdaPrestacao', 'UFFimdaPrestacao'));
   jo.AddPair(TJSONPair.Create('IBGECidadeFimPrestacao', '11'));
   jo.AddPair(TJSONPair.Create('ResponsavelSeguro', '12'));

   // Imprime
   Memo1.Lines.Add(jo.ToString);
end;
procedure TForm2.Button3Click(Sender: TObject);
var  //retorna um array com três elementos onde cada elemento é um objeto contendo um único par
  ja: TJSONArray;
  jo1, jo2, jo3 : TJSONObject;
begin
   Memo1.Clear;
   //Na notação JSON, arrays são delimitados por []
   //e podem conter diversos elementos separados por ,
   ja := TJSONArray.Create;

   jo1 := TJSONObject.Create;
   jo1.AddPair('Nome', TJSONString.Create('DELMAR'));

   jo2 := TJSONObject.Create;
   jo2.AddPair(TJSONPair.Create('Nome', 'DEVMEDIA'));

   jo3 := TJSONObject.Create;
   jo3.AddPair(TJSONPair.Create('Nome', 'DALVAN'));

   ja.AddElement(jo1); //a procedure AddElemento adiciona um elemento ao JSONArray
   ja.AddElement(jo2);
   ja.AddElement(jo3);

   Memo1.Lines.Add(ja.ToString);
end;
procedure TForm2.Button4Click(Sender: TObject);
var  // retorna um array com um elemento que é um objeto contendo três pares
   ja: TJSONArray;
   jo1: TJSONObject;
begin
   Memo1.Clear;
   ja := TJSONArray.Create;
   jo1 := TJSONObject.Create;
   jo1.AddPair('Nome', TJSONString.Create('DELMAR'));
   jo1.AddPair(TJSONPair.Create('Cidade', 'AJURICABA'));
   jo1.AddPair(TJSONPair.Create('Bairro', 'CENTRO'));
   ja.AddElement(jo1);
   Memo1.Lines.Add(ja.ToString);
end;

procedure TForm2.Button5Click(Sender: TObject);
var  // retorna um array com dois elementos onde cada elemento é um objeto contendo três pares
   ja: TJSONArray;
   jo1, jo2 : TJSONObject;
begin
   Memo1.Clear;
   ja := TJSONArray.Create;

   // --------------- CTE
   jo1 := TJSONObject.Create;
   jo1.AddPair('rma', TJSONString.Create('RMA'));
   jo1.AddPair(TJSONPair.Create('remetente', 'REMETENTE'));
   jo1.AddPair(TJSONPair.Create('destinatario', 'DESTINATARIO'));
   jo1.AddPair(TJSONPair.Create('empresa_emitente', 'EMPRESA_EMITENTE'));
   jo1.AddPair(TJSONPair.Create('tipo_modal', 'TIPO_MODAL'));
   jo1.AddPair(TJSONPair.Create('empresa_pagadora', 'EMPRESA_PAGADORA'));
   jo1.AddPair(TJSONPair.Create('situacao_carga', 'SITUACAO_CARGA'));
   jo1.AddPair(TJSONPair.Create('situacao_frete', 'SITUACAO_FRETE'));
   jo1.AddPair(TJSONPair.Create('expedidor', 'EXPEDIDOR'));
   jo1.AddPair(TJSONPair.Create('recebedor', 'RECEBEDOR'));

   jo2 := TJSONObject.Create;
   jo2.AddPair('rma', TJSONString.Create('RMA'));
   jo2.AddPair(TJSONPair.Create('chave_acesso', 'chave_acesso01'));
   jo2.AddPair(TJSONPair.Create('natureza_mercadoria', 'natureza_mercadoria01'));
   jo2.AddPair(TJSONPair.Create('especie_mercadoria', 'especie_mercadoria01'));
   jo2.AddPair(TJSONPair.Create('valor_mercadoria', 'valor_mercadoria01'));
   jo2.AddPair(TJSONPair.Create('numero', 'numero01'));
   jo2.AddPair(TJSONPair.Create('emissao', 'emissao01'));
   jo2.AddPair(TJSONPair.Create('centro_custo', 'centro_custo01'));

   ja.Add(jo1);
   ja.Add(jo2);
//   ja.AddElement(jo1);
//   ja.AddElement(jo2);

   Memo1.Lines.Add(ja.ToString);
end;
procedure TForm2.Button6Click(Sender: TObject);
var

  jsonObj: TJSONObject;

  jp: TJSONPair;

  i: integer;

begin

   Memo1.Lines.Clear;

   jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('{"Nome":"DELMAR","Cidade":"AJURICABA","Bairro":"CENTRO"}'), 0) as TJSONObject;  //dada a seguinte string em notação JSON que será convertida pela função ParseJSONValue em um objeto nativo do delphi do tipo TJSONObject

   jp := TJSONPair.Create;
   Memo1.Lines.Add('quantidade de pares ' +   IntToStr(jsonObj.Size)); //quantidade de pares do objeto
   Memo1.Lines.Add('');
   Memo1.Lines.Add('Pegando junto a chave e valor usando a função ToString do TJSONPair');

   for i := 0 to jsonObj.Size - 1 do //percorrer o objeto para pegar os pares
   begin
      jp := jsonObj.Get(i); //pega o par no índice i
      Memo1.Lines.Add(jp.ToString); //pega junto a chave e valor
   end;

   Memo1.Lines.Add('');
   Memo1.Lines.Add('Pegando separado a chave e o valor usando respectivamente jp.JsonString.ToString e jp.JsonValue.ToString');
   for i := 0 to jsonObj.Size - 1 do //percorrer o objeto para pegar os pares
   begin
      jp := jsonObj.Get(i); //pega o par no índice i
      Memo1.Lines.Add(jp.JsonString.ToString + ' : ' + jp.JsonValue.ToString);  //pega separado a chave e o valor usando ToString
   end;

   Memo1.Lines.Add('');

   Memo1.Lines.Add('Pegando separado a chave e o valor usando respectivamente jp.JsonString.Value e jp.JsonValue.Value');

   for i := 0 to jsonObj.Size - 1 do //percorrer o objeto para pegar os pares

   begin

      jp := jsonObj.Get(i); //pega o par no índice i

      Memo1.Lines.Add(jp.JsonString.Value + ' : ' + jp.JsonValue.Value);          //pega separado a chave e o valor usando Value

   end;
end;
procedure TForm2.Button7Click(Sender: TObject);
var
 jsonObj, jSubObj: TJSONObject;
 ja: TJSONArray;
 jp, jSubPar: TJSONPair;
 i, j: integer;
begin
   Memo1.Lines.Clear;

   jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('{"result":[{"Nome":"DELMAR","Cidade":"AJURICABA","Bairro":"CENTRO"},{"Nome":"DALVAN","Cidade":"IJUÍ","Bairro":"JARDIM"}]}'), 0) as TJSONObject;
//dada a seguinte string em notação JSON que será convertida pela função ParseJSONValue
//em um objeto nativo do delphi do tipo TJSONObject

   jp := TJSONPair.Create;
   jp := jsonObj.Get(0);  //pega o par zero

   ja := TJSONArray.Create;
   ja := (jp.JsonValue as TJSONArray); // do par zero pega o valor, que é array
//quantidade de pares do objeto
   Memo1.Lines.Add('quantidade de elementos ' +   IntToStr(ja.Size));
   jSubObj:= TJSONObject.Create;
   jSubPar := TJSONPair.Create;

   for i := 0 to ja.Size - 1 do //itera o array para pegar cada elemento
   begin
      jSubObj := (ja.Get(i) as TJSONObject); //pega cada elemento do array, onde cada
//elemento é um objeto, neste caso, em função da string JSON montada acima
      Memo1.Lines.Add('');
      Memo1.Lines.Add('No elemento ' + IntToStr(i) +
' a quantidade de pares do objeto é = ' +  IntToStr(jSubObj.Size) ); //quantidade de pares do objeto
      for j := 0 to jSubObj.Size - 1 do  //itera o objeto para pegar cada par
      begin
         jSubPar := jSubObj.Get(j);  //pega o par no índice j
 //do par pega separado a chave e o valor usando Value
         Memo1.Lines.Add(jSubPar.JsonString.Value + ' : ' + jSubPar.JsonValue.Value);
      end;
   end;
end;
procedure TForm2.Button8Click(Sender: TObject);

var
   jo : TJSONObject;

begin

   Memo1.Clear;

   jo := TJSONObject.Create;

   jo.AddPair('ChaveAcesso', TJSONString.Create('ChaveAcesso'));
   jo.AddPair(TJSONPair.Create('NaturezaMercadoria', 'NaturezaMercadoriaNota'));
   jo.AddPair(TJSONPair.Create('EspecieMercadoria', 'EspecieMercadoriaNota'));
   jo.AddPair(TJSONPair.Create('ValorMercadoria', '120.65'));
   jo.AddPair(TJSONPair.Create('NumeroNF', '199'));
   jo.AddPair(TJSONPair.Create('EmissaoNF', '01.04.2016'));
   jo.AddPair(TJSONPair.Create('CFOPNF', '033'));
   jo.AddPair(TJSONPair.Create('PesoCubado', '034'));
   jo.AddPair(TJSONPair.Create('Volume', '55.63'));
   jo.AddPair(TJSONPair.Create('PesoLiquido', '22.66'));
   jo.AddPair(TJSONPair.Create('PesoBruto', '33.25'));
   jo.AddPair(TJSONPair.Create('CentroCusto', '0'));

   Memo1.Lines.Add(jo.ToString);
end;

end.
