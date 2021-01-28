unit u_ApiControllerCapa;

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
  TApiControllerCapa = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  public
    // - Path CAPA
    [MVCPath('/capas')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCapas;

    [MVCPath('/capaalbumcategoria')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCapasCategoria;

    [MVCPath('/capaalbumartista')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCapasArtista;

    [MVCPath('/capa/($cp_id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCapa(cp_id: Integer);

    [MVCPath('/capa')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateCapa;

    [MVCPath('/capa/($cp_id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateCapa(cp_id: Integer);

    [MVCPath('/capa/($cp_id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteCapa(cp_id: Integer);
    // - Path CAPA

  end;

implementation

uses
  u_CapaService, u_CapaClass,
  u00_Global;


procedure TApiControllerCapa.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TApiControllerCapa.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

    // - Path CAPA
procedure TApiControllerCapa.GetCapas;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /capass / QUERY PARAMS (por ALB_NOME)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TCapa>(TCapaService.GetCapas('ALB_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerCapa.GetCapasCategoria;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /capas / QUERY PARAMS (por ART_CATEGORIA)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TCapa>(TCapaService.GetCapas('ART_CATEGORIA', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerCapa.GetCapasArtista;
var
  StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg: String;
begin
  // metodo GET: /capas / QUERY PARAMS (por ART_NOME)
  StrWhereLike := Context.Request.QueryStringParam('wherelike'); // like na clausula where
  StrOrderBy   := Context.Request.QueryStringParam('orderby');   // ordenação ASC/DSC
  StrRegAtual  := Context.Request.QueryStringParam('regatual');  // Nr Reg Atual
  StrQtdReg    := Context.Request.QueryStringParam('qtdereg');   // Qtde Reg Paginação

  Render<TCapa>(TCapaService.GetCapas('ART_NOME', StrWhereLike, StrOrderBy, StrRegAtual, StrQtdReg));
end;

procedure TApiControllerCapa.GetCapa(cp_id: Integer);
var
  vJpeg: TJPEGImage;
  vMemStrm: TMemoryStream;
  vIdHTTP: TIdHTTP;
  vUrl : string;
  vFSSL : TIdSSLIOHandlerSocketOpenSSL;
begin
  vUrl := TCapaService.GetCapa(cp_id);
  vJpeg := TJPEGImage.Create;
  vMemStrm := TMemoryStream.Create;
  vIdHTTP := TIdHTTP.Create(nil);
  vFSSL := TIdSSLIOHandlerSocketOpenSSL.Create(vIdHTTP);
  vFSSL.SSLOptions.SSLVersions := [sslvTLSv1_1, sslvTLSv1_2];
  vIdHTTP.IOHandler := vFSSL;
  try
    vIdHTTP.Get(vUrl, vMemStrm);
    if (vMemStrm.Size > 0) then
    begin
      vMemStrm.Position := 0;
      vJpeg.LoadFromStream(vMemStrm);
      vJpeg.savetofile('c:\banco\teste2.jpg');
    end;
    ContentType :=  TMVCMediaType.TEXT_HTML;
    Render(vUrl);
  finally
    vJpeg.Free;
    vMemStrm.Free;
    vIdHTTP.Free;
  end;
//  Render(TCapaService.GetCapa(cp_id));
end;

procedure TApiControllerCapa.CreateCapa;
var
  ACapa: TCapa;
begin
  // metodo POST: /capa
  ACapa := Context.Request.BodyAs<TCapa>;
  try
    TCapaService.CreateCapa(ACapa);
    Render(200, 'Capa criada com sucesso');
  finally
    ACapa.Free;
  end;
end;

procedure TApiControllerCapa.UpdateCapa(cp_id: Integer);
var
  ACapa: TCapa;
begin
  // metodo PUT: /capa/($cp_id)
  ACapa := Context.Request.BodyAs<TCapa>;
  try
    TCapaService.UpdateCapa(cp_id, ACapa);
    Render(200, Format('Capa %d atualizada com sucesso', [cp_id]));
  finally
    ACapa.Free;
  end;
end;

procedure TApiControllerCapa.DeleteCapa(cp_id: Integer);
begin
  // metodo DELETE: /capa/($cp_id)
  TCapaService.DeleteCapa(cp_id);
  Render(200, Format('Capa %d apagada com sucesso', [cp_id]));
end;
    // - Path CAPA

end.
