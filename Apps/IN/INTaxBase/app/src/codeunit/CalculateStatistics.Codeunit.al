﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Finance.TaxBase;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;

codeunit 18547 "Calculate Statistics"
{
    procedure GetPurchaseStatisticsAmount(
        PurchaseHeader: Record "Purchase Header";
        var TotalInclTaxAmount: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
        RecordIDList: List of [RecordID];
        GSTAmount: Decimal;
        CessAmount: Decimal;
        TDSAmount: Decimal;
    begin
        Clear(TotalInclTaxAmount);

        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document no.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                RecordIDList.Add(PurchaseLine.RecordId());
                TotalInclTaxAmount += PurchaseLine.Amount;
            until PurchaseLine.Next() = 0;

        OnGetPurchaseHeaderGSTAmount(PurchaseHeader, GSTAmount);
        OnGetPurchaseHeaderCessAmount(PurchaseHeader, CessAmount);
        OnGetPurchaseHeaderTDSAmount(PurchaseHeader, TDSAmount);

        TotalInclTaxAmount := RoundInvoicePrecision((TotalInclTaxAmount + GSTAmount + CessAmount - TDSAmount));
    end;

    procedure GetPartialPurchaseInvStatisticsAmount(
        PurchaseHeader: Record "Purchase Header";
        var PartialInclInvTaxAmount: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
        RecordIDList: List of [RecordID];
        PartialGSTAmount: Decimal;
        PartialTDSAmount: Decimal;
    begin
        Clear(PartialInclInvTaxAmount);

        PurchaseLine.SetLoadFields("Document Type", "Document No.", Quantity, Amount, "Qty. to Invoice");
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document no.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                RecordIDList.Add(PurchaseLine.RecordId());
                if PurchaseLine.Quantity <> 0 then
                    PartialInclInvTaxAmount += (PurchaseLine.Amount * PurchaseLine."Qty. to Invoice" / PurchaseLine.Quantity);
            until PurchaseLine.Next() = 0;

        OnGetPartialPurchaseHeaderGSTAmount(PurchaseHeader, PartialGSTAmount);
        OnGetPartialPurchaseHeaderTDSAmount(PurchaseHeader, PartialTDSAmount);

        PartialInclInvTaxAmount := RoundInvoicePrecision((PartialInclInvTaxAmount + PartialGSTAmount - PartialTDSAmount));
    end;

    procedure GetPartialPurchaseRcptStatisticsAmount(
        PurchaseHeader: Record "Purchase Header";
        var PartialInclRcptTaxAmount: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
        RecordIDList: List of [RecordID];
        PartialGSTAmount: Decimal;
        PartialTDSAmount: Decimal;
    begin
        Clear(PartialInclRcptTaxAmount);

        PurchaseLine.SetLoadFields("Document Type", "Document No.", Amount, Quantity, "Qty. to Receive", "Return Qty. to Ship");
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document no.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                RecordIDList.Add(PurchaseLine.RecordId());
                if PurchaseLine.Quantity <> 0 then
                    if PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order then
                        PartialInclRcptTaxAmount += (PurchaseLine.Amount * PurchaseLine."Qty. to Receive" / PurchaseLine.Quantity)
                    else
                        if PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Return Order" then
                            PartialInclRcptTaxAmount += (PurchaseLine.Amount * PurchaseLine."Return Qty. to Ship" / PurchaseLine.Quantity);
            until PurchaseLine.Next() = 0;

        OnGetPartialPurchaseRcptGSTAmount(PurchaseHeader, PartialGSTAmount);
        OnGetPartialPurchaseRcptTDSAmount(PurchaseHeader, PartialTDSAmount);

        PartialInclRcptTaxAmount := RoundInvoicePrecision((PartialInclRcptTaxAmount + PartialGSTAmount - PartialTDSAmount));
    end;

    procedure GetPostedPurchInvStatisticsAmount(
        PurchInvHeader: Record "Purch. Inv. Header";
        var TotalInclTaxAmount: Decimal)
    var
        PurchInvLine: Record "Purch. Inv. Line";
        RecordIDList: List of [RecordID];
        GSTAmount: Decimal;
        TDSAmount: Decimal;
    begin
        Clear(TotalInclTaxAmount);

        PurchInvLine.SetRange("Document no.", PurchInvHeader."No.");
        if PurchInvLine.FindSet() then
            repeat
                RecordIDList.Add(PurchInvLine.RecordId());
                TotalInclTaxAmount += PurchInvLine.Amount;
            until PurchInvLine.Next() = 0;

        OnGetPurchInvHeaderGSTAmount(PurchInvHeader, GSTAmount);
        OnGetPurchInvHeaderTDSAmount(PurchInvHeader, TDSAmount);

        TotalInclTaxAmount := TotalInclTaxAmount + GSTAmount - TDSAmount;
    end;

    procedure GetPostedPurchCrMemoStatisticsAmount(
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        var TotalInclTaxAmount: Decimal)
    var
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        RecordIDList: List of [RecordID];
        GSTAmount: Decimal;
        TDSAmount: Decimal;
    begin
        Clear(TotalInclTaxAmount);

        PurchCrMemoLine.SetRange("Document no.", PurchCrMemoHeader."No.");
        if PurchCrMemoLine.FindSet() then
            repeat
                RecordIDList.Add(PurchCrMemoLine.RecordId());
                TotalInclTaxAmount += PurchCrMemoLine.Amount;
            until PurchCrMemoLine.Next() = 0;

        OnGetPurchCrMemoHeaderGSTAmount(PurchCrMemoHeader, GSTAmount);
        OnGetPurchCrMemoHeaderTDSAmount(PurchCrMemoHeader, TDSAmount);

        TotalInclTaxAmount := TotalInclTaxAmount + GSTAmount - TDSAmount;
    end;

    procedure GetSalesStatisticsAmount(
        SalesHeader: Record "Sales Header";
        var TotalInclTaxAmount: Decimal)
    var
        SalesLine: Record "Sales Line";
        RecordIDList: List of [RecordID];
        GSTAmount: Decimal;
        TCSAmount: Decimal;
    begin
        Clear(TotalInclTaxAmount);

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                RecordIDList.Add(SalesLine.RecordId());
                TotalInclTaxAmount += SalesLine.Amount;
            until SalesLine.Next() = 0;

        OnGetSalesHeaderGSTAmount(SalesHeader, GSTAmount);
        OnGetSalesHeaderTCSAmount(SalesHeader, TCSAmount);

        TotalInclTaxAmount := TotalInclTaxAmount + GSTAmount + TCSAmount;
    end;

    procedure GetPartialSalesInvStatisticsAmount(
        SalesHeader: Record "Sales Header";
        var PartialInclInvTaxAmount: Decimal)
    var
        SalesLine: Record "Sales Line";
        RecordIDList: List of [RecordID];
        PartialGSTAmount: Decimal;
        PartialTCSAmount: Decimal;
    begin
        Clear(PartialInclInvTaxAmount);

        SalesLine.SetLoadFields("Document Type", "Document No.", Amount, Quantity, "Qty. to Invoice");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                RecordIDList.Add(SalesLine.RecordId());
                if SalesLine.Quantity <> 0 then
                    PartialInclInvTaxAmount += (SalesLine.Amount * SalesLine."Qty. to Invoice" / SalesLine.Quantity);
            until SalesLine.Next() = 0;

        OnGetPartialSalesHeaderGSTAmount(SalesHeader, PartialGSTAmount);
        OnGetPartialSalesHeaderTCSAmount(SalesHeader, PartialTCSAmount);

        PartialInclInvTaxAmount := PartialInclInvTaxAmount + PartialGSTAmount + PartialTCSAmount;
    end;

    procedure GetPartialSalesShptStatisticsAmount(
        SalesHeader: Record "Sales Header";
        var PartialInclShptTaxAmount: Decimal)
    var
        SalesLine: Record "Sales Line";
        RecordIDList: List of [RecordID];
        PartialGSTAmount: Decimal;
        PartialTCSAmount: Decimal;
    begin
        Clear(PartialInclShptTaxAmount);

        SalesLine.SetLoadFields("Document Type", "Document No.", Amount, Quantity, "Qty. to Ship", "Return Qty. to Receive");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                RecordIDList.Add(SalesLine.RecordId());
                if SalesLine.Quantity <> 0 then
                    if SalesLine."Document Type" = SalesLine."Document Type"::Order then
                        PartialInclShptTaxAmount += (SalesLine.Amount * SalesLine."Qty. to Ship" / SalesLine.Quantity)
                    else
                        if SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" then
                            PartialInclShptTaxAmount += (SalesLine.Amount * SalesLine."Return Qty. to Receive" / SalesLine.Quantity)
            until SalesLine.Next() = 0;

        OnGetPartialSalesShptGSTAmount(SalesHeader, PartialGSTAmount);
        OnGetPartialSalesShptTCSAmount(SalesHeader, PartialTCSAmount);

        PartialInclShptTaxAmount := PartialInclShptTaxAmount + PartialGSTAmount + PartialTCSAmount;
    end;

    procedure GetPostedSalesInvStatisticsAmount(
        SalesInvHeader: Record "Sales Invoice Header";
        var TotalInclTaxAmount: Decimal)
    var
        SalesInvLine: Record "Sales Invoice Line";
        RecordIDList: List of [RecordID];
        GSTAmount: Decimal;
        TCSAmount: Decimal;
    begin
        Clear(TotalInclTaxAmount);

        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        if SalesInvLine.FindSet() then
            repeat
                RecordIDList.Add(SalesInvLine.RecordId());
                TotalInclTaxAmount += SalesInvLine.Amount;
            until SalesInvLine.Next() = 0;

        OnGetSalesInvHeaderGSTAmount(SalesInvHeader, GSTAmount);
        OnGetSalesInvHeaderTCSAmount(SalesInvHeader, TCSAmount);

        TotalInclTaxAmount := TotalInclTaxAmount + GSTAmount + TCSAmount;
    end;

    procedure GetPostedSalesCrMemoStatisticsAmount(
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        var TotalInclTaxAmount: Decimal)
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        RecordIDList: List of [RecordID];
        GSTAmount: Decimal;
        TCSAmount: Decimal;
    begin
        Clear(TotalInclTaxAmount);

        SalesCrMemoLine.SetRange("Document no.", SalesCrMemoHeader."No.");
        if SalesCrMemoLine.FindSet() then
            repeat
                RecordIDList.Add(SalesCrMemoLine.RecordId());
                TotalInclTaxAmount += SalesCrMemoLine.Amount;
            until SalesCrMemoLine.Next() = 0;

        OnGetSalesCrMemoHeaderGSTAmount(SalesCrMemoHeader, GSTAmount);
        OnGetSalesCrMemoHeaderTCSAmount(SalesCrMemoHeader, TCSAmount);

        TotalInclTaxAmount := TotalInclTaxAmount + GSTAmount + TCSAmount;
    end;

    local procedure RoundInvoicePrecision(InvoiceAmount: Decimal): Decimal
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        InvRoundingDirection: Text[1];
        InvRoundingPrecision: Decimal;
    begin
        if InvoiceAmount = 0 then
            exit(0);

        GeneralLedgerSetup.Get();
        if GeneralLedgerSetup."Inv. Rounding Precision (LCY)" = 0 then
            exit;

        case GeneralLedgerSetup."Inv. Rounding Type (LCY)" of
            GeneralLedgerSetup."Inv. Rounding Type (LCY)"::Nearest:
                InvRoundingDirection := '=';
            GeneralLedgerSetup."Inv. Rounding Type (LCY)"::Up:
                InvRoundingDirection := '>';
            GeneralLedgerSetup."Inv. Rounding Type (LCY)"::Down:
                InvRoundingDirection := '<';
        end;

        InvRoundingPrecision := GeneralLedgerSetup."Inv. Rounding Precision (LCY)";

        exit(Round(InvoiceAmount, InvRoundingPrecision, InvRoundingDirection));
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPurchaseHeaderCessAmount(PurchaseHeader: Record "Purchase Header"; var CessAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPurchaseHeaderGSTAmount(PurchaseHeader: Record "Purchase Header"; var GSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPurchaseHeaderTDSAmount(PurchaseHeader: Record "Purchase Header"; var TDSAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPartialPurchaseHeaderGSTAmount(PurchaseHeader: Record "Purchase Header"; var PartialGSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPartialPurchaseHeaderTDSAmount(PurchaseHeader: Record "Purchase Header"; var PartialTDSAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPartialPurchaseRcptGSTAmount(PurchaseHeader: Record "Purchase Header"; var PartialGSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPartialPurchaseRcptTDSAmount(PurchaseHeader: Record "Purchase Header"; var PartialTDSAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPurchInvHeaderGSTAmount(PurchInvHeader: Record "Purch. Inv. Header"; var GSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPurchInvHeaderTDSAmount(PurchInvHeader: Record "Purch. Inv. Header"; var TDSAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPurchCrMemoHeaderGSTAmount(PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; var GSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPurchCrMemoHeaderTDSAmount(PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; var TDSAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetSalesHeaderGSTAmount(SalesHeader: Record "Sales Header"; var GSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetSalesHeaderTCSAmount(SalesHeader: Record "Sales Header"; var TCSAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPartialSalesHeaderGSTAmount(SalesHeader: Record "Sales Header"; var PartialGSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPartialSalesHeaderTCSAmount(SalesHeader: Record "Sales Header"; var PartialTCSAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPartialSalesShptGSTAmount(SalesHeader: Record "Sales Header"; var PartialGSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetPartialSalesShptTCSAmount(SalesHeader: Record "Sales Header"; var PartialTCSAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetSalesInvHeaderGSTAmount(SalesInvHeader: Record "Sales Invoice Header"; var GSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetSalesInvHeaderTCSAmount(SalesInvHeader: Record "Sales Invoice Header"; var TCSAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetSalesCrMemoHeaderGSTAmount(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var GSTAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetSalesCrMemoHeaderTCSAmount(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var TCSAmount: Decimal)
    begin
    end;
}
