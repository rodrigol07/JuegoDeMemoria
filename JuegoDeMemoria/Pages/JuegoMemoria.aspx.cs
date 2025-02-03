using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using JuegoDeMemoria.Models;

namespace PruebaDeMemoria.Pages
{
    public partial class JuegoMemoria : Page
    {
        private List<Carta> Cartas
        {
            get => (List<Carta>)Session["Cartas"] ?? new List<Carta>();
            set => Session["Cartas"] = value;
        }

        private List<bool> EstadoCartas
        {
            get => (List<bool>)Session["EstadoCartas"] ?? new List<bool>();
            set => Session["EstadoCartas"] = value;
        }

        private List<int> CartasVolteadas
        {
            get => (List<int>)Session["CartasVolteadas"] ?? new List<int>();
            set => Session["CartasVolteadas"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InicializarJuego();
            }
        }

        private void InicializarJuego()
        {
            Cartas = BarajarCartas(new List<Carta>
            {
                new Carta("🍎"), new Carta("🍎"), new Carta("🍌"), new Carta("🍌"),
                new Carta("🍒"), new Carta("🍒"), new Carta("🍇"), new Carta("🍇"),
                new Carta("🍓"), new Carta("🍓"), new Carta("🍍"), new Carta("🍍"),
                new Carta("🥑"), new Carta("🥑"), new Carta("🥕"), new Carta("🥕")
            });

            EstadoCartas = new List<bool>(new bool[Cartas.Count]);
            CartasVolteadas.Clear();
        }

        private List<Carta> BarajarCartas(List<Carta> cartas)
        {
            return cartas.OrderBy(_ => Guid.NewGuid()).ToList();
        }

        protected void BtnReiniciar_Click(object sender, EventArgs e)
        {
            InicializarJuego();
            Response.Redirect(Request.Url.ToString());
        }

        protected void VoltearCarta(int indice)
        {
            if (CartasVolteadas.Count == 2 || EstadoCartas[indice]) return;

            EstadoCartas[indice] = true;
            CartasVolteadas.Add(indice);

            if (CartasVolteadas.Count == 2)
            {
                VerificarCoincidencia();
            }
        }

        private void VerificarCoincidencia()
        {
            int primeraCarta = CartasVolteadas[0];
            int segundaCarta = CartasVolteadas[1];
            if (Cartas[primeraCarta].Simbolo == Cartas[segundaCarta].Simbolo)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Coincidencia", "alert('¡Las cartas coinciden!');", true);
                CartasVolteadas.Clear();
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Error", "alert('Las cartas no coinciden.');", true);
                System.Threading.Thread.Sleep(1000);
                EstadoCartas[primeraCarta] = false;
                EstadoCartas[segundaCarta] = false;
                CartasVolteadas.Clear();
            }

            if (EstadoCartas.All(c => c))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Victoria", "alert('¡Felicidades acertaste todas las cartas!');", true);
            }
        }
    }
}
