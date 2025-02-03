<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JuegoMemoria.aspx.cs" Inherits="PruebaDeMemoria.Pages.JuegoMemoria" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Juego de Memoria</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            color: #333;
            text-align: center;
            margin: 0;
            padding: 0;
        }

        h1 {
            font-size: 36px;
            color: #4CAF50;
            margin-top: 20px;
        }

        .tablero {
            display: grid;
            grid-template-columns: repeat(4, 90px);
            grid-template-rows: repeat(4, 90px);  
            grid-gap: 15px;
            justify-content: center;
            margin-top: 40px;
        }

        .carta {
            width: 90px;
            height: 90px;
            background-color: #e0e0e0;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 32px;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .carta:hover {
            transform: scale(1.1);
        }

        .carta.volteada {
            background-color: #fff;
        }

        .btn-reiniciar {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            margin-top: 30px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .btn-reiniciar:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Juego de Memoria</h1>
            
            <div class="tablero" id="tablero">
            </div>

            <br />
            <asp:Button ID="BtnReiniciar" runat="server" Text="Reiniciar Juego" CssClass="btn-reiniciar" OnClick="BtnReiniciar_Click" />
        </div>
    </form>

    <script type="text/javascript">
        var estadoCartas = [];
        var cartasVolteadas = [];
        var simbolosCartas = [];

        function manejarClick(simbolo, index) {
            if (cartasVolteadas.length === 2 || estadoCartas[index]) return;

            estadoCartas[index] = true;
            document.getElementById('carta_' + index).innerHTML = simbolo;

            cartasVolteadas.push({ index, simbolo });

            if (cartasVolteadas.length === 2) {
                var carta1 = cartasVolteadas[0];
                var carta2 = cartasVolteadas[1];

                console.log(`Comparando: ${carta1.simbolo} con ${carta2.simbolo}`);

                if (carta1.simbolo === carta2.simbolo) {
                    setTimeout(() => {
                        Swal.fire({
                            title: '¡Coincidencia!',
                            text: '¡Las cartas coinciden!',
                            icon: 'success'
                        });
                        cartasVolteadas = [];
                    }, 500);
                } else {
                    setTimeout(() => {
                        Swal.fire({
                            title: 'Error',
                            text: 'Las cartas no coinciden',
                            icon: 'error'
                        });

                        document.getElementById('carta_' + carta1.index).innerHTML = "❔";
                        document.getElementById('carta_' + carta2.index).innerHTML = "❔";
                        estadoCartas[carta1.index] = false;
                        estadoCartas[carta2.index] = false;
                        cartasVolteadas = [];
                    }, 1000);
                }
            }

            if (estadoCartas.every(c => c)) {
                setTimeout(() => {
                    Swal.fire({
                        title: '¡Felicidades!',
                        text: '¡Acertaste todas las cartas!',
                        icon: 'success',
                        showCancelButton: true,
                        confirmButtonText: 'OK',
                        cancelButtonText: 'Reiniciar Juego',
                        focusCancel: true
                    }).then((result) => {
                        if (result.isConfirmed) {
                            Swal.fire('¡Bien hecho!', '', 'success');
                        } else if (result.isDismissed) {
                            location.reload();
                        }
                    });
                }, 500);
            }
        }

        window.onload = function () {
            var simbolos = ['🍎', '🍌', '🍒', '🍇', '🍉', '🍍', '🥝', '🍓', '🍎', '🍌', '🍒', '🍇', '🍉', '🍍', '🥝', '🍓'];
            simbolos = simbolos.sort(() => Math.random() - 0.5);

            var tablero = document.getElementById('tablero');

            simbolos.forEach(function (simbolo, index) {
                var carta = document.createElement('div');
                carta.classList.add('carta');
                carta.id = 'carta_' + index;
                carta.setAttribute('onclick', `manejarClick('${simbolo}', ${index})`);
                carta.innerHTML = "❔";
                tablero.appendChild(carta);

                simbolosCartas[index] = simbolo;
                estadoCartas[index] = false;
            });
        };
    </script>
</body>
</html>
