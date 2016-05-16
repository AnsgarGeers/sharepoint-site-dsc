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
    - Set and update FieldLinks
  * Lists
    - Views
  * Lookup Fields
    - List in current web only
    - Add to specified collection of Content Types
    - Add to specified collection of List Views
  * Data Import
    - Create List Items via PSObject

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
            FieldLinks = @(
                @{
                    InternalName = "Title";
                    DisplayName = "Title";
                    Required = $false;
                    Hidden = $true;
                    ShowInDisplayForm = $false;
                }
            )
        },   
        @{
            ContentTypeId = "$([Microsoft.SharePoint.SPBuiltInContentTypeId]::Item)0031E5BF2B4E904BC382EB1CA8506419E8007B2EF077CF754EB6A937B68DF53400D1";
            Name = "My Item";
            Group = "My Content Types";
            FieldLinks = @(                
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


