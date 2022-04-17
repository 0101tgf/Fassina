program Fassina;

uses
  Vcl.Forms,
  ufrmPrincipal in 'src\ufrmPrincipal.pas' {frmPrincipal},
  ufrmLogin in 'src\ufrmLogin.pas' {frmLogin},
  uDm in 'src\uDm.pas' {Dm: TDataModule},
  cUsuario in 'src\Classes\cUsuario.pas',
  ufrmVenda in 'src\ufrmVenda.pas' {frmVenda},
  cCliente in 'src\Classes\cCliente.pas',
  cProduto in 'src\Classes\cProduto.pas',
  cVenda in 'src\Classes\cVenda.pas',
  ufrmOperacoesAux in 'src\ufrmOperacoesAux.pas' {frmOperacoesAux};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDm, Dm);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
