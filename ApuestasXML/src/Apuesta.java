public class Apuesta {

    private int idUsuario;
    private int idPartido;
    private double dineroApostado;
    private String fecha;
    private String resultado;
    private boolean overUnder;
    private double numero;

    public Apuesta() {
    }

    public Apuesta(int idUsuario, int idPartido, double dineroApostado, String fecha, String resultado) {
        this.idUsuario = idUsuario;
        this.idPartido = idPartido;
        this.dineroApostado = dineroApostado;
        this.fecha = fecha;
        this.resultado = resultado;

    }



    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdPartido() {
        return idPartido;
    }

    public void setIdPartido(int idPartido) {
        this.idPartido = idPartido;
    }

    public double getDineroApostado() {
        return dineroApostado;
    }

    public void setDineroApostado(double dineroApostado) {
        this.dineroApostado = dineroApostado;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getResultado() {
        return resultado;
    }

    public void setResultado(String resultado) {
        this.resultado = resultado;
    }

    public boolean isOverUnder() {
        return overUnder;
    }

    public void setOverUnder(boolean overUnder) {
        this.overUnder = overUnder;
    }

    public double getNumero() {
        return numero;
    }

    public void setNumero(double numero) {
        this.numero = numero;
    }
}
