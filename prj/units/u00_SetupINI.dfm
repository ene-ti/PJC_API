object frmSetupINI: TfrmSetupINI
  Left = 459
  Top = 280
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 535
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 732
    Height = 475
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 366
    object TabSheet1: TTabSheet
      Caption = 'Conexao Banco Dados'
      ExplicitHeight = 338
      object gb1SFCOKE: TGroupBox
        Left = 0
        Top = 0
        Width = 724
        Height = 179
        Align = alTop
        Caption = ' Parametros Aplica'#231#227'o '
        TabOrder = 0
        object Label1: TLabel
          Left = 511
          Top = 22
          Width = 91
          Height = 13
          Caption = 'Ex: 8080 / 80 / etc'
        end
        object edAppWebPorta: TLabeledEdit
          Left = 190
          Top = 19
          Width = 315
          Height = 21
          Hint = 
            'Nome do servidor (ou IP) onde se encontra o banco de dados do SF' +
            'COKE'
          EditLabel.Width = 86
          EditLabel.Height = 13
          EditLabel.Caption = 'Porta Web HTTP '
          LabelPosition = lpLeft
          TabOrder = 0
        end
        object edSecretKeyJWT: TLabeledEdit
          Left = 190
          Top = 59
          Width = 315
          Height = 21
          Hint = 
            'Nome do servidor (ou IP) onde se encontra o banco de dados do SF' +
            'COKE'
          EditLabel.Width = 137
          EditLabel.Height = 13
          EditLabel.Caption = 'Chave Secreta TOKEN JWT'
          LabelPosition = lpLeft
          TabOrder = 1
        end
        object edSenha: TLabeledEdit
          Left = 190
          Top = 129
          Width = 315
          Height = 21
          Hint = 
            'Nome do servidor (ou IP) onde se encontra o banco de dados do SF' +
            'COKE'
          EditLabel.Width = 63
          EditLabel.Height = 13
          EditLabel.Caption = 'Senha Admin'
          LabelPosition = lpLeft
          TabOrder = 3
        end
        object edUsuario: TLabeledEdit
          Left = 190
          Top = 99
          Width = 315
          Height = 21
          Hint = 
            'Nome do servidor (ou IP) onde se encontra o banco de dados do SF' +
            'COKE'
          EditLabel.Width = 68
          EditLabel.Height = 13
          EditLabel.Caption = 'Usuario Admin'
          LabelPosition = lpLeft
          TabOrder = 2
        end
      end
      object gb3SFCOKEAux: TGroupBox
        Left = 0
        Top = 179
        Width = 724
        Height = 192
        Align = alTop
        Caption = ' Banco de Dados '
        TabOrder = 1
        ExplicitTop = 57
        object Label2: TLabel
          Left = 511
          Top = 24
          Width = 103
          Height = 13
          Caption = 'Ex: FB / MySQL / etc'
        end
        object Label3: TLabel
          Left = 511
          Top = 50
          Width = 154
          Height = 13
          Caption = 'Ex: localhost / 192.10.10.5 / etc'
        end
        object Label4: TLabel
          Left = 511
          Top = 77
          Width = 103
          Height = 13
          Caption = 'Ex: 3050 / 3306 / etc'
        end
        object Label5: TLabel
          Left = 511
          Top = 104
          Width = 105
          Height = 13
          Caption = 'Ex: root / bduser / etc'
        end
        object Label7: TLabel
          Left = 511
          Top = 158
          Width = 136
          Height = 13
          Caption = 'Ex: pjc_banco / my_bd / etc'
        end
        object edBancoDriverID: TLabeledEdit
          Left = 190
          Top = 21
          Width = 315
          Height = 21
          Hint = 
            'Nome do servidor (ou IP) onde se encontra o banco de dados do SF' +
            'COKE-AUX'
          EditLabel.Width = 76
          EditLabel.Height = 13
          EditLabel.Caption = 'ID Driver Banco'
          LabelPosition = lpLeft
          TabOrder = 0
        end
        object edBancoServer: TLabeledEdit
          Left = 190
          Top = 47
          Width = 315
          Height = 21
          Hint = 'Nome do banco de dados do SFCOKE-AUX'
          EditLabel.Width = 106
          EditLabel.Height = 13
          EditLabel.Caption = 'Endereco do Servidor '
          LabelPosition = lpLeft
          TabOrder = 1
        end
        object edBancoUserName: TLabeledEdit
          Left = 190
          Top = 101
          Width = 315
          Height = 21
          Hint = 'ID do usuario do SFCOKE-AUX'
          EditLabel.Width = 68
          EditLabel.Height = 13
          EditLabel.Caption = 'ID do Usuario:'
          LabelPosition = lpLeft
          TabOrder = 3
        end
        object edBancoPassword: TLabeledEdit
          Left = 190
          Top = 128
          Width = 315
          Height = 21
          Hint = 'Senha de acesso SFCOKE-AUX'
          EditLabel.Width = 34
          EditLabel.Height = 13
          EditLabel.Caption = 'Senha:'
          LabelPosition = lpLeft
          TabOrder = 4
        end
        object edBancoPorta: TLabeledEdit
          Left = 190
          Top = 74
          Width = 315
          Height = 21
          Hint = 'Nome do banco de dados do SFCOKE-AUX'
          EditLabel.Width = 108
          EditLabel.Height = 13
          EditLabel.Caption = 'Porta Banco de Dados'
          LabelPosition = lpLeft
          TabOrder = 2
        end
        object edBancoDatabase: TLabeledEdit
          Left = 190
          Top = 155
          Width = 315
          Height = 21
          Hint = 'Nome do banco de dados do SFCOKE-AUX'
          EditLabel.Width = 114
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome Banco de Dados '
          LabelPosition = lpLeft
          TabOrder = 5
        end
      end
      object pn4Rodape: TPanel
        Left = 0
        Top = 371
        Width = 724
        Height = 76
        Align = alClient
        TabOrder = 2
        ExplicitTop = 249
        ExplicitHeight = 89
        object btnGrava: TBitBtn
          Left = 40
          Top = 10
          Width = 175
          Height = 40
          Caption = 'Salva configura'#231#227'o'
          TabOrder = 0
          OnClick = btnGravaClick
        end
        object btnTeste: TBitBtn
          Left = 410
          Top = 10
          Width = 110
          Height = 40
          Caption = 'Testa Conex'#227'o'
          TabOrder = 1
          OnClick = btnTesteClick
        end
      end
    end
  end
  object pnRodape: TPanel
    Left = 0
    Top = 475
    Width = 732
    Height = 60
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 366
    object btnSair: TBitBtn
      Left = 44
      Top = 6
      Width = 110
      Height = 40
      Caption = 'Sair'
      TabOrder = 0
      OnClick = btnSairClick
    end
  end
end
