﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Service.History;

using Microsoft.Bank.BankAccount;
using Microsoft.Bank.Setup;
using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Foundation.Company;

tableextension 11735 "Service Invoice Header CZL" extends "Service Invoice Header"
{
    fields
    {
        field(11717; "Specific Symbol CZL"; Code[10])
        {
            Caption = 'Specific Symbol';
            OptimizeForTextSearch = true;
            CharAllowed = '09';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11718; "Variable Symbol CZL"; Code[10])
        {
            Caption = 'Variable Symbol';
            OptimizeForTextSearch = true;
            CharAllowed = '09';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11719; "Constant Symbol CZL"; Code[10])
        {
            Caption = 'Constant Symbol';
            OptimizeForTextSearch = true;
            CharAllowed = '09';
            TableRelation = "Constant Symbol CZL";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11720; "Bank Account Code CZL"; Code[20])
        {
            Caption = 'Bank Account Code';
            TableRelation = "Bank Account";
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
            begin
                if "Bank Account Code CZL" = '' then begin
                    UpdateBankInfoCZL('', '', '', '', '', '', '');
                    exit;
                end;
                BankAccount.Get("Bank Account Code CZL");
                UpdateBankInfoCZL(
                  BankAccount."No.",
                  BankAccount."Bank Account No.",
                  BankAccount."Bank Branch No.",
                  BankAccount.Name,
                  BankAccount."Transit No.",
                  BankAccount.IBAN,
                  BankAccount."SWIFT Code");
            end;
        }
        field(11721; "Bank Account No. CZL"; Text[30])
        {
            Caption = 'Bank Account No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11722; "Bank Branch No. CZL"; Text[20])
        {
            Caption = 'Bank Branch No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11723; "Bank Name CZL"; Text[100])
        {
            Caption = 'Bank Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11724; "Transit No. CZL"; Text[20])
        {
            Caption = 'Transit No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11725; "IBAN CZL"; Code[50])
        {
            Caption = 'IBAN';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11726; "SWIFT Code CZL"; Code[20])
        {
            Caption = 'SWIFT Code';
            Editable = false;
            TableRelation = "SWIFT Code";
            DataClassification = CustomerContent;
        }
        field(11774; "VAT Currency Factor CZL"; Decimal)
        {
            Caption = 'VAT Currency Factor';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(11775; "VAT Currency Code CZL"; Code[10])
        {
            Caption = 'VAT Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
            Editable = false;
        }
#if not CLEANSCHEMA25
        field(11780; "VAT Date CZL"; Date)
        {
            Caption = 'VAT Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Replaced by VAT Reporting Date.';
        }
#endif
        field(11781; "Registration No. CZL"; Text[20])
        {
            Caption = 'Registration No.';
            DataClassification = CustomerContent;
        }
        field(11782; "Tax Registration No. CZL"; Text[20])
        {
            Caption = 'Tax Registration No.';
            DataClassification = CustomerContent;
        }
#if not CLEANSCHEMA25
        field(31068; "Physical Transfer CZL"; Boolean)
        {
            Caption = 'Physical Transfer';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions.';
        }
        field(31069; "Intrastat Exclude CZL"; Boolean)
        {
            Caption = 'Intrastat Exclude';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions. This field is not used any more.';
        }
#endif
        field(31072; "EU 3-Party Intermed. Role CZL"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
            DataClassification = CustomerContent;
        }
    }

    procedure UpdateBankInfoCZL(BankAccountCode: Code[20]; BankAccountNo: Text[30]; BankBranchNo: Text[20]; BankName: Text[100]; TransitNo: Text[20]; IBANCode: Code[50]; SWIFTCode: Code[20])
    begin
        "Bank Account Code CZL" := BankAccountCode;
        "Bank Account No. CZL" := BankAccountNo;
        "Bank Branch No. CZL" := BankBranchNo;
        "Bank Name CZL" := BankName;
        "Transit No. CZL" := TransitNo;
        "IBAN CZL" := IBANCode;
        "SWIFT Code CZL" := SWIFTCode;
        OnAfterUpdateBankInfoCZL(Rec);
    end;

    procedure CreateServiceInvoicePaymentQRCodeStringCZL(): Text
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        CompanyInformation: Record "Company Information";
        IBAN: Code[50];
        SWIFT: Code[20];
        QRCode: Text;
        InvoiceTxt: Label 'Invoice';
    begin
        if "Bank Account Code CZL" <> '' then begin
            IBAN := "IBAN CZL";
            SWIFT := "SWIFT Code CZL";
        end else begin
            CompanyInformation.Get();
            IBAN := CompanyInformation.IBAN;
            SWIFT := CompanyInformation."SWIFT Code";
            if "IBAN CZL" <> '' then
                IBAN := "IBAN CZL";
            if "SWIFT Code CZL" <> '' then
                SWIFT := "SWIFT Code CZL";
        end;
        if IBAN <> '' then
            IBAN := DelChr(IBAN, '=', ' ');

        CalcFields("Amount Including VAT");

        QRCode := 'SPD*1.0*';

        // ACC
        if SWIFT <> '' then
            QRCode := QRCode + 'ACC:' + IBAN + '+' + SWIFT + '*'
        else
            QRCode := QRCode + 'ACC:' + IBAN + '*';

        // AM
        QRCode := QRCode + 'AM:' + format("Amount Including VAT", 0, '<Precision,2:2><Standard Format,2>') + '*';

        // CC
        if "Currency Code" = '' then begin
            GeneralLedgerSetup.Get();
            QRCode := QRCode + 'CC:' + UpperCase(GeneralLedgerSetup."LCY Code") + '*';
        end else
            QRCode := QRCode + 'CC:' + UpperCase("Currency Code") + '*';

        // DT
        QRCode := QRCode + 'DT:' + format("Due Date", 0, '<Year4><Month,2><Day,2>') + '*';

        // MSG
        QRCode := QRCode + 'MSG:' + InvoiceTxt + ' ' + "No." + '*';

        // XVS
        QRCode := QRCode + 'X-VS:' + "Variable Symbol CZL" + '*';

        // X-KS
        QRCode := QRCode + 'X-KS:' + "Constant Symbol CZL" + '*';

        if IBAN = '' then
            QRCode := '';
        OnBeforeExitServiceInvoicePaymentQRCodeStringCZL(Rec, QRCode);
        exit(QRCode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateBankInfoCZL(var ServiceInvoiceHeader: Record "Service Invoice Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExitServiceInvoicePaymentQRCodeStringCZL(ServiceInvoiceHeader: Record "Service Invoice Header"; var QRCode: Text)
    begin
    end;
}
