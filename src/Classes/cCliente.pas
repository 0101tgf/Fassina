unit cCliente;

interface

uses System.Classes,
     System.SysUtils,
     FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
     FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
     FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
     FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
     FireDAC.Comp.Client;

type
    TCliente = Class
    private
    FConexao: TFDConnection;
    FCodEmp: integer;
    FCodigo: integer;
    FNome: string;
    FCidade: string;
    FUF: string;
    FAtivo: Integer;

    public
    property Conexao: TFDConnection read FConexao write FConexao;
    property CodEmp: integer read FCodEmp write FCodEmp;
    property Codigo: integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
    property Ativo: Integer read FAtivo write FAtivo;
    function fBuscaCliente(const PCodigo: Integer; out PRetorno:String):Boolean;
    constructor Create(AConexao:TFDConnection; ACodEmp: Integer);
    destructor Destroy; override;
    End;

implementation

{ TCliente }

uses ufrmPrincipal;

{$region 'CONSTRUTOR E DESTRUIDOR'}

constructor TCliente.Create(AConexao: TFDConnection; ACodEmp: Integer);
begin
  Conexao := AConexao;
  CodEmp := ACodEmp;
end;

destructor TCliente.Destroy;
begin
  inherited;
end;
{$endregion}

{$region 'METODOS'}

function TCliente.fBuscaCliente(const PCodigo: Integer; out PRetorno: String): Boolean;
  var
  Qry : TFDQuery;
begin

 Result := False;

 Qry := TFDQuery.Create(Nil);
 Qry.Connection := Conexao;
 try

  Qry.Active := false;
  Qry.SQL.clear;
  Qry.SQL.Add('select CodEmp,Codigo,Nome,Cidade,UF,Ativo from clientes where CodEmp = :CodEmp');
  Qry.SQL.Add('and Ativo=1 and Codigo=:Codigo limit 1');
  Qry.ParamByName('CodEmp').AsInteger := CodEmp;
  Qry.ParamByName('Codigo').AsInteger := PCodigo;
  Qry.Active := true;

  if Qry.RecordCount > 0 then
  begin
  Nome := Qry.FieldByName('Nome').AsString;
  Result := true;
  end
  else
  begin
  PRetorno := 'Cliente n?o encontrado..';
  end;


 finally
 Qry.DisposeOf;
 end;

end;

{$endregion}

end.
