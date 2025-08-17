# Comparison
Save imgdiff and odiff from release page of both projects

## Building ddiff:
```bash
dub build -b=release
mv ddiff comparison/ddiff.exe
```

## Getting other solutions
Use release page in GitHub of each project and your OS/architecture:

- imgdiff: https://github.com/n7olkachev/imgdiff/releases/tag/v1.0.0
- odiff: https://github.com/dmtrKovalenko/odiff/releases

## Command
Comparison of all solutions with `hyperfine`:
```bash
hyperfine -i -w 3 "odiff-macos-arm64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png" "ddiff.exe --file1='../data/www_cypress_io.png' --file2='../data/www_cypress_io.png'" "imgdiff-darwin-amd64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png"
```

Comparison of each solution:
```bash
/usr/bin/time ./ddiff.exe --file1='../data/www_cypress_io.png' --file2='../data/www_cypress_io.png'
```

```bash
/usr/bin/time ./imgdiff-darwin-amd64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png     
```

```bash
/usr/bin/time ./odiff-macos-arm64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png     
```
