unit u_AlbumClass;

interface

uses
  MVCFramework.Serializer.Commons,
  u_ArtistaClass;

type
  [MVCNameCaseAttribute(ncLowerCase)]
  TAlbum = class(TArtista)
  private
    Falb_id: Integer;
    Falb_nome: string;
    Fid_art: Integer;
  public
    property alb_id: Integer read Falb_id write Falb_id;
    property alb_nome: string read Falb_nome write Falb_nome;
    property id_art: Integer read Fid_art write Fid_art;
  end;

implementation

end.
