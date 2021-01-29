import java.util.Scanner;

public class Utilidades {

    static boolean deseaContinuar() {

        Scanner teclado = new Scanner(System.in);
        String respuesta = "";
        boolean continuar = false;

        do {

            respuesta = teclado.nextLine(); //Leemos lo que introduce el usuario

            if (respuesta.toLowerCase().equals("si")) { //Si la respuesta es si

                continuar = true;
            }

            if(!respuesta.toLowerCase().equals("si") && !respuesta.toLowerCase().equals("no")) { //Si el usuario no introduce ni si ni no, mostramos mensaje de ayuda

                System.out.println();
                System.out.println("Introduzca si o no: ");

            }

        } while (!respuesta.toLowerCase().equals("si") && !respuesta.toLowerCase().equals("no"));

        return  continuar;

    }

}
