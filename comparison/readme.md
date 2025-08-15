# Comparison
Save imgdiff and odiff from release page of both projects

## Command
Comparison of all solutions with `hyperfine`:
```bash
hyperfine -i -w 3 "odiff-macos-arm64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png" "ddiff-par --file1='../data/www_cypress_io.png' --file2='../data/www_cypress_io.png'" "imgdiff-darwin-amd64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png"
```

Comparison of each solution:
```bash
/usr/bin/time ./ddiff --file1='../data/www_cypress_io.png' --file2='../data/www_cypress_io.png'
```

```bash
/usr/bin/time ./imgdiff-darwin-amd64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png     
```

```bash
/usr/bin/time ./odiff-macos-amd64.exe ../data/www_cypress_io.png ../data/www_cypress_io.png     
```
