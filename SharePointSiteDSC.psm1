Function Remove-SPSiteColumn($web, $config){
    try {
        $field = $web.Fields.GetFieldByInternalName($config.InternalName);
        $field.Delete();
        Write-Host $config.InternalName -ForegroundColor Cyan
    } catch {
        Write-Warning "[CATCH] Unable to remove $($config.InternalName)";
    }
}

Function Add-SPSiteColumn($web,$config){

    $fieldName = $web.Fields.Add($config.InternalName,$config.FieldType,$config.Required,$false,$config.Choices); 
    $spField = $web.Fields.GetFieldByInternalName($fieldName);
    
    $spField.Title = $config.DisplayName;
    $spField.Description = $config.Description;
    $spField.Group = $config.Group;
    $spField.Required = $config.Required;
    $spField.DefaultValue = $config.DefaultValue;
    $spField.DefaultFormula = $config.DefaultFormula;

    if ($Config.EnforceUniqueValues -eq $true){
        $spField.Indexed = $true;
         $spfield.EnforceUniqueValues = $config.EnforceUniqueValues;
    }
    
    switch ($spField.TypeAsString){
        "DateTime" {
            $spField.DisplayFormat = $config.DateFormat;
        }
        "User" { 
            $spField.SelectionMode = $config.SelectionMode;
        }
        "Number" {
            $spField.DisplayFormat = $config.DisplayFormat;
            $spField.MinimumValue = $config.MinimumValue;
            $spField.MaximumValue = $config.MaximumValue;
            $spField.ShowAsPercentage = $config.ShowAsPercentage;
        }   
        "Note" {
            $spField.UnlimitedLengthInDocumentLibrary = $config.UnlimitedLengthInDocumentLibrary;
            $spField.NumberOfLines = $config.NumberOfLines;
            $spField.RichText = $config.RichText;
            if ($spField.RichText -eq $true){                
                $spField.RichTextMode = $config.RichTextMode;
            }                     
            $spField.AppendOnly = $config.AppendOnly; 
        }
        "Currency" {
            $spField.CurrencyLocaleId = $config.CurrencyLocaleId;
            $spField.DisplayFormat = $config.DisplayFormat;
            $spField.MinimumValue = $config.MinimumValue;
            $spField.MaximumValue = $config.MaximumValue;
        }
        "Url" {
            $spField.DisplayFormat = $config.DisplayFormat;
        }
        "Calculated"{
            $spField.Formula = $config.Formula;
            $spField.OutputType = $config.OutputType;
        }
        default {}
    }

    $spField.Update();

}

Function Add-SPFieldLinksToContentType($web,$contentType,$config){
 
    $config.FieldLinks | ForEach-Object {
        $exists = $web.Fields.ContainsField($_.InternalName);
        if ($exists){
            $field = $web.Fields.GetFieldByInternalName($_.InternalName);
            $fieldLink = $contentType.FieldLinks[$_.InternalName]
            if ($fieldLink -eq $null){
                $fieldLink = New-Object Microsoft.SharePoint.SPFieldLink($field);     
                $fieldLink.DisplayName = $_.DisplayName;
                $fieldLink.Hidden = $_.Hidden;
                $fieldLink.Required = $_.Required;    
                $contentType.FieldLinks.Add($fieldLink);
            }else{
                $fieldLink.DisplayName = $_.DisplayName;
                $fieldLink.Hidden = $_.Hidden;
                $fieldLink.Required = $_.Required;    
            }           
            
            $contentType.Update();            
        }
    }
}

Function Add-SPContentType($web,$config){

    $webContentTypes = $web.ContentTypes;
    $contentTypeId = New-Object Microsoft.SharePoint.SPContentTypeId($config.ContentTypeId);
    $contentType = New-Object Microsoft.SharePoint.SPContentType($contentTypeId,$webContentTypes,$config.Name);
    $contentType = $web.ContentTypes.Add($contentType);
    $contentType.Group = $config.Group;
    $contentType.Update();

    if ($config.FieldLinks -ne $null){
        Add-SPFieldLinksToContentType -web $web -contentType $contentType -config $config
    }

    $web.Update();
}

Function Remove-SPContentTypes($web,$config){
    
    for($i=$config.ContentTypes.Length - 1; $i -ge 0; $i--){       
        Write-Host $config.ContentTypes.Item($i).Name -ForegroundColor Blue
        $contentType = $web.ContentTypes[$config.ContentTypes.Item($i).Name];
        if ($contentType -ne $null){            
            try{
                $web.ContentTypes.Delete($contentType.Id)
            }
            catch{
                [Microsoft.SharePoint.SPContentTypeUsage]::GetUsages($contentType) | ForEach-Object { $_.Url }                
            }            
        }
    }        
}

Function Add-SPList($web,$config){
    
    $listId = $web.Lists.Add($config.Title.Replace(" ",[string]::Empty),$config.Description,$config.ListTemplateType);
    $list = $web.Lists.GetList($listId,$false);
    
    $list.Title = $config.Title;
    $list.ForceCheckout = $config.ForceCheckout;
    $list.EnableAttachments = $config.EnableAttachments;
    $list.EnableFolderCreation = $config.EnableFolderCreation;
    $list.EnableModeration = $config.EnableModeration;
    $list.EnableMinorVersions = $config.EnableMinorVersions;
    $list.EnableVersioning = $config.EnableVersioning;
    if ($config.ContentTypes -ne $null){
        $list.ContentTypesEnabled = $true;
        $defaultContentType = $list.ContentTypes[0]
        $config.ContentTypes | ForEach-Object {
            $ct = $list.ContentTypes.Add($web.ContentTypes[$_])
        }
        $list.ContentTypes.Delete($defaultContentType.Id)
    }

    if ($config.Views -ne $null){
        $config.Views | ForEach-Object {
            $view = $list.Views.Add($_.Name,$_.ViewFields,$_.Query,$_.RowLimit,$_.Paged,$_.DefaultView)
        }
    }

    $list.Update()

}

Function Remove-SPLists($web,$config){
    
    $config.Lists | ForEach-Object {        
        $list = $web.Lists[$_.Title]
        if($list -ne $null){
            Write-Host $list.Title -ForegroundColor Magenta;
            $web.Lists.Delete($list.ID);
        }    
    }
    
}

Function Add-SPLookupColumn($web,$config){

    $lookupList = $web.Lists.TryGetList($config.LookupList);
    $fieldName = $web.Fields.AddLookup($config.InternalName,$lookupList.ID,$config.Required)
    $spField = $web.Fields.GetFieldByInternalName($fieldName);
    $spField.Title = $config.DisplayName;
    $spField.Group = $config.Group;
    $spField.LookupField = $config.LookupField;
    $spField.Update();

    if ($config.ContentTypes -ne $null){
        $config.ContentTypes | ForEach-Object {
            $fieldLink = New-Object Microsoft.SharePoint.SPFieldLink($spField);
            $web.ContentTypes[$_].FieldLinks.Add($fieldLink);
            $web.ContentTypes[$_].Update($true);
        }
    }

    if($config.Views -ne $null){
        $config.Views | ForEach-Object {
            $list = $web.Lists.TryGetList($_.List);
            $view = $list.Views[$_.View]
            $view.ViewFields.Add($config.InternalName);
            $view.Update();
        }
    }
}

Function Add-SPListData($web,$config){
    $list = $web.Lists.TryGetList($config.List);

    if ($config.Items -ne $null){
        $config.Items | ForEach-Object {
            $item = $_;
            $listItem = $list.Items.Add();
            $item.Keys | ForEach-Object { 
                $listItem[$_] = $item[$_]
            }
            $listItem.Update();
        }
    }

    if ($config.Csv -ne $null){
        $items = Import-Csv -Path $config.Csv
        $items | ForEach-Object {
            $item = $_;
            $listItem = $list.Items.Add();
            $_.psobject.properties | ForEach-Object {
                $listItem[$_.Name] = $_.Value;
            }
            $listItem.Update();
        }
    }

    if ($config.Documents -ne $null){
        $config.Documents | ForEach-Object {
            $bytes = Get-Content $_.PathToLocalDocument -Encoding Byte -ReadCount 0;
            $file = $list.RootFolder.Files.Add(
                $_.FileName,
                $bytes,
                $_.Properties,
                $web.EnsureUser($_.CreatedBy),
                $web.EnsureUser($_.ModifiedBy),
                $_.TimeCreated,
                $_.TimeModified,      
                $_.Overwrite   
            )

            if ($_.ContentType -ne $null){
                $file.Item[[Microsoft.SharePoint.SPBuiltInFieldId]::ContentType] = $_.ContentType;
                $file.Item.SystemUpdate($false);
            }
            
            if ($list.EnableVersioning -and $list.EnableMinorVersions){
                $file.Publish([string]::Empty);
            }

            if ($_.IsTemplate -ne $null){
                if($_.IsTemplate){
                    $contentType = $web.ContentTypes[$_.ContentType];
                    $contentType.DocumentTemplate = $file.ServerRelativeUrl;
                    $contentType.Update($true);
                }
            }
        }
    }    
}

Function Add-SPSecurityGroup($web, $config){

    $group = $web.SiteGroups.GetByName($config.Name);
    $owner = $web.EnsureUser($config.Owner);
    $defaultUser = $web.EnsureUser($config.DefaultUser);

    if ($group -eq $null){        
        $web.SiteGroups.Add($config.Name, $owner, $defaultUser, $config.Description);
        $web.Update();
        $group = $web.SiteGroups.GetByName($config.Name);
    }

    $group.Owner = $owner;    
    $group.Description = $config.Description;
    $group.AllowMembersEditMembership = $config.AllowMembersEditMembership;
    $group.AllowRequestToJoinLeave = $config.AllowRequestToJoinLeave;
    $group.AutoAcceptRequestToJoinLeave = $config.AutoAcceptRequestToJoinLeave;
    $group.OnlyAllowMembersViewMembership = $config.OnlyAllowMembersViewMembership;
    $group.RequestToJoinLeaveEmailSetting = $config.RequestToJoinLeaveEmailSetting;
    $group.Update();

    $users = $group.Users;
    if ($users.Count -gt 0){
        $users | ForEach-Object {
            $group.RemoveUser($_);
        }
    }

    if($config.Users -ne $null){
        $config.Users | ForEach-Object {
            $user = $web.EnsureUser($_);            
            $group.AddUser($user);
        }
    }
}

Function Remove-SPSiteColumns($web,$config){
    
    if($config.Columns -ne $null){
        $config.Columns | ForEach-Object {
            Remove-SPSiteColumn -web $web -config $_
        }
    }
    
    if($config.Lookups -ne $null){
        $config.Lookups | ForEach-Object {
            Remove-SPSiteColumn -web $web -config $_
        }
    }
    
}

Function Start-IABuilder($web,$config){

    Write-Host "Cleanup..." -ForegroundColor Yellow;
    Remove-SPLists -web $web -config $config;
    Remove-SPContentTypes -web $web -config $config;
    Remove-SPSiteColumns -web $web -config $config;
    Write-Host "Cleanup completed... Processing configuration..." -ForegroundColor Yellow;

    if($config.Columns -ne $null){
        $config.Columns | ForEach-Object {
            Write-Progress -Activity "Creating Site Columns..." -Status "Progress > $($config.Columns.indexOf($_) + 1) of $($config.Columns.Count)" -PercentComplete (($($config.Columns.indexOf($_) +1)/$($config.Columns.Count)*100)) -CurrentOperation $_.InternalName
            Add-SPSiteColumn -web $web -config $_        
        }
    }
    
    if($config.ContentTypes -ne $null){
        $config.ContentTypes | ForEach-Object {
            Write-Progress -Activity "Creating Site Content Types..." -Status "Progress > $($config.ContentTypes.indexOf($_) + 1) of $($config.ContentTypes.Count)" -PercentComplete (($($config.ContentTypes.indexOf($_) +1)/$($config.ContentTypes.Count)*100)) -CurrentOperation $_.Name
            Add-SPContentType -web $web -config $_
        }
    }
    if($config.Lists -ne $null){
        $config.Lists | ForEach-Object {
            Write-Progress -Activity "Creating Lists..." -Status "Progress > $($config.Lists.indexOf($_) + 1) of $($config.Lists.Count)" -PercentComplete (($($config.Lists.indexOf($_) +1)/$($config.Lists.Count)*100)) -CurrentOperation $_.Title
            Add-SPList -web $web -config $_
        }
    }
    if($config.Lookups -ne $null){
        $config.Lookups | ForEach-Object {
            Write-Progress -Activity "Creating Site Lookup Columns..." -Status "Progress > $($config.Lookups.indexOf($_) + 1) of $($config.Lookups.Count)" -PercentComplete (($($config.Lookups.indexOf($_) +1)/$($config.Lookups.Count)*100)) -CurrentOperation $_.InternalName
            Add-SPLookupColumn -web $web -config $_
        }
    }
    if($config.DataImports -ne $null){
        $config.DataImports | ForEach-Object {
            Write-Progress -Activity "Importing data..." -Status "Progress > $($config.DataImports.indexOf($_) + 1) of $($config.DataImports.Count)" -PercentComplete (($($config.DataImports.indexOf($_) +1)/$($config.DataImports.Count)*100)) -CurrentOperation $_.List
            Add-SPListData -web $web -config $_
        }
    }
    if($config.SecurityGroups -ne $null){
        $config.SecurityGroups | ForEach-Object {
            Write-Progress -Activity "Creating Security Groups..." -Status "Progress > $($config.SecurityGroups.indexOf($_) + 1) of $($config.SecurityGroups.Count)" -PercentComplete (($($config.SecurityGroups.indexOf($_) +1)/$($config.SecurityGroups.Count)*100)) -CurrentOperation $_.Name
            Add-SPSecurityGroup -web $web -config $_
        }
    }
    Write-Host "Finished..." -ForegroundColor Green;
}

Export-ModuleMember -Function *