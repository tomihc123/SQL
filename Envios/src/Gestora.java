import javax.sound.sampled.Mixer;
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


            System.out.println("IDEnvio"+ " "+this.resultado.getInt("ID") + "  " + "NumContenedores"+" "+this.resultado.getString("NumeroContenedores") + "  " + "FechaAsignacion"+ "   " + this.resultado.getString("FechaAsignacion"));

        }

    }

    public void insertShipmentsToAsignations() throws SQLException {

        String senteceInsert = "INSERT INTO Asignaciones (IDEnvio, IDAlmacen) VALUES (?,?)";
        PreparedStatement insertAsignaciones = this.conexion.prepareStatement(senteceInsert);

        insertAsignaciones.setInt(1, this.resultado.getInt("ID"));
        insertAsignaciones.setInt(2, this.resultado.getInt("AlmacenPreferido"));
        insertAsignaciones.executeUpdate();

    }

    public void insertShipmentsToAsignations(int nuevoAlmacen) throws SQLException {

        String senteceInsert = "INSERT INTO Asignaciones (IDEnvio, IDAlmacen) VALUES (?,?)";
        PreparedStatement insertAsignaciones = this.conexion.prepareStatement(senteceInsert);

        insertAsignaciones.setInt(1, this.resultado.getInt("ID"));
        insertAsignaciones.setInt(2, nuevoAlmacen);
        insertAsignaciones.executeUpdate();

    }


    public void assignShipmentsToWarehouses() throws SQLException {

        String sentence = "SELECT * FROM Envios WHERE FechaAsignacion IS NULL";

        this.resultado = this.sentencia.executeQuery(sentence);

        while(this.resultado.next()) {

            try {

                insertShipmentsToAsignations();
                updateShipments();

            } catch (SQLException e) {

                askNewWarehouse();

            }
        }
    }


    private String getTodayDate()
    {

        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String stringDate = formatter.format(date);
        return stringDate;

    }

    private void updateShipments() throws SQLException {

        this.resultado.updateDate("FechaAsignacion", java.sql.Date.valueOf(getTodayDate()));
        this.resultado.updateRow();

    }

    private void askNewWarehouse() throws SQLException {

        System.out.println();
        System.out.println("El envio "+this.resultado.getInt("ID")+" se quedo sin espacio para su almacen preferido "+this.resultado.getInt("AlmacenPreferido"));
        System.out.println("Desea asignarlo al almacen mas cercano con espacio disponible el cual es "+getClosetWarehouseWithDisponibility());
        if(Utilidades.deseaContinuar()) {

            insertShipmentsToAsignations(getClosetWarehouseWithDisponibility());
            updateShipments();

        }

    }

    private int getClosetWarehouseWithDisponibility() throws SQLException {

        String sentencia = "EXECUTE almacenMasCercanoConEspacio ?, ?, ?";
        CallableStatement almacenMasCercanoConEspacio = this.conexion.prepareCall(sentencia);
        almacenMasCercanoConEspacio.setInt(1, this.resultado.getInt("AlmacenPreferido"));
        almacenMasCercanoConEspacio.setInt(2, this.resultado.getInt("NumeroContenedores"));
        almacenMasCercanoConEspacio.registerOutParameter(3, Types.INTEGER);
        almacenMasCercanoConEspacio.executeUpdate();
        int almacenDisponible = almacenMasCercanoConEspacio.getInt(3);

        return almacenDisponible;

    }

}
