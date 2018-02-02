unit IntfComp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs;

type

  // define the Interface
  ITestInterface =  interface
      function OnlyDummy: integer;
    end;

  { TIntfComp }

  TIntfComp = class(TComponent)
  private
    FObjectHasInterface: ITestInterface;
    function GetObjectHasInterface: ITestInterface;
    procedure SetObjectHasInterface(AValue: ITestInterface);
  protected

  public

  published
    property ObjectHasInterface: ITestInterface read GetObjectHasInterface write SetObjectHasInterface;
  end;

  { TCompHasIntf }

  TCompHasIntf = class(TComponent, ITestInterface)
  private
  protected

  public
    function OnlyDummy: integer;

  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ShowBug',[TIntfComp,TCompHasIntf]);
end;

{ TCompHasIntf }

function TCompHasIntf.OnlyDummy: integer;
begin
  // Only a Dummy :-)
  Result:= 0;
end;

{ TIntfComp }

function TIntfComp.GetObjectHasInterface: ITestInterface;
begin
  Result:= FObjectHasInterface;
end;

procedure TIntfComp.SetObjectHasInterface(AValue: ITestInterface);
begin
  FObjectHasInterface:= AValue;
end;

end.
