unit u_ApiControllerAlbum;

interface

uses
  System.Classes, Graphics,
  Vcl.Dialogs, Vcl.imaging.jpeg, Vcl.ExtCtrls,
  System.SysUtils,
  System.StrUtils, Web.HTTPApp,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Intf,
  MVCFramework.Serializer.Commons,
  MVCFramework.Swagger.Commons, // Documentação Swagger
  u_AlbumService, u_AlbumClass,

  IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type

  [MVCPath('/api')]
  [MVCSwagAuthentication(atJsonWebToken)]   // Documentação
  TApiControllerAlbum = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  public
    // - Path ALBUM
    [MVCPath('/albuns')]
    [MVCSwagSummaryAttribute('Albuns', 'Lista de Albuns por Nome', 'GetAlbuns')]
    [MVCSwagParamAttribute(plQuery, 'wherelike', 'Filtro por Nome do Album', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'orderby', 'Ordenação ASC ou DSC', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'regatual', 'Paginação a partir do registro n?', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'qtdereg', 'Numero de registro por pagina', ptString, False)]
    [MVCSwagResponsesAttribute(200, 'Lista de Albuns', TAlbum, True)]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbuns;

    [MVCPath('/albunscategoria')]
    [MVCSwagSummaryAttribute('Albuns', 'Lista de Albuns por Categoria', 'GetAlbunsCategoria')]
    [MVCSwagParamAttribute(plQuery, 'wherelike', 'Filtro por Categoria do Artista', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'orderby', 'Ordenação ASC ou DSC', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'regatual', 'Paginação a partir do registro n?', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'qtdereg', 'Numero de registro por pagina', ptString, False)]
    [MVCSwagResponsesAttribute(200, 'Lista de Albuns', TAlbum, True)]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbunsCategoria;

    [MVCPath('/albunsartista')]
    [MVCSwagSummaryAttribute('Albuns', 'Lista de Albuns por Artista', 'GetAlbunsArtista')]
    [MVCSwagParamAttribute(plQuery, 'wherelike', 'Filtro por Nome do Artista', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'orderby', 'Ordenação ASC ou DSC', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'regatual', 'Paginação a partir do registro n?', ptString, False)]
    [MVCSwagParamAttribute(plQuery, 'qtdereg', 'Numero de registro por pagina', ptString, False)]
    [MVCSwagResponsesAttribute(200, 'Lista de Albuns', TAlbum, True)]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbunsArtista;

    [MVCPath('/album/($alb_id)')]
    [MVCSwagSummaryAttribute('Albuns', 'Retorna o Album n...', 'GetAlbum')]
    [MVCSwagParamAttribute(plPath, 'alb_id', 'ID do Album', ptInteger, True)]
    [MVCSwagResponsesAttribute(200, 'Album', TAlbum, False)]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbum(alb_id: Integer);

    [MVCPath('/album')]
    [MVCSwagSummaryAttribute('Albuns', 'Insere o Album', 'CreateAlbum')]
    [MVCSwagParam(plBody, 'Album', 'Album Inserido', TAlbum)]
    [MVCSwagResponsesAttribute(200, 'Album', TAlbum, False)]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateAlbum;

    [MVCPath('/album/($alb_id)')]
    [MVCSwagSummaryAttribute('Albuns', 'Altera o Album', 'UpdateAlbum')]
    [MVCSwagParamAttribute(plPath, 'alb_id', 'ID do Album', ptInteger, True)]
    [MVCSwagParam(plBody, 'Album', 'Album Alterado', TAlbum)]
    [MVCSwagResponsesAttribute(200, 'Album', TAlbum, False)]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateAlbum(alb_id: Integer);

    [MVCPath('/album/($alb_id)')]
    [MVCSwagSummaryAttribute('Albuns', 'Apaga o Album', 'DeleteAlbum')]
    [MVCSwagParamAttribute(plPath, 'alb_id', 'ID do Album', ptInteger, True)]
    [MVCSwagResponsesAttribute(200, 'Album apagado com sucesso')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteAlbum(alb_id: Integer);
    // - Path ALBUM

  end;

implementation

uses
  u00_Global;


procedure TApiControllerAlbum.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TApiControllerAlbum.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

    // - Path ALBUM
procedure TApiControllerAlbum.GetAlbuns;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /albuns / QUERY PARAMS (por ALB_NOME)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TAlbum>(TAlbumService.GetAlbuns('ALB_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerAlbum.GetAlbunsCategoria;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /albuns / QUERY PARAMS (por ART_CATEGORIA)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TAlbum>(TAlbumService.GetAlbuns('ART_CATEGORIA', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerAlbum.GetAlbunsArtista;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /albuns / QUERY PARAMS (por ART_NOME)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TAlbum>(TAlbumService.GetAlbuns('ART_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerAlbum.GetAlbum(alb_id: Integer);
begin
  // metodo GET: /album/($alb_id)
  Render(TAlbumService.GetAlbum(alb_id));
end;

procedure TApiControllerAlbum.CreateAlbum;
var
  AAlbum: TAlbum;
begin
  // metodo POST: /album
  AAlbum := Context.Request.BodyAs<TAlbum>;
  try
    TAlbumService.CreateAlbum(AAlbum);
    Render(200, 'Album criado com sucesso');
  finally
    AAlbum.Free;
  end;
end;

procedure TApiControllerAlbum.UpdateAlbum(alb_id: Integer);
var
  AAlbum: TAlbum;
begin
  // metodo PUT: /album/($alb_id)
  AAlbum := Context.Request.BodyAs<TAlbum>;
  try
    TAlbumService.UpdateAlbum(alb_id, AAlbum);
    Render(200, Format('Album %d atualizado com sucesso', [alb_id]));
  finally
    AAlbum.Free;
  end;
end;

procedure TApiControllerAlbum.DeleteAlbum(alb_id: Integer);
begin
  // metodo DELETE: /album/($alb_id)
  TAlbumService.DeleteAlbum(alb_id);
  Render(200, Format('Album %d apagado com sucesso', [alb_id]));
end;
    // - Path ALBUM

end.
