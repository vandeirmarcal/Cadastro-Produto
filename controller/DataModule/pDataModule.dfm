object UdmParame: TUdmParame
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 436
  Width = 784
  object trTrans: TIBTransaction
    DefaultDatabase = ciGtrans
    Params.Strings = (
      'read_committed'
      'rec_version'
      'wait')
    AutoStopAction = saRollback
    Left = 120
    Top = 16
  end
  object ciGtrans: TIBDatabase
    DatabaseName = 'C:\delphi\cadProduto\BD\CADPROD.FDB'
    Params.Strings = (
      'lc_ctype=ISO8859_1'
      'user_name=sysdba'
      'password=masterkey')
    LoginPrompt = False
    DefaultTransaction = trTrans
    ServerType = 'IBServer'
    AllowStreamedConnected = False
    Left = 26
    Top = 12
  end
end
