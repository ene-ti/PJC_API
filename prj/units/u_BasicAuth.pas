unit u_BasicAuth;

interface

uses
  MVCFramework,
  System.Generics.Collections;

type
  TBasicAuth = class(TInterfacedObject, IMVCAuthenticationHandler)
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

{ TBasicAuth }

procedure TBasicAuth.OnAuthentication(const AContext: TWebContext;
  const AUserName, APassword: string; AUserRoles: TList<string>;
  var AIsValid: Boolean; const ASessionData: TDictionary<string, string>);
begin
  // Lugar para checar usuario e senha

  AIsValid := (AUserName = vgAppusername) and (APassword = vgApppassword); // True Se usuario e senha forem iguais

end;

procedure TBasicAuth.OnAuthorization(const AContext: TWebContext;
  AUserRoles: TList<string>; const AControllerQualifiedClassName,
  AActionName: string; var AIsAuthorized: Boolean);
begin
  // Lugar para definir os niveis de acesso

  // seta autorização para tudo
  AIsAuthorized := True;
end;

procedure TBasicAuth.OnRequest(const AContext: TWebContext;
  const AControllerQualifiedClassName, AActionName: string;
  var AAuthenticationRequired: Boolean);
begin
  // Lugar para definir quais requisições precisao de autenticação

  // seta autenticação para todas as requisições
  AAuthenticationRequired := True;
end;

end.
