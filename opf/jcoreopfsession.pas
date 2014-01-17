(*
  JCore, OPF Session Interface
  Copyright (C) 2014 Joao Morais

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit JCoreOPFSession;

{$I jcore.inc}

interface

uses
  JCoreOPFPID,
  JCoreOPFDriver,
  JCoreOPFMapping;

type

  IJCoreOPFSessionManager = interface
    function GetMappingClassList: TJCoreOPFMappingClassList;
    property MappingClassList: TJCoreOPFMappingClassList read GetMappingClassList;
  end;

  IJCoreOPFSession = interface(IInterface)
    function Retrieve(const AClass: TClass; const AOID: string): TObject;
    procedure Store(const AObject: TObject);
  end;

  { TJCoreOPFSession }

  TJCoreOPFSession = class(TInterfacedObject, IJCoreOPFSession, IJCoreOPFMapper)
  private
    FDriver: TJCoreOPFDriver;
    FMappingList: TJCoreOPFMappingList;
    FSessionManager: IJCoreOPFSessionManager;
    function CreateMapping(const AMappingClass: TJCoreOPFMappingClass): TJCoreOPFMapping;
  protected
    function AcquireMapping(const AClass: TClass): TJCoreOPFMapping;
    procedure StorePID(const APID: IJCoreOPFPID);
    property SessionManager: IJCoreOPFSessionManager read FSessionManager;
  public
    constructor Create(const ASessionManager: IJCoreOPFSessionManager; const ADriver: TJCoreOPFDriver);
    destructor Destroy; override;
    function Retrieve(const AClass: TClass; const AOID: string): TObject;
    procedure Store(const AEntity: TObject);
  end;

implementation

uses
  sysutils,
  JCoreOPFException;

{ TJCoreOPFSession }

function TJCoreOPFSession.CreateMapping(const AMappingClass: TJCoreOPFMappingClass): TJCoreOPFMapping;
begin
  Result := AMappingClass.Create(Self, FDriver);
  try
    FMappingList.Add(Result);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function TJCoreOPFSession.AcquireMapping(const AClass: TClass): TJCoreOPFMapping;
var
  VMappingClass: TJCoreOPFMappingClass;
begin
  for Result in FMappingList do
    if Result.Apply(AClass) then
      Exit;
  for VMappingClass in SessionManager.MappingClassList do
    if VMappingClass.Apply(AClass) then
    begin
      Result := CreateMapping(VMappingClass);
      Exit;
    end;
  raise EJCoreOPFMappingNotFound.Create(AClass.ClassName);
end;

procedure TJCoreOPFSession.StorePID(const APID: IJCoreOPFPID);
begin
  AcquireMapping(APID.Entity.ClassType).Store(APID);
end;

constructor TJCoreOPFSession.Create(const ASessionManager: IJCoreOPFSessionManager; const ADriver: TJCoreOPFDriver);
begin
  inherited Create;
  FSessionManager := ASessionManager;
  FDriver := ADriver;
  FMappingList := TJCoreOPFMappingList.Create(True);
end;

destructor TJCoreOPFSession.Destroy;
begin
  FreeAndNil(FDriver);
  FreeAndNil(FMappingList);
  inherited Destroy;
end;

function TJCoreOPFSession.Retrieve(const AClass: TClass; const AOID: string): TObject;
begin
  Result := AcquireMapping(AClass).Retrieve(AClass, AOID);
end;

procedure TJCoreOPFSession.Store(const AEntity: TObject);
begin
  { TODO : User defined PID class }
  StorePID(TJCoreOPFPID.AcquirePID(AEntity));
end;

end.

