unit uOITest;

{$mode objfpc}{$H+}

interface

// A lot of Info is here http://wiki.lazarus.freepascal.org/Extending_the_IDE
//
// Insert of PropEdits is needed for InitPropEdits. This initialize the
//   standard PropertyEditors

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  PropEdits, ObjectInspector, PropEditUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    BuCreate: TButton;
    BuFree: TButton;
    procedure BuCreateClick(Sender: TObject);
    procedure BuFreeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    DUT: TObjectInspectorDlg;
    PerList: TPersistentSelectionList;
    ThePropertyEditorHook: TPropertyEditorHook;
    // Forms and components for the Test
    ATestForm : TForm;
    ATestPanel : TPanel;
    ATestPanelSub : TPanel;
    ATestPanelSubSub : TPanel;

    procedure FreeUsedObjects;
  public

  end;

var
  Form1: TForm1;

implementation


{$R *.lfm}

{ TForm1 }

procedure TForm1.BuCreateClick(Sender: TObject);
begin
  BuCreate.Enabled:= false;
  BuFree.Enabled:= not BuCreate.Enabled;

  DUT := TObjectInspectorDlg.Create(nil);
  DUT.Caption:= 'My ObjectInspector';

  // create the PropertyEditorHook (the interface to the properties)
  ThePropertyEditorHook:=TPropertyEditorHook.Create(DUT);
  DUT.PropertyEditorHook:=ThePropertyEditorHook;

  // Create components
  ATestForm :=  TForm.Create(nil);
  ATestForm.Name:= 'Main';
  // Create a Panel
  ATestPanel := TPanel.Create(ATestForm);
  ATestPanel.Parent:=ATestForm;
  ATestPanel.Name:='PanelA';
  ATestPanel.Caption:= 'Panel';
  // Create in the panel a panel (to see the chain)
  ATestPanelSub := TPanel.Create(ATestForm);
  ATestPanelSub.Parent := ATestPanel;
  ATestPanelSub.Name:= 'SubPanelA';
  ATestPanelSub.Caption:= 'Sub Panel';
  // Create in the panel a panel (to see the chain)
  ATestPanelSubSub := TPanel.Create(ATestForm);
  ATestPanelSubSub.Parent := ATestPanelSub;
  ATestPanelSubSub.Name:= 'SubSubPanelA';
  ATestPanelSubSub.Caption:= 'SubSub Panel';

  ThePropertyEditorHook.LookupRoot:=ATestForm;

  PerList:=TPersistentSelectionList.Create;
  PerList.Add(ATestForm);
  DUT.Selection:=PerList;
  PerList.Free;

  DUT.Show;
end;

procedure TForm1.BuFreeClick(Sender: TObject);
begin
  BuCreate.Enabled:=true;
  BuFree.Enabled:= not BuCreate.Enabled;
  FreeUsedObjects;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DUT:= nil;
  BuCreate.Enabled:= true;
  BuFree.Enabled:= not BuCreate.Enabled;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeUsedObjects;
end;

procedure TForm1.FreeUsedObjects;
begin
  if DUT <> nil then begin
    ATestForm.Free;
    FreeAndNil(DUT);
  end;
end;

end.

