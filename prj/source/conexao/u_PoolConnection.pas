unit u_PoolConnection;

//unit u_PoolConnection;

interface

uses
  System.SysUtils, System.Classes,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.DApt,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  Data.DB;


// type
//  TdmConexaoBD = class(TDataModule)
//    FDManager1: TFDManager;
//    FDConnection1: TFDConnection;
//  private
    { Private declarations }
//  public
    { Public declarations }
    function CreatePoolConnection:Boolean;
//  end;

//var
//  dmConexaoBD: TdmConexaoBD;

var
  FDManager1 : TFDManager;
  FDConnection1 : TFDConnection;

implementation

Uses u00_Global, u00_SetupINI;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function CreatePoolConnection:Boolean;
var
  oParametros: TStringList;
begin
  FDManager1.Close;  // Responsavel pelo POOL de conex�o

  oParametros := TStringList.Create;
  try
    oParametros.Clear;
    oParametros.Add('DriverID=MySQL');
    oParametros.Add('Server=localhost');
    oParametros.Add('Port=3306');
    oParametros.Add('User_Name=eneti');
    oParametros.Add('Password=R&n0sa01');
    oParametros.Add('Database=DB_PJC');

    // parametros para o controle do pool se necess�rio e quiser alterar
    //oParametros.Add('POOL_MaximumItems=50');
    //oParametros.Add('POOL_ExpireTimeout=9000');
    //oParametros.Add('POOL_CleanupTimeout=900000');

    FDManager1.AddConnectionDef(NOME_CONEXAO_BD, 'MySQL', oParametros);
    FDManager1.Open;

    FDConnection1.ConnectionDefName := NOME_CONEXAO_BD;
    FDConnection1.Connected := true;
    if (FDConnection1.Connected = true) then
    begin
      raise EDatabaseError.Create('Conectou');
    end
    else
    begin
      raise EDatabaseError.Create('N�o conectou!');
    end;
  finally
    FDConnection1.Free;
    oParametros.Free;
  end;
end;

end.