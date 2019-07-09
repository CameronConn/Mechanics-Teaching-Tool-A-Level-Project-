unit PracticeUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects,Math,BallUnit, FMX.Edit;

type
  TPracticeForm = class(TForm)
    PracticeFormWelcomeMessage: TLabel;
    Plank: TLine;
    PlankString: TLine;
    VerticalString: TLine;
    TensionDisclaimer: TLabel;
    AngleOfPlankDisclaimer: TLabel;
    Ball1MassDisclaimer: TLabel;
    Ball2MassDisclaimer: TLabel;
    LengthOfPlankDisclaimer: TLabel;
    LengthOfStringDisclaimer: TLabel;
    HowFarBall1StartsUpPlankDisclaimer: TLabel;
    CoefficientOfFrictionDisclaimer: TLabel;
    AccelerationDisclaimer: TLabel;
    TensionNewtons: TLabel;
    AccelerationMetresPerSecondSquared: TLabel;
    AngleOfPlankDegrees: TLabel;
    Ball1MassKilograms: TLabel;
    Ball2MassKilograms: TLabel;
    LengthOfPlankMetres: TLabel;
    LengthOfStringMetres: TLabel;
    HowFarBall1UpPlankMetres: TLabel;
    TensionShow: TLabel;
    AccelerationShow: TLabel;
    AngleOfPlankShow: TLabel;
    Ball1MassShow: TLabel;
    CoefficientOfFrictionShow: TLabel;
    HowFarBall1UpPlankShow: TLabel;
    LengthOfStringShow: TLabel;
    LengthOfPlankShow: TLabel;
    Ball2MassShow: TLabel;
    QuestionsDisclaimer: TLabel;
    Question1: TLabel;
    Question2: TLabel;
    Question3: TLabel;
    CheckAndAnimateButton: TButton;
    Question1Answer: TEdit;
    Question2Answer: TEdit;
    Question3Answer: TEdit;
    NewProblemButton: TButton;
    CloseProgramButton: TButton;
    ReturnToMenuButton: TButton;
    procedure UpdateModel;
    procedure ChangeBallsToCorrectPositions;
    procedure ChangePlankAngle;
    procedure ChangePlankStringAngleAndPosition(TopOfSlopeY,TopOfSlopeX:Real);
    procedure ChangeVerticalStringPosition(TopOfSlopeY,TopOfSlopeX:Real);
    procedure ChangeStringToCorrectHeight;
    procedure FormCreate(Sender: TObject);
    procedure CheckAndAnimateButtonClick(Sender: TObject);
    procedure NewProblemButtonClick(Sender: TObject);
    procedure CreateProblem;
    procedure FormShow(Sender: TObject);
    procedure CloseProgramButtonClick(Sender: TObject);
    procedure ReturnToMenuButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PracticeForm: TPracticeForm;
  Acceleration,Tension, PlankAngleDegrees, PlankAngleRadians, Ball1Mass, Ball2Mass, PlankLength, StringLength, DistanceBall1StartsUpPlank, CoefficientOfFriction, HeightOfPlankPixels,InitialMovementLength,ExtraDisplacementLength : real;
  UpSlope : String;
  RandomInteger1,RandomInteger2 : integer;
  Ball1,Ball2: TBall;
CONST
  g = 9.8;
  SmoothnessConstant=100;


implementation

uses MainMenuUnit;

{$R *.fmx}


function ConvertMetresToPixels(Input : real) : real;
begin
  result:=Input*(HeightOfPlankPixels/PlankLength);
end;

function CalculateHeightofPlankToUseInPixels : real;
begin
  if PracticeForm.Height < PracticeForm.Width then result:= PracticeForm.Height-150
  else result:=PracticeForm.Width-150;
end;

function CalculateSignificantFigures(Input:String) : integer;
var Stepper : integer;
begin
Result:=Length(Input);
  for Stepper := 1 to Length(Input) do
    begin
      if Input[Stepper] = '.' then Result:=Length(Input) - 1
    end;
end;

function Random3DigitReal : real;
var FloatasString : String;
    Counter,RandomDecisionValue : integer;
begin
  for counter := 1 to 3 do
    begin
      FloatasString:=FloatasString+IntToStr(Random(9));
    end;
  RandomDecisionValue:=Random(100);
  if RandomDecisionValue<33 then
    begin
     SetLength(FloatAsString,4);
     FloatAsString[4]:=FloatAsString[3];
     FloatAsString[3]:=FloatAsString[2];
     FloatAsString[2]:='.';
    end;
  if (RandomDecisionValue>=33) and (RandomDecisionValue<66) then
    begin
     SetLength(FloatAsString,4);
     FloatAsString[4]:=FloatAsString[3];
     FloatAsString[3]:='.';
    end;
  result:=StrtoFloat(FloatasString);
end;

function RoundInputasString(Input:String;EndLength:Integer) : string;
var Stepper : integer;
    Finished : boolean;
begin
  if ord(Input[Endlength+1])>52
    then begin
           if ord(Input[Endlength])<57
            then Input[EndLength]:=Char((Ord(Input[Endlength]))+1)
            else begin
                  Input[Endlength]:='0';
                  Stepper:=EndLength-1;
                  while not Finished do
                      begin
                        if ord(input[Stepper])<57
                          then begin
                                Input[Stepper]:=Char((Ord(Input[Stepper]))+1);
                                Finished:=True;
                               end
                        else begin
                              Input[Stepper]:='0';
                              Stepper:=Stepper-1;
                             end;
                      end;
                 end;
         end;
result:=Input;
end;

function MakeXDigits(Input:real;X:Integer) : real;
Var InputasString,InputasStringNoDecimal : String;
    DecimalPlace : boolean;
    Stepper,Counter,i,DecimalPosition : integer;
begin
  InputasString:=FloattoStr(Input);
  for Stepper := 1 to Length(InputAsString) do
    begin
      if InputasString[Stepper]='.'
        then begin
              DecimalPosition:=Stepper;
              DecimalPlace:=true;
             end
        else begin
             SetLength(InputAsStringNoDecimal,Length(InputAsStringNoDecimal)+1);
             InputasStringNoDecimal[Length(InputAsStringNoDecimal)]:=InputasString[Stepper]
             end;
    end;
  InputasStringNoDecimal:=RoundInputasString(InputasStringNoDecimal,X);
  SetLength(InputasStringNoDecimal,X);
  InputasString:=InputasStringNoDecimal;
  if DecimalPlace=true
    then begin
          SetLength(InputasString,X+1);
          for I := Length(InputasString) downto DecimalPosition+1 do
              begin
                 InputasString[i]:=InputasString[i-1]
              end;
          InputasString[DecimalPosition]:='.';
         end;
Result:=StrtoFloat(InputasString);
end;

function CalculateTension:real;
var Temp : real;
begin
  if UpSlope='UpSlope' then Temp:=Ball2Mass*(g-Acceleration);
  if UpSlope='DownSlope' then Temp:=Ball2Mass*(g+Acceleration);
  Result:=MakeXDigits(Temp,4);
end;

procedure CreateRandomValues;
begin
  PlankAngleDegrees:= RandomRange(20,60);
  PlankAngleRadians:=DegtoRad(PlankAngleDegrees);
  Ball1Mass:= Random3DigitReal;
  Ball2Mass:= Random3DigitReal;
  PlankLength:= Random3DigitReal;
  DistanceBall1StartsUpPlank:= Random3DigitReal;
  StringLength:= Random3DigitReal;
  CoefficientOfFriction:= MakeXDigits(Random,4);
end;

function CalculateTopOfSlopeY (HeightOfPlankPixels : real) : real;
begin
 Result:=PracticeForm.Height-50-(HeightOfPlankPixels*Cos((pi/2)-PlankAngleRadians));
end;

function CalculateTopOfSlopeX (HeightOfPlankPixels : real) : real;
begin
 Result:=70+(HeightOfPlankPixels*Sin((pi/2)-PlankAngleRadians));
end;

function SensibleM1Problem : boolean;
var TempAcceleration,InitialMovementLength,ExtraDisplacementLength,VelocityOfBall1WhenBall2HitGround,VelocityOFBall2WhenBall1HitGround:real;
begin
    if (DistanceBall1StartsUpPlank+StringLength<PlankLength)
    or (DistanceBall1StartsUpPlank>PlankLength)
    or (StringLength-PlankLength+DistanceBall1StartsUpPlank>PlankLength*Sin(PlankAngleRadians))
    then result:=false
else begin
        result:=true;
        if Ball2Mass>Ball1Mass*((CoefficientofFriction*Cos(PlankAngleRadians))+Sin(PlankAngleRadians)) then UpSlope:='UpSlope'
        else if Ball2Mass<Ball1Mass*((-CoefficientofFriction*Cos(PlankAngleRadians))+Sin(PlankAngleRadians)) then UpSlope:='DownSlope'
        else result:=false;
        if UpSlope = 'UpSlope' then
          begin
            TempAcceleration:=((-Ball1Mass*g*((Sin(PlankAngleRadians))+(CoefficientofFriction*(Cos(PlankAngleRadians)))))+(Ball2Mass*g))/(Ball1Mass+Ball2Mass);
            Acceleration:=MakeXDigits(TempAcceleration,7);
            if Acceleration<0
              then result:=false
              else begin
                    VelocityOfBall1WhenBall2HitGround:= Sqrt(2*Acceleration*((PlankLength*Sin(PlankAngleRadians))-StringLength+PlankLength-DistanceBall1StartsUpPlank));
                    ExtraDisplacementLength:=(((VelocityOfBall1WhenBall2HitGround)*(VelocityOfBall1WhenBall2HitGround))/(2*g*((CoefficientofFriction*Cos(PlankAngleRadians))+(Sin(PlankAngleRadians)))));
                    InitialMovementLength:=(PlankLength*Sin(PlankAngleRadians))-StringLength+PlankLength-DistanceBall1StartsUpPlank;
                    if DistanceBall1StartsUpPlank+InitialMovementLength+ExtraDisplacementLength>PlankLength then result:=false;
                   end;
          end
         else if UpSlope = 'DownSlope' then
         begin
           TempAcceleration:=((Ball1Mass*g*((Sin(PlankAngleRadians))-(CoefficientofFriction*(Cos(PlankAngleRadians)))))-(Ball2Mass*g))/(Ball1Mass+Ball2Mass);
           Acceleration:=MakeXDigits(TempAcceleration,7);
           if Acceleration<0
            then result:=false
            else begin
                   VelocityOfBall2WhenBall1HitGround:= Sqrt(2*Acceleration*DistanceBall1StartsUpPlank);
                   InitialMovementLength:=DistanceBall1StartsUpPlank;
                   ExtraDisplacementLength:=((VelocityOfBall2WhenBall1HitGround)*(VelocityOfBall2WhenBall1HitGround))/(2*g);
                   if PlankLength*Sin(PlankAngleRadians)-StringLength+PlankLength-DistanceBall1StartsUpPlank+InitialMovementLength+ExtraDisplacementLength > PlankLength*Sin(PlankAngleRadians) then result:=false;
                 end;
         end;
    end;
end;

procedure TPracticeForm.ChangeBallsToCorrectPositions;
var NewBall1X,NewBall1Y,NewBall2X,NewBall2Y,BottomOfPlankX,BottomOfPlankY : real;
begin
  BottomOfPlankY:=Plank.Position.Y+HeightOfPlankPixels-52;
  BottomOfPlankX:=Plank.Position.X-18;
  NewBall1X:=BottomOfPlankX+(ConvertMetresToPixels(DistanceBall1StartsUpPlank)*Cos(PlankAngleRadians));
  NewBall1Y:=BottomOfPlankY-(ConvertMetresToPixels(DistanceBall1StartsUpPlank)*Sin(PlankAngleRadians));
  NewBall2X:=BottomOfPlankX+HeightOfPlankPixels*Cos(PlankAngleRadians);
  NewBall2Y:=BottomOfPlankY - ConvertMetresToPixels((PlankLength*Sin(PlankAngleRadians))-StringLength+PlankLength-DistanceBall1StartsUpPlank);
  Ball1.Position.X:=NewBall1X;
  Ball1.Position.Y:=NewBall1Y;
  Ball2.Position.X:=NewBall2X;
  Ball2.Position.Y:=NewBall2Y;
end;

procedure TPracticeForm.ChangePlankAngle;
begin
  Plank.RotationAngle:=90-PlankAngleDegrees;
end;

procedure TPracticeForm.ChangePlankStringAngleAndPosition(TopOfSlopeY,TopOfSlopeX : real);
begin
 PlankString.RotationAngle:=90-PlankAngleDegrees;
 PlankString.Position.X:=TopOfSlopeX+6;
 PlankString.Position.Y:=TopOfSlopeY-30;
end;

procedure TPracticeForm.ChangeVerticalStringPosition(TopOfSlopeY,TopOfSlopeX: Real);
begin
  VerticalString.Position.X:=TopOfSlopeX+6;
  VerticalString.Position.Y:=TopOfSlopeY-30;
end;

procedure TPracticeForm.CheckAndAnimateButtonClick(Sender: TObject);
var    Counter : integer;
       NewXBall1,NewYBall1,NewXBall2,NewYBall2,TimeForThisMovement,PartEndVelocity,Ball2YLocation,Ball1XLocation,Ball1YLocation,EachPartOfInitialMovementLength,EachPartOfExtraDisplacementLength,VelocityOfBall1WhenBall2HitGround,VelocityOFBall2WhenBall1HitGround,CurrentInitialSpeed,WaitingTime,LowestRatioForMovement,HighestRatioForMovement:real;
       Question1Correct,Question2Correct,Question3Correct : boolean;
begin
if Ball2Mass>Ball1Mass*((CoefficientofFriction*Cos(PlankAngleRadians))+Sin(PlankAngleRadians)) then UpSlope:='UpSlope'
else if Ball2Mass<Ball1Mass*((-CoefficientofFriction*Cos(PlankAngleRadians))+Sin(PlankAngleRadians)) then UpSlope:='DownSlope';
if UpSlope = 'UpSlope' then
         begin
            VelocityOfBall1WhenBall2HitGround:= Sqrt(2*Acceleration*((PlankLength*Sin(PlankAngleRadians))-StringLength+PlankLength-DistanceBall1StartsUpPlank));
            ExtraDisplacementLength:=(((VelocityOfBall1WhenBall2HitGround)*(VelocityOfBall1WhenBall2HitGround))/(2*g*((CoefficientofFriction*Cos(PlankAngleRadians))+(Sin(PlankAngleRadians)))));
            InitialMovementLength:=(PlankLength*Sin(PlankAngleRadians))-StringLength+PlankLength-DistanceBall1StartsUpPlank;
         end;
if UpSlope = 'DownSlope' then
         begin
            VelocityOfBall2WhenBall1HitGround:= Sqrt(2*Acceleration*DistanceBall1StartsUpPlank);
            InitialMovementLength:=DistanceBall1StartsUpPlank;
            ExtraDisplacementLength:=((VelocityOfBall2WhenBall1HitGround)*(VelocityOfBall2WhenBall1HitGround))/(2*g);
         end;
if (UpSlope='UpSlope') and (Uppercase(Question1Answer.Text)='UP') then Question1Correct:=True;
if (UpSlope='DownSlope') and (Uppercase(Question1Answer.Text)='DOWN') then Question1Correct:=True;
if (RandomInteger1=1) and (Question2Answer.Text=FloatToStr(Tension)) then Question2Correct:=True;
if (RandomInteger1=2) and (Question2Answer.Text=FloatToStr(Acceleration)) then Question2Correct:=True;
if (RandomInteger1=3) and (Question2Answer.Text=FloatToStr(PlankAngleDegrees)) then Question2Correct:=True;
if (RandomInteger1=4) and (Question2Answer.Text=FloatToStr(Ball1Mass)) then Question2Correct:=True;
if (RandomInteger1=5) and (Question2Answer.Text=FloatToStr(Ball2Mass)) then Question2Correct:=True;
if (RandomInteger1=6) and (Question2Answer.Text=FloatToStr(CoefficientOfFriction)) then Question2Correct:=True;
if (RandomInteger2=1) and (Question3Answer.Text=FloatToStr(Tension)) then Question3Correct:=True;
if (RandomInteger2=2) and (Question3Answer.Text=FloatToStr(Acceleration)) then Question3Correct:=True;
if (RandomInteger2=3) and (Question3Answer.Text=FloatToStr(PlankAngleDegrees)) then Question3Correct:=True;
if (RandomInteger2=4) and (Question3Answer.Text=FloatToStr(Ball1Mass)) then Question3Correct:=True;
if (RandomInteger2=5) and (Question3Answer.Text=FloatToStr(Ball2Mass)) then Question3Correct:=True;
if (RandomInteger2=6) and (Question3Answer.Text=FloatToStr(CoefficientOfFriction)) then Question3Correct:=True;
if (RandomInteger2=7) and (Question3Answer.Text=FloatToStr(InitialMovementLength)) then Question3Correct:=True;
if (RandomInteger2=8) and (Question3Answer.Text=FloatToStr(ExtraDisplacementLength)) then Question3Correct:=True;
if (Question1Correct=True) and (Question2Correct=True) and (Question3Correct=True)
then begin
        ShowMessage('Answers Correct. Animating!');
        CurrentInitialSpeed:=0;
        WaitingTime:=0;
        if UpSlope = 'UpSlope' then
         begin
            EachPartOfExtraDisplacementLength:=ExtraDisplacementLength/SmoothnessConstant;
            EachPartOfInitialMovementLength:=InitialMovementLength/SmoothnessConstant;
            Ball2YLocation:=Ball2.Position.Y;
            Ball1YLocation:=Ball1.Position.Y;
            Ball1XLocation:=Ball1.Position.X;
            if DistanceBall1StartsUpPlank+InitialMovementLength+ExtraDisplacementLength>PlankLength
              then Showmessage('Chosen Values result in a problem beyond the M1 Specification, Ball 1 would fly off the top of the incline')
              else begin
                      for counter := 1 to SmoothnessConstant do
                        begin
                          PartEndVelocity:=Sqrt((CurrentInitialSpeed*CurrentInitialSpeed)+(2*Acceleration*EachPartOfInitialMovementLength));
                          TimeForThisMovement:=(PartEndVelocity-CurrentInitialSpeed)/Acceleration;
                          NewYBall2:=Ball2YLocation+ConvertMetresToPixels(Counter*EachPartOfInitialMovementLength);
                          NewXBall1:= Ball1XLocation + ConvertMetresToPixels((Counter*EachPartOfInitialMovementLength)*Cos(PlankAngleRadians));
                          NewYBall1:= Ball1YLocation - ConvertMetresToPixels((Counter*EachPartOfInitialMovementLength)*Sin(PlankAngleRadians));
                          Ball1.AnimateFloatDelay('position.Y',NewYBall1,TimeForThisMovement,WaitingTime);
                          Ball1.AnimateFloatDelay('position.X',NewXBall1,TimeForThisMovement,WaitingTime);
                          Ball2.AnimateFloatDelay('position.Y',NewYBall2,TimeForThisMovement,WaitingTime);
                          PlankString.AnimateFloatDelay('Height',ConvertMetresToPixels(PlankLength-(DistanceBall1StartsUpPlank+(Counter*EachPartOfInitialMovementLength))),TimeForThisMovement,WaitingTime);
                          VerticalString.AnimateFloatDelay('Height',ConvertMetresToPixels(StringLength-PlankLength+DistanceBall1StartsUpPlank+(Counter*EachPartOfInitialMovementLength)),TimeForThisMovement,WaitingTime);
                          WaitingTime:=WaitingTime+TimeforThisMovement;
                          CurrentInitialSpeed:=PartEndVelocity;
                        end;
                      Ball1XLocation:=NewXBall1;
                      Ball1YLocation:=NewYBall1;
                      for counter := 1 to (SmoothnessConstant-1) do
                        begin
                         PartEndVelocity:=Sqrt((CurrentInitialSpeed*CurrentInitialSpeed)+(-2*g*((CoefficientofFriction*Cos(PlankAngleRadians))+Sin(PlankAngleRadians))*EachPartOfExtraDisplacementLength));
                         TimeForThisMovement:=(2*EachPartOfExtraDisplacementLength)/(CurrentInitialSpeed+PartEndVelocity);
                         NewXBall1:=Ball1XLocation + ConvertMetresToPixels((Counter*EachPartOfExtraDisplacementLength)*Cos(PlankAngleRadians));
                         NewYBall1:= Ball1YLocation - ConvertMetresToPixels((Counter*EachPartOfExtraDisplacementLength)*Sin(PlankAngleRadians));
                         Ball1.AnimateFloatDelay('position.Y',NewYBall1,TimeForThisMovement,WaitingTime);
                         Ball1.AnimateFloatDelay('position.X',NewXBall1,TimeForThisMovement,WaitingTime);
                         PlankString.AnimateFloatDelay('Height',ConvertMetresToPixels(PlankLength-(DistanceBall1StartsUpPlank+InitialMovementLength+(Counter*EachPartOfExtraDisplacementLength))),TimeForThisMovement,WaitingTime);
                         WaitingTime:=WaitingTime+TimeForThisMovement;
                         CurrentInitialSpeed:=PartEndVelocity;
                        end;
                      Ball1XLocation:=NewXBall1;
                      Ball1YLocation:=NewYBall1;
                      CurrentInitialSpeed:=0;
                      for counter := 1 to (SmoothnessConstant-1) do
                        begin
                         PartEndVelocity:=Sqrt((CurrentInitialSpeed*CurrentInitialSpeed)+(2*g*((CoefficientofFriction*Cos(PlankAngleRadians))+Sin(PlankAngleRadians))*EachPartOfExtraDisplacementLength));
                         TimeForThisMovement:=(2*EachPartOfExtraDisplacementLength)/(CurrentInitialSpeed+PartEndVelocity);
                         NewXBall1:=Ball1XLocation - ConvertMetresToPixels((Counter*EachPartOfExtraDisplacementLength)*Cos(PlankAngleRadians));
                         NewYBall1:=Ball1YLocation + ConvertMetresToPixels((Counter*EachPartOfExtraDisplacementLength)*Sin(PlankAngleRadians));
                         Ball1.AnimateFloatDelay('position.Y',NewYBall1,TimeForThisMovement,WaitingTime);
                         Ball1.AnimateFloatDelay('position.X',NewXBall1,TimeForThisMovement,WaitingTime);
                         PlankString.AnimateFloatDelay('Height',ConvertMetresToPixels(PlankLength-(DistanceBall1StartsUpPlank+InitialMovementLength+ExtraDisplacementLength-(Counter*EachPartOfExtraDisplacementLength))),TimeForThisMovement,WaitingTime);
                         WaitingTime:=WaitingTime+TimeForThisMovement;
                         CurrentInitialSpeed:=PartEndVelocity;
                        end;
                  end;
         end
         else if UpSlope = 'DownSlope' then begin
            EachPartOfInitialMovementLength:=InitialMovementLength/SmoothnessConstant;
            EachPartOfExtraDisplacementLength:=ExtraDisplacementLength/SmoothnessConstant;
            Ball2YLocation:=Ball2.Position.Y;
            Ball1YLocation:=Ball1.Position.Y;
            Ball1XLocation:=Ball1.Position.X;
            if (PlankLength*Sin(PlankAngleRadians))-StringLength+PlankLength-DistanceBall1StartsUpPlank+InitialMovementLength+ExtraDisplacementLength>PlankLength*Sin(PlankAngleRadians)
              then Showmessage('Chosen Values result in a problem beyond the M1 Specification, Ball 2 would move higher than the top of the incline')
              else begin
                    for counter := 1 to SmoothnessConstant do
                      begin
                        PartEndVelocity:=Sqrt((CurrentInitialSpeed*CurrentInitialSpeed)+(2*Acceleration*EachPartOfInitialMovementLength));
                        TimeForThisMovement:=(PartEndVelocity-CurrentInitialSpeed)/Acceleration;
                        NewYBall2:=Ball2YLocation- ConvertMetresToPixels(Counter*EachPartOfInitialMovementLength);
                        NewXBall1:= Ball1XLocation - ConvertMetresToPixels((Counter*EachPartOfInitialMovementLength)*Cos(PlankAngleRadians));
                        NewYBall1:= Ball1YLocation + ConvertMetresToPixels((Counter*EachPartOfInitialMovementLength)*Sin(PlankAngleRadians));
                        Ball1.AnimateFloatDelay('position.Y',NewYBall1,TimeForThisMovement,WaitingTime);
                        Ball1.AnimateFloatDelay('position.X',NewXBall1,TimeForThisMovement,WaitingTime);
                        Ball2.AnimateFloatDelay('position.Y',NewYBall2,TimeForThisMovement,WaitingTime);
                        PlankString.AnimateFloatDelay('Height',ConvertMetresToPixels(PlankLength-(DistanceBall1StartsUpPlank-(Counter*EachPartOfInitialMovementLength))),TimeForThisMovement,WaitingTime);
                        VerticalString.AnimateFloatDelay('Height',ConvertMetresToPixels(StringLength-PlankLength+DistanceBall1StartsUpPlank-(Counter*EachPartOfInitialMovementLength)),TimeForThisMovement,WaitingTime);
                        WaitingTime:=WaitingTime+TimeforThisMovement;
                        CurrentInitialSpeed:=PartEndVelocity;
                      end;
                    Ball2YLocation:=NewYBall2;
                    for counter := 1 to (SmoothnessConstant-1) do
                      begin
                       PartEndVelocity:=Sqrt((CurrentInitialSpeed*CurrentInitialSpeed)+(-2*g*EachPartOfExtraDisplacementLength));
                       TimeForThisMovement:=(2*EachPartOfExtraDisplacementLength)/(CurrentInitialSpeed+PartEndVelocity);
                       NewYBall2:=Ball2YLocation- ConvertMetresToPixels(Counter*EachPartOfExtraDisplacementLength);
                       Ball2.AnimateFloatDelay('position.y',NewYBall2,TimeForThisMovement,WaitingTime);
                       VerticalString.AnimateFloatDelay('Height',ConvertMetresToPixels(StringLength-PlankLength+DistanceBall1StartsUpPlank-InitialMovementLength-(Counter*EachPartOfExtraDisplacementLength)),TimeForThisMovement,WaitingTime);
                       WaitingTime:=WaitingTime+TimeForThisMovement;
                       CurrentInitialSpeed:=PartEndVelocity;
                      end;
                    CurrentInitialSpeed:=0;
                    Ball2YLocation:=NewYBall2;
                    for counter := 1 to (SmoothnessConstant-1) do
                      begin
                       PartEndVelocity:=Sqrt((CurrentInitialSpeed*CurrentInitialSpeed)+(2*g*EachPartOfExtraDisplacementLength));
                       TimeForThisMovement:=(2*EachPartOfExtraDisplacementLength)/(CurrentInitialSpeed+PartEndVelocity);
                       NewYBall2:=Ball2YLocation+ConvertMetresToPixels(Counter*EachPartOfExtraDisplacementLength);
                       Ball2.AnimateFloatDelay('position.y',NewYBall2,TimeForThisMovement,WaitingTime);
                       VerticalString.AnimateFloatDelay('Height',ConvertMetresToPixels(StringLength-PlankLength+DistanceBall1StartsUpPlank-InitialMovementLength-ExtraDisplacementLength+(Counter*EachPartOfExtraDisplacementLength)),TimeForThisMovement,WaitingTime);
                       WaitingTime:=WaitingTime+TimeForThisMovement;
                       CurrentInitialSpeed:=PartEndVelocity;
                      end;
              end;
         end;
        end
else if (Question1Correct=False) and (Question2Correct=True) and (Question3Correct=True) then ShowMessage('Answer to Question 1 is incorrect')
else if (Question1Correct=True) and (Question2Correct=False) and (Question3Correct=True) then ShowMessage('Answer to Question 2 is incorrect')
else if (Question1Correct=True) and (Question2Correct=True) and (Question3Correct=False) then ShowMessage('Answer to Question 3 is incorrect')
else if (Question1Correct=False) and (Question2Correct=False) and (Question3Correct=True) then ShowMessage('Answers to Question 1 and Question 2 are incorrect')
else if (Question1Correct=False) and (Question2Correct=True) and (Question3Correct=False) then ShowMessage('Answers to Question 1 and Question 3 are incorrect')
else if (Question1Correct=True) and (Question2Correct=False) and (Question3Correct=False) then ShowMessage('Answers to Question 2 and Question 3 are incorrect')
else if (Question1Correct=False) and (Question2Correct=False) and (Question3Correct=False) then ShowMessage('Answers to all Questions are incorrect')
end;

procedure TPracticeForm.CloseProgramButtonClick(Sender: TObject);
begin
 halt;
 Ball1.Destroy;
 Ball2.Destroy;
end;

procedure TPracticeForm.ChangeStringToCorrectHeight;
begin
  PlankString.Height:=ConvertMetresToPixels(PlankLength-DistanceBall1StartsUpPlank);
  VerticalString.Height:=ConvertMetresToPixels(StringLength-PlankLength+DistanceBall1StartsUpPlank);
end;

procedure TPracticeForm.UpdateModel;
var TopOfSlopeY,TopOfSlopeX : real;
begin
 HeightofPlankPixels:=CalculateHeightofPlanktoUseInPixels;
 ChangePlankAngle;
 TopOfSlopeY:=CalculateTopOfSlopeY(HeightOfPlankPixels);
 TopOfSlopeX:=CalculateTopOfSlopeX(HeightOfPlankPixels);
 ChangePlankStringAngleAndPosition(TopOfSlopeY,TopOfSlopeX);
 ChangeVerticalStringPosition(TopOfSlopeY,TopOfSlopeX);
 ChangeBallsToCorrectPositions;
 ChangeStringToCorrectHeight;
end;

procedure ResetValuestoZero;
begin
 RandomInteger1:=0;
 RandomInteger2:=0;
 Tension:=0;
 Acceleration:=0;
 PlankAngleDegrees:=0;
 Ball1Mass:=0;
 Ball2Mass:=0;
 PlankLength:=0;
 StringLength:=0;
 DistanceBall1StartsUpPlank:=0;
 CoefficientOfFriction:=0;
end;

procedure TPracticeForm.CreateProblem;
Var QuestionsStream : TResourceStream;
    QuestionsList : TStringList;
    TensionQuestion,AccelerationQuestion,AngleQuestion,Ball1MassQuestion,Ball2MassQuestion,CoefficientQuestion : boolean;
begin
  Question1Answer.Text:='';
  Question2Answer.Text:='';
  Question3Answer.Text:='';
  ResetValuestoZero;
  CreateRandomValues;
  While not SensibleM1Problem = true do CreateRandomValues;
  Tension:=CalculateTension;
  QuestionsStream := TResourceStream.Create(MainInstance, 'Questions', RT_RCDATA);
  QuestionsList:=TStringList.Create;
  QuestionsList.LoadFromStream(QuestionsStream);
  while (RandomInteger1=RandomInteger2)
  or ((RandomInteger1=6) And (RandomInteger2=4))
  or ((RandomInteger1=4) And (RandomInteger2=6))
  or ((RandomInteger1=6) And (RandomInteger2=3))
  or ((RandomInteger1=3) And (RandomInteger2=6))
  do begin
       RandomInteger1:=RandomRange(1,6);
       RandomInteger2:=RandomRange(1,8);
     end;
  case RandomInteger1 of
  1 : TensionQuestion:=True;
  2 : AccelerationQuestion:=True;
  3 : AngleQuestion:=True;
  4 : Ball1MassQuestion:=True;
  5 : Ball2MassQuestion:=True;
  6 : CoefficientQuestion:=True;
  end;
  case RandomInteger2 of
  1 : TensionQuestion:=True;
  2 : AccelerationQuestion:=True;
  3 : AngleQuestion:=True;
  4 : Ball1MassQuestion:=True;
  5 : Ball2MassQuestion:=True;
  6 : CoefficientQuestion:=True;
  end;
  Question1.Text:=QuestionsList[8];
  Question2.Text:=QuestionsList[RandomInteger1-1];
  Question3.Text:=QuestionsList[RandomInteger2-1];
  if AccelerationQuestion = true then AccelerationShow.Text:='?'
  else AccelerationShow.Text:=FloattoStr(Acceleration);
  if TensionQuestion = true then TensionShow.Text:='?'
  else TensionShow.Text:=FloattoStr(Tension);
  if AngleQuestion = true then AngleofPlankShow.Text:='?'
  else AngleOfPlankShow.Text:=FloattoStr(PlankAngleDegrees);
  if Ball1MassQuestion = true then Ball1MassShow.Text:='?'
  else Ball1MassShow.Text:=FloattoStr(Ball1Mass);
  if Ball2MassQuestion = true then Ball2MassShow.Text:='?'
  else Ball2MassShow.Text:=FloattoStr(Ball2Mass);
  if CoefficientQuestion = true then CoefficientOfFrictionShow.Text:='?'
  else CoefficientOfFrictionShow.Text:=FloattoStr(CoefficientOfFriction);
  LengthOfPlankShow.Text:=FloattoStr(PlankLength);
  LengthOfStringShow.Text:=FloattoStr(StringLength);
  HowFarBall1UpPlankShow.Text:=FloattoStr(DistanceBall1StartsUpPlank);
  UpdateModel;
end;

procedure TPracticeForm.FormCreate(Sender: TObject);
var BallStream:TResourceStream;
begin
  BallStream := TResourceStream.Create(MainInstance, 'BallImage', RT_RCDATA);
  Ball1:=TBall.Create(BallStream,Self);
  Ball2:=TBall.Create(BallStream,Self);
  Randomize;
end;

procedure TPracticeForm.FormShow(Sender: TObject);
begin
  HeightofPlankPixels:=CalculateHeightofPlanktoUseInPixels;
  Plank.SetBounds(70,PracticeForm.Height-50-HeightOfPlankPixels,50,HeightofPlankPixels);
  CreateProblem;
end;

procedure TPracticeForm.NewProblemButtonClick(Sender: TObject);
begin
 CreateProblem;
end;

procedure TPracticeForm.ReturnToMenuButtonClick(Sender: TObject);
begin
 MainMenuForm.Show;
 PracticeForm.Hide;
end;

end.

