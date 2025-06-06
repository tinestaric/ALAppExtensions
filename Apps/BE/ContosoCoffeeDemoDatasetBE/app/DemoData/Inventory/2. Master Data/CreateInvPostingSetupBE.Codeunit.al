// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.DemoData.Inventory;

using Microsoft.Inventory.Item;
using Microsoft.DemoData.Finance;

codeunit 11373 "Create Inv. Posting Setup BE"
{
    SingleInstance = true;
    EventSubscriberInstance = Manual;
    InherentEntitlements = X;
    InherentPermissions = X;

    [EventSubscriber(ObjectType::Table, Database::"Inventory Posting Setup", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertInvPostingSetup(var Rec: Record "Inventory Posting Setup")
    var
        CreateInvPostingGroup: Codeunit "Create Inventory Posting Group";
        CreateBEGLAccount: Codeunit "Create GL Account BE";
    begin
        case Rec."Invt. Posting Group Code" of
            CreateInvPostingGroup.Resale():
                ValidateRecordFields(Rec, CreateBEGLAccount.Goods(), CreateBEGLAccount.GoodsInterim());
        end;
    end;

    local procedure ValidateRecordFields(var InventoryPostingSetup: Record "Inventory Posting Setup"; InventoryAccount: Code[20]; InventoryAccountInterim: Code[20])
    begin
        InventoryPostingSetup.Validate("Inventory Account", InventoryAccount);
        InventoryPostingSetup.Validate("Inventory Account (Interim)", InventoryAccountInterim);
    end;
}
