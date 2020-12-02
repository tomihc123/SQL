import java.sql.*;


public class Main {

    public static void main(String[] args) throws SQLException {

        Gestora gestor = new Gestora();

        gestor.showListShipping();

        gestor.assignShipmentsToWarehouses();

    }
}
