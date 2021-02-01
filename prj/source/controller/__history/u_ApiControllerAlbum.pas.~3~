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

  IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type

  [MVCPath('/api')]
  TApiControllerAlbum = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  public
    // - Path ALBUM
    [MVCPath('/albuns')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbuns;

    [MVCPath('/albumcategoria')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbunsCategoria;

    [MVCPath('/albumartista')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbunsArtista;

    [MVCPath('/album/($alb_id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetAlbum(alb_id: Integer);

    [MVCPath('/album')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateAlbum;

    [MVCPath('/album/($alb_id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateAlbum(alb_id: Integer);

    [MVCPath('/album/($alb_id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteAlbum(alb_id: Integer);
    // - Path ALBUM

  end;

implementation

uses
  u_AlbumService, u_AlbumClass,
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
