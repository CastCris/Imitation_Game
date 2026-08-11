<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Tabuada 3D Psicodélica</title>
	<style>
		/* Background escuro e cena 3D */
		body {
			background-color: #05010d;
			height: 100vh;
			display: flex;
			justify-content: center;
			align-items: center;
			perspective: 1200px;
			overflow: hidden;
			margin: 0;
			user-select: none;
		}

		/* Tabela 3D interativa */
		table {
			border-collapse: separate;
			border-spacing: 6px;
			transform-style: preserve-3d;
			transition: transform 0.1s ease-out;
		}

		/* Estilo base das células com efeito 3D e neon */
		td {
			background: rgba(255, 255, 255, 0.03);
			backdrop-filter: blur(4px);
			border: 2px solid #ff00ff;
			text-align: center;
			width: 55px;
			height: 55px;
			border-radius: 8px;
			box-shadow: 0 0 10px #ff00ff, inset 0 0 10px rgba(255, 0, 255, 0.3);
			cursor: grab;
			transition: border-color 0.3s, box-shadow 0.3s;
		}

		td:active {
			cursor: grabbing;
		}

		td:hover {
			border-color: #00ffff;
			box-shadow: 0 0 20px #00ffff, inset 0 0 15px rgba(0, 255, 255, 0.5);
			z-index: 100;
		}

		/* Células soltas arrastadas */
		td.floating-cell {
			position: absolute !important;
			z-index: 999;
			cursor: grabbing;
			animation: floatPsyco 4s infinite alternate;
		}

		/* Cabeçalhos e números base */
		.cell_num {
			background: rgba(255, 255, 0, 0.15);
			border-color: #ffff00;
			box-shadow: 0 0 10px #ffff00;
		}

		/* Célula canto superior esquerdo */
		.cell_excluded {
			background: rgba(0, 0, 0, 0.8);
			border-color: #ff0055;
			box-shadow: 0 0 10px #ff0055;
		}

		/* Textos e animações psicodélicas */
		h2, h3 {
			margin: 0;
			font-family: 'Courier New', Courier, monospace;
			font-size: 1.1rem;
			animation: colorCycle 6s infinite alternate;
			pointer-events: none; /* Evita interferência no drag */
		}

		.cell_excluded h2 { color: #ff0055; }
		.cell_num h2 { color: #ffff00; text-shadow: 0 0 8px #ffff00; }
		td h3 { color: #00ffff; text-shadow: 0 0 8px #00ffff; }

		/* Animação de troca de cores psicodélica */
		@keyframes colorCycle {
			0% { filter: hue-rotate(0deg); }
			50% { filter: hue-rotate(180deg); }
			100% { filter: hue-rotate(360deg); }
		}

		@keyframes floatPsyco {
			0% { transform: translateY(0px) rotateZ(0deg); }
			100% { transform: translateY(-10px) rotateZ(5deg); }
		}
	</style>
</head>
<body>
	<table id="tabuadaTable">
	<%
		int i, j;
		final int max_table = 10;
		for(i=0; i <= max_table; ++i){
	%>
		<% 
		if(i == 0){
		%>
			<tr>
				<td class="cell_excluded"> X </td>
				<%
				for(j=0; j <= max_table; ++j){
				%>
				<td class="cell_num">
					<h2><%= j %></h2>
				</td>
				<%
				}
				%>
			</tr>
		<%
		}
		else {
		%>
			<tr>
				<td class="cell_num">
					<h2><%= i %></h2>
				</td>
				<%
				for(j=0; j <= max_table; ++j ){
				%>
				<td>
					<h3><%= j * i %></h3>
				</td>
				<%
				}
				%>
			</tr>
	<% 
		}
	} 
	%>
	</table>

	<script>
		// 1. Efeito de Perspectiva 3D com o Movimento do Mouse
		const table = document.getElementById('tabuadaTable');
		
		document.addEventListener('mousemove', (e) => {
			const xPos = (window.innerWidth / 2 - e.clientX) / 25;
			const yPos = (e.clientY - window.innerHeight / 2) / 25;
			
			table.style.transform = `rotateX(${yPos}deg) rotateY(${xPos}deg)`;
		});

		// 2. Funcionalidade de Arrastar e Soltar (Drag & Drop) para qualquer Célula
		let activeCell = null;
		let startX = 0, startY = 0;
		let initialLeft = 0, initialTop = 0;

		document.addEventListener('mousedown', (e) => {
			const cell = e.target.closest('td');
			if (!cell) return;

			activeCell = cell;
			
			// Se a célula ainda faz parte da tabela, converte sua posição para absoluta na tela
			if (!activeCell.classList.contains('floating-cell')) {
				const rect = activeCell.getBoundingClientRect();
				activeCell.style.width = rect.width + 'px';
				activeCell.style.height = rect.height + 'px';
				activeCell.classList.add('floating-cell');
				activeCell.style.left = rect.left + 'px';
				activeCell.style.top = rect.top + 'px';
				document.body.appendChild(activeCell);
			}

			startX = e.clientX;
			startY = e.clientY;
			initialLeft = parseInt(activeCell.style.left) || 0;
			initialTop = parseInt(activeCell.style.top) || 0;

			e.preventDefault();
		});

		document.addEventListener('mousemove', (e) => {
			if (!activeCell) return;

			const dx = e.clientX - startX;
			const dy = e.clientY - startY;

			activeCell.style.left = (initialLeft + dx) + 'px';
			activeCell.style.top = (initialTop + dy) + 'px';
		});

		document.addEventListener('mouseup', () => {
			activeCell = null;
		});
	</script>
</body>
</html>
