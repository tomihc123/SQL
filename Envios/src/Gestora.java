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

        this.conexion = MiConexion.getConexion(); //Obtenemos la conexion a la base de datos
        this.sentencia = this.conexion.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE); //Objeto de tipo statment, los parametros sirven para poder actualizar con resultset

    }

/*

Entradas: Ninguna
Salidas: Ninguna
Muestra por pantalla todos los envios

*/

    public void mostrarListadoEnvios() throws SQLException {

        String sentencia = "SELECT ID, NumeroContenedores, FechaAsignacion FROM Envios"; //EL query

        this.resultado = this.sentencia.executeQuery(sentencia); // Execute query porque devuelve una tabla

        while(this.resultado.next()) { //Recorremos la tabla

            //Obtenemos los datos de las columnas con los result set
            System.out.println("IDEnvio"+ " "+this.resultado.getInt("ID") + "  " + "NumContenedores"+" "+this.resultado.getString("NumeroContenedores") + "  " + "FechaAsignacion"+ "   " + this.resultado.getString("FechaAsignacion"));

        }

    }


/*

Entradas: Ninguna
Salidas: Ninguna
Inserta los envios en las asignaciones

*/

    private void insertarEnviosEnAsignaciones() throws SQLException {

        String senteceInsert = "INSERT INTO Asignaciones (IDEnvio, IDAlmacen) VALUES (?,?)"; //La sentencia con parametros que despues asignaremos
        PreparedStatement insertAsignaciones = this.conexion.prepareStatement(senteceInsert);

        insertAsignaciones.setInt(1, this.resultado.getInt("ID")); //Obtenemos el ID (Envio) de la fila en la que se encuentra el result set
        insertAsignaciones.setInt(2, this.resultado.getInt("AlmacenPreferido")); //Obtenemos el AlmacenPreferido del envio en la fila en la que se encuentra el result set
        insertAsignaciones.executeUpdate(); //Ejecutamos la sentencia

    }

    /*

    Metodo sobreescrito que inserta un envio en asignaciones pero con un almacen distinto a su preferido,
    por lo tanto recibe como parametro el nuevoAlmacen al que se va a asignar


     */

    private void insertShipmentsToAsignations(int nuevoAlmacen) throws SQLException {

        String senteceInsert = "INSERT INTO Asignaciones (IDEnvio, IDAlmacen) VALUES (?,?)";
        PreparedStatement insertAsignaciones = this.conexion.prepareStatement(senteceInsert);

        insertAsignaciones.setInt(1, this.resultado.getInt("ID"));
        insertAsignaciones.setInt(2, nuevoAlmacen);
        insertAsignaciones.executeUpdate();

    }


    public void asignarEnviosParaAlmacenes() throws SQLException {

        String sentence = "SELECT ID, NumeroContenedores, FechaAsignacion, AlmacenPreferido FROM Envios WHERE FechaAsignacion IS NULL"; //El query para saber todos los enviios que tenemos que asignar

        this.resultado = this.sentencia.executeQuery(sentence);

        while(this.resultado.next()) { //Recorremos con el result set los envios sin asignar

            try { //No veo muy bien que una excepcion forme parte del flujo del programa pero no veia otra forma

                insertarEnviosEnAsignaciones(); //Intentamos asignar en asignaciones si no se puede saltara una excepcion del trigger
                actualizarEnvio(); //Si no ha saltado la excepcion actualizamos la fecha de envio

            } catch (SQLException e) {

                preguntarNuevoAlmacen(); //Para ese envio no se ha podido insertar en su almacen preferido luego preguntamos al usuario por otro alternativo mas cercano y con espacio

            }
        }
    }


    /*
    Entradas: Ninguna
    Salidas: String
    Proposito: Nos devolvera un String con la fecha actual en el formato que indicamos yyyy-MM-dd
     */

    private String getTodayDate()
    {

        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String stringDate = formatter.format(date);
        return stringDate;

    }

    private void actualizarEnvio() throws SQLException {

        //Actualizamos con result set, nos posicionamos en la fila que esta actualmente, en la columna fechaAsignacion y cogemos la fecha de hoy
        this.resultado.updateDate("FechaAsignacion", java.sql.Date.valueOf(getTodayDate()));
        this.resultado.updateRow();

    }

    private void preguntarNuevoAlmacen() throws SQLException {

        System.out.println();
        System.out.println("El envio "+this.resultado.getInt("ID")+" se quedo sin espacio para su almacen preferido "+this.resultado.getInt("AlmacenPreferido"));
        System.out.println("Desea asignarlo al almacen mas cercano con espacio disponible el cual es "+obtenerAlmacenMasCercanoConEspacio());
        if(Utilidades.deseaContinuar()) {

            insertShipmentsToAsignations(obtenerAlmacenMasCercanoConEspacio()); //Insertamos el envio que ha dado error en un nuevo almacen
            actualizarEnvio(); //Actualizamos ese envio

        }

    }

    private int obtenerAlmacenMasCercanoConEspacio() throws SQLException {

        String sentencia = "EXECUTE almacenMasCercanoConEspacio ?, ?, ?";
        CallableStatement almacenMasCercanoConEspacio = this.conexion.prepareCall(sentencia); //Calleable statment sirve para llamar a procedimientos almacenamos
        almacenMasCercanoConEspacio.setInt(1, this.resultado.getInt("AlmacenPreferido")); //Parametro de nuestro procedimiento indicando de que almacen partimos
        almacenMasCercanoConEspacio.setInt(2, this.resultado.getInt("NumeroContenedores")); //Pasamos el numero de contenedores que tenemos
        almacenMasCercanoConEspacio.registerOutParameter(3, Types.INTEGER); //Registramos el parametro de salida
        almacenMasCercanoConEspacio.executeUpdate();
        int almacenDisponible = almacenMasCercanoConEspacio.getInt(3);

        return almacenDisponible; //Devolvemos el almacen disponible

    }

}
