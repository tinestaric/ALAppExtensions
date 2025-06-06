// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.DemoData.Inventory;

using Microsoft.DemoTool.Helpers;
using Microsoft.DemoData.Foundation;

codeunit 5411 "Create Order Promising Setup"
{
    InherentEntitlements = X;
    InherentPermissions = X;

    trigger OnRun()
    var
        ContosoInventory: Codeunit "Contoso Inventory";
        CreateNoSeries: Codeunit "Create No. Series";
    begin
        ContosoInventory.InsertOrderPromisingSetup('<1D>', CreateNoSeries.OrderPromising(), Planning(), Default());
    end;

    procedure Planning(): Code[10]
    begin
        exit(PlanningTok);
    end;

    procedure Default(): Code[10]
    begin
        exit(DefaultTok);
    end;

    var
        PlanningTok: Label 'PLANNING', MaxLength = 10;
        DefaultTok: Label 'DEFAULT', MaxLength = 10;
}
