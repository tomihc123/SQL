
/**
 * @author Leo
 */

import Incidencias.Incidencia;
import Incidencias.Incidencias;
import Incidencias.ObjectFactory;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import java.io.File;
import java.io.StringWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


public class GestionContenido extends DefaultHandler {

    private Apuesta apuesta;
    private boolean esUsuario, esPartido, esImporte, esFecha, esResultado, overHunder, numero, handicap;
    private GestoraSQL gestoraSql;
    private Incidencias incidencias;
    private ObjectFactory objectFactory;


    public GestionContenido() {
        super();
        this.esUsuario = false;
        this.esPartido = false;
        this.esImporte = false;
        this.esFecha = false;
        this.esResultado = false;
        apuesta = new Apuesta();
        try {
            gestoraSql = new GestoraSQL();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        objectFactory = new ObjectFactory();
        incidencias = objectFactory.createIncidencias();
    }

    @Override
    public void startDocument() {
        System.out.println("Comienzo del documento XML");
    }

    @Override
    public void endDocument() {
        if (!incidencias.getIncidencia().isEmpty()) {
            guardarIncidencias();
        }
        System.out.println("Fin del documento XML");
    }

    @Override
    public void startElement(String uri, String nombre, String nombreC, Attributes att) {

        switch (nombreC) {

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
    public void endElement(String uri, String nombre, String nombreC) {

        switch (nombreC) {

            case "apuestatipo1":

                try {
                    System.out.println("Apuesta tipo 1 insertada con id " + this.gestoraSql.anadirApuestasTipo1(this.apuesta));
                    this.apuesta = new Apuesta();
                } catch (SQLException throwables) {

                    Incidencia incidencia = objectFactory.createIncidencia();
                    incidencia.setUsuario("" + this.apuesta.getIdUsuario());
                    incidencia.setFecha(this.apuesta.getFecha());
                    incidencia.setEvento("Resultados (Evento Tipo 1)");
                    incidencia.setImporte("" + this.apuesta.getDineroApostado());
                    incidencia.setMotivoRechazo(throwables.getMessage());
                    incidencias.getIncidencia().add(incidencia);
                }

                break;

            case "apuestatipo2":
                try {
                    System.out.println("Apuesta tipo 2 insertada con id " + this.gestoraSql.anadirApuestasTipo2(this.apuesta));
                } catch (SQLException throwables) {

                    Incidencia incidencia = objectFactory.createIncidencia();
                    incidencia.setUsuario("" + this.apuesta.getIdUsuario());
                    incidencia.setFecha(this.apuesta.getFecha());
                    incidencia.setEvento("Handicap (Evento Tipo 2)");
                    incidencia.setImporte("" + this.apuesta.getDineroApostado());
                    incidencia.setMotivoRechazo(throwables.getMessage());
                    incidencias.getIncidencia().add(incidencia);
                }

                break;

            case "apuestatipo3":
                try {
                    System.out.println("Apuesta tipo 3 insertada con id " + this.gestoraSql.anadirApuestasTipo3(this.apuesta));
                } catch (SQLException throwables) {
                    Incidencia incidencia = objectFactory.createIncidencia();
                    incidencia.setUsuario("" + this.apuesta.getIdUsuario());
                    incidencia.setFecha(this.apuesta.getFecha());
                    incidencia.setEvento("OverHunder (Evento Tipo 3)");
                    incidencia.setImporte("" + this.apuesta.getDineroApostado());
                    incidencia.setMotivoRechazo(throwables.getMessage());
                    incidencias.getIncidencia().add(incidencia);
                }

        }

    }

    private void guardarIncidencias() {
        JAXBContext contexto;
        try {
            contexto = JAXBContext.newInstance(Incidencias.class);
            Marshaller marshalero = contexto.createMarshaller();
            marshalero.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            StringWriter escribiente = new StringWriter();
            marshalero.marshal(incidencias, new File("XML\\Incidencias.xml"));
            // ahora lo marshaleamos a un stream para visualizarlo
            marshalero.marshal(incidencias, escribiente);
            System.out.println("-----------------");
            System.out.println("Object2XML:");
            System.out.println(escribiente.toString());
            System.out.println("-----------------");
        } catch (JAXBException ex) {
            Logger.getLogger(GestionContenido.class.getName()).log(Level.SEVERE, null, ex);
        }
    }


    @Override
    public void characters(char[] ch, int inicio, int longitud)
            throws SAXException {
        String cad = new String(ch, inicio, longitud);
        cad = cad.replaceAll("[\t\n]", ""); // Quitamos tabuladores y saltos de linea

        if (this.esUsuario) {
            apuesta.setIdUsuario(Integer.parseInt(cad));
            this.esUsuario = false;
        }
        if (this.esPartido) {
            apuesta.setIdPartido(Integer.parseInt(cad));
            this.esPartido = false;
        }
        if (this.esImporte) {
            apuesta.setDineroApostado(Double.parseDouble(cad));
            this.esImporte = false;
        }
        if (this.esFecha) {
            apuesta.setFecha(cad);
            this.esFecha = false;
        }
        if (this.esResultado) {
            apuesta.setResultado(cad);
            this.esResultado = false;
        }
        if (this.overHunder) {
            apuesta.setOverUnder(Boolean.getBoolean(cad));
            this.overHunder = false;
        }
        if (this.numero) {
            apuesta.setNumero(Double.parseDouble(cad));
            this.numero = false;
        }
        if (this.handicap) {
            apuesta.setHandicap(Short.parseShort(cad));
            this.handicap = false;
        }
    }
}
// FIN GestionContenido
