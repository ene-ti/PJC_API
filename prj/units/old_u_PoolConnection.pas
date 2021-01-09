unit u_PoolConnection;

interface

uses
  System.Classes,

  FireDAC.DApt,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, {FireDAC.VCLUI.Wait,} Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB;

function CreatePoolConnection:Boolean;

implementation

Uses u00_Global, u00_SetupINI;

function CreatePoolConnection:Boolean;
var
  oParametros: TStringList;
begin
  FDManager.Close;  // Responsavel pelo POOL de conexão

  oParametros := TStringList.Create;
  try
    oParametros.Clear;
    oParametros.Add('DriverID=MySQL');
    oParametros.Add('Server=localhost');
    oParametros.Add('Port=3306');
    oParametros.Add('User_Name=eneti');
    oParametros.Add('Password=R&n0sa01');
    oParametros.Add('Database=DB_PJC');

    // parametros para o controle do pool se necessário e quiser alterar
    //oParametros.Add('POOL_MaximumItems=50');
    //oParametros.Add('POOL_ExpireTimeout=9000');
    //oParametros.Add('POOL_CleanupTimeout=900000');

    FDManager.AddConnectionDef(NOME_CONEXAO_BD, 'MySQL', oParametros);
    FDManager.Open;
  finally
    oParametros.Free;
  end;
end;

end.
