using System;

namespace JuegoDeMemoria.Models
{
    public class Carta
    {
        public string Simbolo { get; set; }
        public bool EstaVolteada { get; set; }

        public Carta(string simbolo)
        {
            Simbolo = simbolo;
            EstaVolteada = false;
        }
    }
}
