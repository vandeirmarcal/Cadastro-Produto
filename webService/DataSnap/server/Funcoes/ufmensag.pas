{ Mensagens }

unit ufmensag;

interface

uses Forms, Windows, SysUtils, uDmParame;

procedure MsgErro(fmessage: pchar);
procedure MsgExcl(fMessage: pchar);
procedure MsgInfo(fmessage: pchar);
function  MsgConf(fmessage: pchar; fdefault: byte=1): boolean;
function  MsgCon2(fmessage: pchar; fdefault: byte): char;
procedure MsgIncl(fException: string);
procedure MsgAlte(fException: string);
function  MsgApag(): boolean;  // CONFIRMA EXCLUS�O
procedure MsgApa2(fException: string);
procedure MsgExpo(fException: string);
procedure MsgCons(fException: string);
function  MsgImpr(fMessage: string ; iBotaoSimNao : Byte = 2): boolean;
procedure MsgImp2(fException: string);
procedure MsgLibUso(fLogUsu:string;fRegistrou:boolean;fDatLib:tdatetime);
procedure MsgModLib();
procedure MsgSemMov();
procedure MsgCalc(fmessage: pchar; fException: string);
function  MsgArqv(): boolean;
procedure MsgArq2(fException: string);
function  MsgArqvRec(): boolean;
procedure MsgRec(fException: string);

Function MsgReportarErro : Boolean;

implementation

uses UFuncoes;

procedure MsgErro(fmessage: PChar);
begin
  Application.MessageBox(fMessage, PChar(Application.Title), mb_Ok + mb_IconError);
end;

procedure MsgExcl(fmessage: pchar);
begin
  Application.MessageBox(fMessage, Pchar(Application.Title), mb_Ok + mb_IconExclamation);
end;

procedure MsgInfo(fmessage: pchar);
begin
  Application.MessageBox(fMessage, Pchar(Application.Title), mb_Ok + mb_IconInformation);
end;

{ Exibe uma mensagem de Confirma��o
  Par�metros: fDefault: n�mero do bot�o default. Ex. 1 = Sim, 2 = N�o }
function  MsgConf(fmessage: pchar; fdefault: byte ): boolean;
var
  xretorn: integer;
begin
  if fDefault = 1 then
    xretorn := Application.MessageBox(fMessage, Pchar(Application.Title), mb_YesNo + mb_DefButton1 + mb_IconQuestion)
  else
    xretorn := Application.MessageBox(fMessage, Pchar(Application.Title), mb_YesNo + mb_DefButton2 + mb_IconQuestion);

  if xretorn = 6 then
    MsgConf := true
  else
    MsgConf := false;
end;


{ Exibe uma mensagem de Confirma��o
  Par�metros: fDefault: n�mero do bot�o default. Ex. 1 = Sim, 2 = N�o, 3 = Cancelar }
function  MsgCon2(fmessage: pchar; fdefault: byte): char;
var
  xretorn: integer;
begin
  Case fDefault of
    1: xretorn := Application.MessageBox(fMessage, Pchar(Application.Title),
                  mb_YesNoCancel + mb_DefButton1 + mb_IconQuestion);
    2: xretorn := Application.MessageBox(fMessage, Pchar(Application.Title),
                  mb_YesNoCancel + mb_DefButton2 + mb_IconQuestion);
    else xretorn := Application.MessageBox(fMessage, Pchar(Application.Title),
                    mb_YesNoCancel + mb_DefButton3 + mb_IconQuestion);
  end;

  Case xRetorn of
    6: MsgCon2 := 'S';
    2: MsgCon2 := 'C';
    else MsgCon2 := 'N';
  end;
end;

procedure MsgIncl(fException: string);
var
  xMsg: string;
begin
  xMsg := 'N�o foi poss�vel realizar a inclus�o.';

  fException := dmparame.VerificaErro(fException);  

  if fException <> '' then
    xMsg := xMsg + chr(13) + chr(13) + 'Erro: ' + fException;
  MsgErro(PChar(xMsg));
end;

procedure MsgAlte(fException: string);
var
  xMsg: string;
begin
  xMsg := 'N�o foi poss�vel realizar a altera��o.';

  fException := dmparame.VerificaErro(fException);

  if fException <> '' then
    xMsg := xMsg + chr(13) + chr(13) + 'Erro: ' + fException;
  MsgErro(PChar(xMsg));
end;

function MsgApag(): boolean;
begin
  MsgApag := MsgConf('Confirma a exclus�o ?', 2);
end;

procedure MsgApa2(fException: string);
var
  xMsg: string;
begin
  xMsg := 'N�o foi poss�vel realizar a exclus�o.';

  fException := dmparame.VerificaErro(fException);  

  if fException <> '' then
    if ((Length(fException) >= 24) and (Uppercase(copy(fException, 1, 24)) =
       'VIOLATION OF FOREIGN KEY')) or ((Length(fException) >= 24) and
       (Uppercase(copy(fException, 1, 60)) =
       'DELETE STATEMENT CONFLICTED WITH COLUMN REFERENCE CONSTRAINT')) then
      xMsg := xMsg + chr(13) + chr(13) + 'O registro est� sendo utilizado em outra rotina.'
    else
      xMsg := xMsg + chr(13) + chr(13) + 'Erro: ' + fException;
    MsgErro(PChar(xMsg));
end;

procedure MsgExpo(fException: string);
var
  xMsg: string;
begin
  xMsg := 'N�o foi poss�vel realizar a exporta��o.';

  fException := dmparame.VerificaErro(fException);

  if fException <> '' then
    xMsg := xMsg + chr(13) + chr(13) + 'Erro: ' + fException;
  MsgErro(PChar(xMsg));
end;

procedure MsgCons(fException: string);
var
  xMsg: string;
begin
  xMsg := 'N�o foi poss�vel executar a consulta.';

  fException := dmparame.VerificaErro(fException);  

  if fException <> '' then
    xMsg := xMsg + chr(13) + chr(13) + 'Erro: ' + fException;
  MsgErro(PChar(xMsg));
end;

function MsgImpr(fMessage: string ; iBotaoSimNao : Byte = 2): boolean;
var
  xMsg: string;
begin
  if fMessage = '' then
    xMsg := 'Confirma impress�o ?'
  else
    xMsg := 'Confirma impress�o ' + fMessage;

  MsgImpr := MsgConf(Pchar(xMsg), iBotaoSimNao);
end;

procedure MsgImp2(fException: string);
var
  xMsg: string;
begin
  xMsg := 'N�o foi poss�vel realizar a impress�o.';

  fException := dmparame.VerificaErro(fException);  

  if fException <> '' then
    xMsg := xMsg + chr(13) + chr(13) + 'Erro: ' + fException;
    MsgErro(PChar(xMsg));
end;

procedure MsgLibUso(fLogUsu:string;fRegistrou:boolean;fDatLib:tdatetime);
var
  xDias: real;
begin
  if (fLogUsu = 'MESTRE') or (not fRegistrou) then
    exit;

  xDias := fDatLib - date;
  if xDias <= 10 then
    if xDias <= 0 then
      MsgInfo('Sua senha de libera��o de uso j� expirou.' + chr(13) +
              'Por favor, entre em contato atrav�s do Tel: (19)3229-8990 e adquira sua senha.')
    else
      MsgInfo(PChar('Faltam '+FloattoStr(xDias)+ ' dias para expirar a senha de libera��o de uso. ' +
              chr(13) + 'Por favor, entre em contato atrav�s do Tel: (19)3229-8990 e adquira sua senha.'));
end;

procedure MsgModLib;
begin
  MsgExcl('Licen�a n�o liberada para o m�dulo. ' + chr(13) + 'Entre em contato com a Aji Inform�tica. ')
end;

procedure MsgSemMov;
begin
  MsgExcl('N�o h� movimento.');
end;

procedure MsgCalc;
begin
  fException := dmparame.VerificaErro(fException);

  if fMessage = '' then
    MsgErro(PChar('N�o foi poss�vel executar o c�lculo.' + chr(13) + chr(13) + fException))
  else
    MsgErro(PChar('N�o foi poss�vel executar o c�lculo ' + fMessage + chr(13) +  chr(13) + fException));
end;

function MsgArqv;
begin
  MsgArqv := MsgConf('Confirma a gera��o do arquivo ?', 1);
end;

procedure MsgArq2(fException: string);
var
  xMsg: string;
begin
  xMsg := 'N�o foi poss�vel concluir a gera��o do arquivo.';

  fException := dmparame.VerificaErro(fException);  

  if fException <> '' then
    xMsg := xMsg + chr(13) + chr(13) + 'Erro: ' + fException;
  MsgErro(PChar(xMsg));
end;

function MsgArqvRec;
begin
  MsgArqvRec := MsgConf('Confirma o recebimento do arquivo ?', 1);
end;

procedure MsgRec(fException: string);
var
  xMsg: string;
begin
  xMsg := 'N�o foi poss�vel concluir o recebimento do arquivo.';

  fException := dmparame.VerificaErro(fException);

  if fException <> '' then
    xMsg := xMsg + chr(13) + chr(13) + 'Erro: ' + fException;
  MsgErro(PChar(xMsg));
end;

Function MsgReportarErro : Boolean;
var
  iRetorno : Integer;
begin
  iRetorno := Application.MessageBox('Deseja enviar as informa��es do processo para o Suporte Aji Sistemas?'+#13+#10+
                                     'Essas informa��es visam agilizar a resolu��o do processo.', Pchar(Application.Title),
                                     MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON1);
  MsgReportarErro := iRetorno = 6;

End;
End.
