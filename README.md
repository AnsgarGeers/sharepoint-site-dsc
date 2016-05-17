# SharePoint Site DSC
A script to configure a SharePoint Site which is based on the PowerShell Desired State Configuration (DSC) pattern.

The main objective is simple, execute a single script that takes in a configuration object and get the desired state for your SharePoint site.

##Usage

`SharePointTeamSite.ps1 -SiteUrl <siteurl> -DataFile <datafile>.psm1`

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
        }
    )
    
###Site Content Types

    ContentTypes = @(
        @{
            ContentTypeId = "$([Microsoft.SharePoint.SPBuiltInContentTypeId]::Item)0031E5BF2B4E904BC382EB1CA8506419E8";
            Name = "Base Item";
            Group = "Base Content Types";
        }
    )
    
###Lists

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


