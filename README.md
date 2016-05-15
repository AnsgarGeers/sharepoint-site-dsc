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
  * Lookup Fields
  * Data Import
    - List Items via PSObject

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

###Data Import

    DataImports = @(
        @{
            List = "My Lookup List";
            Items = @(
                @{
                    Title = "Title";
                    MyTextColumn = "England";
                    ContentType = "My Lookup Item";
                },
                @{
                    Title = "Title";
                    MyTextColumn = "Scotland";
                    ContentType = "My Lookup Item";
                },
                @{
                    Title = "Title";
                    MyTextColumn = "Wales";
                    ContentType = "My Lookup Item";
                },
                @{
                    Title = "Title";
                    MyTextColumn = "N. Ireland";
                    ContentType = "My Lookup Item";
                },
                @{
                    Title = "Title";
                    MyTextColumn = "Ireland";
                    ContentType = "My Lookup Item";
                }
            )
        }
    )


