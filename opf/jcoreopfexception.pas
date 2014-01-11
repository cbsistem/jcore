unit JCoreOPFException;

{$mode objfpc}{$H+}

interface

uses
  sysutils,
  JCoreClasses;

type

  { EJCoreOPF }

  EJCoreOPF = class(EJCoreException)
  end;

  { EJCoreOPFDriverNotFound }

  EJCoreOPFDriverNotFound = class(EJCoreOPF)
  public
    constructor Create(const ADriverName: string);
  end;

  { EJCoreOPFUndefinedDriver }

  EJCoreOPFUndefinedDriver = class(EJCoreOPF)
  public
    constructor Create;
  end;

  { EJCoreOPFPersistentIDFieldNotFound }

  EJCoreOPFPersistentIDFieldNotFound = class(EJCoreOPF)
  public
    constructor Create(const AClassName: string);
  end;

  { EJCoreOPFUnsupportedDriver }

  EJCoreOPFUnsupportedDriver = class(EJCoreOPF)
  public
    constructor Create(const AClassName: string);
  end;

  { EJCoreOPFEmptyResultSet }

  EJCoreOPFEmptyResultSet = class(EJCoreOPF)
  public
    constructor Create(const AExpectedSize: Integer);
  end;

  { EJCoreOPFUnexpectedResultSetSize }

  EJCoreOPFUnexpectedResultSetSize = class(EJCoreOPF)
  public
    constructor Create(const AExpectedSize, AActualSize: Integer);
  end;

  { EJCoreOPFMappingNotFound }

  EJCoreOPFMappingNotFound = class(EJCoreOPF)
  public
    constructor Create(const AEntityClassName: string);
  end;

  { EJCoreOPFCannotAssignOIDPersistent }

  EJCoreOPFCannotAssignOIDPersistent = class(EJCoreOPF)
  public
    constructor Create;
  end;

implementation

{ EJCoreOPFDriverNotFound }

constructor EJCoreOPFDriverNotFound.Create(const ADriverName: string);
begin
end;

{ EJCoreOPFUndefinedDriver }

constructor EJCoreOPFUndefinedDriver.Create;
begin
end;

{ EJCoreOPFPersistentIDFieldNotFound }

constructor EJCoreOPFPersistentIDFieldNotFound.Create(const AClassName: string);
begin
end;

{ EJCoreOPFUnsupportedDriver }

constructor EJCoreOPFUnsupportedDriver.Create(const AClassName: string);
begin
end;

{ EJCoreOPFEmptyResultSet }

constructor EJCoreOPFEmptyResultSet.Create(const AExpectedSize: Integer);
begin
end;

{ EJCoreOPFUnexpectedResultSetSize }

constructor EJCoreOPFUnexpectedResultSetSize.Create(const AExpectedSize,
  AActualSize: Integer);
begin
end;

{ EJCoreOPFMappingNotFound }

constructor EJCoreOPFMappingNotFound.Create(const AEntityClassName: string);
begin
end;

{ EJCoreOPFCannotAssignOIDPersistent }

constructor EJCoreOPFCannotAssignOIDPersistent.Create;
begin
end;

end.
