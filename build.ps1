#Build a new xml file
[xml]$doc = New-Object System.Xml.XmlDocument
#Create xml declaration
$doc.AppendChild($doc.CreateXmlDeclaration("1.0", "UTF-8", $null))
#Create root node (<FilterItems>)
$root = $doc.CreateElement("FilterItems")
$doc.AppendChild($root)
#Enumerate all txt files under current directory, build xml nodes
$files = Get-ChildItem $PWD -Filter "*.txt"
foreach ($file in $files) {
    #Concat rule texts with |
    $content = (Get-Content $file.FullName) -match "^.+?$" -join "|"
    #Create <FilterItem> node
    $node = $doc.CreateElement("FilterItem")
    $node.SetAttribute("Name", [System.IO.Path]::GetFileNameWithoutExtension($file.Name))
    $node.SetAttribute("IsRegex", $true)
    $cdata = $doc.CreateCDataSection($content)
    $node.AppendChild($cdata)
    $root.AppendChild($node)
}
#Save xml document into "filter.xml"
$doc.Save([System.IO.Path]::Combine($PWD, "filter.xml"))



