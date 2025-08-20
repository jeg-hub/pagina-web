void main() {
  String palabra = "anita"; // INSERTA LA PALABRA AQUI
  if (esPalindromo(palabra)) {
    print("$palabra es un palíndromo.");
  } else {
    print("$palabra no es un palíndromo.");
  }
}

bool esPalindromo(String str) {
  String textoLimpio = str.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  String textoInvertido = textoLimpio.split('').reversed.join('');
  return textoLimpio == textoInvertido;
}