void main() {
  var raw = 'download/ssfn895090427336812694?sec=67cdadb");';
  var index = raw.lastIndexOf('sec=');
  var rightIndex = raw.indexOf(')', index);

  print(index);
  print(rightIndex);

  print(raw.substring(index + 4, rightIndex - 1));
}
