$ESC = [char]0x1b

enum OutputRendering {
    Host
    PlainText
    Ansi
}

enum ProgressView {
    Minimal
    Classic
}

class ForegroundColor {
    [string]$Black         = "${ESC}[30m"
    [string]$BrightBlack   = "${ESC}[90m"
    [string]$White         = "${ESC}[37m"
    [string]$BrightWhite   = "${ESC}[97m"
    [string]$Red           = "${ESC}[31m"
    [string]$BrightRed     = "${ESC}[91m"
    [string]$Magenta       = "${ESC}[35m"
    [string]$BrightMagenta = "${ESC}[95m"
    [string]$Blue          = "${ESC}[34m"
    [string]$BrightBlue    = "${ESC}[94m"
    [string]$Cyan          = "${ESC}[36m"
    [string]$BrightCyan    = "${ESC}[96m"
    [string]$Green         = "${ESC}[32m"
    [string]$BrightGreen   = "${ESC}[92m"
    [string]$Yellow        = "${ESC}[33m"
    [string]$BrightYellow  = "${ESC}[93m"

    [string]FromRGB ([byte]$r, [byte]$g, [byte]$b) {
        $ESC = [char]0x1b
        return "${ESC}[38;2;${r};${g};${b}m"
    }

    [string]FromRGB ([uint32]$rgb) {
        $ESC = [char]0x1b
        [byte]$r = ($rgb -band 0x00ff0000) -shr 16
        [byte]$g = ($rgb -band 0x0000ff00) -shr 8
        [byte]$b = ($rgb -band 0x000000ff)
        return "${ESC}[38;2;${r};${g};${b}m"
    }
}

class BackgroundColor {
    [string]$Black         = "${ESC}[40m"
    [string]$BrightBlack   = "${ESC}[100m"
    [string]$White         = "${ESC}[47m"
    [string]$BrightWhite   = "${ESC}[107m"
    [string]$Red           = "${ESC}[41m"
    [string]$BrightRed     = "${ESC}[101m"
    [string]$Magenta       = "${ESC}[45m"
    [string]$BrightMagenta = "${ESC}[105m"
    [string]$Blue          = "${ESC}[44m"
    [string]$BrightBlue    = "${ESC}[104m"
    [string]$Cyan          = "${ESC}[46m"
    [string]$BrightCyan    = "${ESC}[106m"
    [string]$Green         = "${ESC}[42m"
    [string]$BrightGreen   = "${ESC}[102m"
    [string]$Yellow        = "${ESC}[43m"
    [string]$BrightYellow  = "${ESC}[103m"

    [string]FromRGB ([byte]$r, [byte]$g, [byte]$b) {
        $ESC = [char]0x1b
        return "${ESC}[48;2;${r};${g};${b}m"
    }

    [string]FromRGB ([uint32]$rgb) {
        $ESC = [char]0x1b
        [byte]$r = ($rgb -band 0x00ff0000) -shr 16
        [byte]$g = ($rgb -band 0x0000ff00) -shr 8
        [byte]$b = ($rgb -band 0x000000ff)
        return "${ESC}[48;2;${r};${g};${b}m"
    }
}

class FormattingData {
    [string]$FormatAccent           = "${ESC}[32;1m"
    [string]$ErrorAccent            = "${ESC}[36;1m"
    [string]$Error                  = "${ESC}[31;1m"
    [string]$Warning                = "${ESC}[33;1m"
    [string]$Verbose                = "${ESC}[33;1m"
    [string]$Debug                  = "${ESC}[33;1m"
    [string]$TableHeader            = "${ESC}[32;1m"
    [string]$CustomTableHeaderLabel = "${ESC}[32;1;3m"
    [string]$FeedbackProvider       = "${ESC}[33m"
    [string]$FeedbackText           = "${ESC}[96m"
}

class ProgressConfiguration {
    [string]$Style         = "${ESC}[33;1m"
    [int]$MaxWidth         = 120
    [ProgressView ]$View   = [ProgressView]::Minimal
    [bool]$UseOSCIndicator = $false
}

class FileInfoFormatting {
    [string]$Directory       = "${ESC}[44;1m"
    [string]$SymbolicLink    = "${ESC}[36;1m"
    [string]$Executable      = "${ESC}[32;1m"
    [hashtable[]]$Extension  = @(
        @{'.zip'    = "${ESC}[31;1m"},
        @{'.tgz'    = "${ESC}[31;1m"},
        @{'.gz'     = "${ESC}[31;1m"},
        @{'.tar'    = "${ESC}[31;1m"},
        @{'.nupkg'  = "${ESC}[31;1m"},
        @{'.cab'    = "${ESC}[31;1m"},
        @{'.7z'     = "${ESC}[31;1m"},
        @{'.ps1'    = "${ESC}[33;1m"},
        @{'.psd1'   = "${ESC}[33;1m"},
        @{'.psm1'   = "${ESC}[33;1m"},
        @{'.ps1xml' = "${ESC}[33;1m"}
    )
}

class PSStyle {
    [string]$Reset                    = "${ESC}[0m"
    [string]$BlinkOff                 = "${ESC}[25m"
    [string]$Blink                    = "${ESC}[5m"
    [string]$BoldOff                  = "${ESC}[22m"
    [string]$Bold                     = "${ESC}[1m"
    [string]$DimOff                   = "${ESC}[22m"
    [string]$Dim                      = "${ESC}[2m"
    [string]$Hidden                   = "${ESC}[8m"
    [string]$HiddenOff                = "${ESC}[28m"
    [string]$Reverse                  = "${ESC}[7m"
    [string]$ReverseOff               = "${ESC}[27m"
    [string]$ItalicOff                = "${ESC}[23m"
    [string]$Italic                   = "${ESC}[3m"
    [string]$UnderlineOff             = "${ESC}[24m"
    [string]$Underline                = "${ESC}[4m"
    [string]$StrikethroughOff         = "${ESC}[29m"
    [string]$Strikethrough            = "${ESC}[9m"
    [OutputRendering]$OutputRendering = [OutputRendering]::Host
    [FormattingData]$Formatting       = [FormattingData]::new()
    [ProgressConfiguration]$Progress  = [ProgressConfiguration]::new()
    [FileInfoFormatting]$FileInfo     = [FileInfoFormatting]::new()
    [ForegroundColor]$Foreground      = [ForegroundColor]::new()
    [BackgroundColor]$Background      = [BackgroundColor]::new()

    [string]FormatHyperlink([string]$text, [Uri]$link) {
        $ESC = [char]0x1b
        return "${ESC}]8;;${link}${ESC}\${text}${ESC}]8;;${ESC}\"
    }

}


$PSStyle = [PSStyle]::new()

Export-ModuleMember -Variable PSStyle
