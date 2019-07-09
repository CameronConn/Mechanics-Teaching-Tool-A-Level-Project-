unit MainMenuUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, OwnModelUnit, PracticeUnit;

type
  TMainMenuForm = class(TForm)
    GoToOwnModelButton: TButton;
    GoToPracticeButton: TButton;
    WelcomeMessage: TLabel;
    CloseProgramButton: TButton;
    procedure GoToOwnModelButtonClick(Sender: TObject);
    procedure GoToPracticeButtonClick(Sender: TObject);
    procedure CloseProgramButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainMenuForm: TMainMenuForm;

implementation

{$R *.fmx}



procedure TMainMenuForm.CloseProgramButtonClick(Sender: TObject);
begin
halt;
end;

procedure TMainMenuForm.GoToOwnModelButtonClick(Sender: TObject);
begin
MainMenuForm.Hide;
OwnModelForm.Show;
end;

procedure TMainMenuForm.GoToPracticeButtonClick(Sender: TObject);
begin
MainMenuForm.Hide;
PracticeForm.Show;
end;

end.
