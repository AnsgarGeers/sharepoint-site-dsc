$config = @{
    Columns = @(
        @{            
            InternalName = "MyTextColumn";
            DisplayName = "My Text Column";
            Group = "My Columns"
            FieldType = [Microsoft.SharePoint.SPFieldType]::Text;
            Required = $true;            
        },
        @{            
            InternalName = "MyMultiTextColumn";
            DisplayName = "My Multi Text Column";
            Group = "My Columns"
            FieldType = [Microsoft.SharePoint.SPFieldType]::Note;
            UnlimitedLengthInDocumentLibrary = $false;
            NumberOfLines = 10;
            RichText = $true;
            RichTextMode = [Microsoft.SharePoint.SPRichTextMode]::FullHtml;
            AppendOnly = $true;
            Required = $true;                     
        },
        @{
            InternalName = "MyChoiceColumn";
            DisplayName = "My Choice Column";
            Group = "My Columns";
            FieldType = [Microsoft.SharePoint.SPFieldType]::Choice;  
            Choices = @(
                "A";
                "B";
                "C";
            )
            Required = $true;
        },
        @{
            InternalName = "MyDateTimeColumn";
            DisplayName = "My Date Time Column";
            Group = "My Columns";
            FieldType = [Microsoft.SharePoint.SPFieldType]::DateTime;
            DateFormat = [Microsoft.SharePoint.SPDateTimeFieldFormatType]::DateOnly;            
            Required = $true;
        },
        @{
            InternalName = "MyBooleanColumn";
            DisplayName = "My Boolean Column";
            Group = "My Columns";
            FieldType = [Microsoft.SharePoint.SPFieldType]::Boolean;
            DefaultValue = "0"            
        },
        @{
            InternalName = "MyPeopleColumn";
            DisplayName = "My People Column";
            Group = "My Columns";
            FieldType = [Microsoft.SharePoint.SPFieldType]::User;
            SelectionMode = [Microsoft.SharePoint.SPFieldUserSelectionMode]::PeopleOnly;
            Required = $true;
            EnforceUniqueValues = $true;
        },
        @{
            InternalName = "MyNumberColumn";
            DisplayName = "My Number Column";
            Group = "My Columns";
            FieldType = [Microsoft.SharePoint.SPFieldType]::Number;
            DisplayFormat = [Microsoft.SharePoint.SPNumberFormatTypes]::NoDecimal;
            MinimumValue = 1;
            MaximumValue = 10;
            ShowAsPercentage = $true;
            Required = $true;
        },
        @{
            InternalName = "MyCurrencyColumn";
            DisplayName = "My Currency Column";
            Group = "My Columns";
            FieldType = [Microsoft.SharePoint.SPFieldType]::Currency;
            CurrencyLocaleId = 2057;
            DisplayFormat = [Microsoft.SharePoint.SPNumberFormatTypes]::NoDecimal;
            MinimumValue = 1;
            MaximumValue = 10;
        },
        @{
            InternalName = "MyHyperlinkColumn";
            DisplayName = "My Hyperlink Column";
            Group = "My Columns";
            FieldType = [Microsoft.SharePoint.SPFieldType]::URL; 
            DisplayFormat = [Microsoft.SharePoint.SPUrlFieldFormatType]::Hyperlink;
        },
        @{
            InternalName = "MyCalculatedColumn";
            DisplayName = "My Calculated Column";
            Group = "My Columns";
            FieldType = [Microsoft.SharePoint.SPFieldType]::Calculated;
            Formula = "=IF([My Choice Column]=`"A`",TRUE,FALSE)";
            OutputType = [Microsoft.SharePoint.SPFieldType]::Boolean;
        }
    )
    ContentTypes = @(
        @{
            ContentTypeId = "$([Microsoft.SharePoint.SPBuiltInContentTypeId]::Item)0031E5BF2B4E904BC382EB1CA8506419E8";
            Name = "Base Item";
            Group = "Base Content Types";
        },   
        @{
            ContentTypeId = "$([Microsoft.SharePoint.SPBuiltInContentTypeId]::Item)0031E5BF2B4E904BC382EB1CA8506419E8007B2EF077CF754EB6A937B68DF53400D1";
            Name = "My Item";
            Group = "My Content Types";
            FieldLinks = @(
                @{
                    InternalName = "Title";
                    DisplayName = "Title";
                    Required = $false;
                    Hidden = $true;
                    ShowInDisplayForm = $false;
                },
                @{
                    InternalName = "MyTextColumn";
                    DisplayName = "My Text Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyMultiTextColumn";
                    DisplayName = "My Multi Text Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyChoiceColumn";
                    DisplayName = "My Choice Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyDateTimeColumn";
                    DisplayName = "My DateTime Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyBooleanColumn";
                    DisplayName = "My Boolean Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyPeopleColumn";
                    DisplayName = "My People Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyNumberColumn";
                    DisplayName = "My Number Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyCurrencyColumn";
                    DisplayName = "My Currency Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyHyperlinkColumn";
                    DisplayName = "My Text Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyHyperlinkColumn";
                    DisplayName = "My Hyperlink Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                }
                @{
                    InternalName = "MyCalculatedColumn";
                    DisplayName = "My Calculated Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                }
            )
        },
        @{
            ContentTypeId = "$([Microsoft.SharePoint.SPBuiltInContentTypeId]::Item)0031E5BF2B4E904BC382EB1CA8506419E800EEDE97697FFC4C2B85FDCD5FFB30B198";
            Name = "My Lookup Item";
            Group = "My Content Types";
            FieldLinks = @(
                @{
                    InternalName = "Title";
                    DisplayName = "Title";
                    Required = $false;
                    Hidden = $true;
                    ShowInDisplayForm = $false;
                },
                @{
                    InternalName = "MyTextColumn";
                    DisplayName = "My Text Column";
                    Required = $true;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                }                
            )
        },
        @{
            ContentTypeId = "$([Microsoft.SharePoint.SPBuiltInContentTypeId]::Document)0031E5BF2B4E904BC382EB1CA8506419E8";
            Name = "Base Document";
            Group = "Base Content Types";
        },
        @{
            ContentTypeId = "$([Microsoft.SharePoint.SPBuiltInContentTypeId]::Document)0031E5BF2B4E904BC382EB1CA8506419E800853DDE728AF44BC7846D3751D2014CE5";
            Name = "My Document";
            Group = "My Content Types";
            FieldLinks = @(
                @{
                    InternalName = "Title";
                    DisplayName = "Title";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $false;
                },
                @{
                    InternalName = "MyTextColumn";
                    DisplayName = "My Text Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyMultiTextColumn";
                    DisplayName = "My Multi Text Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyChoiceColumn";
                    DisplayName = "My Choice Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyDateTimeColumn";
                    DisplayName = "My DateTime Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyBooleanColumn";
                    DisplayName = "My Boolean Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyPeopleColumn";
                    DisplayName = "My People Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyNumberColumn";
                    DisplayName = "My Number Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyCurrencyColumn";
                    DisplayName = "My Currency Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyHyperlinkColumn";
                    DisplayName = "My Text Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                },
                @{
                    InternalName = "MyHyperlinkColumn";
                    DisplayName = "My Hyperlink Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                }
                @{
                    InternalName = "MyCalculatedColumn";
                    DisplayName = "My Calculated Column";
                    Required = $false;
                    Hidden = $false;
                    ShowInDisplayForm = $true;
                }
            )
        }
    )
    Lists = @(
        @{
            Title = "My Custom List";
            Description = [string]::Empty;
            ListTemplateType = [Microsoft.SharePoint.SPListTemplateType]::GenericList;
            ForceCheckout = $false;
            EnableAttachments = $false;
            EnableFolderCreation = $false;
            EnableModeration = $false;
            EnableMinorVersions = $false;
            EnableVersioning = $false;
            ContentTypes = @(
                "My Item"
            );
            Views = @(
                @{
                    Name = "My View";
                    ViewFields = @(
                        "Title";
                        "MyTextColumn";
                        "MyMultiTextColumn";
                        "MyChoiceColumn";
                        "MyDateTimeColumn";
                        "MyBooleanColumn";
                        "MyPeopleColumn";
                        "MyNumberColumn";                
                        "MyCurrencyColumn";
                        "MyHyperlinkColumn";
                        "MyCalculatedColumn";
                        "ContentType";
                    );
                    Query = [string]::Empty;
                    RowLimit = 30;
                    Paged = $true;
                    DefaultView = $true;
                }
            )
        },
        @{
            Title = "My Lookup List";
            Description = [string]::Empty;
            ListTemplateType = [Microsoft.SharePoint.SPListTemplateType]::GenericList;
            ForceCheckout = $false;
            EnableAttachments = $false;
            EnableFolderCreation = $false;
            EnableModeration = $false;
            EnableMinorVersions = $false;
            EnableVersioning = $false;
            ContentTypes = @(
                "My Lookup Item"
            );
            Views = @(
                @{
                    Name = "My View";
                    ViewFields = @(                       
                        "MyTextColumn";
                        "ContentType";                        
                    );
                    Query = [string]::Empty;
                    RowLimit = 30;
                    Paged = $true;
                    DefaultView = $true;
                }
            )
        },
        @{
            Title = "My Document Library";
            Description = [string]::Empty;
            ListTemplateType = [Microsoft.SharePoint.SPListTemplateType]::DocumentLibrary;
            ForceCheckout = $true;
            EnableAttachments = $false;
            EnableFolderCreation = $false;
            EnableModeration = $false;
            EnableMinorVersions = $true;
            EnableVersioning = $true;
            ContentTypes = @(
                "My Document"
            );
            Views = @(
                @{
                    Name = "My Documents";
                    ViewFields = @(
                        "DocIcon";
                        "LinkFilename";
                        "Title";
                        "Modified";
                        "Editor";
                        "MyTextColumn";
                        "MyMultiTextColumn";
                        "MyChoiceColumn";
                        "MyDateTimeColumn";
                        "MyBooleanColumn";
                        "MyPeopleColumn";
                        "MyNumberColumn";                
                        "MyCurrencyColumn";
                        "MyHyperlinkColumn";
                        "MyCalculatedColumn";
                        "ContentType";
                    );
                    Query = "<Where>
                                <Eq>
                                    <FieldRef Name='MyPeopleColumn' />
                                    <Value Type='Integer' >
                                        <UserID Type='Integer' />
                                    </Value>
                                </Eq>
                            </Where>";
                    RowLimit = 30;
                    Paged = $true;
                    DefaultView = $true;
                }
            )
        }
    )
    Lookups = @(
        @{
            InternalName = "MyLookupColumn";
            DisplayName = "My Lookup Column";
            Group = "My Columns"
            Required = $false;
            LookupList = "My Lookup List";
            LookupField = "MyTextColumn";
            ContentTypes = @(
                "My Item"
            )
            Views = @(
                @{
                    List = "My Custom List";
                    View = "My View";
                }
            )
        }
    )
    DataImports = @(
        @{
            List = "My Lookup List";
            Items = @(
                @{                    
                    MyTextColumn = "England";
                    ContentType = "My Lookup Item";
                },
                @{
                    Title = "Title";
                    MyTextColumn = "Scotland";
                    ContentType = "My Lookup Item";
                },
                @{                   
                    MyTextColumn = "Wales";
                    ContentType = "My Lookup Item";
                },
                @{                    
                    MyTextColumn = "N. Ireland";
                    ContentType = "My Lookup Item";
                },
                @{                    
                    MyTextColumn = "Ireland";
                    ContentType = "My Lookup Item";
                }
            )
        }
    )
    SecurityGroups = @(
        @{
            Name = "SharePoint Site DSC Visitors";
            Owner = "gt\garry.trinder"
            DefaultUser = "gt\adamb";
            Description = [string]::Empty;
            AllowMembersEditMembership = $false;
            AllowRequestToJoinLeave = $false;
            AutoAcceptRequestToJoinLeave = $false;
            OnlyAllowMembersViewMembership = $false;
            RequestToJoinLeaveEmailSetting = [string]::Empty;
            Users = @(
                "gt\stephed";
                "gt\olivief";
                "gt\michelf";
                "gt\arleneh";
                "gt\pieterw";
                "gt\erwinz";
                "gt\lukask";
                "gt\kene";
                "gt\justint";
                "gt\jong";
                "gt\job";
                "gt\hansg";
                "gt\davidb1";
                "gt\maried";
                "gt\kevink";
                "gt\kaia";
                "gt\manishc";
                "gt\sunilu";
                "gt\luisb";
            )
        },
        @{
            Name = "My Security Group";
            Owner = "gt\garry.trinder"
            DefaultUser = "gt\adamb";
            Description = [string]::Empty;
            AllowMembersEditMembership = $false;
            AllowRequestToJoinLeave = $false;
            AutoAcceptRequestToJoinLeave = $false;
            OnlyAllowMembersViewMembership = $false;
            RequestToJoinLeaveEmailSetting = [string]::Empty;            
            Users = @(
                "gt\danj";
                "gt\adamb";
                "gt\alans";
                "gt\chrisn";
                "gt\dianet";
                "gt\christk";
                "gt\frankm1";
                "gt\karimm";
                "gt\danp";
                "gt\jeffh";
                "gt\garthf";
                "gt\cesarg";
                "gt\christg";
                "gt\jackc";
                "gt\davidm";
                "gt\alanb";
                "gt\davids";
                "gt\annal";
                "gt\eduardd";
                "gt\spencel";
                "gt\kellyw";
                "gt\mollyc";
                "gt\larryz";
                "gt\arturol";
                "gt\aprils";
                "gt\aaronp";
                "gt\andrewm";
            )
        }        
    )
}

Export-ModuleMember -Variable config