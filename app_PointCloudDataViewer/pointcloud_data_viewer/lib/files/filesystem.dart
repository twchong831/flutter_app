import 'dart:convert';
import 'dart:io';

class FileSystem {
  String filename = '';
  String bPath = '';

  // FileSystem({
  //   required this.filename,
  // });

  void setLocalPath(String path) {
    bPath = path;
  }

  void setFileName(String name) {
    filename = name;
  }

  File get filePath {
    return File('$bPath/$filename');
  }

  // write file
  Future<File> write(var value) async {
    final file = filePath;
    // 파일 쓰기
    return file.writeAsString('$value');
  }

  // void readLoop() async {
  //   final File file;
  //   if (bPath.isNotEmpty) {
  //     file = File('$bPath/$filename');
  //   } else {
  //     file = await _localFile;
  //   }
  //   // contents = file.openRead();
  //   if (await file.exists()) {
  //     Stream<String> lines = file
  //         .openRead()
  //         .transform(utf8.decoder)
  //         .transform(const LineSplitter());

  //     try {
  //       await for (var line in lines) {
  //         print("$line: ${line.length}");
  //       }
  //     } catch (e) {
  //       print('Error : $e');
  //     }
  //   }
  // }

  // read file
  Future<Stream<String>> read() async {
    Stream<String> contents;
    final File file;
    if (bPath.isNotEmpty) {
      file = File('$bPath/$filename');
    } else {
      file = filePath;
    }
    // contents = file.openRead();
    if (await file.exists()) {
      try {
        // await for (var line in lines) {
        //   print("$line: ${line.length}");
        // }
        contents = file
            .openRead()
            .transform(utf8.decoder)
            .transform(const LineSplitter());

        file.deleteSync(); //delete
        return contents; //return
      } catch (e) {
        print('Error : $e');
        return const Stream.empty();
      }
    }
    return const Stream.empty();
  }

  Stream<String> readSync() {
    final File file = filePath;

    if (file.existsSync()) {
      try {
        Stream<String> contents = file
            .openRead()
            .transform(utf8.decoder)
            .transform(const LineSplitter());
        // file.deleteSync(); //delete file
        return contents;
      } catch (e) {
        print('Error : $e');
        return const Stream.empty();
      }
    } else {
      print("file not exists ${filePath.path}");
    }
    return const Stream.empty();
  }

  Future<String> getBasePath() async {
    return bPath;
  }
}
