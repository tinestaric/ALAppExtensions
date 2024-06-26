namespace Microsoft.Bank.Deposit;

using Microsoft.Foundation.Navigate;
using Microsoft.Sales.History;
using Microsoft.Purchases.History;
using Microsoft.Service.History;
using Microsoft.Sales.Document;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Purchases.Payables;
using Microsoft.Service.Ledger;

codeunit 1699 "Navigate Bank Deposit Ext."
{
    Access = Internal;

    local procedure SetPostedBankDepositHeaderFilters(var PostedBankDepositHeader: Record "Posted Bank Deposit Header"; DocNoFilter: Text): Boolean
    begin
        if not PostedBankDepositHeader.ReadPermission() then
            exit(false);

        PostedBankDepositHeader.Reset();
        PostedBankDepositHeader.SetFilter("No.", DocNoFilter);
        exit(true);
    end;

    local procedure SetPostedBankDepositLineFilters(var PostedBankDepositLine: Record "Posted Bank Deposit Line"; DocNoFilter: Text; PostingDateFilter: Text; UseDocumentNo: Boolean): Boolean
    begin
        if not PostedBankDepositLine.ReadPermission() then
            exit(false);

        PostedBankDepositLine.Reset();
        PostedBankDepositLine.SetCurrentKey("Bank Deposit No.", "Posting Date");
        if UseDocumentNo then
            PostedBankDepositLine.SetFilter("Document No.", DocNoFilter)
        else
            PostedBankDepositLine.SetFilter("Bank Deposit No.", DocNoFilter);
        PostedBankDepositLine.SetFilter("Posting Date", PostingDateFilter);
        exit(true);
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure OnAfterNavigateFindRecords(Sender: Page Navigate; var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; var NewSourceRecVar: Variant)
    var
        PostedBankDepositHeader: Record "Posted Bank Deposit Header";
        PostedBankDepositLine: Record "Posted Bank Deposit Line";
    begin
        if SetPostedBankDepositHeaderFilters(PostedBankDepositHeader, DocNoFilter) then
            Sender.InsertIntoDocEntry(DocumentEntry, Database::"Posted Bank Deposit Header", PostedBankDepositHeader.TableCaption(), PostedBankDepositHeader.Count());

        if SetPostedBankDepositLineFilters(PostedBankDepositLine, DocNoFilter, PostingDateFilter, not Sender.GetNavigationFromPostedBankDeposit()) then
            Sender.InsertIntoDocEntry(DocumentEntry, Database::"Posted Bank Deposit Line", PostedBankDepositLine.TableCaption(), PostedBankDepositLine.Count());
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnBeforeNavigateShowRecords', '', false, false)]
    local procedure OnBeforeNavigateShowRecords(Sender: Page Navigate; TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry" temporary; var IsHandled: Boolean; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ServiceInvoiceHeader: Record "Service Invoice Header"; var ServiceCrMemoHeader: Record "Service Cr.Memo Header"; var SOSalesHeader: Record "Sales Header"; var SISalesHeader: Record "Sales Header"; var SCMSalesHeader: Record "Sales Header"; var SROSalesHeader: Record "Sales Header"; var GLEntry: Record "G/L Entry"; var VATEntry: Record "VAT Entry"; var VendLedgEntry: Record "Vendor Ledger Entry"; var WarrantyLedgerEntry: Record "Warranty Ledger Entry"; var NewSourceRecVar: Variant; var SalesShipmentHeader: Record "Sales Shipment Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var ReturnShipmentHeader: Record "Return Shipment Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        PostedBankDepositHeader: Record "Posted Bank Deposit Header";
        PostedBankDepositLine: Record "Posted Bank Deposit Line";
    begin
        if ItemTrackingSearch or IsHandled then
            exit;

        if TableID = Database::"Posted Bank Deposit Header" then begin
            IsHandled := true;
            SetPostedBankDepositHeaderFilters(PostedBankDepositHeader, DocNoFilter);
            Page.Run(0, PostedBankDepositHeader);
            exit;
        end;
        if TableID = Database::"Posted Bank Deposit Line" then begin
            IsHandled := true;
            SetPostedBankDepositLineFilters(PostedBankDepositLine, DocNoFilter, PostingDateFilter, not Sender.GetNavigationFromPostedBankDeposit());
            Page.Run(0, PostedBankDepositLine);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnBeforeFindRecordsSetSources', '', false, false)]
    local procedure OnBeforeFindRecordsSetSources(Sender: Page Navigate; DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; ExtDocNo: Text; var IsHandled: Boolean)
    var
        PostedBankDepositHeader: Record "Posted Bank Deposit Header";
        DocType: Text[100];
    begin
        if not Sender.GetNavigationFromPostedBankDeposit() then
            exit;
        if Sender.GetNoOfRecords(Database::"Posted Bank Deposit Header") <> 1 then
            exit;
        if not SetPostedBankDepositHeaderFilters(PostedBankDepositHeader, DocNoFilter) then
            exit;
        if IsHandled then
            exit;
        if not PostedBankDepositHeader.FindFirst() then
            exit;
        IsHandled := true;
        DocType := CopyStr(PostedBankDepositHeader.TableCaption(), 1, MaxStrLen(DocType));
        Sender.SetSource(PostedBankDepositHeader."Posting Date", DocType, PostedBankDepositHeader."No.", 4, PostedBankDepositHeader."Bank Account No.");
    end;
}