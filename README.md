# SharePoint Site DSC
A script to configure a SharePoint Site which is based on the PowerShell Desired State Configuration (DSC) pattern.

The main objective is simple, execute a single script that takes in a configuration object and get the desired state for your SharePoint site.

##Usage

`SharePointSiteDSC.ps1 -SiteUrl <siteurl> -DataFile <datafile>.psm1`

##Support
(So far) the script supports the creation of the following through configuration

  * Site Columns
    - Text
    - Multi Text (Plain, Rich Text, HTML)
    - User
    - Date Time
    - Yes\No
    - Number
    - Hyperlink
    - Currency
    - Calculated
  * Site Content Types
  * Lists
    - Creates new Views
  * Lookup Fields
  * Security Groups
    - Creates new and updates existing
    - Adds collection of users to groups
  * Data Import
    - List Items via PSObject
    - List Items via CSV Import

##Configuration Examples

###Site Columns

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
    
###Site Content Types

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
        }
    )
    
###Lists

    Lists = @(
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
    
###Lookup Fields

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

###Security Groups

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
        }
    )

###Data Import

    DataImports = @(
        @{
            List = "My Lookup List";
            Items = @(
                @{
                    MyTextColumn = "England";
                    ContentType = "My Lookup Item";
                },
                @{
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
        },
        @{
            List = "My List";
            Csv = "MyCsv.csv";
        }
    )


