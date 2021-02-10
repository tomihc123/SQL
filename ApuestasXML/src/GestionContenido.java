
/**
 *
 * @author Leo
 */
import org.xml.sax.helpers.*;
import org.xml.sax.*;

import java.net.SocketTimeoutException;
import java.sql.SQLException;

public class GestionContenido extends DefaultHandler {

    private Apuesta apuesta;
    private boolean esUsuario, esPartido, esImporte, esFecha, esResultado, overHunder, numero, handicap;
    private Gestora gestoraSql;

    public GestionContenido()  {
        super();
        this.esUsuario = false;
        this.esPartido = false;
        this.esImporte = false;
        this.esFecha = false;
        this.esResultado = false;
        apuesta = new Apuesta();
        try {
            gestoraSql = new Gestora();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    @Override
    public void startDocument(){
        System.out.println("Comienzo del documento XML");
    }
    @Override
    public void endDocument(){
        System.out.println("Fin del documento XML");
    }
    @Override
    public void startElement(String uri, String nombre, String nombreC, Attributes att){

        switch(nombreC) {

            case "idusuario":
                this.esUsuario = true;
                break;
            case "idpartida":
                    this.esPartido = true;
                break;
            case "importe":
                    this.esImporte = true;
                break;
            case "fecha":
                this.esFecha = true;
                break;
            case "resultado":
                this.esResultado = true;
                break;
            case "overhunder":
                    this.overHunder = true;
                break;
            case "numero":
                this.numero = true;
                break;

            case "handicap":
                this.handicap = true;
                break;
        }

    }
    @Override
    public void endElement(String uri, String nombre, String nombreC){

       switch (nombreC) {

           case "apuestatipo1":

               try {
                   System.out.println("Apuesta tipo 1 insertada con id "+this.gestoraSql.anadirApuestasTipo1(this.apuesta));
                   this.apuesta = new Apuesta();
               } catch (SQLException throwables) {
                   throwables.printStackTrace();
               }

               break;

           case "apuestatipo2":
               try {
                   System.out.println("Apuesta tipo 2 insertada con id "+this.gestoraSql.anadirApuestasTipo2(this.apuesta));
               } catch (SQLException throwables) {
                       throwables.printStackTrace();
               }

               break;

           case "apuestatipo3":
               try {
                   System.out.println("Apuesta tipo 3 insertada con id "+this.gestoraSql.anadirApuestasTipo3(this.apuesta));
               } catch (SQLException throwables) {
                       throwables.printStackTrace();
               }

       }


    }
    @Override
    public void characters (char[] ch, int inicio, int longitud)
            throws SAXException {
        String cad = new String(ch, inicio, longitud);
        cad = cad.replaceAll("[\t\n]",""); // Quitamos tabuladores y saltos de linea

        if(this.esUsuario) {
            apuesta.setIdUsuario(Integer.parseInt(cad));
            this.esUsuario = false;
        }
        if(this.esPartido) {
            apuesta.setIdPartido(Integer.parseInt(cad));
            this.esPartido = false;
        }
        if(this.esImporte) {
            apuesta.setDineroApostado(Double.parseDouble(cad));
            this.esImporte = false;
        }
        if(this.esFecha) {
            apuesta.setFecha(cad);
            this.esFecha = false;
        }
        if(this.esResultado) {
            apuesta.setResultado(cad);
            this.esResultado = false;
        }
        if(this.overHunder) {
            apuesta.setOverUnder(Boolean.getBoolean(cad));
            this.overHunder = false;
        }
        if(this.numero) {
            apuesta.setNumero(Double.parseDouble(cad));
            this.numero = false;
        }
        if(this.handicap) {
            apuesta.setHandicap(Short.parseShort(cad));
            this.handicap = false;
        }
    }
}
// FIN GestionContenido
