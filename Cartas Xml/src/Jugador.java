public class Jugador {

    private String nombre;
    private double totalCartas;

    public Jugador() {
        this.nombre = "";
        this.totalCartas = 0;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public double getTotalCartas() {
        return totalCartas;
    }

    public void setTotalCartas(double totalCartas) {
        this.totalCartas = totalCartas;
    }

    @Override
    public String toString() {
        return "Jugador{" +
                "nombre='" + nombre + '\'' +
                ", totalCartas=" + totalCartas +
                '}';
    }
}
