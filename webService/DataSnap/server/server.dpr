program server;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  pWebService in 'pWebService.pas' {FWebService},
  ServerMethodsUnit1 in 'ServerMethodsUnit1.pas',
  ServerContainerUnit1 in 'ServerContainerUnit1.pas' {ServerContainer1: TDataModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  pDataModule in 'DataModule\pDataModule.pas' {UdmParame: TDataModule},
  UConexaoINI in 'Funcoes\UConexaoINI.pas',
  UFuncoes in 'Funcoes\UFuncoes.pas',
  Unit2 in 'Unit2.pas' {Form2},
  bValidacaoUsusario in 'validacao\bValidacaoUsusario.pas',
  bBaseSql in 'sql\bBaseSql.pas',
  bSelect in 'sql\bSelect.pas',
  bCriterioSql in 'sql\bCriterioSql.pas',
  uCTe in 'Source\uCTe.pas',
  uDestinatario in 'Source\uDestinatario.pas',
  uEmitente in 'Source\uEmitente.pas',
  uEndereco in 'Source\uEndereco.pas',
  uExpedidor in 'Source\uExpedidor.pas',
  uInfCTe in 'Source\uInfCTe.pas',
  uMunicipio in 'Source\uMunicipio.pas',
  uNotasFiscais in 'Source\uNotasFiscais.pas',
  uPessoa in 'Source\uPessoa.pas',
  uPessoaJuridica in 'Source\uPessoaJuridica.pas',
  uRecebedor in 'Source\uRecebedor.pas',
  uRemetente in 'Source\uRemetente.pas',
  uTipoModal in 'Source\uTipoModal.pas',
  uTomador in 'Source\uTomador.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.Title := 'Aji Sistemas e Tecnologia da Informação';
  Application.ShowMainForm := False;
  Application.CreateForm(TUdmParame, UdmParame);
  Application.ShowMainForm := True;
  Application.CreateForm(TFWebService, FWebService);
//  Application.CreateForm(TForm2, Form2);

  Application.Run;
end.
