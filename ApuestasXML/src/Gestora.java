import javax.sound.sampled.Mixer;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.*;
import java.util.concurrent.Callable;


public class Gestora {

    private final Connection conexion;
    private Statement sentencia;
    private ResultSet resultado;
    private CallableStatement insertarApuestaTipo1;
    private CallableStatement insertarApuestaTipo2;
    private CallableStatement insertarApuestaTipo3;
    private final String sentenciaGanadoresPartidos1 =  "EXECUTE GrabarApuestaGanadoresPartidos ?, ?, ?, ?, ?, ?";
    private final String sentenciaInsertarApuestaTipo2 =  "EXECUTE GrabarApuestaOverUnder ?, ?, ?, ?, ?, ?, ?";
    private final String sentenciaInsertarApuestaTipo3 =  "EXECUTE GrabarApuestaHandicap ?, ?, ?, ?, ?, ?";

    public Gestora() throws SQLException {

        this.conexion = MiConexion.getConexion(); //Obtenemos la conexion a la base de datos
        this.sentencia = this.conexion.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE); //Objeto de tipo statment, los parametros sirven para poder actualizar con resultset

        this.insertarApuestaTipo1 = this.conexion.prepareCall(sentenciaGanadoresPartidos1); //Calleable statment sirve para llamar a procedimientos almacenamos
        this.insertarApuestaTipo2 = this.conexion.prepareCall(sentenciaInsertarApuestaTipo2);
        this.insertarApuestaTipo3 = this.conexion.prepareCall(sentenciaInsertarApuestaTipo3);

    }


    public int anadirApuestasTipo1(Apuesta apuesta) throws SQLException {

        this.insertarApuestaTipo1.setInt(1, apuesta.getIdUsuario());
        this.insertarApuestaTipo1.setInt(2, apuesta.getIdPartido());
        this.insertarApuestaTipo1.setBigDecimal(3, java.math.BigDecimal.valueOf(apuesta.getDineroApostado()));
        this.insertarApuestaTipo1.setTimestamp(4, java.sql.Timestamp.valueOf(apuesta.getFecha()));
        this.insertarApuestaTipo1.setString(5, apuesta.getResultado());
        this.insertarApuestaTipo1.registerOutParameter(6, Types.INTEGER); //Registramos el parametro de salida
        this.insertarApuestaTipo1.executeUpdate();
        int idApuesta = this.insertarApuestaTipo1.getInt(6);

        return idApuesta;

    }

    public int anadirApuestasTipo2(Apuesta apuesta) throws  SQLException {

        this.insertarApuestaTipo2.setInt(1, apuesta.getIdUsuario());
        this.insertarApuestaTipo2.setInt(2, apuesta.getIdPartido());
        this.insertarApuestaTipo2.setBigDecimal(3, java.math.BigDecimal.valueOf(apuesta.getDineroApostado()));
        this.insertarApuestaTipo2.setTimestamp(4, java.sql.Timestamp.valueOf(apuesta.getFecha()));
        this.insertarApuestaTipo2.setBoolean(5, apuesta.isOverUnder());
        this.insertarApuestaTipo2.setBigDecimal(6, java.math.BigDecimal.valueOf(apuesta.getNumero()));
        this.insertarApuestaTipo2.registerOutParameter(7, Types.INTEGER); //Registramos el parametro de salida
        this.insertarApuestaTipo2.executeUpdate();
        int idApuesta = this.insertarApuestaTipo2.getInt(7);

        return idApuesta;

    }

    public int anadirApuestasTipo3(Apuesta apuesta) throws SQLException {

        this.insertarApuestaTipo3.setInt(1, apuesta.getIdUsuario());
        this.insertarApuestaTipo3.setInt(2, apuesta.getIdPartido());
        this.insertarApuestaTipo3.setBigDecimal(3, java.math.BigDecimal.valueOf(apuesta.getDineroApostado()));
        this.insertarApuestaTipo3.setTimestamp(4, java.sql.Timestamp.valueOf(apuesta.getFecha()));
        this.insertarApuestaTipo3.setShort(5, apuesta.getHandicap());
        this.insertarApuestaTipo3.registerOutParameter(6, Types.INTEGER); //Registramos el parametro de salida
        this.insertarApuestaTipo3.executeUpdate();

        int idApuesta = this.insertarApuestaTipo3.getInt(6);

        return idApuesta;

    }

}
