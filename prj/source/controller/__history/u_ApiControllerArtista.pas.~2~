unit u_ApiControllerArtista;

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
  TApiControllerArtista = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  public
    // - Path ARTISTA
    [MVCPath('/artistas')]
    [MVCHTTPMethod([httpGET])]
    procedure GetArtistas;

    [MVCPath('/artistascategoria')]
    [MVCHTTPMethod([httpGET])]
    procedure GetArtistasCategoria;

    [MVCPath('/artista/($art_id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetArtista(art_id: Integer);

    [MVCPath('/artista')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateArtista;

    [MVCPath('/artista/($art_id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateArtista(art_id: Integer);

    [MVCPath('/artista/($art_id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteArtista(art_id: Integer);
    // - Path ARTISTA

  end;

implementation

uses
  u_ArtistaService, u_ArtistaClass,
  u00_Global;

procedure TApiControllerArtista.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TApiControllerArtista.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

    // - Path ARTISTA
procedure TApiControllerArtista.GetArtistas;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /artistas / QUERY PARAMS (por ART_NOME)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TArtista>(TArtistaService.GetArtistas('ART_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerArtista.GetArtistasCategoria;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /artistas / QUERY PARAMS (por ART_CATEGORIA)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TArtista>(TArtistaService.GetArtistas('ART_CATEGORIA', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerArtista.GetArtista(art_id: Integer);
begin
  // metodo GET: /artista/($art_id)
  Render(TArtistaService.GetArtista(art_id));
end;

procedure TApiControllerArtista.CreateArtista;
var
  AArtista: TArtista;
begin
  // metodo POST: /artista
  AArtista := Context.Request.BodyAs<TArtista>;
  try
    TArtistaService.CreateArtista(AArtista);
    Render(200, 'Artista criado com sucesso');
  finally
    AArtista.Free;
  end;
end;

procedure TApiControllerArtista.UpdateArtista(art_id: Integer);
var
  AArtista: TArtista;
begin
  // metodo PUT: /artista/($art_id)
  AArtista := Context.Request.BodyAs<TArtista>;
  try
    TArtistaService.UpdateArtista(art_id, AArtista);
    Render(200, Format('Artista %d atualizado com sucesso', [art_id]));
  finally
    AArtista.Free;
  end;
end;

procedure TApiControllerArtista.DeleteArtista(art_id: Integer);
begin
  // metodo DELETE: /artista/($art_id)
  TArtistaService.DeleteArtista(art_id);
  Render(200, Format('Artista %d apagado com sucesso', [art_id]));
end;
    // - Path ARTISTA

end.
