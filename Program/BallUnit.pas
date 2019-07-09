unit BallUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,FMX.Objects;

type
  TBallForm = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBall = Class(TImage)
  Private
  Public
    Constructor Create(Stream:TStream; var AOwner);
    Destructor Destroy;
  End;

var
  BallForm: TBallForm;

implementation

{$R *.fmx}


Constructor TBall.Create(Stream: TStream; Var AOwner);
begin
  Inherited Create(TComponent(AOwner));
  Bitmap.LoadFromStream(Stream);
  Parent := TFMXObject(AOwner);
end;

Destructor TBall.Destroy;
begin
  Inherited Destroy;
end;


end.
