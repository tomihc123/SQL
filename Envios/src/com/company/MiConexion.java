package com.company;

import java.sql.*;

public class MiConexion {

    private static final String sourceURL = "jdbc:sqlserver://localhost";
    private static final String usuario = "pepito";
    private static final String password = "qq";

    public static Connection getConexion() throws SQLException {
        // Carga la clase del driver. Lo comentamos porque no es necesario a partir de Java 6
        //Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        // Cadena de conexión
        // Connection es una interface, no una clase
        Connection conexionBaseDatos = DriverManager.getConnection(sourceURL, usuario, password);

        return conexionBaseDatos;

    }

    public static void cerrar ( ResultSet rs ) throws SQLException {
        rs.close();
    }
    public static void cerrar ( Statement st ) throws SQLException {
        st.close();
    }
    public static void cerrar (Connection con) throws SQLException {
        con.close();
    }

}
