# Comparison with other solutions

To run the comparison save `imgdiff` and `odiff` from release page of both projects

Without saving files:
```bash
Summary
  ./odiff-macos-arm64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png ran
    1.20 ± 0.01 times faster than ./ddiff.exe --file1='../data/www_cypress_io.png' --file2='../data/www_cypress_io.png'
    2.07 ± 0.01 times faster than ./imgdiff-darwin-amd64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png
```

With saving diff file:
```bash
Summary
  ./ddiff.exe --file1='../data/water-4k.png' --file2='../data/water-4k-2.png' --output='./ddiff-out.png' ran
    1.65 ± 0.02 times faster than ./imgdiff-darwin-amd64.exe ../data/water-4k.png ../data/water-4k-2.png ./imgdiff-out.png
    1.92 ± 0.01 times faster than ./odiff-macos-arm64.exe ../data/water-4k.png ../data/water-4k-2.png ./odiff-out.png
```

## Building ddiff:
```bash
dub build -b=release
mv ddiff comparison/ddiff.exe
```

## Getting other solutions
Use release page in GitHub of each project and your OS/architecture:

- imgdiff [release page](https://github.com/n7olkachev/imgdiff/releases/tag/v1.0.0)
- odiff [release page](https://github.com/dmtrKovalenko/odiff/releases)

## Command
Comparison of all solutions with `hyperfine`

without saving diff on cypress file:
```bash
hyperfine -r 3 -w 2 "./odiff-macos-arm64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png" "./ddiff.exe --file1='../data/www_cypress_io.png' --file2='../data/www_cypress_io.png'" "./imgdiff-darwin-amd64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png"
```

with saving diff on water-4k file:
```bash
hyperfine -i -r 3 -w 2 "./odiff-macos-arm64.exe ../data/water-4k.png ../data/water-4k-2.png odiff-out.png" "./ddiff.exe --file1='../data/water-4k.png' --file2='../data/water-4k-2.png' --output='ddiff-out.png'" "./imgdiff-darwin-amd64.exe ../data/water-4k.png ../data/water-4k-2.png imgdiff-out.png"
```

Comparison of a single solution:
```bash
/usr/bin/time ./ddiff.exe --file1='../data/www_cypress_io.png' --file2='../data/www_cypress_io.png'
```

```bash
/usr/bin/time ./imgdiff-darwin-amd64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png
```

```bash
/usr/bin/time ./odiff-macos-arm64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png
```
