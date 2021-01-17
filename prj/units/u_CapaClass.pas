unit u_CapaClass;

interface

uses
  MVCFramework.Serializer.Commons,
  u_AlbumClass;

type
  [MVCNameCaseAttribute(ncLowerCase)]
  TCapa = class(TAlbum)
  private
    Fcp_id: Integer;
    Fid_alb: Integer;
    Fcp_url: string;
  public
    property cp_id: Integer read Fcp_id write Fcp_id;
    property id_alb: Integer read Fid_alb write Fid_alb;
    property cp_url: String read Fcp_url write Fcp_url;
  end;

implementation

end.
