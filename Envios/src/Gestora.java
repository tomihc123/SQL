import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.*;



public class Gestora {

    private final Connection conexion;
    private Statement sentencia;
    private ResultSet resultado;


    public Gestora() throws SQLException {

        this.conexion = MiConexion.getConexion();
        this.sentencia = this.conexion.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);

    }

    public void showListShipping() throws SQLException {

        String sentencia = "SELECT * FROM Envios";

        this.resultado = this.sentencia.executeQuery(sentencia);

        while(this.resultado.next()) {


            System.out.println("NumContenedores"+" "+this.resultado.getString("NumeroContenedores") + "  " + "FechaAsignacion"+ "   " + this.resultado.getString("FechaAsignacion"));

        }

    }

    public void insertDataToShipping() throws SQLException {

        String sentencia = "SELECT * FROM Envios";

        this.resultado = this.sentencia.executeQuery(sentencia);

        this.resultado.moveToInsertRow();
        this.resultado.updateInt("ID", 60);
        this.resultado.updateInt("NumeroContenedores", 50);
        this.resultado.updateDate("FechaCreacion", java.sql.Date.valueOf("2018-04-03"));
        this.resultado.updateDate("FechaAsignacion", null);
        this.resultado.updateInt("AlmacenPreferido", 10);
        this.resultado.insertRow();

    }


    public void assignShipmentsToWarehouses() throws SQLException {

        String sentence = "SELECT * FROM Envios WHERE FechaAsignacion IS NULL";
        String senteceInsert = "INSERT INTO Asignaciones (IDEnvio, IDAlmacen) VALUES (?,?)";
        PreparedStatement insertAsignaciones = this.conexion.prepareStatement(senteceInsert);

        int shipmentId = 0;
        int warehouseId = 0;

        this.resultado = this.sentencia.executeQuery(sentence);

        while(this.resultado.next()) {

            shipmentId = this.resultado.getInt(("ID"));
            warehouseId = this.resultado.getInt(("AlmacenPreferido"));

            try {

                insertAsignaciones.setInt(1, shipmentId);
                insertAsignaciones.setInt(2, warehouseId);
                insertAsignaciones.executeUpdate();

            } catch (SQLException e) {

                e.printStackTrace();

            }


        }


    }


    private String getTodayDate()
    {

        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
        String stringDate = formatter.format(date);
        return stringDate;

    }

}