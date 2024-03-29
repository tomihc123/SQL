
package Incidencias;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the mypackage package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _Incidencias_QNAME = new QName("", "incidencias");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: mypackage
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link Incidencias }
     * 
     */
    public Incidencias createIncidencias() {
        return new Incidencias();
    }

    /**
     * Create an instance of {@link Incidencia }
     * 
     */
    public Incidencia createIncidencia() {
        return new Incidencia();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Incidencias }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "incidencias")
    public JAXBElement<Incidencias> createIncidencias(Incidencias value) {
        return new JAXBElement<Incidencias>(_Incidencias_QNAME, Incidencias.class, null, value);
    }

}
