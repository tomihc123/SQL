import java.sql.SQLException;

public class Main {

	public static void main(String[] args)  {

		String nombreArchivo = "XML\\Apuestas.xml";

			try {
				PruebaSAX1 probando = new PruebaSAX1(nombreArchivo);
				probando.andale();

			} catch(SQLException e) {
				e.printStackTrace();
			}

	}// Fin main

}
