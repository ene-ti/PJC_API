unit u_ApiController;

interface

uses
  System.SysUtils,
  System.StrUtils,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons;

type
  [MVCDoc('Recurso para acesso ao sistema')]
  [MVCPath('/api')]
  TApiController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCDoc('Retorna página padrão com configurações de conexão')]
    [MVCPath('/')]
    [MVCPath('')]
    [MVCHTTPMethod([httpGET])]
    procedure GetMyRootPage;

    //Sample CRUD Actions for a "Customer" entity
    [MVCPath('/produtos')]
    [MVCHTTPMethod([httpGET])]
    procedure GetProdutos;

    [MVCPath('/produtos/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetProduto(id: Integer);

    [MVCPath('/produtos')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateProduto;

    [MVCPath('/produtos/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateProduto(id: Integer);

    [MVCPath('/produtos/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteProduto(id: Integer);
  end;

implementation

uses
  u_ArtistaService,
  u_ArtistaClass;

procedure TApiController.GetMyRootPage;
begin
  ContentType := TMVCMediaType.TEXT_HTML;
  Render(
    '<h1>Teste API DMVC</h1>' + sLineBreak +
    '<p>API de testes utilizando DMC e REST</p>' + sLineBreak +
    '</br>' + sLineBreak +

    '<dl>' + sLineBreak +
//    '<dt>Servidor: </dt><dd>' + ConfiguracaoApp.Servidor       + '</dd>' + sLineBreak +
//    '<dt>Porta: </dt><dd>'    + ConfiguracaoApp.Porta.ToString + '</dd>' + sLineBreak +
//    '<dt>Caminho: </dt><dd>'  + ConfiguracaoApp.Caminho        + '</dd>' + sLineBreak +
    '</dl>'
  );
end;

procedure TApiController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TApiController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

//Sample CRUD Actions for a "Customer" entity
procedure TApiController.Getprodutos;
var
  StrQuery: string;
begin
  StrQuery := Context.Request.QueryStringParam('like');

  Render<TProduto>(TProdutoService.GetProdutos(StrQuery));

end;

procedure TApiController.Getproduto(id: Integer);
begin

  Render(TProdutoService.GetProduto(Id));

end;

procedure TApiController.Createproduto;
var
  Produto: TProduto;
begin
  Produto := Context.Request.BodyAs<TProduto>;
  try
    TProdutoService.Post(Produto);
    Render(200, 'Produto criado com sucesso');
  finally
    Produto.Free;
  end;
end;

procedure TApiController.Updateproduto(id: Integer);
var
  Produto: TProduto;
begin
  Produto := Context.Request.BodyAs<TProduto>;
  try
    TProdutoService.Update(Id, Produto);
    Render(200, Format('Produto "%d" atualizado com sucesso', [Id]));
  finally
    Produto.Free;
  end;
end;

procedure TApiController.Deleteproduto(id: Integer);
begin

  TProdutoService.Delete(Id);
  Render(200, Format('Produto "%d" apagado com sucesso', [Id]));
end;



end.
