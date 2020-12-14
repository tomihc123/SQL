import java.sql.*;
import java.util.Scanner;


public class Main {

    public static void main(String[] args) throws SQLException {

        Gestora gestor = new Gestora();
        gestor.mostrarListadoEnvios();

        System.out.println();
        System.out.println("Asignar los envios a los almacenes automaticamente (Si No) ");

        if(Utilidades.deseaContinuar()) {

            gestor.assignShipmentsToWarehouses();
            gestor.mostrarListadoEnvios();

        }

    }
}
