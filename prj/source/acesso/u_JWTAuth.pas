unit u_JWTAuth;

interface

uses
  MVCFramework,
  System.Generics.Collections;

type
  TJWTAuth = class(TInterfacedObject, IMVCAuthenticationHandler)
  public
    procedure OnRequest(const AContext: TWebContext; const AControllerQualifiedClassName, AActionName: string;
      var AAuthenticationRequired: Boolean);
    procedure OnAuthentication(const AContext: TWebContext; const AUserName, APassword: string;
      AUserRoles: TList<string>;
      var AIsValid: Boolean; const ASessionData: TDictionary<string, string>);
    procedure OnAuthorization(const AContext: TWebContext; AUserRoles: TList<string>;
      const AControllerQualifiedClassName: string;
      const AActionName: string; var AIsAuthorized: Boolean);
  end;

implementation

Uses u00_Global;

{ TJWTAuth }

procedure TJWTAuth.OnAuthentication(const AContext: TWebContext;
  const AUserName, APassword: string; AUserRoles: TList<string>;
  var AIsValid: Boolean; const ASessionData: TDictionary<string, string>);
begin
   AUserRoles.Clear;
  // Lugar para checar usuario e senha

  AIsValid := (AUserName = vgAppusername) and (APassword = vgApppassword); // True Se usuario e senha forem iguais

  //Quais os acessos do usuario
  // AUserRoles.Add('incluir');
  // AUserRoles.Add('alterar');
  // AUserRoles.Add('excluir');
end;

procedure TJWTAuth.OnAuthorization(const AContext: TWebContext;
  AUserRoles: TList<string>; const AControllerQualifiedClassName,
  AActionName: string; var AIsAuthorized: Boolean);
begin
  // Lugar para definir os niveis de acesso

  // Como n�o esta sendo tratados todas as a��es o padr�o � TRUE para todos
  // as actions n�o tratadas abaixo
  AIsAuthorized := True;

  // seta autoriza��o de acordo com os acessos
 // if AControllerQualifiedClassName = 'u_ApiController.TApiController' then
 // begin
 //   if AActionName = 'CreateArtista' then
 //   begin
 //     AIsAuthorized := AUserRoles.Contains('incluir')
 //   end;
 //   if AActionName = 'UpdateArtista' then
 //   begin
 //     AIsAuthorized := AUserRoles.Contains('alterar')
 //   end;
 //   if AActionName = 'DeleteArtista' then
 //   begin
 //     AIsAuthorized := AUserRoles.Contains('excluir')
 //   end;
 // end;

end;

procedure TJWTAuth.OnRequest(const AContext: TWebContext;
  const AControllerQualifiedClassName, AActionName: string;
  var AAuthenticationRequired: Boolean);
begin
  // Lugar para definir quais requisi��es precisao de autentica��o

  // seta autentica��o para todas as requisi��es
   AAuthenticationRequired := True;
  if (AControllerQualifiedClassName = 'u_ApiControllerPublico.TApiControllerPublico') then
  begin
    AAuthenticationRequired := false;
  end;
  // AAuthenticationRequired := AControllerQualifiedClassName = 'u_ApiController.TApiController';
end;

end.
