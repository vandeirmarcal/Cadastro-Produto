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
    Connected = True
    DatabaseName = 'localhost:D:\GTRANS_DHL\GTRANS_DHL.GDB'
    Params.Strings = (
      'lc_ctype=ISO8859_1'
      'user_name=SISTEMA'
      'password=aji1990')
    LoginPrompt = False
    DefaultTransaction = trTrans
    ServerType = 'IBServer'
    AllowStreamedConnected = False
    Left = 26
    Top = 12
  end
end
