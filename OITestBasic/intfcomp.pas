unit IntfComp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, LCLProc;

type

{$interfaces com}
  ITestInterface = interface
    ['{DC209DB2-6E2D-4680-93D6-5D9B3983C0D3}']
    function OnlyDummy: integer;
  end;
{$interfaces com}

  { TIntfComp }

  TIntfComp = class(TComponent)
  private
    FObjectHasInterface: ITestInterface;
    function GetObjectHasInterface: ITestInterface;
    procedure SetObjectHasInterface(AValue: ITestInterface);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    destructor Destroy; override;
  published
    property ObjectHasInterface: ITestInterface read GetObjectHasInterface write SetObjectHasInterface;
  end;

  { TCompInterface }

  TCompInterface = class(TComponent, ITestInterface)
  private
    function OnlyDummy: integer;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TestInterface', [TIntfComp, TCompInterface]);
end;

{ TCompInterface }

function TCompInterface.OnlyDummy: integer;
begin
  Result := -1;
end;

{ TIntfComp }

function TIntfComp.GetObjectHasInterface: ITestInterface;
begin
  Result := FObjectHasInterface;
end;

procedure TIntfComp.SetObjectHasInterface(AValue: ITestInterface);
begin
  FObjectHasInterface := AValue;
end;

procedure TIntfComp.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  // if ObjectHasInterface is being removed then we need to make sure it is
  // removed from here too
  if (Operation = opRemove) and Assigned(AComponent)
  and AComponent.IsImplementorOf(ObjectHasInterface) then
    Pointer(FObjectHasInterface) := nil;
end;

destructor TIntfComp.Destroy;
begin
  Pointer(FObjectHasInterface) := nil;
  inherited Destroy;
end;

end.
