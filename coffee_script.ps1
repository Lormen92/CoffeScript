# Aggiungi l'assembly necessario per usare SendKeys
Add-Type -AssemblyName "System.Windows.Forms"

# Elenco dei tasti validi
$validKeys = @(
    "{F1}", "{F2}", "{F3}", "{F4}", "{F5}", "{F6}", "{F7}", "{F8}", "{F9}",
    "{F10}", "{F11}", "{F12}",
    "{ENTER}", "{TAB}", "{ESC}", "{SPACE}", "{BACKSPACE}",
    "{LEFT}", "{RIGHT}", "{UP}", "{DOWN}",
    "{SHIFT}", "{CONTROL}", "{ALT}", "{CAPSLOCK}", "{NUMLOCK}",
    "{SCROLLLOCK}", "{PAUSE}", "{BREAK}", "{INSERT}", "{DELETE}", "{HOME}", "{END}",
    "{PGUP}", "{PGDN}", "{PRINTSCREEN}", "{LWIN}", "{RWIN}", "{APPLICATION}",
    "{NUMPAD0}", "{NUMPAD1}", "{NUMPAD2}", "{NUMPAD3}", "{NUMPAD4}", "{NUMPAD5}", "{NUMPAD6}", "{NUMPAD7}", "{NUMPAD8}", "{NUMPAD9}",
    "{NUMPADENTER}", "{NUMPADPLUS}", "{NUMPADMINUS}", "{NUMPADMULTIPLY}", "{NUMPADDIVIDE}", "{NUMPADDECIMAL}",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", 
    "{+}", "{-}", "{=}", "{,}", "{.}",
    "{CONTROL}", "{ALT}", "{SHIFT}",
    "{TAB}", "{ENTER}"
)

# Funzione per caricare e validare il file config.json
function Get-ExecutionIntervalAndKey {
    $configFile = "config.json"
    $interval = $null
    $key = "{SCROLLLOCK}"  # Tasto predefinito SCROLLLOCK
    $double_press = $null  # Valore di default per double_press

    # Controlla se il file esiste
    if (Test-Path $configFile) {
        try {
            # Carica il contenuto del file JSON
            $config = Get-Content -Path $configFile | ConvertFrom-Json

            # Verifica se l'intervallo è valido
            if ($config.execution_interval -match '^\d+$' -and [int]$config.execution_interval -gt 0) {
                $interval = [int]$config.execution_interval
            } else {
                Write-Host "Campo 'execution_interval' non valido nel file config.json."
            }

            # Verifica se il tasto da premere è valido (se presente)
            if ($config.key_to_press -and $validKeys -contains $config.key_to_press) {
                $key = $config.key_to_press
            } else {
                Write-Host "Il tasto '$($config.key_to_press)' nel file config.json non è valido. Usando il tasto predefinito '{SCROLLLOCK}'."
            }

            # Verifica la configurazione di double_press, se presente
            if ($config.PSObject.Properties.Match('double_press')) {
                $double_press = $config.double_press
            }
        } catch {
            Write-Host "Errore durante la lettura del file config.json."
        }
    }

    # Se non hai un file o non hai la configurazione di double_press, imposta il valore per default
    if ($double_press -eq $null) {
        if ($key -eq "{SCROLLLOCK}") {
            $double_press = $true
        } else {
            $double_press = $false
        }
    }

    # Se l'intervallo non è stato trovato o è invalido, chiedi all'utente un valore
    if (-not $interval) {
        while ($true) {
            $userInput = Read-Host "Inserisci un intervallo di esecuzione in secondi (intero positivo)"
            
            # Verifica se l'input è un intero positivo
            if ($userInput -match '^\d+$' -and [int]$userInput -gt 0) {
                $interval = [int]$userInput
                break
            } else {
		Clear-Host  # Pulisce la finestra per ogni tentativo di input
                Write-Host "Valore non valido. Per favore inserisci un intero positivo."
            }
        }
    }

    return $interval, $key, $double_press
}

# Funzione per premere un tasto
function PressKey {
    param (
        [string]$keyToPress,
        [bool]$double_press
    )

    # Se la doppia pressione è abilitata
    if ($double_press) {
        [System.Windows.Forms.SendKeys]::SendWait($keyToPress)
        # Start-Sleep -Milliseconds 50  # Pausa breve tra le pressioni
        [System.Windows.Forms.SendKeys]::SendWait($keyToPress)
    } else {
        # Se la doppia pressione non è abilitata, premere il tasto una sola volta
        [System.Windows.Forms.SendKeys]::SendWait($keyToPress)
    }
}

# Funzione per stampare l'ASCII art
function Print-AsciiArt {
    $asciiArt = Get-Content -Path "ascii_art.txt" -Raw
    Write-Host $asciiArt
}

# Carica l'intervallo di esecuzione, il tasto da premere e la doppia pressione
$executionInterval, $keyToPress, $double_press = Get-ExecutionIntervalAndKey

# Mostra l'ASCII art
Print-AsciiArt

# Scrive il messaggio di esecuzione
Write-Host "`nLo script è in esecuzione. L'azione verrà eseguita ogni $executionInterval secondi. Per fermare lo script, puoi interromperlo con una combinazione di tasti o chiudere la finestra."

# Ciclo per simulare la pressione del tasto ogni intervallo
while ($true) {
    $secondsRemaining = $executionInterval
    while ($secondsRemaining -gt 0) {
        Clear-Host
        Print-AsciiArt
        Write-Host "`nLo script è in esecuzione. L'azione verrà eseguita ogni $executionInterval secondi."
        Write-Host "Next action in: $secondsRemaining seconds"
        Start-Sleep -Seconds 1
        $secondsRemaining--
    }

    PressKey $keyToPress $double_press
}
