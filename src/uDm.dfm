object Dm: TDm
  OldCreateOrder = False
  Height = 243
  Width = 317
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    Left = 131
    Top = 39
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 88
    Top = 104
  end
  object conexao: TFDConnection
    Params.Strings = (
      'Database=fassina'
      'User_Name=root'
      'Password=123456'
      'Server=localhost'
      'DriverID=mySQL')
    Left = 200
    Top = 120
  end
end
