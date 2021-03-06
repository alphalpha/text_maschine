import java.io.FilenameFilter;

class FileNameFilter implements FilenameFilter {
  FileNameFilter(String regExp) {
    this.regExp = regExp;
  }

  @Override
  public boolean accept(File dir, String name) {
    return match(name, this.regExp) != null;
  }

  private String regExp;
}
  
String[] listFilenames(String dir, String regExp) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list(new FileNameFilter(regExp));
    return sort(names);
  } else {
    return null;
  }
}

int stringToInt(String number) {
  return Integer.parseInt(number.replaceFirst("^0+(?!$)", ""));
}

StringDict getText(String path, String filename, String[] languages) throws Exception {
  filename = listFilenames(path, filename)[0];
  if (filename.isEmpty()) { throw new Exception("No Welcome file!"); }
  
  println("Read Text from file: " + filename);
  String[] lines = loadStrings(path + filename);
 
  StringDict texts = new StringDict();
  int lineNumber = 0;
  int index = 0;
  while (index < languages.length)
  {
    String[] text = match(lines[lineNumber], "(" + languages[index] + ")@(.*)");
    if (text == null) { throw new Exception(filename + ": No text for " + languages[index] + "!"); }
    ++lineNumber;
    ++index;
    while (lineNumber < lines.length && match(lines[lineNumber], "@") == null) {
      text[2] = text[2] + "\n" + lines[lineNumber];
      ++lineNumber;
    }
    texts.set(text[1], text[2]);
}
  
  return texts;
}