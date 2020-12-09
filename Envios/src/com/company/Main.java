package com.company;

import java.sql.*;
import java.util.Scanner;


public class Main {

    public static void main(String[] args) throws SQLException {

        Gestora gestor = new Gestora();
        Scanner teclado = new Scanner(System.in);
        String respuesta = " ";

        gestor.showListShipping();

        do {

            System.out.println();
            System.out.println("Asignar los envios a los almacenes automaticamente (Si No) ");
            respuesta = teclado.nextLine();

        } while (!respuesta.toLowerCase().equals("si") && !respuesta.toLowerCase().equals("no"));

        if(respuesta.toLowerCase().equals("si")) {

            gestor.assignShipmentsToWarehouses();

        }


    }
}
