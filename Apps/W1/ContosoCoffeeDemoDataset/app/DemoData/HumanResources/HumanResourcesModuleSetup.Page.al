// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.DemoData.HumanResources;

page 4770 "Human Resources Module Setup"
{
    PageType = Card;
    ApplicationArea = BasicHR;
    Caption = 'Human Resources Module Setup';
    SourceTable = "Human Resources Module Setup";
    Extensible = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group("Master Data")
            {
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    ToolTip = 'Specifies the default Posting Group of Employee';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InitRecord();
    end;
}
