// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.ExternalFileStorage;

enum 4580 "Ext. SharePoint Auth. Type"
{
    Access = Internal;

    value(0; AuthCode)
    {
        Caption = 'AuthCode';
    }
    value(1; Certificate)
    {
        Caption = 'Certificate';
    }
}
