if (!(Test-Path .\out\module)) {
    $null = md .\out\module
}

$clobber = Test-Path .\out\module\VssAdmin.psd1

Export-CrescendoModule -ConfigurationFile VssAdmin.crescendo.v1.1.config.json -ModuleName .\out\module\VssAdmin.psm1 -Force -NoClobberManifest:$clobber

dir .\out\module