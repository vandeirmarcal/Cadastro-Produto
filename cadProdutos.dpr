program cadProdutos;

uses
  Vcl.Forms,
  pMenu in 'view\pMenu.pas' {FMenu},
  pCadProdutos in 'view\pCadProdutos.pas' {Fcadprodutos},
  pDataModule in 'controller\DataModule\pDataModule.pas' {UdmParame: TDataModule},
  bBaseSql in 'controller\sql\bBaseSql.pas',
  bCriterioSql in 'controller\sql\bCriterioSql.pas',
  bSelect in 'controller\sql\bSelect.pas',
  UConexaoINI in 'controller\DataModule\UConexaoINI.pas',
  bCadPrdutos in 'model\bCadPrdutos.pas',
  bInsert in 'controller\sql\bInsert.pas',
  bUpdate in 'controller\sql\bUpdate.pas',
  bDelete in 'controller\sql\bDelete.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMenu, FMenu);
  Application.CreateForm(TUdmParame, UdmParame);
  Application.Run;


  Application.Initialize;
  Application.Title := 'Software Produto';
  Application.CreateForm(TFMenu, FMenu);
  Application.CreateForm(TUdmParame, UdmParame);
{  Try
    UdmParame.ciGtrans.Open;
    dmParametros.SQLConexaoSecundaria.Open;
    dmParametros.BuscaVersao;
    { Verifica registro do Sistema }
 {   dmParametros.MainRegistry;
  except on E: Exception do
    begin
      MsgExcl('Não foi possível estabelecer conexão com o Banco de Dados.'+#13#10+#13#10+
              'Servidor : '+ StringReplace(dmParametros.SQLConexao.Params.Strings[1], 'HostName=','',[]) +#13#10+
              'Banco de Dados : '+StringReplace(dmParametros.SQLConexao.Params.Strings[2],'DataBase=','',[])+ #13#10+#13#10+
              'Erro : '+E.Message);
      Application.ShowMainForm := False;
      Application.Terminate;
      Application.Run;
      Exit;
    end;
  End;
  sMestre := SenhaMestre;

  Application.CreateForm(TFrmLogin, FrmLogin);
  FrmLogin.ShowModal;

  if FrmLogin.bFechar then
  Begin
    Application.ShowMainForm := False;
    Application.Terminate;
    Application.Run;
    Exit;
  End
  Else
  Begin
    Application.Run;
  End;
  if bReiniciar then
  Begin
    WinExec(PAnsiChar(Application.ExeName),0);
  End;         }
end.
