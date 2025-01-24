# Add the necessary assembly to use SendKeys
Add-Type -AssemblyName "System.Windows.Forms"

# List of valid keys
$validKeys = @(
    # Function keys
    "{F1}", "{F2}", "{F3}", "{F4}", "{F5}", "{F6}", "{F7}", "{F8}", "{F9}",
    "{F10}", "{F11}", "{F12}",

    # Navigation and control keys
    "{ENTER}", "{TAB}", "{ESC}", "{SPACE}", "{BACKSPACE}",
    "{LEFT}", "{RIGHT}", "{UP}", "{DOWN}",

    # Modifier keys
    "{SHIFT}", "{CONTROL}", "{ALT}", "{CAPSLOCK}", "{NUMLOCK}",
    "{SCROLLLOCK}", "{PAUSE}", "{BREAK}", "{INSERT}", "{DELETE}", "{HOME}", "{END}",
    "{PGUP}", "{PGDN}", "{PRINTSCREEN}", "{LWIN}", "{RWIN}", "{APPLICATION}",

    # Additional function keys
    "{NUMPAD0}", "{NUMPAD1}", "{NUMPAD2}", "{NUMPAD3}", "{NUMPAD4}", "{NUMPAD5}", "{NUMPAD6}", "{NUMPAD7}", "{NUMPAD8}", "{NUMPAD9}",
    "{NUMPADENTER}", "{NUMPADPLUS}", "{NUMPADMINUS}", "{NUMPADMULTIPLY}", "{NUMPADDIVIDE}", "{NUMPADDECIMAL}",

    # Alphanumeric keys
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", 
    "{+}", "{-}", "{=}", "{,}", "{.}",

    # System keys
    "{CONTROL}", "{ALT}", "{SHIFT}",
    "{TAB}", "{ENTER}"
)

# Function to load and validate the config.json file
function Get-ExecutionIntervalAndKey {
    $configFile = "config.json"
    $interval = $null
    $key = "{SCROLLLOCK}"  # Default key SCROLLLOCK
    $double_press = $null  # Default value for double_press

    # Check if the file exists
    if (Test-Path $configFile) {
        try {
            # Load the content of the JSON file
            $config = Get-Content -Path $configFile | ConvertFrom-Json

            # Verify if the interval is valid
            if ($config.execution_interval -match '^\d+$' -and [int]$config.execution_interval -gt 0) {
                $interval = [int]$config.execution_interval
            } else {
                Write-Host "Invalid 'execution_interval' field in the config.json file."
            }

            # Verify if the key to press is valid (if present)
            if ($config.key_to_press -and $validKeys -contains $config.key_to_press) {
                $key = $config.key_to_press
            } else {
                Write-Host "The key '$($config.key_to_press)' in the config.json file is invalid. Using the default key '{SCROLLLOCK}'."
            }

            # Verify the double_press configuration, if present
            if ($config.PSObject.Properties.Match('double_press')) {
                $double_press = $config.double_press
            }
        } catch {
            Write-Host "Error reading the config.json file."
        }
    }

    # If there is no file or no double_press configuration, set the default value
    if ($double_press -eq $null) {
        if ($key -eq "{SCROLLLOCK}") {
            $double_press = $true
        } else {
            $double_press = $false
        }
    }

    # If the interval was not found or is invalid, prompt the user for a value
    if (-not $interval) {
        while ($true) {
            $userInput = Read-Host "Enter an execution interval in seconds (positive integer)"
            
            # Check if the input is a positive integer
            if ($userInput -match '^\d+$' -and [int]$userInput -gt 0) {
                $interval = [int]$userInput
                break
            } else {
                Clear-Host  # Clear the screen for every input attempt
                Write-Host "Invalid value. Please enter a positive integer."
            }
        }
    }

    return $interval, $key, $double_press
}

# Function to press a key
function PressKey {
    param (
        [string]$keyToPress,
        [bool]$double_press
    )

    # If double press is enabled
    if ($double_press) {
        [System.Windows.Forms.SendKeys]::SendWait($keyToPress)
        # Start-Sleep -Milliseconds 50  # Short pause between presses
        [System.Windows.Forms.SendKeys]::SendWait($keyToPress)
    } else {
        # If double press is not enabled, press the key only once
        [System.Windows.Forms.SendKeys]::SendWait($keyToPress)
    }
}

# Function to print the ASCII art
function Print-AsciiArt {
    $asciiArt = Get-Content -Path "ascii_art.txt" -Raw
    Write-Host $asciiArt
}

# Load the execution interval, key to press, and double press
$executionInterval, $keyToPress, $double_press = Get-ExecutionIntervalAndKey

# Display the ASCII art
Print-AsciiArt

# Write the execution message
Write-Host "`nThe script is running. The action will be performed every $executionInterval seconds. To stop the script, you can press CTRL+C or close the window."

# Loop to simulate pressing the key at the specified interval
while ($true) {
    $secondsRemaining = $executionInterval
    while ($secondsRemaining -gt 0) {
        Clear-Host
        Print-AsciiArt
        Write-Host "`nThe script is running. The action will be performed every $executionInterval seconds."
        Write-Host "Next action in: $secondsRemaining seconds"
        Start-Sleep -Seconds 1
        $secondsRemaining--
    }

    PressKey $keyToPress $double_press
}
