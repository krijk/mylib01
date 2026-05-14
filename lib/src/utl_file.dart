import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';

/// Sort Order
enum SortOrder {
  ///
  ascending,
  ///
  descending,
}

/// Return value of copy
enum RetCopy {
  ///
  success,
  ///
  warning,
  ///
  skipped,
  ///
  error,
}

/// Utilities for file and folder actions
abstract class FileUtils {
  /// Checks if the given path is within the protected source directory.
  /// Throws a SecurityException if protection is violated.
  static void _checkSafety(String targetPath) {
    // Should be override by each project
  }

  /// Returns file size in Megabytes (decimal: 1,000,000 bytes).
  static Future<double> getFileSizeMb(File file) async {
    final int sizeInBytes = await file.length();
    return sizeInBytes / 1000000;
  }

  /// Returns file size in bytes.
  static Future<int> getFileSizeBytes(String path) async {
    final File file = File(path);
    if (!await file.exists()) return 0;
    return file.length();
  }

  /// Folder name : The FullPath without the filename
  static String getDirectoryPath(String path) => p.dirname(path);

  /// Extracts the filename from a full path using the 'path' package.
  static String getFileNameFromPath(String path) => p.basename(path);

  /// Extract only the filename from the path
  static String getFileNameWithoutExtension(String path) => p.basenameWithoutExtension(path);

  /// Extracts the extension (without the dot) from a filepath.
  static String getExtension(String path) => p.extension(path).replaceFirst('.', '');

  /// Extracts the filename without its extension from a path.
  static String getOnlyFileName(String path) => p.basenameWithoutExtension(path);

  /// Unified file listing method.
  /// If a file extension is specified, a list of files with only that extension
  static Future<List<String>> listFiles(
    String path, {
    String? extension,
    SortOrder? sort,
    bool recursive = false,
    bool returnFullPath = false,
  }) async {
    final Directory dir = Directory(path);
    if (!await dir.exists()) return <String>[];

    final List<String> results = <String>[];
    await for (final FileSystemEntity entity in dir.list(recursive: recursive, followLinks: false)) {
      if (entity is! File) continue;

      final String filePath = entity.path;
      if (extension != null) {
        final String ext = p.extension(filePath).replaceFirst('.', '');
        if (ext.toLowerCase() != extension.toLowerCase()) continue;
      }

      results.add(returnFullPath ? filePath : p.basename(filePath));
    }

    if (sort != null) {
      results.sort((String a, String b) => sort == SortOrder.ascending ? a.compareTo(b) : b.compareTo(a));
    }
    return results;
  }

  /// Create a list of folders in a specified folder
  static Future<List<String>> listDirectories(
    String path, {
    String? filterName,
    SortOrder? sort,
    bool recursive = true,
  }) async {
    final Directory dir = Directory(path);
    if (!await dir.exists()) return <String>[];

    final List<String> results = <String>[];
    await for (final FileSystemEntity entity in dir.list(recursive: recursive, followLinks: false)) {
      if (entity is Directory) {
        if (filterName != null && p.basename(entity.path) != filterName) continue;
        results.add(entity.path);
      }
    }

    if (sort != null) {
      results.sort((String a, String b) => sort == SortOrder.ascending ? a.compareTo(b) : b.compareTo(a));
    }
    return results;
  }

  /// Read a text file
  static Future<String> readFile(String path) async {
    final File file = File(path);
    return await file.exists() ? await file.readAsString() : '';
  }

  /// Write a text file
  static Future<void> writeFile(String path, String contents) async {
    _checkSafety(path);
    await File(path).writeAsString(contents);
  }

  /// Copies a file using dart:io.
  /// Specify the full path for both src and dst
  /// If the dst folder does not exist, it will be created.
  static Future<File> copyFile({
    required File src,
    required File dst,
    bool preserve = true,
  }) async {
    _checkSafety(dst.path);
    await dst.parent.create(recursive: true);

    final File copiedFile = await src.copy(dst.path);
    if (preserve) {
      // 2. Sourceファイルの最終更新日時を取得してセット
      final DateTime srcModificationDate = src.lastModifiedSync();
      await copiedFile.setLastModified(srcModificationDate);
    }
    return copiedFile;
  }

  /// File copy by process run
  /// cp -aup srcFile dstFile
  static Future<bool> copyByProcessRun({required File src, required File dst, String option = '-aupP'}) async {
    final String cmd = 'cp'
        ' $option'
        ' "${src.path}"'
        ' "${dst.path}"';

    // -a, --archive                same as -dR --preserve=all
    // -d                           same as --no-dereference --preserve=links
    // -P, --no-dereference         never follow symbolic links in SOURCE
    // -R, -r, --recursive          copy directories recursively
    // -u, --update                 copy only when the SOURCE file is newer
    //                              than the destination file or when the
    //                              destination file is missing
    // -P, --no-dereference         never follow symbolic links in SOURCE
    // -p                           same as --preserve=mode,ownership,timestamps
    // --preserve[=ATTR_LIST]       preserve the specified attributes (default:
    //                              mode,ownership,timestamps), if possible
    //                              additional attributes: context, links, xattr, all
    final ShellLinesController streamStdOut = ShellLinesController();
    final ShellLinesController streamStdErr = ShellLinesController();
    final Shell shell = Shell(stdout: streamStdOut.sink, stderr: streamStdErr.sink);
    streamStdOut.stream.listen((String event) {
      // debugPrint('stdout:' + event);
    });
    streamStdErr.stream.listen((String event) {
      // debugPrint('stderr:' + event);
    });

    await shell.run(cmd);
    return true;
  }

  /// Updates target file if source is newer using atomic copy.
  static Future<InfoCopy> updateFile({
    required File src,
    required File dst,
    bool dryRun = false,
  }) async {
    if (!src.existsSync()) {
      return InfoCopy(copied: false, ret: RetCopy.error, message: 'Source missing');
    }

    // file copy check
    bool shouldCopy = false;
    RetCopy status = RetCopy.skipped;
    String message = '';

    if (!dst.existsSync()) {
      shouldCopy = true;
    } else {
      final DateTime srcDate = src.lastModifiedSync();
      final DateTime dstDate = dst.lastModifiedSync();
      if (srcDate.isAfter(dstDate)) {
        shouldCopy = true;
      } else if (srcDate.isBefore(dstDate)) {
        message = 'WARNING: Source is older than destination';
        status = RetCopy.warning;
      }
    }

    if (shouldCopy) {
      if (!dryRun) {
        await dst.parent.create(recursive: true);

        // Atomic Copy: Copy to a temporary file and then rename
        final String tmpPath = '${dst.path}.tmp';
        final File tmpFile = File(tmpPath);

        try {
          await copyFile(src: src, dst: tmpFile);
          // Rename (overwrite if an existing dst file exists)
          if (await dst.exists()) await dst.delete();
          await tmpFile.rename(dst.path);
        } catch (e) {
          if (await tmpFile.exists()) await tmpFile.delete();
          return InfoCopy(copied: false, ret: RetCopy.error, message: 'Copy failed: $e');
        }
      }
      return InfoCopy(copied: true, ret: RetCopy.success);
    }
    return InfoCopy(copied: false, ret: status, message: message);
  }

  /// Is Target newer than Source?
  /// false: not newer
  /// true: newer, the same or target not exists
  bool isNewer(File sourceFile, File targetFile) {
    if (!targetFile.existsSync()) {
      return true;
    }

    final DateTime dateSrc = sourceFile.lastModifiedSync();
    final DateTime dateDst = targetFile.lastModifiedSync();
    if (dateSrc.compareTo(dateDst) < 0) {
      return false;
    }
    return true;
  }

  /// Copy the entire source folder to target by process run
  /// EX: cp -r /home/sa/AndroidStudioFlutter/navi01/lib /home/sa/AndroidStudioFlutter/temp01
  static Future<bool> copyFolder(String sourcePath, String targetPath) async {
    if (!await isFolderExists(sourcePath)) {
      return false;
    }

    final String cmd = 'cp'
        ' -r'
        ' "$sourcePath"'
        ' "$targetPath"';

    final ShellLinesController streamStdOut = ShellLinesController();
    final ShellLinesController streamStdErr = ShellLinesController();
    final Shell shell = Shell(stdout: streamStdOut.sink, stderr: streamStdErr.sink);
    streamStdOut.stream.listen((String event) {
      // debugPrint('stdout:' + event);
    });
    streamStdErr.stream.listen((String event) {
      // debugPrint('stderr:' + event);
    });

    await shell.run(cmd);
    return true;
  }

  /// Make Directory by dart.io create
  static Future<void> md(File target, {bool recursive = true}) async {
    await target.parent.create(recursive: recursive);
  }

  /// Make Directory by dart.io create
  /// Check if target path exists in advance
  static Future<void> md0(String path, {bool recursive = true}) async {
    final Directory dir = Directory(path);
    if (await dir.exists()) {
      // debugPrint('DebugSA md exist');
      return;
    }
    // debugPrint('DebugSA md create');
    await dir.create(recursive: recursive);
  }

  /// mkdir by process_run
  static Future<bool> mkDir(String targetPath) async {
    if (await isFolderExists(targetPath)) {
      return true;
    }

    final String cmd = 'mkdir'
        ' -p' // recursive create
        ' "$targetPath"';

    final ShellLinesController streamStdOut = ShellLinesController();
    final ShellLinesController streamStdErr = ShellLinesController();
    final Shell shell = Shell(stdout: streamStdOut.sink, stderr: streamStdErr.sink);
    streamStdOut.stream.listen((String event) {
      // debugPrint('stdout:' + event);
    });
    streamStdErr.stream.listen((String event) {
      // debugPrint('stderr:' + event);
    });

    await shell.run(cmd);
    return true;
  }

  /// Remove(Delete) file
  static Future<void> deleteFile(File file) async {
    _checkSafety(file.path);
    if (await file.exists()) await file.delete();
  }

  /// Remove(Delete) directory
  static Future<void> deleteDirectory(Directory dir, {bool recursive = false}) async {
    _checkSafety(dir.path);
    if (await dir.exists()) await dir.delete(recursive: recursive);
  }

  /// Moves a file, attempting rename first for performance.
  static Future<File> moveFile(File source, String newPath, {bool preserve = true}) async {
    _checkSafety(newPath);
    try {
      debugPrint('moveFile(): try to rename as it is probably faster');
      return await source.rename(newPath);
    } on FileSystemException {
      debugPrint('moveFile(): Fallback for moving across partitions');
      final File newFile = await copyFile(src: source, dst: File(newPath), preserve: preserve);
      await source.delete();
      return newFile;
    }
  }

  /// Check if the folder specified in `Path` exists
  static Future<bool> isFolderExists(String path) async {
    final bool exists = await Directory(path).exists();
    return exists;
  }
}

/// Copy action result information
class InfoCopy {
  /// Whether copy action was executed
  final bool copied;

  /// copy result
  final RetCopy ret;

  /// Error/Warning message
  final String message;

  /// Copy action result information
  InfoCopy({required this.copied, required this.ret, this.message = ''});
}
