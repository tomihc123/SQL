import java.util.Scanner;

public class Utilidades {

    static boolean deseaContinuar() {

        Scanner teclado = new Scanner(System.in);
        String respuesta = "";
        boolean continuar = false;

        do {

            respuesta = teclado.nextLine();

            if (respuesta.toLowerCase().equals("si")) {

                continuar = true;
            }

            if(!respuesta.toLowerCase().equals("si") && !respuesta.toLowerCase().equals("no")) {

                System.out.println();
                System.out.println("Introduzca si o no: ");

            }

        } while (!respuesta.toLowerCase().equals("si") && !respuesta.toLowerCase().equals("no"));

        return  continuar;

    }

}
