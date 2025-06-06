// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.DemoData.Purchases;

using Microsoft.Purchases.Setup;
using Microsoft.DemoData.Foundation;

codeunit 17135 "Create NZ Purch Payable Setup"
{
    InherentEntitlements = X;
    InherentPermissions = X;

    trigger OnRun()
    begin
        UpdatePurchasePayableSetup();
    end;

    local procedure UpdatePurchasePayableSetup()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        CreateNZNoSeries: Codeunit "Create NZ No. Series";
    begin
        PurchasesPayablesSetup.Get();

        PurchasesPayablesSetup.Validate("Posted Tax Invoice Nos.", CreateNZNoSeries.PostedPurchaseTaxInvoice());
        PurchasesPayablesSetup.Validate("Posted Tax Credit Memo Nos", CreateNZNoSeries.PostedPurchaseTaxCreditMemo());
        PurchasesPayablesSetup.Validate("Copy Line Descr. to G/L Entry", true);
        PurchasesPayablesSetup.Modify(true);
    end;
}
