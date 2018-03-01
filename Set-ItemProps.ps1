# PS Script that sets the value of a list of fields
# Example of how to call this script
# $argumentList = @{'path'='/sitecore/content/home'
#				; 'templateId'='{AB59F27A-8CC9-4AE6-B9A9-DE649A94691F}'
#				; 'templateAttr'= @{'Field1' = 'Text value'
#							; 'Field2' = '1'
#							; 'Field3' = '{DADA3C82-7AA6-4265-951C-CAF63FBE17D3}'}};
#							
# Invoke-Script 'SampleScripts\Set-ItemProps' -ArgumentList $argumentList | Out-File C:\Scripts\Set-ItemProps.log

param($params);
$path = $($params.path);
$templateAttr = $($params.templateAttr);
$templateId = $($params.templateId);

if ($path -eq $null -or $path -eq '') {
	"'path' parameter is required";
	exit;
}

if ($templateAttr -eq $null) {
	"'templateAttr' parameter is required";
	exit;
}

if ($templateId -ne $null -and $templateId -ne '') {
	$queryPath = "$path/*[@@templateid='$templateId']";
} else {
	$queryPath = "$path/*";
}

$count = 0;
foreach($item in Get-Item -Path master: -Query $queryPath) {
	
	$item.Editing.BeginEdit();

	$templateAttr.GetEnumerator() | ForEach-Object {
		$item[$_.Name] = $_.Value;
	}	

	$item.Editing.EndEdit() | Out-Null;
	Write-Output "Item '$($item.ItemPath)' - DONE";
	++$count;
 }

 Write-Output "Total processed items: '$count'";