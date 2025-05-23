// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.DemoData.Purchases;

using Microsoft.Purchases.Setup;

codeunit 10510 "Create Purch. Payable Setup US"
{
    InherentEntitlements = X;
    InherentPermissions = X;

    trigger OnRun()
    begin
        UpdatePurchasesPayablesSetup();
    end;

    local procedure UpdatePurchasesPayablesSetup()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get();

        PurchasesPayablesSetup.Validate("Allow VAT Difference", true);
        PurchasesPayablesSetup.Validate("Combine Special Orders Default", PurchasesPayablesSetup."Combine Special Orders Default"::"Always Combine");
        PurchasesPayablesSetup.Validate("Use Vendor's Tax Area Code", false);
        PurchasesPayablesSetup.Modify(true);
    end;
}
