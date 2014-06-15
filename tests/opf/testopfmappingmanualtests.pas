unit TestOPFMappingManualTests;

{$mode objfpc}{$H+}

interface

uses
  TestOPFConfig;

type

  { TTestOPFInsertManualMappingPlainTests }

  TTestOPFInsertManualMappingPlainTests = class(TTestOPFIPIDContactTestCase)
  published
    procedure Single;
    procedure EntityComposition;
    procedure EntityAggregation;
    procedure CollectionCompositionEmbedded;
    procedure CollectionAggregation;
    procedure CollectionAggregationChange;
  end;

  { TTestOPFUpdateManualMappingPlainTests }

  TTestOPFUpdateManualMappingPlainTests = class(TTestOPFIPIDContactTestCase)
  published
    procedure Single;
    procedure EntityAggregation;
    procedure CollectionCompositionEmbeddedAdd;
    procedure CollectionCompositionEmbeddedRemove;
    procedure CollectionAggregationAdd;
    procedure CollectionAggregationRemove;
    procedure CollectionAggregationRemoveAdd;
    procedure CollectionAggregationNoChange;
    procedure CollectionAggregationChange;
  end;

  { TTestOPFSelectManualMappingPlainTests }

  TTestOPFSelectManualMappingPlainTests = class(TTestOPFIPIDContactTestCase)
  published
    procedure Single;
    procedure EntityCompositionAggregation;
    procedure EntityAggregation;
    procedure SingleNullCompositions;
    procedure CollectionComposition;
    procedure CollectionAggregation;
  end;

  { TTestOPFDeleteOneManualMappingPlainTests }

  TTestOPFDeleteOneManualMappingPlainTests = class(TTestOPFIPIDContactTestCase)
  published
    procedure Single;
    procedure EntityComposition;
    procedure EntityAggregation;
    procedure CollectionCompositionOne;
    procedure CollectionAggregationOne;
    procedure CollectionCompositionMany;
    procedure CollectionAggregationMany;
  end;

  { TTestOPFDeleteArrayManualMappingPlainTests }

  TTestOPFDeleteArrayManualMappingPlainTests = class(TTestOPFIPIDContactTestCase)
  published
    procedure Single;
    procedure EntityComposition;
    procedure EntityAggregation;
    procedure CollectionComposition;
    procedure CollectionAggregation;
  end;

  { TTestOPFInsertManualMappingInheritanceTests }

  TTestOPFInsertManualMappingInheritanceTests = class(TTestOPFProxyInvoiceTestCase)
  published
    procedure Single;
    procedure EntityAggregation;
    procedure CollectionComposition;
  end;

  { TTestOPFUpdateManualMappingInheritanceTests }

  TTestOPFUpdateManualMappingInheritanceTests = class(TTestOPFProxyInvoiceTestCase)
  published
    procedure SingleOneMappingChanged;
  end;

  { TTestOPFSelectManualMappingInheritanceTests }

  TTestOPFSelectManualMappingInheritanceTests = class(TTestOPFProxyInvoiceTestCase)
  published
    procedure SingleFromSubclass;
    procedure SingleFromSuperclass1;
    procedure SingleFromSuperclass2;
    procedure SingleFromSuperclass3;
  end;

  { TTestOPFDeleteManualMappingInheritanceTests }

  TTestOPFDeleteManualMappingInheritanceTests = class(TTestOPFProxyInvoiceTestCase)
  published
    procedure Single1;
    procedure Single2;
  end;

implementation

uses
  testregistry,
  sysutils,
  TestOPFModelContact,
  TestOPFModelInvoice,
  TestOPFMappingContact,
  TestOPFMappingInvoice;

{ TTestOPFInsertManualMappingPlainTests }

procedure TTestOPFInsertManualMappingPlainTests.Single;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'TheName';
    VPerson.Age := 15;
    Session.Store(VPerson);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteString TheName',
     'WriteInteger 15',
     'WriteNull',
     'WriteNull',
     'ExecSQL ' + CSQLINSERTPERSON]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFInsertManualMappingPlainTests.EntityComposition;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'name';
    VPerson.Age := 25;
    VPerson.Address := TTestIPIDAddress.Create;
    VPerson.Address.Street := 'route 66';
    Session.Store(VPerson);
    AssertNotNull('person pid', VPerson._PID);
    AssertEquals('person oid', '1', VPerson._PID.OID.AsString);
    AssertNotNull('address pid', VPerson.Address._PID);
    AssertEquals('address oid', '2', VPerson.Address._PID.OID.AsString);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteString name',
     'WriteInteger 25',
     'WriteInteger 2',
     'WriteString route 66',
     'WriteString ',
     'ExecSQL ' + CSQLINSERTADDRESS,
     'WriteInteger 2',
     'WriteNull',
     'ExecSQL ' + CSQLINSERTPERSON]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFInsertManualMappingPlainTests.EntityAggregation;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'SomeName';
    VPerson.Age := 25;
    VPerson.City := TTestIPIDCity.Create;
    VPerson.City.Name := 'CityName';
    Session.Store(VPerson);
    AssertNotNull('person pid', VPerson._PID);
    AssertEquals('person oid', '1', VPerson._PID.OID.AsString);
    AssertNotNull('city pid', VPerson.City._PID);
    AssertEquals('city oid', '2', VPerson.City._PID.OID.AsString);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteString SomeName',
     'WriteInteger 25',
     'WriteNull',
     'WriteInteger 2',
     'WriteString CityName',
     'ExecSQL ' + CSQLINSERTCITY,
     'WriteInteger 2',
     'ExecSQL ' + CSQLINSERTPERSON]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFInsertManualMappingPlainTests.CollectionCompositionEmbedded;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'thename';
    VPerson.Age := 10;
    VPerson.Phones.Add(TTestIPIDPhone.Create);
    VPerson.Phones[0].Number := '636-3626';
    VPerson.Phones.Add(TTestIPIDPhone.Create);
    VPerson.Phones[1].Number := '212-4321';
    Session.Store(VPerson);
    AssertNotNull('person pid', VPerson._PID);
    AssertEquals('person oid', '1', VPerson._PID.OID.AsString);
    AssertNotNull('phone0 pid', VPerson.Phones[0]._PID);
    AssertEquals('phone0 oid', '2', VPerson.Phones[0]._PID.OID.AsString);
    AssertNotNull('phone1 pid', VPerson.Phones[1]._PID);
    AssertEquals('phone1 oid', '3', VPerson.Phones[1]._PID.OID.AsString);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteString thename',
     'WriteInteger 10',
     'WriteNull',
     'WriteNull',
     'ExecSQL ' + CSQLINSERTPERSON,
     'WriteInteger 2',
     'WriteInteger 1',
     'WriteString 636-3626',
     'ExecSQL ' + CSQLINSERTPHONE,
     'WriteInteger 3',
     'WriteInteger 1',
     'WriteString 212-4321',
     'ExecSQL ' + CSQLINSERTPHONE]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFInsertManualMappingPlainTests.CollectionAggregation;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'SomeName';
    VPerson.Languages.Add(TTestIPIDLanguage.Create('English'));
    VPerson.Languages.Add(TTestIPIDLanguage.Create('Spanish'));
    Session.Store(VPerson);
    AssertNotNull('person pid', VPerson._PID);
    AssertEquals('person oid', '1', VPerson._PID.OID.AsString);
    AssertNotNull('lang0 pid', VPerson.Languages[0]._PID);
    AssertEquals('lang0 oid', '2', VPerson.Languages[0]._PID.OID.AsString);
    AssertNotNull('lang1 pid', VPerson.Languages[1]._PID);
    AssertEquals('lang1 oid', '3', VPerson.Languages[1]._PID.OID.AsString);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteString SomeName',
     'WriteInteger 0',
     'WriteNull',
     'WriteNull',
     'ExecSQL ' + CSQLINSERTPERSON,
     'WriteInteger 2',
     'WriteString English',
     'ExecSQL ' + CSQLINSERTLANG,
     'WriteInteger 3',
     'WriteString Spanish',
     'ExecSQL ' + CSQLINSERTLANG,
     'WriteInteger 1',
     'WriteInteger 2',
     'ExecSQL ' + CSQLINSERTPERSON_LANG,
     'WriteInteger 1',
     'WriteInteger 3',
     'ExecSQL ' + CSQLINSERTPERSON_LANG]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFInsertManualMappingPlainTests.CollectionAggregationChange;
var
  VPerson: TTestIPIDPerson;
  VLang: TTestIPIDLanguage;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VLang := TTestIPIDLanguage.Create('portuguese');
    try
      Session.Store(VLang);
      AssertNotNull('lang pid', VLang._PID);
      AssertEquals('lang oid', '1', VLang._PID.OID.AsString);
      VPerson.Name := 'name';
      VPerson.Languages.Add(VLang);
      VLang.AddRef;
      VLang.Name := 'german';
      TTestSQLDriver.Commands.Clear;
      Session.Store(VPerson);
      AssertNotNull('person pid', VPerson._PID);
      AssertEquals('person oid', '2', VPerson._PID.OID.AsString);
      AssertSQLDriverCommands([
       'WriteInteger 2',
       'WriteString name',
       'WriteInteger 0',
       'WriteNull',
       'WriteNull',
       'ExecSQL ' + CSQLINSERTPERSON,
       'WriteInteger 2',
       'WriteInteger 1',
       'ExecSQL ' + CSQLINSERTPERSON_LANG]);
    finally
      FreeAndNil(VLang);
    end;
  finally
    FreeAndNil(VPerson);
  end;
end;

{ TTestOPFUpdateManualMappingPlainTests }

procedure TTestOPFUpdateManualMappingPlainTests.Single;
var
  VCity: TTestIPIDCity;
begin
  VCity := TTestIPIDCity.Create;
  try
    VCity.Name := 'TheName';
    Session.Store(VCity);
    TTestSQLDriver.Commands.Clear;
    VCity.Name := 'OtherName';
    Session.Store(VCity);
    AssertSQLDriverCommands([
     'WriteString OtherName',
     'WriteInteger 1',
     'ExecSQL ' + CSQLUPDATECITY]);
  finally
    FreeAndNil(VCity);
  end;
end;

procedure TTestOPFUpdateManualMappingPlainTests.EntityAggregation;
var
  VPerson: TTestIPIDPerson;
  VCity1: TTestIPIDCity;
  VCity2: TTestIPIDCity;
begin
  VPerson := TTestIPIDPerson.Create;
  VCity1 := TTestIPIDCity.Create;
  VCity2 := TTestIPIDCity.Create;
  try
    Session.Store(VCity1);
    AssertEquals('city1 id', '1', VCity1._PID.OID.AsString);
    Session.Store(VCity2);
    AssertEquals('city2 id', '2', VCity2._PID.OID.AsString);
    VPerson.Name := 'TheName';
    VPerson.Age := 18;
    VPerson.City := VCity1;
    VCity1.AddRef;
    Session.Store(VPerson);
    VPerson.City := VCity2;
    VCity2.AddRef;
    TTestSQLDriver.Commands.Clear;
    Session.Store(VPerson);
    AssertEquals('person id', '3', VPerson._PID.OID.AsString);
    AssertSQLDriverCommands([
     'WriteString TheName',
     'WriteInteger 18',
     'WriteNull',
     'WriteInteger 2',
     'WriteInteger 3',
     'ExecSQL ' + CSQLUPDATEPERSON]);
  finally
    FreeAndNil(VCity2);
    FreeAndNil(VCity1);
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFUpdateManualMappingPlainTests.CollectionCompositionEmbeddedAdd;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'somename';
    VPerson.Phones.Add(TTestIPIDPhone.Create);
    VPerson.Phones.Add(TTestIPIDPhone.Create);
    VPerson.Phones[0].Number := '123';
    VPerson.Phones[1].Number := '456';
    Session.Store(VPerson);
    TTestSQLDriver.Commands.Clear;
    VPerson.Phones[1].Number := '987';
    Session.Store(VPerson);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteString 987',
     'WriteInteger 3',
     'ExecSQL ' + CSQLUPDATEPHONE]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFUpdateManualMappingPlainTests.CollectionCompositionEmbeddedRemove;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'name';
    VPerson.Phones.Add(TTestIPIDPhone.Create);
    VPerson.Phones.Add(TTestIPIDPhone.Create);
    VPerson.Phones[0].Number := '123';
    VPerson.Phones[1].Number := '456';
    Session.Store(VPerson);
    TTestSQLDriver.Commands.Clear;
    VPerson.Phones.Delete(1);
    Session.Store(VPerson);
    AssertSQLDriverCommands([
     'WriteInteger 3',
     'ExecSQL ' + CSQLDELETEPHONE + '=?']);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFUpdateManualMappingPlainTests.CollectionAggregationAdd;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'somename';
    VPerson.Languages.Add(TTestIPIDLanguage.Create('german'));
    Session.Store(VPerson);
    VPerson.Languages.Add(TTestIPIDLanguage.Create('spanish'));
    TTestSQLDriver.Commands.Clear;
    Session.Store(VPerson);
    AssertSQLDriverCommands([
     'WriteInteger 3',
     'WriteString spanish',
     'ExecSQL ' + CSQLINSERTLANG,
     'WriteInteger 1',
     'WriteInteger 3',
     'ExecSQL ' + CSQLINSERTPERSON_LANG]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFUpdateManualMappingPlainTests.CollectionAggregationRemove;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'thename';
    VPerson.Languages.Add(TTestIPIDLanguage.Create('italian'));
    VPerson.Languages.Add(TTestIPIDLanguage.Create('portuguese'));
    Session.Store(VPerson);
    VPerson.Languages.Delete(0);
    TTestSQLDriver.Commands.Clear;
    Session.Store(VPerson);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteInteger 2',
     'ExecSQL ' + CSQLDELETEPERSON_LANG_IDs + '=?']);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFUpdateManualMappingPlainTests.CollectionAggregationRemoveAdd;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'aname';
    VPerson.Languages.Add(TTestIPIDLanguage.Create('English'));
    VPerson.Languages.Add(TTestIPIDLanguage.Create('Brazilian portuguese'));
    Session.Store(VPerson);
    VPerson.Languages.Delete(0);
    VPerson.Languages.Add(TTestIPIDLanguage.Create('Spanish'));
    TTestSQLDriver.Commands.Clear;
    Session.Store(VPerson);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteInteger 2',
     'ExecSQL ' + CSQLDELETEPERSON_LANG_IDs + '=?',
     'WriteInteger 4',
     'WriteString Spanish',
     'ExecSQL ' + CSQLINSERTLANG,
     'WriteInteger 1',
     'WriteInteger 4',
     'ExecSQL ' + CSQLINSERTPERSON_LANG]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFUpdateManualMappingPlainTests.CollectionAggregationNoChange;
var
  VPerson: TTestIPIDPerson;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'SomeName';
    VPerson.Languages.Add(TTestIPIDLanguage.Create('English'));
    Session.Store(VPerson);
    TTestSQLDriver.Commands.Clear;
    VPerson.Name := 'anothername';
    Session.Store(VPerson);
    AssertSQLDriverCommands([
     'WriteString anothername',
     'WriteInteger 0',
     'WriteNull',
     'WriteNull',
     'WriteInteger 1',
     'ExecSQL ' + CSQLUPDATEPERSON]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFUpdateManualMappingPlainTests.CollectionAggregationChange;
var
  VPerson: TTestIPIDPerson;
  VLang: TTestIPIDLanguage;
begin
  VPerson := TTestIPIDPerson.Create;
  try
    VPerson.Name := 'name';
    VLang := TTestIPIDLanguage.Create('english');
    VPerson.Languages.Add(VLang);
    Session.Store(VPerson);
    TTestSQLDriver.Commands.Clear;
    VLang.Name := 'italian';
    Session.Store(VPerson);
    AssertSQLDriverCommands([]);
  finally
    FreeAndNil(VPerson);
  end;
end;

{ TTestOPFSelectManualMappingPlainTests }

procedure TTestOPFSelectManualMappingPlainTests.Single;
var
  VCity: TTestIPIDCity;
begin
  // Single
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('thecityname');

  VCity := Session.Retrieve(TTestIPIDCity, '15') as TTestIPIDCity;
  try
    AssertEquals(0, TTestSQLDriver.Data.Count);
    AssertEquals(0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertSQLDriverCommands([
     'WriteInteger 15',
     'ExecSQL ' + CSQLSELECTCITY]);
    AssertNotNull(VCity);
    AssertNotNull(VCity._PID);
    AssertEquals('15', VCity._PID.OID.AsString);
    AssertEquals('thecityname', VCity.Name);
  finally
    FreeAndNil(VCity);
  end;
end;

procedure TTestOPFSelectManualMappingPlainTests.EntityCompositionAggregation;
var
  VPerson: TTestIPIDPerson;
  VAddress: TTestIPIDAddress;
  VCity: TTestIPIDCity;
begin
  // person
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('name');
  TTestSQLDriver.Data.Add('3');

  TTestSQLDriver.Data.Add('18');
  // address
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('thestreet');
  TTestSQLDriver.Data.Add('01000-001');

  TTestSQLDriver.Data.Add('11');
  // Single
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('thecity');

  VPerson := Session.Retrieve(TTestIPIDPerson, '2') as TTestIPIDPerson;
  try
    AssertEquals('data count', 0, TTestSQLDriver.Data.Count);
    AssertEquals('exprs count', 0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertSQLDriverCommands([
     'WriteInteger 2',
     'ExecSQL ' + CSQLSELECTPERSON,
     'WriteInteger 18',
     'ExecSQL ' + CSQLSELECTADDRESS,
     'WriteInteger 11',
     'ExecSQL ' + CSQLSELECTCITY,
     'WriteInteger 2',
     'ExecSQL ' + CSQLSELECTPERSON_PHONES,
     'WriteInteger 2',
     'ExecSQL ' + CSQLSELECTPERSON_LANG]);
    AssertNotNull('person', VPerson);
    AssertNotNull('person pid', VPerson._PID);
    AssertEquals('person oid', '2', VPerson._PID.OID.AsString);
    AssertEquals('person name', 'name', VPerson.Name);
    AssertEquals('person age', 3, VPerson.Age);
    VAddress := VPerson.Address;
    AssertNotNull('address', VAddress);
    AssertNotNull('address pid', VAddress._PID);
    AssertEquals('address oid', '18', VAddress._PID.OID.AsString);
    AssertEquals('address street', 'thestreet', VAddress.Street);
    AssertEquals('address zipcode', '01000-001', VAddress.ZipCode);
    VCity := VPerson.City;
    AssertNotNull('city', VCity);
    AssertNotNull('city pid', VCity._PID);
    AssertEquals('city oid', '11', VCity._PID.OID.AsString);
    AssertEquals('city name', 'thecity', VCity.Name);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFSelectManualMappingPlainTests.EntityAggregation;
var
  VPerson: TTestIPIDPerson;
  VCity: TTestIPIDCity;
begin
  // person
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('thepersonname');
  TTestSQLDriver.Data.Add('30');
  TTestSQLDriver.Data.Add('null');

  TTestSQLDriver.Data.Add('5');
  // Single
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('nameofcity');

  VPerson := Session.Retrieve(TTestIPIDPerson, '8') as TTestIPIDPerson;
  try
    AssertEquals('data count', 0, TTestSQLDriver.Data.Count);
    AssertEquals('exprs count', 0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertSQLDriverCommands([
     'WriteInteger 8',
     'ExecSQL ' + CSQLSELECTPERSON,
     'WriteInteger 5',
     'ExecSQL ' + CSQLSELECTCITY,
     'WriteInteger 8',
     'ExecSQL ' + CSQLSELECTPERSON_PHONES,
     'WriteInteger 8',
     'ExecSQL ' + CSQLSELECTPERSON_LANG]);
    AssertNotNull('person', VPerson);
    AssertNotNull('person pid', VPerson._PID);
    AssertEquals('person oid', '8', VPerson._PID.OID.AsString);
    AssertEquals('person name', 'thepersonname', VPerson.Name);
    AssertEquals('person age', 30, VPerson.Age);
    VCity := VPerson.City;
    AssertNotNull('city', VCity);
    AssertNotNull('city pid', VCity._PID);
    AssertEquals('city oid', '5', VCity._PID.OID.AsString);
    AssertEquals('city name', 'nameofcity', VCity.Name);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFSelectManualMappingPlainTests.SingleNullCompositions;
var
  VPerson: TTestIPIDPerson;
begin
  // person
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('personname');
  TTestSQLDriver.Data.Add('22');
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('null');

  VPerson := Session.Retrieve(TTestIPIDPerson, '18') as TTestIPIDPerson;
  try
    AssertEquals(0, TTestSQLDriver.Data.Count);
    AssertEquals(0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertSQLDriverCommands([
     'WriteInteger 18',
     'ExecSQL ' + CSQLSELECTPERSON,
     'WriteInteger 18',
     'ExecSQL ' + CSQLSELECTPERSON_PHONES,
     'WriteInteger 18',
     'ExecSQL ' + CSQLSELECTPERSON_LANG]);
    AssertNotNull(VPerson);
    AssertNotNull(VPerson._PID);
    AssertEquals('18', VPerson._PID.OID.AsString);
    AssertEquals('personname', VPerson.Name);
    AssertEquals(22, VPerson.Age);
    AssertNull(VPerson.City);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFSelectManualMappingPlainTests.CollectionComposition;
var
  VPerson: TTestIPIDPerson;
begin
  // person
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('aname');
  TTestSQLDriver.Data.Add('5');
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('null');

  // two phone objects
  TTestSQLDriver.ExpectedResultsets.Add(2);
  TTestSQLDriver.Data.Add('11');
  TTestSQLDriver.Data.Add('212');
  TTestSQLDriver.Data.Add('12');
  TTestSQLDriver.Data.Add('555');

  VPerson := Session.Retrieve(TTestIPIDPerson, '9') as TTestIPIDPerson;
  try
    AssertEquals('data count', 0, TTestSQLDriver.Data.Count);
    AssertEquals('exprs count', 0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertSQLDriverCommands([
     'WriteInteger 9',
     'ExecSQL ' + CSQLSELECTPERSON,
     'WriteInteger 9',
     'ExecSQL ' + CSQLSELECTPERSON_PHONES,
     'WriteInteger 9',
     'ExecSQL ' + CSQLSELECTPERSON_LANG]);
    AssertNotNull('person', VPerson);
    AssertNotNull('person pid', VPerson._PID);
    AssertEquals('person oid', '9', VPerson._PID.OID.AsString);
    AssertEquals('person name', 'aname', VPerson.Name);
    AssertEquals('person age', 5, VPerson.Age);
    AssertNull('city', VPerson.City);
    AssertEquals('phone cnt', 2, VPerson.Phones.Count);
    AssertNotNull('phone0 pid', VPerson.Phones[0]._PID);
    AssertEquals('phone0 oid', '11', VPerson.Phones[0]._PID.OID.AsString);
    AssertEquals('phone0 number', '212', VPerson.Phones[0].Number);
    AssertNotNull('phone1 pid', VPerson.Phones[1]._PID);
    AssertEquals('phone1 oid', '12', VPerson.Phones[1]._PID.OID.AsString);
    AssertEquals('phone1 number', '555', VPerson.Phones[1].Number);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFSelectManualMappingPlainTests.CollectionAggregation;
var
  VPerson: TTestIPIDPerson;
begin
  // person
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('personname');
  TTestSQLDriver.Data.Add('0');
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('null');

  // phones
  TTestSQLDriver.ExpectedResultsets.Add(0);

  // language
  TTestSQLDriver.ExpectedResultsets.Add(2);
  TTestSQLDriver.Data.Add('3');
  TTestSQLDriver.Data.Add('spanish');
  TTestSQLDriver.Data.Add('8');
  TTestSQLDriver.Data.Add('german');

  // let's go
  VPerson := Session.Retrieve(TTestIPIDPerson, '5') as TTestIPIDPerson;
  try
    AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
    AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertSQLDriverCommands([
     'WriteInteger 5',
     'ExecSQL ' + CSQLSELECTPERSON,
     'WriteInteger 5',
     'ExecSQL ' + CSQLSELECTPERSON_PHONES,
     'WriteInteger 5',
     'ExecSQL ' + CSQLSELECTPERSON_LANG]);
    AssertNotNull('person', VPerson);
    AssertNotNull('person pid', VPerson._PID);
    AssertEquals('person oid', '5', VPerson._PID.OID.AsString);
    AssertEquals('person name', 'personname', VPerson.Name);
    AssertEquals('person age', 0, VPerson.Age);
    AssertNull('city', VPerson.City);
    AssertEquals('phone cnt', 0, VPerson.Phones.Count);
    AssertEquals('lang cnt', 2, VPerson.Languages.Count);
    AssertNotNull('lang0 pid', VPerson.Languages[0]);
    AssertEquals('lang0 oid', '3', VPerson.Languages[0]._PID.OID.AsString);
    AssertEquals('lang0 name', 'spanish', VPerson.Languages[0].Name);
    AssertNotNull('lang1 pid', VPerson.Languages[1]);
    AssertEquals('lang1 oid', '8', VPerson.Languages[1]._PID.OID.AsString);
    AssertEquals('lang1 name', 'german', VPerson.Languages[1].Name);
  finally
    FreeAndNil(VPerson);
  end;
end;

{ TTestOPFDeleteOneManualMappingPlainTests }

procedure TTestOPFDeleteOneManualMappingPlainTests.Single;
begin
  Session.Dispose(TTestIPIDCity, ['5']);
  AssertSQLDriverCommands([
   'WriteInteger 5',
   'ExecSQL ' + CSQLDELETECITY + '=?']);
end;

procedure TTestOPFDeleteOneManualMappingPlainTests.EntityComposition;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('4');

  Session.Dispose(TTestIPIDPerson, ['12']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 12',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + '=?',
   'WriteInteger 12',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + '=?',
   'WriteInteger 12',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + '=?',
   'WriteInteger 4',
   'ExecSQL ' + CSQLDELETEADDRESS + '=?',
   'WriteInteger 12',
   'ExecSQL ' + CSQLDELETEPERSON + '=?']);
end;

procedure TTestOPFDeleteOneManualMappingPlainTests.EntityAggregation;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('null');

  Session.Dispose(TTestIPIDPerson, ['3']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 3',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + '=?',
   'WriteInteger 3',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + '=?',
   'WriteInteger 3',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + '=?',
   'WriteInteger 3',
   'ExecSQL ' + CSQLDELETEPERSON + '=?']);
end;

procedure TTestOPFDeleteOneManualMappingPlainTests.CollectionCompositionOne;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('15');
  // Delete Phones
  TTestSQLDriver.ExpectedResultsets.Add(1);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('null');

  Session.Dispose(TTestIPIDPerson, ['7']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 7',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + '=?',
   'WriteInteger 15',
   'ExecSQL ' + CSQLDELETEPHONE + '=?',
   'WriteInteger 7',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + '=?',
   'WriteInteger 7',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + '=?',
   'WriteInteger 7',
   'ExecSQL ' + CSQLDELETEPERSON + '=?']);
end;

procedure TTestOPFDeleteOneManualMappingPlainTests.CollectionAggregationOne;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(1);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('null');

  Session.Dispose(TTestIPIDPerson, ['6']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 6',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + '=?',
   'WriteInteger 6',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + '=?',
   'WriteInteger 6',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + '=?',
   'WriteInteger 6',
   'ExecSQL ' + CSQLDELETEPERSON + '=?']);
end;

procedure TTestOPFDeleteOneManualMappingPlainTests.CollectionCompositionMany;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(2);
  TTestSQLDriver.Data.Add('17');
  TTestSQLDriver.Data.Add('18');
  // Delete Phones
  TTestSQLDriver.ExpectedResultsets.Add(2);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('null');

  Session.Dispose(TTestIPIDPerson, ['2']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 2',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + '=?',
   'WriteInteger 17',
   'WriteInteger 18',
   'ExecSQL ' + CSQLDELETEPHONE + ' IN (?,?)',
   'WriteInteger 2',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + '=?',
   'WriteInteger 2',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + '=?',
   'WriteInteger 2',
   'ExecSQL ' + CSQLDELETEPERSON + '=?']);
end;

procedure TTestOPFDeleteOneManualMappingPlainTests.CollectionAggregationMany;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(2);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('null');

  Session.Dispose(TTestIPIDPerson, ['5']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 5',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + '=?',
   'WriteInteger 5',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + '=?',
   'WriteInteger 5',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + '=?',
   'WriteInteger 5',
   'ExecSQL ' + CSQLDELETEPERSON + '=?']);
end;

{ TTestOPFDeleteArrayManualMappingPlainTests }

procedure TTestOPFDeleteArrayManualMappingPlainTests.Single;
begin
  Session.Dispose(TTestIPIDCity, ['13', '22']);
  AssertSQLDriverCommands([
   'WriteInteger 13',
   'WriteInteger 22',
   'ExecSQL ' + CSQLDELETECITY + ' IN (?,?)']);
end;

procedure TTestOPFDeleteArrayManualMappingPlainTests.EntityComposition;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(3);
  TTestSQLDriver.Data.Add('10');
  TTestSQLDriver.Data.Add('13');
  TTestSQLDriver.Data.Add('null');

  Session.Dispose(TTestIPIDPerson, ['9', '11', '16']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 9',
   'WriteInteger 11',
   'WriteInteger 16',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + ' IN (?,?,?)',
   'WriteInteger 9',
   'WriteInteger 11',
   'WriteInteger 16',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + ' IN (?,?,?)',
   'WriteInteger 9',
   'WriteInteger 11',
   'WriteInteger 16',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + ' IN (?,?,?)',
   'WriteInteger 10',
   'WriteInteger 13',
   'ExecSQL ' + CSQLDELETEADDRESS + ' IN (?,?)',
   'WriteInteger 9',
   'WriteInteger 11',
   'WriteInteger 16',
   'ExecSQL ' + CSQLDELETEPERSON + ' IN (?,?,?)']);
end;

procedure TTestOPFDeleteArrayManualMappingPlainTests.EntityAggregation;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(3);
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('null');

  Session.Dispose(TTestIPIDPerson, ['21', '22', '23']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 21',
   'WriteInteger 22',
   'WriteInteger 23',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + ' IN (?,?,?)',
   'WriteInteger 21',
   'WriteInteger 22',
   'WriteInteger 23',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + ' IN (?,?,?)',
   'WriteInteger 21',
   'WriteInteger 22',
   'WriteInteger 23',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + ' IN (?,?,?)',
   'WriteInteger 21',
   'WriteInteger 22',
   'WriteInteger 23',
   'ExecSQL ' + CSQLDELETEPERSON + ' IN (?,?,?)']);
end;

procedure TTestOPFDeleteArrayManualMappingPlainTests.CollectionComposition;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(2);
  TTestSQLDriver.Data.Add('11');
  TTestSQLDriver.Data.Add('13');
  // Delete Phones
  TTestSQLDriver.ExpectedResultsets.Add(7);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(3);
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('null');

  Session.Dispose(TTestIPIDPerson, ['10', '12', '14']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 10',
   'WriteInteger 12',
   'WriteInteger 14',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + ' IN (?,?,?)',
   'WriteInteger 11',
   'WriteInteger 13',
   'ExecSQL ' + CSQLDELETEPHONE + ' IN (?,?)',
   'WriteInteger 10',
   'WriteInteger 12',
   'WriteInteger 14',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + ' IN (?,?,?)',
   'WriteInteger 10',
   'WriteInteger 12',
   'WriteInteger 14',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + ' IN (?,?,?)',
   'WriteInteger 10',
   'WriteInteger 12',
   'WriteInteger 14',
   'ExecSQL ' + CSQLDELETEPERSON + ' IN (?,?,?)']);
end;

procedure TTestOPFDeleteArrayManualMappingPlainTests.CollectionAggregation;
begin
  // Phones IDs
  TTestSQLDriver.ExpectedResultsets.Add(0);
  // Languages IDs
  TTestSQLDriver.ExpectedResultsets.Add(2);
  // Address ID
  TTestSQLDriver.ExpectedResultsets.Add(2);
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('null');

  Session.Dispose(TTestIPIDPerson, ['15', '18']);

  AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
  AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
  AssertSQLDriverCommands([
   'WriteInteger 15',
   'WriteInteger 18',
   'ExecSQL ' + CSQLSELECTPERSON_PHONES_FOR_DELETE + ' IN (?,?)',
   'WriteInteger 15',
   'WriteInteger 18',
   'ExecSQL ' + CSQLDELETEPERSON_LANG + ' IN (?,?)',
   'WriteInteger 15',
   'WriteInteger 18',
   'ExecSQL ' + CSQLSELECTPERSON_FOR_DELETE + ' IN (?,?)',
   'WriteInteger 15',
   'WriteInteger 18',
   'ExecSQL ' + CSQLDELETEPERSON + ' IN (?,?)']);
end;

{ TTestOPFInsertManualMappingInheritanceTests }

procedure TTestOPFInsertManualMappingInheritanceTests.Single;
var
  VPerson: TPerson;
begin
  VPerson := TPerson.Create;
  try
    VPerson.Name := 'Jack';
    VPerson.Nick := 'J';
    Session.Store(VPerson);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteString Jack',
     'ExecSQL ' + CSQLINSERTINVOICECLIENT,
     'WriteInteger 1',
     'WriteString J',
     'ExecSQL ' + CSQLINSERTINVOICEPERSON]);
  finally
    FreeAndNil(VPerson);
  end;
end;

procedure TTestOPFInsertManualMappingInheritanceTests.EntityAggregation;
var
  VInvoice: TInvoice;
  VPerson: TPerson;
begin
  VInvoice := TInvoice.Create;
  VPerson := TPerson.Create;
  try
    VPerson.Name := 'aclient';
    VPerson.Nick := 'cli';
    VInvoice.Client := VPerson;
    VPerson.AddRef;
    VInvoice.Date := '01/01';
    Session.Store(VInvoice);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'WriteInteger 2',
     'WriteString aclient',
     'ExecSQL ' + CSQLINSERTINVOICECLIENT,
     'WriteInteger 2',
     'WriteString cli',
     'ExecSQL ' + CSQLINSERTINVOICEPERSON,
     'WriteInteger 2',
     'WriteString 01/01',
     'ExecSQL ' + CSQLINSERTINVOICEINVOICE]);
  finally
    FreeAndNil(VPerson);
    FreeAndNil(VInvoice);
  end;
end;

procedure TTestOPFInsertManualMappingInheritanceTests.CollectionComposition;
var
  VProduct: TProduct;
  VInvoice: TInvoice;
  VItemProduct: TInvoiceItemProduct;
  VItemService: TInvoiceItemService;
begin
  VInvoice := TInvoice.Create;
  try
    VProduct := TProduct.Create;
    try
      VProduct.Name := 'prod';
      Session.Store(VProduct);  // ID 1
      VItemProduct := TInvoiceItemProduct.Create;
      VInvoice.Items.Add(VItemProduct);  // ID 3
      VItemProduct.Qty := 15;
      VItemProduct.Product := VProduct;
      VItemProduct.Total := 28;
      VProduct.AddRef;

      VItemService := TInvoiceItemService.Create;
      VInvoice.Items.Add(VItemService);  // ID 4
      VItemService.Description := 'srv description';
      VItemService.Total := 90;

      VInvoice.Date := '05/01';

      TTestSQLDriver.Commands.Clear;
      Session.Store(VInvoice);  // ID 2
      AssertSQLDriverCommands([
       'WriteInteger 2',
       'WriteNull',
       'WriteString 05/01',
       'ExecSQL INSERT INTO INVOICE (ID,CLIENT,DATE) VALUES (?,?,?)',
       'WriteInteger 3',
       'WriteInteger 28',
       'ExecSQL INSERT INTO INVOICEITEM (ID,TOTAL) VALUES (?,?)',
       'WriteInteger 3',
       'WriteInteger 15',
       'WriteInteger 1',
       'ExecSQL INSERT INTO INVOICEITEMPRODUCT (ID,QTY,PRODUCT) VALUES (?,?,?)',
       'WriteInteger 4',
       'WriteInteger 90',
       'ExecSQL INSERT INTO INVOICEITEM (ID,TOTAL) VALUES (?,?)',
       'WriteInteger 4',
       'WriteString srv description',
       'ExecSQL INSERT INTO INVOICEITEMSERVICE (ID,DESCRIPTION) VALUES (?,?)']);
    finally
      FreeAndNil(VProduct);
    end;
  finally
    FreeAndNil(VInvoice);
  end;
end;

{ TTestOPFUpdateManualMappingInheritanceTests }

procedure TTestOPFUpdateManualMappingInheritanceTests.SingleOneMappingChanged;
var
  VCompany: TCompany;
begin
  VCompany := TCompany.Create;
  try
    VCompany.Name := 'company co';
    VCompany.ContactName := 'joe';
    Session.Store(VCompany);
    TTestSQLDriver.Commands.Clear;
    VCompany.Name := 'comp corp';
    Session.Store(VCompany);
    AssertSQLDriverCommands([
     'WriteString comp corp',
     'WriteInteger 1',
     'ExecSQL UPDATE CLIENT SET NAME=? WHERE ID=?']);
    TTestSQLDriver.Commands.Clear;
    VCompany.ContactName := 'wil';
    Session.Store(VCompany);
    AssertSQLDriverCommands([
     'WriteString wil',
     'WriteInteger 1',
     'ExecSQL UPDATE COMPANY SET CONTACTNAME=? WHERE ID=?']);
  finally
    FreeAndNil(VCompany);
  end;
end;

{ TTestOPFSelectManualMappingInheritanceTests }

procedure TTestOPFSelectManualMappingInheritanceTests.SingleFromSubclass;
var
  VCompany: TCompany;
begin
  // company
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('company corp');
  TTestSQLDriver.Data.Add('jack');

  VCompany := Session.Retrieve(TCompany, '10') as TCompany;
  try
    AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
    AssertNotNull('company not null', VCompany);
    AssertEquals('company name', 'company corp', VCompany.Name);
    AssertEquals('company contact', 'jack', VCompany.ContactName);
    AssertSQLDriverCommands([
     'WriteInteger 10',
     'ExecSQL SELECT T_1.NAME,T.CONTACTNAME FROM COMPANY T INNER JOIN CLIENT T_1 ON T.ID=T_1.ID WHERE T.ID=?']);
  finally
    FreeAndNil(VCompany);
  end;
end;

procedure TTestOPFSelectManualMappingInheritanceTests.SingleFromSuperclass1;
var
  VClient: TClient;
  VPerson: TPerson;
begin
  // client
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('7');
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('johnson');

  // person
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('joe');

  VClient := Session.Retrieve(TClient, '7') as TClient;
  try
    AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
    AssertNotNull('client not null', VClient);
    AssertTrue('client is person', VClient is TPerson);
    VPerson := VClient as TPerson;
    AssertEquals('person name', 'johnson', VPerson.Name);
    AssertEquals('person nick', 'joe', VPerson.Nick);
    AssertSQLDriverCommands([
     'WriteInteger 7',
     'ExecSQL SELECT T_1.ID,T_2.ID,T.NAME FROM CLIENT T LEFT OUTER JOIN PERSON T_1 ON T.ID=T_1.ID LEFT OUTER JOIN COMPANY T_2 ON T.ID=T_2.ID WHERE T.ID=?',
     'WriteInteger 7',
     'ExecSQL SELECT NICK FROM PERSON WHERE ID=?']);
  finally
    FreeAndNil(VClient);
  end;
end;

procedure TTestOPFSelectManualMappingInheritanceTests.SingleFromSuperclass2;
var
  VClient: TClient;
  VCompany: TCompany;
begin
  // client
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('91');
  TTestSQLDriver.Data.Add('acorp');

  // person
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('mike');

  VClient := Session.Retrieve(TClient, '91') as TClient;
  try
    AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
    AssertNotNull('client not null', VClient);
    AssertTrue('client is company', VClient is TCompany);
    VCompany := VClient as TCompany;
    AssertEquals('company name', 'acorp', VCompany.Name);
    AssertEquals('company contact name', 'mike', VCompany.ContactName);
    AssertSQLDriverCommands([
     'WriteInteger 91',
     'ExecSQL SELECT T_1.ID,T_2.ID,T.NAME FROM CLIENT T LEFT OUTER JOIN PERSON T_1 ON T.ID=T_1.ID LEFT OUTER JOIN COMPANY T_2 ON T.ID=T_2.ID WHERE T.ID=?',
     'WriteInteger 91',
     'ExecSQL SELECT CONTACTNAME FROM COMPANY WHERE ID=?']);
  finally
    FreeAndNil(VClient);
  end;
end;

procedure TTestOPFSelectManualMappingInheritanceTests.SingleFromSuperclass3;
var
  VClient: TClient;
begin
  // client
  TTestSQLDriver.ExpectedResultsets.Add(1);
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('null');
  TTestSQLDriver.Data.Add('someone');

  VClient := Session.Retrieve(TClient, '3') as TClient;
  try
    AssertEquals('expr cnt', 0, TTestSQLDriver.ExpectedResultsets.Count);
    AssertEquals('data cnt', 0, TTestSQLDriver.Data.Count);
    AssertNotNull('client not null', VClient);
    AssertTrue('client is tclient', VClient.ClassType = TClient);
    AssertEquals('client name', 'someone', VClient.Name);
    AssertSQLDriverCommands([
     'WriteInteger 3',
     'ExecSQL SELECT T_1.ID,T_2.ID,T.NAME FROM CLIENT T LEFT OUTER JOIN PERSON T_1 ON T.ID=T_1.ID LEFT OUTER JOIN COMPANY T_2 ON T.ID=T_2.ID WHERE T.ID=?']);
  finally
    FreeAndNil(VClient);
  end;
end;

{ TTestOPFDeleteManualMappingInheritanceTests }

procedure TTestOPFDeleteManualMappingInheritanceTests.Single1;
var
  VCompany: TCompany;
begin
  VCompany := TCompany.Create;
  try
    Session.Store(VCompany);
    AssertEquals('company id', '1', VCompany._proxy.OID.AsString);
    TTestSQLDriver.Commands.Clear;
    Session.Dispose(VCompany);
    AssertSQLDriverCommands([
     'WriteInteger 1',
     'ExecSQL DELETE FROM CLIENT WHERE ID=?',
     'WriteInteger 1',
     'ExecSQL DELETE FROM COMPANY WHERE ID=?']);
  finally
    FreeAndNil(VCompany);
  end;
end;

procedure TTestOPFDeleteManualMappingInheritanceTests.Single2;
begin
  Session.Dispose(TPerson, ['5', '6']);
  AssertSQLDriverCommands([
   'WriteInteger 5',
   'WriteInteger 6',
   'ExecSQL DELETE FROM CLIENT WHERE ID IN (?,?)',
   'WriteInteger 5',
   'WriteInteger 6',
   'ExecSQL DELETE FROM PERSON WHERE ID IN (?,?)']);
end;

initialization
  RegisterTest('jcore.opf.mapping.manualmapping.plain', TTestOPFInsertManualMappingPlainTests);
  RegisterTest('jcore.opf.mapping.manualmapping.plain', TTestOPFUpdateManualMappingPlainTests);
  RegisterTest('jcore.opf.mapping.manualmapping.plain', TTestOPFSelectManualMappingPlainTests);
  RegisterTest('jcore.opf.mapping.manualmapping.plain', TTestOPFDeleteOneManualMappingPlainTests);
  RegisterTest('jcore.opf.mapping.manualmapping.plain', TTestOPFDeleteArrayManualMappingPlainTests);
  RegisterTest('jcore.opf.mapping.manualmapping.inheritance', TTestOPFInsertManualMappingInheritanceTests);
  RegisterTest('jcore.opf.mapping.manualmapping.inheritance', TTestOPFUpdateManualMappingInheritanceTests);
  RegisterTest('jcore.opf.mapping.manualmapping.inheritance', TTestOPFSelectManualMappingInheritanceTests);
  RegisterTest('jcore.opf.mapping.manualmapping.inheritance', TTestOPFDeleteManualMappingInheritanceTests);

end.

