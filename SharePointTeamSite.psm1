Function Remove-SPSiteColumn($web, $config){

    try {
        $field = $web.Fields.GetFieldByInternalName($config.InternalName)
        $web.Fields.Delete($field)
        Start-Sleep -s 1
    } catch {
        #Column not found, move on
    }
}

Function Add-SPSiteColumn($web,$config){
    
    Remove-SPSiteColumn -web $web -config $config

    $spField = $null;    
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
            $spField.RichTextMode = $config.RichTextMode;         
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
    $contentType = $webContentTypes.Add($contentType);
    $contentType.Group = $config.Group;
    $contentType.Update();

    if($config.FieldLinks -ne $null){
        Add-SPFieldLinksToContentType -web $web -contentType $contentType -config $config
    }
    
}

Function Remove-SPContentTypes($web,$config){

    for($i=$config.ContentTypes.Length - 1; $i -ge 0; $i--){
        #$config.ContentTypes.Item($i);
        $contentType = $web.ContentTypes[$config.ContentTypes.Item($i).Name];
        if($contentType -ne $null){
            $web.ContentTypes.Delete($contentType.Id)
        }
    }
        
}

Function Add-SPList($web,$config){
    
    $listId = $web.Lists.Add($config.Title,$config.Description,$config.ListTemplateType);
    $list = $web.Lists.GetList($listId,$false);
    
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
        $list = $web.Lists.TryGetList($_.Title)
        if($list -ne $null){
            $web.Lists.Delete($list.ID)
        }    
    }
    
}

Function Add-SPLookupColumn($web,$config){

    Remove-SPSiteColumn -web $web -config $config

    $lookupList = $web.Lists.TryGetList($config.LookupList);
    $fieldName = $web.Fields.AddLookup($config.InternalName,$lookupList.ID,$config.Required)
    $spField = $web.Fields.GetFieldByInternalName($fieldName);
    $spField.Title = $config.DisplayName;
    $spField.Group = $config.Group;
    $spField.LookupField = $config.LookupField;
    $spField.Update();

    $config.ContentTypes | ForEach-Object {
        $fieldLink = New-Object Microsoft.SharePoint.SPFieldLink($spField);
        $web.ContentTypes[$_].FieldLinks.Add($fieldLink);
        $web.ContentTypes[$_].Update($true);
    }

    $config.Views | ForEach-Object {
        $list = $web.Lists.TryGetList($_.List);
        $view = $list.Views[$_.View]
        $view.ViewFields.Add($config.InternalName);
        $view.Update();
    }

}

Function Add-SPListData($web,$config){
    $list = $web.Lists.TryGetList($_.List);
    $collection = $null

    if ($config.Items -ne $null){
        $collection = $config.Items
    }

    if ($config.Csv -ne $null){
        $collection = Import-Csv -Path $config.Csv
    }

    $collection | ForEach-Object {
        $item = $_;
        $listItem = $list.Items.Add();
        $item.Keys | ForEach-Object { 
            $listItem[$_] = $item[$_]
        }
        $listItem.Update();
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

    $config.Users | ForEach-Object {
        $user = $web.EnsureUser($_);            
        $group.AddUser($user);
    }
}

Function Start-IABuilder($web,$config){

    Remove-SPLists -web $web -config $config
    Remove-SPContentTypes -web $web -config $config
    
    $config.Columns | ForEach-Object {
        Write-Progress -Activity "Creating Site Columns..." -Status "Progress > $($config.Columns.indexOf($_) + 1) of $($config.Columns.Count)" -PercentComplete (($($config.Columns.indexOf($_) +1)/$($config.Columns.Count)*100)) -CurrentOperation $_.InternalName
        Add-SPSiteColumn -web $web -config $_        
    }
    
    $config.ContentTypes | ForEach-Object {
        Write-Progress -Activity "Creating Site Content Types..." -Status "Progress > $($config.ContentTypes.indexOf($_) + 1) of $($config.ContentTypes.Count)" -PercentComplete (($($config.ContentTypes.indexOf($_) +1)/$($config.ContentTypes.Count)*100)) -CurrentOperation $_.Name
        Add-SPContentType -web $web -config $_
    }

    $config.Lists | ForEach-Object {
        Write-Progress -Activity "Creating Lists..." -Status "Progress > $($config.Lists.indexOf($_) + 1) of $($config.Lists.Count)" -PercentComplete (($($config.Lists.indexOf($_) +1)/$($config.Lists.Count)*100)) -CurrentOperation $_.Title
        Add-SPList -web $web -config $_
    }

    $config.Lookups | ForEach-Object {
        Write-Progress -Activity "Creating Site Lookup Columns..." -Status "Progress > $($config.Lookups.indexOf($_) + 1) of $($config.Lookups.Count)" -PercentComplete (($($config.Lookups.indexOf($_) +1)/$($config.Lookups.Count)*100)) -CurrentOperation $_.InternalName
        Add-SPLookupColumn -web $web -config $_
    }

    $config.DataImports | ForEach-Object {
        Write-Progress -Activity "Importing data..." -Status "Progress > $($config.DataImports.indexOf($_) + 1) of $($config.DataImports.Count)" -PercentComplete (($($config.DataImports.indexOf($_) +1)/$($config.DataImports.Count)*100)) -CurrentOperation $_.List
        Add-SPListData -web $web -config $_
    }

    $config.SecurityGroups | ForEach-Object {
        Write-Progress -Activity "Creating Security Groups..." -Status "Progress > $($config.SecurityGroups.indexOf($_) + 1) of $($config.SecurityGroups.Count)" -PercentComplete (($($config.SecurityGroups.indexOf($_) +1)/$($config.SecurityGroups.Count)*100)) -CurrentOperation $_.Name
        Add-SPSecurityGroup -web $web -config $_
    }
}

Export-ModuleMember -Function *