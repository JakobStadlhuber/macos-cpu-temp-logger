# OSX CPU Temp Logger

Outputs and logs CPU temperature for MacOS over a specific period of time.

## Usage 

```bash
sh start-recording.sh [min] [-f] [-F] [-p]
```

or

```bash
chmod +x start-recording.sh
./start-recording.sh [min] [-f] [-F] [-p]
```


###  example

```bash
sh start-recording.sh 10 -f
```
Output:
```
Current temperature: 51,8
Current RPM: 200
Current temperature: 51,4
Current RPM: 210
```
rpm.txt
```
200
210
```

temp.txt
```
51,8
51,4
```
### Options

 * `<min>` How long should the program run/log in minutes (default 1 minute).
 * `-f` Output and log fan speed (not default).
 * `-F` Output and log temperature in Fahrenheit (default is Celsius).
 * `-p` Change to point separator (default is comma seperator).

## Maintainer 

Jakob Stadlhuber <office@jakobstadlhuber.com>

### Fork
 https://github.com/lavoiesl/osx-cpu-temp
