// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.DemoTool.Helpers;

using Microsoft.Foundation.Address;

codeunit 11200 "Contoso Post Code SE"
{
    InherentEntitlements = X;
    InherentPermissions = X;
    Permissions =
        tabledata "Post Code" = rim;

    procedure SetOverwriteData(Overwrite: Boolean)
    begin
        OverwriteData := Overwrite;
    end;

    procedure InsertPostCode(Code: Code[20]; City: Text[30]; CountryRegionCode: Code[10])
    var
        PostCode: Record "Post Code";
        Exists: Boolean;
    begin
        if PostCode.Get(Code, City) then begin
            Exists := true;

            if not OverwriteData then
                exit;
        end;

        PostCode.Validate(Code, Code);
        PostCode.Validate(City, City);
        PostCode.Validate("Search City", City);
        PostCode.Validate("Country/Region Code", CountryRegionCode);

        if Exists then
            PostCode.Modify(true)
        else
            PostCode.Insert(true);
    end;

    var
        OverwriteData: Boolean;
}
