unit cVenda;

interface

uses System.Classes,
     System.SysUtils,
     FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
     FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
     FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
     FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
     FireDAC.Comp.Client;

type TVenda = Class
  private
    FCodEmp: integer;
    FConexao: TFDConnection;
    FCodigoVenda: Integer;
    FDtEmissao: TDate;
    FCodigoCliente: Integer;
    FValorTotal: Currency;
    FNomeCliente: string;
    FProdutosMemoria: TFDQuery;

  public
    property Conexao: TFDConnection read FConexao write FConexao;
    property CodEmp: integer read FCodEmp write FCodEmp;
    property CodigoVenda: Integer read FCodigoVenda write FCodigoVenda;
    property DtEmissao : TDate read FDtEmissao write FDtEmissao;
    property CodigoCliente : Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal : Currency read FValorTotal write FValorTotal;
    property NomeCliente : string read FNomeCliente write FNomeCliente;
    property ProdutosMemoria : TFDQuery read FProdutosMemoria write FProdutosMemoria;
    function fGeraNumeroVenda:Boolean; {ok}
    function fAtulizaSequenciaVenda:Boolean; {ok}
    function fSalvarVenda(AOperacao:Integer;out ARetorno:String;const AMemoriaTemporaria: TFDMemTable):Boolean; {ok}
    function fExcluirVenda(ARetorno:String):Boolean; {ok}
    function fVerificaVendaExiste(out ARetorno:String):Boolean; {ok}
    function fCarregarVenda(out ARetorno:String):Boolean;
    constructor Create(AConexao:TFDConnection; ACodEmp: Integer);
    destructor Destroy; override;
End;

implementation

{ TVenda }

{$region 'CONSTRUTOR E DESTRUIDOR'}

constructor TVenda.Create(AConexao: TFDConnection; ACodEmp: Integer);
begin
  Conexao := AConexao;
  CodEmp := ACodEmp;
  ProdutosMemoria := TFDQuery.Create(Nil); {Usado somente para carregar produtos de venda j? efetuada..}
  ProdutosMemoria.Connection := Conexao;
end;

destructor TVenda.Destroy;
begin
  inherited;
  ProdutosMemoria.DisposeOf;
end;

{$endregion}

{$region 'METODOS'}

function TVenda.fAtulizaSequenciaVenda: Boolean;
var
  Qry : TFDQuery;
begin

  Result := false;

  if not fGeraNumeroVenda then
  begin
  exit;
  end;

  Qry := TFDQuery.Create(Nil);
  Qry.Connection := Conexao;
  try

    Qry.Active := false;
    Qry.SQL.clear;
    Qry.SQL.Add('update sequencial set Seq_Venda= :Seq_Venda where CodEmp = :CodEmp limit 1');
    Qry.ParamByName('Seq_Venda').AsInteger := CodigoVenda;
    Qry.ParamByName('CodEmp').AsInteger := CodEmp;
    Qry.ExecSQL;

    if Qry.RowsAffected = 1 then
    begin
      Result := true;
    end;

  finally
  Qry.DisposeOf;
  end;

end;

function TVenda.fCarregarVenda(out ARetorno:String):Boolean;
  var
  Qry: TFDQuery;
begin

  Result := false;

  Qry := TFDQuery.Create(nil);
  Qry.Connection := Conexao;
  try

    Qry.Active := false;
    Qry.SQL.clear;
    Qry.SQL.Add('select venda_cab.CodEmp,venda_cab.Cod_Cliente,clientes.nome, venda_cab.Valor_Total from venda_cab ');
    Qry.SQL.Add('inner join clientes on clientes.CodEmp = venda_cab.CodEmp ');
    Qry.SQL.Add('and clientes.Codigo=venda_cab.Cod_Cliente where venda_cab.CodEmp = :CodEmp and venda_cab.Cod_Venda= :Cod_Venda');
    Qry.ParamByName('CodEmp').AsInteger := CodEmp;
    Qry.ParamByName('Cod_Venda').AsInteger := CodigoVenda;
    qry.Active := true;

    if Qry.RecordCount > 0 then
    begin
      CodigoCliente := Qry.FieldByName('Cod_Cliente').AsInteger;
      NomeCliente := Qry.FieldByName('nome').AsString;
      ValorTotal := Qry.FieldByName('Valor_Total').AsCurrency;
    end
    else
    begin
      ARetorno := 'Venda n?o encontrada..';
      exit;
    end;

    ProdutosMemoria.Active := false;
    ProdutosMemoria.SQL.clear;
    ProdutosMemoria.SQL.Add('select venda_pro.CodEmp,venda_pro.Cod_Venda,venda_pro.Cod_Produto, produtos.descricao, ');
    ProdutosMemoria.SQL.Add('venda_pro.Quantidade,venda_pro.Vlr_Uni,venda_pro.Vlr_Total from venda_pro ');
    ProdutosMemoria.SQL.Add('inner join produtos on produtos.CodEmp = venda_pro.CodEmp and ');
    ProdutosMemoria.SQL.Add('produtos.codigo = venda_pro.Cod_Produto where venda_pro.CodEmp = :CodEmp and venda_pro.Cod_Venda = :Cod_Venda');
    ProdutosMemoria.ParamByName('CodEmp').AsInteger := CodEmp;
    ProdutosMemoria.ParamByName('Cod_Venda').AsInteger := CodigoVenda;
    ProdutosMemoria.Active := true;

    if ProdutosMemoria.RecordCount > 0 then
    begin
    Result := true;
    end
    else
    begin
    ARetorno := 'Produtos n?o encontradados..';
    end;

  finally
  Qry.DisposeOf;
  end;

end;

function TVenda.fExcluirVenda(ARetorno: String): Boolean;
var
 Qry : TFDQuery;
begin

  Result := false;

  Qry := TFDQuery.Create(Nil);
  Qry.Connection := Conexao;
  try

    Conexao.StartTransaction;
    try

      Qry.Active := false;
      Qry.SQL.clear;
      Qry.SQL.Add('delete from venda_pro where CodEmp = :CodEmp and Cod_Venda = :Cod_Venda');
      Qry.ParamByName('CodEmp').AsInteger := CodEmp;
      Qry.ParamByName('Cod_Venda').AsInteger := CodigoVenda;
      Qry.ExecSQL;

      Qry.Active := false;
      Qry.SQL.clear;
      Qry.SQL.Add('delete from venda_cab where CodEmp = :CodEmp and Cod_Venda = :Cod_Venda');
      Qry.ParamByName('CodEmp').AsInteger := CodEmp;
      Qry.ParamByName('Cod_Venda').AsInteger := CodigoVenda;
      Qry.ExecSQL;

      Conexao.Commit;

    except
    Conexao.Rollback;
    ARetorno := 'Falha ao cancelar venda, solicite suporte..';
    exit;
    end;

    Result := true;

  finally
  Qry.DisposeOf;
  end;

end;

function TVenda.fGeraNumeroVenda: Boolean;
var
  Qry : TFDQuery;
begin

  Result := false;

  Qry := TFDQuery.Create(nil);
  Qry.Connection := Conexao;
  try

    Qry.Active := false;
    Qry.SQL.clear;
    Qry.SQL.Add('select Seq_Venda+1 as Seq_Venda from sequencial where CodEmp = :CodEmp limit 1');
    Qry.ParamByName('CodEmp').AsInteger := CodEmp;
    Qry.Active := true;

    if Qry.RecordCount > 0 then
    begin
    CodigoVenda := Qry.FieldByName('Seq_Venda').AsInteger;
    Result := true;
    end;

  finally
  Qry.DisposeOf;
  end;

end;

function TVenda.fSalvarVenda(AOperacao:Integer;out ARetorno:String;const AMemoriaTemporaria: TFDMemTable):Boolean;
var
  Qry : TFDQuery;
begin

  Result := false;

  {AOperacao = 0 - Nova Venda}
  {AOperacao = 1 - Atualizar venda existente}

  if AMemoriaTemporaria.IsEmpty then
  begin
    ARetorno := 'Aten??o, n?o existem produtos para salvar..';
    exit;
  end;

  qry := TFDQuery.Create(nil);
  qry.Connection := Conexao;
  try

    Conexao.StartTransaction;
    try

      if AOperacao = 0 then {Nova Venda}
      begin

        if not fAtulizaSequenciaVenda then
        begin
        ARetorno := 'Falha ao atualizar sequencia da venda, solicite suporte..';
        exit;
        end;

      end;

      if AOperacao = 1 then {Limpar produtos para atualizar venda existente..}
      begin

        Qry.Active := false;
        Qry.SQL.clear;
        Qry.SQL.Add('delete from venda_pro where Cod_Venda = :Cod_Venda and CodEmp = :CodEmp');
        Qry.ParamByName('Cod_Venda').AsInteger := CodigoVenda;
        Qry.ParamByName('CodEmp').AsInteger := CodEmp;
        Qry.ExecSQL;

      end;

      Qry.Active := false;
      Qry.SQL.Clear;
      Qry.SQL.Add('insert into venda_cab (CodEmp,Cod_Venda,Dt_Emissao,Cod_Cliente,Valor_Total) ');
      Qry.SQL.Add('values (:CodEmp,:Cod_Venda, :Dt_Emissao,:Cod_Cliente,:Valor_Total) ON DUPLICATE KEY ');
      Qry.SQL.Add('update Valor_Total=:Valor_Total');
      Qry.ParamByName('CodEmp').AsInteger := CodEmp;
      Qry.ParamByName('Cod_Venda').AsInteger:= CodigoVenda;
      Qry.ParamByName('Dt_Emissao').AsDate := DtEmissao;
      Qry.ParamByName('Cod_Cliente').AsInteger := CodigoCliente;
      Qry.ParamByName('Valor_Total').AsCurrency := ValorTotal;
      Qry.ExecSQL;

      AMemoriaTemporaria.First;

      while not AMemoriaTemporaria.Eof do
      begin

        Qry.Active := false;
        Qry.SQL.clear;
        Qry.SQL.Add('insert into venda_pro (CodEmp,Cod_Venda,Cod_Produto,Quantidade,Vlr_Uni,Vlr_Total) ');
        Qry.SQL.Add('values(:CodEmp,:Cod_Venda,:Cod_Produto,:Quantidade,:Vlr_Uni,:Vlr_Total);');
        Qry.ParamByName('CodEmp').AsInteger := CodEmp;
        Qry.ParamByName('Cod_Venda').AsInteger := CodigoVenda;
        Qry.ParamByName('Cod_Produto').AsInteger := AMemoriaTemporaria.FieldByName('Codigo').AsInteger;
        Qry.ParamByName('Quantidade').AsFloat := AMemoriaTemporaria.FieldByName('Qtd').AsFloat;
        Qry.ParamByName('Vlr_Uni').AsCurrency := AMemoriaTemporaria.FieldByName('Vlr_Uni').AsCurrency;
        Qry.ParamByName('Vlr_Total').AsCurrency := AMemoriaTemporaria.FieldByName('Total').AsCurrency;
        Qry.ExecSQL;


        AMemoriaTemporaria.Next;

      end;

      Conexao.Commit;

    except
    Conexao.Rollback;
    ARetorno := 'Falha ao salvar venda, solicite suporte..';
    exit;
    end;

    Result := true;

  finally
  qry.DisposeOf;
  end;

end;

function TVenda.fVerificaVendaExiste(out ARetorno: String): Boolean;
var
  Qry : TFDQuery;
begin

  Result := false;

  Qry := TFDQuery.Create(Nil);
  Qry.Connection := Conexao;
  try

    Qry.Active := false;
    Qry.SQL.clear;
    Qry.SQL.Add('select Cod_Venda from venda_cab where CodEmp = :CodEmp and Cod_Venda = :Cod_Venda');
    Qry.ParamByName('CodEmp').AsInteger := CodEmp;
    Qry.ParamByName('Cod_Venda').AsInteger := CodigoVenda;
    Qry.Active := true;

    if Qry.RecordCount > 0 then
    begin
      Result := true;
    end
    else
    Begin
      ARetorno := 'Nenhuma venda com esse c?digo encontrada..';
    End;

  finally
  Qry.DisposeOf;
  end;

end;

{$endregion}

end.
