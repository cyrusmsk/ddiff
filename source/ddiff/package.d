module ddiff;

import std.stdio;
import std.getopt;
import gamut;
import ddiff.imgdiff: Options, Result, imageDiff;

void main(string[] args) {
    string filePath1, filePath2, filePathOutput;
    double threshold;
    bool diffImage;

    auto helpInfo = getopt(
        args,
        "file1", &filePath1,
        "file2", &filePath2,
        "output", &filePathOutput
    );

    if (helpInfo.helpWanted) {
        defaultGetoptPrinter("Simpe diff image CLI", helpInfo.options);
    } else {
        Image img1, img2;
        img1.loadFromFile(filePath1);
        img2.loadFromFile(filePath2);

        auto imgFormat = img1.identifyFormatFromFile(cast(const(char)*)filePath1);

        auto res = imageDiff(img1, img2, Options(0.1, true, imgFormat));
        if (res.equal) {
            writeln("Success! Images are equal.");
        } else {
            writeln("Images are different. Different pixels ", res.diffPixelsCount);
        }

        if (filePathOutput != "")
            (res.image).saveToFile(filePathOutput);
    }

}
