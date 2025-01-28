
# CoffeScript
A script to prevent the computer from going to sleep.

## Description

CoffeScript is a PowerShell script designed to prevent your computer from going to sleep by simulating key presses at regular intervals. It can be customized through a configuration file to choose which key to simulate and how frequently the action should be executed.

## How It Works

The script runs in a loop, performing a simulated key press action at the interval specified in the configuration file. The action can be executed with a single key press or a double key press, depending on the chosen configuration.

### Core Functionality:

1. **Execution Interval**: The time interval between each key press simulation is defined in the configuration file, or it will be requested from the user during execution.
   
2. **Key Selection**: You can choose the key to simulate by modifying the value in the configuration file. It can be a function key, navigation key, or an alphanumeric key.
   
3. **Double Press**: The configuration allows you to choose whether the key should be pressed twice consecutively (i.e., a double press).

4. **Configuration File**: The `config.json` file is used to set the execution interval and the key to simulate.

## Configuration File Usage

The `config.json` file must be located in the same directory as the script. It allows you to define the following parameters:

- **execution_interval**: The time interval in seconds between each simulated key press.
- **key_to_press**: The key to be simulated.
- **double_press**: A boolean value (`true` or `false`) to define whether the key should be pressed twice consecutively.

### Example of `config.json`:

```json
{
    "execution_interval": 30,
    "key_to_press": "{SCROLLLOCK}",
    "double_press": true
}
```

- **execution_interval**: Set to 10 seconds, the script will simulate the key press every 30 seconds.
- **key_to_press**: Set to `{SCROLLLOCK}`, the script will simulate pressing the SCROLLLOCK key.
- **double_press**: Set to `true`, the script will simulate a double press of the SCROLLLOCK key.

### If the `config.json` file is missing or contains invalid values, the script will prompt the user for an execution interval and assume default values for the key to press.

## List of Valid Keys

The following keys can be used in the `key_to_press` field in the configuration file. Specify the key exactly as shown in the list:

### Function Keys:
- `"{F1}"`, `"{F2}"`, `"{F3}"`, `"{F4}"`, `"{F5}"`, `"{F6}"`, `"{F7}"`, `"{F8}"`, `"{F9}"`, `"{F10}"`, `"{F11}"`, `"{F12}"`

### Navigation and Control Keys:
- `"{ENTER}"`, `"{TAB}"`, `"{ESC}"`, `"{SPACE}"`, `"{BACKSPACE}"`, `"{LEFT}"`, `"{RIGHT}"`, `"{UP}"`, `"{DOWN}"`, `"{HOME}"`, `"{END}"`, `"{PGUP}"`, `"{PGDN}"`, `"{INSERT}"`, `"{DELETE}"`, `"{PAUSE}"`, `"{BREAK}"`, `"{NUMLOCK}"`, `"{CAPSLOCK}"`, `"{SCROLLLOCK}"`, `"{PRINTSCREEN}"`, `"{LWIN}"`, `"{RWIN}"`, `"{APPLICATION}"`

### Numpad Keys:
- `"{NUMPAD0}"`, `"{NUMPAD1}"`, `"{NUMPAD2}"`, `"{NUMPAD3}"`, `"{NUMPAD4}"`, `"{NUMPAD5}"`, `"{NUMPAD6}"`, `"{NUMPAD7}"`, `"{NUMPAD8}"`, `"{NUMPAD9}"`, `"{NUMPADENTER}"`, `"{NUMPADPLUS}"`, `"{NUMPADMINUS}"`, `"{NUMPADMULTIPLY}"`, `"{NUMPADDIVIDE}"`, `"{NUMPADDECIMAL}"`

### Alphanumeric Keys:
- `"a"`, `"b"`, `"c"`, `"d"`, `"e"`, `"f"`, `"g"`, `"h"`, `"i"`, `"j"`, `"k"`, `"l"`, `"m"`, `"n"`, `"o"`, `"p"`, `"q"`, `"r"`, `"s"`, `"t"`, `"u"`, `"v"`, `"w"`, `"x"`, `"y"`, `"z"`, `"0"`, `"1"`, `"2"`, `"3"`, `"4"`, `"5"`, `"6"`, `"7"`, `"8"`, `"9"`

### Other Keys:
- `"{+}"`, `"{-}"`, `"{=}"`, `"{,}"`, `"{.}"`

## Running the Script

To run the script, you can use the `start.bat` file, which is included in the project directory. The `start.bat` file will handle the execution of the PowerShell script by setting the appropriate execution policy.

### Explanation of `start.bat`:

The `start.bat` file is structured as follows:

```bat
@echo off
REM Get the batch file's directory path
set BAT_DIR=%~dp0

REM Start PowerShell, set the execution policy, run the PowerShell script, and exit
powershell -NoExit -ExecutionPolicy Bypass -Command "& '%BAT_DIR%coffee_script.ps1'"
```

### How It Works:
1. **`set BAT_DIR=%~dp0`**: This command retrieves the directory path where the `start.bat` file is located.
2. **`powershell -NoExit -ExecutionPolicy Bypass -Command "& '%BAT_DIR%coffee_script.ps1'"`**: This command runs PowerShell, bypasses the execution policy to allow the script to run, and executes the `coffee_script.ps1` script.

This setup is necessary to allow the execution of PowerShell scripts, as the default security policy on Windows may block the execution of unsigned scripts. The `-ExecutionPolicy Bypass` argument temporarily overrides this restriction.

Simply double-click `start.bat` to run the script.

