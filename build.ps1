#运行此脚本，需要安装 PowerShell Core (支持Windows/macOS/Linux)
#下载地址： https://github.com/PowerShell/PowerShell/releases

#此脚本将读取当面目录下所有 .txt 文件的内容，并将所有规则合并后输出为一个 filter.xml 文件，格式与 sample.xml 相同

#建立一个新的 XmlDocument 文档
[xml]$doc = New-Object System.Xml.XmlDocument
#创建 XML 声明
$doc.AppendChild($doc.CreateXmlDeclaration("1.0", "utf-8", $null))
#创建根节点 (<FilterItems>)
$root = $doc.CreateElement("FilterItems")
$doc.AppendChild($root)
#遍历当前目录下所有 *.txt 文件，生成 xml 节点
$files = Get-ChildItem $PWD -Filter "*.txt"
foreach ($file in $files) {
    #使用 | 字符将文件内容拼接起来
    $content = (Get-Content $file.FullName) -match "^.+?$" -join "|"
    #创建 <FilterItem> 节点
    $node = $doc.CreateElement("FilterItem")
    $node.SetAttribute("Name", [System.IO.Path]::GetFileNameWithoutExtension($file.Name))
    $node.SetAttribute("IsRegex", $true)
    $cdata = $doc.CreateCDataSection($content)
    $node.AppendChild($cdata)
    $root.AppendChild($node)
}
#将 XML 文档保存到 filter.xml 文件中
$doc.Save([System.IO.Path]::Combine($PWD, "filter.xml"))



