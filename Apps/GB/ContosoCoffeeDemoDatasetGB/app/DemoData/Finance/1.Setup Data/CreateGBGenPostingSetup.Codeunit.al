// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.DemoData.Finance;

using Microsoft.DemoTool.Helpers;

codeunit 10512 "Create GB Gen Posting Setup"
{
    InherentEntitlements = X;
    InherentPermissions = X;

    procedure UpdateGenPostingSetup()
    var
        ContosoGenPostingSetup: Codeunit "Contoso Posting Setup";
        CreatePostingGroups: Codeunit "Create Posting Groups";
        CreateGBGLAccounts: Codeunit "Create GB GL Accounts";
    begin
        ContosoGenPostingSetup.SetOverwriteData(true);
        ContosoGenPostingSetup.InsertGeneralPostingSetup('', CreatePostingGroups.RetailPostingGroup(), '', '', CreateGBGLAccounts.CostOfMaterials(), CreateGBGLAccounts.GoodsForResale(), '', '', '', '', '', '', CreateGBGLAccounts.CostOfMaterials(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup('', CreatePostingGroups.ZeroPostingGroup(), '', '', CreateGBGLAccounts.CostOfMaterials(), CreateGBGLAccounts.GoodsForResale(), '', '', '', '', '', '', CreateGBGLAccounts.CostOfMaterials(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup('', CreatePostingGroups.ServicesPostingGroup(), '', '', CreateGBGLAccounts.CostOfMaterials(), CreateGBGLAccounts.GoodsForResale(), '', '', '', '', '', '', CreateGBGLAccounts.CostOfMaterials(), '', '');

        ContosoGenPostingSetup.InsertGeneralPostingSetup(CreatePostingGroups.DomesticPostingGroup(), CreatePostingGroups.RetailPostingGroup(), CreateGBGLAccounts.SaleOfFinishedGoods(), CreateGBGLAccounts.GoodsForResale(), CreateGBGLAccounts.CostOfMaterials(), CreateGBGLAccounts.GoodsForResale(), '', '', CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.CostOfMaterials(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup(CreatePostingGroups.DomesticPostingGroup(), CreatePostingGroups.ServicesPostingGroup(), CreateGBGLAccounts.SaleOfResources(), CreateGBGLAccounts.MiscExternalExpenses(), CreateGBGLAccounts.CostOfLabor(), CreateGBGLAccounts.MiscExternalExpenses(), '', '', CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.CostOfLabor(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup(CreatePostingGroups.DomesticPostingGroup(), CreatePostingGroups.ZeroPostingGroup(), CreateGBGLAccounts.SaleOfFinishedGoods(), CreateGBGLAccounts.GoodsForResale(), CreateGBGLAccounts.CostOfMaterials(), CreateGBGLAccounts.GoodsForResale(), '', '', CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.CostOfMaterials(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup(CreatePostingGroups.EUPostingGroup(), CreatePostingGroups.RetailPostingGroup(), CreateGBGLAccounts.SaleOfFinishedGoods(), CreateGBGLAccounts.GoodsForResale(), CreateGBGLAccounts.CostOfMaterials(), CreateGBGLAccounts.GoodsForResale(), '', '', CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.CostOfMaterials(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup(CreatePostingGroups.EUPostingGroup(), CreatePostingGroups.ServicesPostingGroup(), CreateGBGLAccounts.SaleOfResources(), CreateGBGLAccounts.MiscExternalExpenses(), CreateGBGLAccounts.CostOfLabor(), CreateGBGLAccounts.MiscExternalExpenses(), '', '', CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.CostOfLabor(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup(CreatePostingGroups.EUPostingGroup(), CreatePostingGroups.ZeroPostingGroup(), CreateGBGLAccounts.SaleOfFinishedGoods(), CreateGBGLAccounts.GoodsForResale(), CreateGBGLAccounts.CostOfMaterials(), CreateGBGLAccounts.GoodsForResale(), '', '', CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.CostOfMaterials(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup(CreatePostingGroups.ExportPostingGroup(), CreatePostingGroups.RetailPostingGroup(), CreateGBGLAccounts.SaleOfFinishedGoods(), CreateGBGLAccounts.GoodsForResale(), CreateGBGLAccounts.CostOfMaterials(), CreateGBGLAccounts.GoodsForResale(), '', '', CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.CostOfMaterials(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup(CreatePostingGroups.ExportPostingGroup(), CreatePostingGroups.ServicesPostingGroup(), CreateGBGLAccounts.SaleOfResources(), CreateGBGLAccounts.MiscExternalExpenses(), CreateGBGLAccounts.CostOfLabor(), CreateGBGLAccounts.MiscExternalExpenses(), '', '', CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.CostOfLabor(), '', '');
        ContosoGenPostingSetup.InsertGeneralPostingSetup(CreatePostingGroups.ExportPostingGroup(), CreatePostingGroups.ZeroPostingGroup(), CreateGBGLAccounts.SaleOfFinishedGoods(), CreateGBGLAccounts.GoodsForResale(), CreateGBGLAccounts.CostOfMaterials(), CreateGBGLAccounts.GoodsForResale(), '', '', CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.DiscountsAndAllowances(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.PurchaseDiscounts(), CreateGBGLAccounts.CostOfMaterials(), '', '');
        ContosoGenPostingSetup.SetOverwriteData(false);
    end;
}
