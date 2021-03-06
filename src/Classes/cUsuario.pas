unit cUsuario;

interface

uses System.Classes,
     System.SysUtils,
     FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
     FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
     FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
     FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
     FireDAC.Comp.Client;

type
    TUsuario = Class
    private
    FConexao: TFDConnection;
    FCodEmp: integer;
    FCodigo: integer;
    FNome: string;
    FAtivo: Integer;

    public
    property Conexao: TFDConnection read FConexao write FConexao;
    property CodEmp: integer read FCodEmp write FCodEmp;
    property Codigo: integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Ativo: Integer read FAtivo write FAtivo;
    function fFazerLogin(ANome,ASenha: String;out ARetorno:String): Boolean;
    constructor Create(AConexao:TFDConnection; ACodEmp: Integer);
    destructor Destroy; override;
    End;

implementation

{ TUsuario }

uses ufrmPrincipal;

{$region 'CONSTRUTOR E DESTRUIDOR'}

constructor TUsuario.Create(AConexao: TFDConnection; ACodEmp: Integer);
begin
  Conexao := AConexao;
  CodEmp := ACodEmp;
end;

destructor TUsuario.Destroy;
begin
  inherited;
end;

{$endregion}

{$region 'METODOS'}

function TUsuario.fFazerLogin(ANome, ASenha: String;
out ARetorno: String): Boolean;
var
Qry:TFDQuery;
begin

  Result := false;

  if (ANome.Trim.IsEmpty) or (ASenha.Trim.IsEmpty) then
  begin
    ARetorno := 'Por favor, informe usu?rio e senha..';
    exit;
  end;

  try

    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=Conexao;
    Qry.Active := false;
    Qry.SQL.Clear;
    Qry.SQL.Add('select CodEmp, Codigo, Nome, Senha, Ativo from usuarios Where CodEmp = :CodEmp and Ativo = 1');
    Qry.SQL.Add('AND lower(Nome) = :Nome and lower(Senha) = :Senha limit 1 ');
    Qry.ParamByName('Nome').AsString  := ANome.ToLower;
    Qry.ParamByName('Senha').AsString := ASenha.ToLower;
    Qry.ParamByName('CodEmp').AsInteger := CodEmp;

    Try

      Qry.Active := true;

      if Qry.RecordCount > 0 then
      begin
         CodEmp := Qry.FieldByName('CodEmp').AsInteger;
         Codigo     := Qry.FieldByName('Codigo').AsInteger;
         Nome    := Qry.FieldByName('Nome').AsString;
         Ativo    := Qry.FieldByName('Ativo').AsInteger;
         ARetorno := '';
         Result := true;
      end
      else
      begin
        ARetorno := 'Usu?rio n?o encontrado, solicite suporte..';
      end;

    Except
      ARetorno := 'Falha ao executar instru??o SQL, solicite suporte..';
    End;

  finally

    if Assigned(Qry) then
    begin
    Qry.Free;
    end;


  end;

end;


{$endregion}

end.
