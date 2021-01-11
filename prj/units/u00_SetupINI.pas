unit u00_SetupINI;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Dialogs,
   StdCtrls, Controls, ExtCtrls, //AppEvent,
  IniFiles, Mask, //ToolEdit,
  CheckLst, //IBOServices,
  Buttons, Vcl.ComCtrls;


type
  TfrmSetupINI = class(TForm)
    gb1SFCOKE: TGroupBox;
    edAppWebPorta: TLabeledEdit;
    gb3SFCOKEAux: TGroupBox;
    pn4Rodape: TPanel;
    btnGrava: TBitBtn;
    edBancoDriverID: TLabeledEdit;
    edBancoServer: TLabeledEdit;
    edBancoUserName: TLabeledEdit;
    edBancoPassword: TLabeledEdit;
    btnTeste: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    pnRodape: TPanel;
    btnSair: TBitBtn;
    edBancoPorta: TLabeledEdit;
    edBancoDatabase: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnGravaClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnTesteClick(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure CarregaVersaoAtual;
  end;

var
  frmSetupINI: TfrmSetupINI;
  vNomeArqIni : String;

implementation

uses u00_Global, u00_FunPro, u00_Conexao;

{$R *.DFM}

procedure TfrmSetupINI.FormCreate(Sender: TObject);
var
  vArqIni : TextFile;
begin
  vNomeArqIni := vgPathAplicacao + C_nome_Arq_Ini;

  if not FileExists(vNomeArqIni) then
  begin
    AssignFile(vArqIni, vNomeArqIni);
    Rewrite(vArqIni);

    writeln(vArqIni,'*********************************************************************');
    writeln(vArqIni,'** Inicio do arquivo                                              ***');
    writeln(vArqIni,'** Arquivo com confiruações Iniciais de conexões                  ***');
    writeln(vArqIni,'** ' + C_desc_aplicacao + ' ***');
    writeln(vArqIni,'*********************************************************************');
    writeln(vArqIni,'[Aplicacao]');
    writeln(vArqIni,'AppWebPorta=');
    writeln(vArqIni,' ');
    writeln(vArqIni,'[BancoDados]');
    writeln(vArqIni,'BDDriverID=');
    writeln(vArqIni,'BDServer=');
    writeln(vArqIni,'BDPorta=');
    writeln(vArqIni,'BDUserName=');
    writeln(vArqIni,'BDPassword=');
    writeln(vArqIni,'BDDatabase=');
    writeln(vArqIni,'                                                                     ');
    writeln(vArqIni,'*********************************************************************');
    writeln(vArqIni,'** Fim do arquivo                                                  **');
    writeln(vArqIni,'*********************************************************************');

    Flush(vArqIni);
    CloseFile(vArqIni);
  end;

  CarregaVersaoAtual;
end;

Procedure TfrmSetupINI.CarregaVersaoAtual;
var
  vDir : String;
begin

  edAppWebPorta.Text    := AchaParametro('Aplicacao','AppWebPorta');

  edBancoDriverID.Text := AchaParametro('BancoDados','BDDriverID');
  edBancoServer.Text   := AchaParametro('BancoDados','BDServer');
  edBancoPorta.Text    := AchaParametro('BancoDados','BDPorta');
  edBancoUserName.Text := Crypto('D', AchaParametro('BancoDados','BDUserName'));
  edBancoPassword.Text := Crypto('D', AchaParametro('BancoDados','BDPassword'));
  edBancoDatabase.Text := AchaParametro('BancoDados','BDDatabase');

end;


procedure TfrmSetupINI.btnGravaClick(Sender: TObject);
var
  vIni : TIniFile;
begin
 try
  try
   vIni  := TiniFile.Create(vNomeArqIni);

   vIni.WriteString('Aplicacao','AppWebPorta',edAppWebPorta.Text);

   vIni.WriteString('BancoDados','BDDriverID',  edBancoDriverID.Text);
   vIni.WriteString('BancoDados','BDServer',edBancoServer.Text);
   vIni.WriteString('BancoDados','BDPorta',  edBancoPorta.Text);
   vIni.WriteString('BancoDados','BDUserName',  Crypto('C', edBancoUserName.Text));
   vIni.WriteString('BancoDados','BDPassword',  Crypto('C', edBancoPassword.Text));
   vIni.WriteString('BancoDados','BDDatabase',  edBancoDatabase.Text);

   vIni.Free;
  except
    on E: Exception do
    begin
      MessageDlg('Atencao!!! Erro ao GRAVAR o arquivo:' + #13#13 +
        vNomeArqIni + #13#13 +
        E.Message + #13#13 +
        'Verifique.', MTERROR, [MBOK], 0);
    end;
  end;
 finally
    MessageDlg('Arquivo salvo com sucesso. <OK> para continuar.', mtInformation, [mbOk], 0);
    CargaParametrosIniciais;
    btnSair.Click;
 end;
end;

procedure TfrmSetupINI.btnSairClick(Sender: TObject);
begin
  frmSetupINI.Close;
end;

procedure TfrmSetupINI.btnTesteClick(Sender: TObject);
begin
  CargaParametrosIniciais;

 if CreatePoolConnection then
  begin
    MessageDlg('Teste de conexão:'            + #13#13 +
       ' -> Servidor = ' + vgBancoServer      + #13    +
       ' -> Banco Dados = ' + vgBancoDatabase + #13#13 +
       ' Efetuado com Sucesso.', mtInformation, [mbOK], 0);
  end
  else
  begin
    MessageDlg('Atenção!!! Teste de conexão:' + #13#13 +
       ' -> Servidor = ' + vgBancoServer      + #13    +
       ' -> Banco Dados = ' + vgBancoDatabase + #13#13 +
       'Com erro!', mtError, [mbOK], 0);
  end;

end;


end.


