/**
 *
 * @author Leo
 */
import org.xml.sax.helpers.*;
import org.xml.sax.*;
public class GestionContenido extends DefaultHandler {

    private boolean numero;
    private boolean nombre;
    private Jugador aux;
    private Jugador ganadorPartida1;


    public GestionContenido() {
        super();
        numero = false;
        nombre = false;
        aux = new Jugador();
        ganadorPartida1 = new Jugador();
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
        System.out.println("\t{- "+nombreC +"-}");

        switch(nombreC) {
            case "nombre":
                this.nombre = true;
                break;

            case "numero":
                this.numero = true;
                break;
        }

    }
    @Override
    public void endElement(String uri, String nombre, String nombreC){
        System.out.println("\t[/ "+nombreC +"]");
        if(nombreC.equals("jugador")) {

            if(aux.getTotalCartas() > ganadorPartida1.getTotalCartas() && aux.getTotalCartas()<=7.5) {
                ganadorPartida1 = aux;
            }
            aux = new Jugador();
        }

        if(nombreC.equals("partida")) {

            System.out.println(ganadorPartida1.toString());
            ganadorPartida1 = new Jugador();

        }

    }
    @Override
    public void characters (char[] ch, int inicio, int longitud)
            throws SAXException{
        String cad = new String(ch, inicio, longitud);
        cad = cad.replaceAll("[\t\n]",""); // Quitamos tabuladores y saltos de linea
        System.out.println("\t\t" + cad);

       if(this.nombre) {
            aux.setNombre(cad);
            this.nombre = false;
        }

        if(this.numero) {

            if(cad.length() == 1) {
                aux.setTotalCartas(aux.getTotalCartas() + Double.parseDouble(cad));
            } else {
                aux.setTotalCartas(aux.getTotalCartas() + 0.5);
            }
            this.numero = false;
        }
    }
}

