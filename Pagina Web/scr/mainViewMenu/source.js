// ---- POP UP ACTIONS
// --------------------------------------------------------------------
function closePopUp() {
    const popUp = document.getElementById("extraInformation_Container");
    popUp.style.display = "none";
}
function showPopUp(e) {
    const popUp = document.getElementById("extraInformation_Container");
    popUp.style.display = "flex";

    updateSpecificData(e);
}
// --------------------------------------------------------------------

// ---- DATA ACTIONS
// --------------------------------------------------------------------
let activeMode;

const HTML_SemanaPlanilla_Head = 
`
<div id="tableTittleContainer">Planilla Semana</div>
<tr class="rowTable titleHeadTable">
    <th class="headTable"><div>Salario Bruto</div></th>
    <th class="headTable"><div>Total de Deducciones</div></th>
    <th class="headTable"><div>Salario Neto</div></th>
    <th class="headTable"><div>Cantidad de horas ordinarias</div></th>
    <th class="headTable"><div>Cantidad de horas extras normales</div></th>
    <th class="headTable"><div>Cantidad de horas extras dobles</div></th>
</tr>`
const HTML_SemanaMes_Head = 
`
<div id="tableTittleContainer">Planilla Mensual</div>
<tr class="rowTable titleHeadTable">
    <th class="headTable"><div>Salario Bruto</div></th>
    <th class="headTable"><div>Total Deducciones</div></th>
    <th class="headTable"><div>Salario Neto</div></th>
</tr>
`

async function update(root) {
    const table = root.querySelector("#mainTable");
    const requestPetition = window.location.search;
    const response = await fetch(root.dataset.url + requestPetition);
    const jsonData = await response.json();

    const modeDisplayData = jsonData.mode;
    const responseData = jsonData.data;

    activeMode = modeDisplayData;
    
    let head_HTML_Format;
    let columnsNumber;

    // Check which data mode is going to be display
    if (modeDisplayData == 'listarPlanillaSemanal') {
        head_HTML_Format = HTML_SemanaPlanilla_Head;
        columnsNumber = 7;
    }
    else {
        head_HTML_Format = HTML_SemanaMes_Head;
        columnsNumber = 2;
    }

    // Set the title for the columns
    table.querySelector("thead")
            .insertAdjacentHTML("beforeend", head_HTML_Format);

    for (let row of responseData) {

        if (columnsNumber == 7) {
            table.querySelector("tbody").insertAdjacentHTML("beforeend", `
                        <tr>
                            <td class="contentTable" ID_WeekPerEmployee="${row.ID_PlanillaSemanaXEmpleado}" colspan="${columnsNumber}" onclick="showPopUp(event)">
                                <div class="contentRowTable">${row.SalarioBruto}</div>
                                <div class="contentRowTable">${row.TotalDeducciones}</div>
                                <div class="contentRowTable">${row.SalarioNeto}</div>
                                <div class="contentRowTable">${row.HorasOrdinarias}</div>
                                <div class="contentRowTable">${row.HorasExtrasNormales}</div>
                                <div class="contentRowTable">${row.HorasExtrasDobles}</div>
                            </td>
                        </tr>
                 `);
        }
        else {
            table.querySelector("tbody").insertAdjacentHTML("beforeend", `
                        <tr>
                            <td class="contentTable" ID_MonthPerEmployee="${row.Id}" colspan="${columnsNumber}" onclick="showPopUp(event)">
                                <div class="contentRowTable specialRow">${row.SalarioTotal}</div>
                                <div class="contentRowTable specialRow">${row.TotalDeducciones}</div>
                                <div class="contentRowTable specialRow">${row.SalarioNeto}</div>
                            </td>
                        </tr>
                 `);
        }
    }
}

async function updateSpecificData(e) {
    const deducciones = document.getElementById('deductionContainer');
    const movimientos = document.getElementById('movementContainer');

    const table_Deduction = document.createElement("ul");
    const table_Movements = document.createElement("ul");
    deducciones.innerHTML = '';
    movimientos.innerHTML = '';

    if (activeMode == 'listarPlanillaSemanal') {
        const ID_WeekPerEmployee = e.path[1].getAttribute('ID_WeekPerEmployee');

        const response = await fetch(`/detailWeekInformation?IDWeek=${ID_WeekPerEmployee}`);
        const jsonData = await response.json();

        for (let row of jsonData.Deducciones) {
            table_Deduction.insertAdjacentHTML("beforeend", `
                    <li>Nombre: ${row.Nombre}</li>
                    <li>Valor: ${row.Valor}</li>
                    <li>Monto: ${row.Monto}</li>
                    <li> </li>
                `);
        }
        for (let row of jsonData.Movimientos) {
            table_Movements.insertAdjacentHTML("beforeend", `
                    <li>Fecha: ${row.Fecha}</li>
                    <li>Hora Entrada: ${row.HoraEntrada}</li>
                    <li>Hora Salida: ${row.HoraSalida}</li>
                    <li>Horas Ordinarias: ${row.HorasOrdinarias}</li>
                    <li>Monto: ${row.MontoOridinario}</li>
                    <li>Horas Extras Normales: ${row.HorasExtrasNorm}</li>
                    <li>Monto: ${row.MontoExtrasNorm}</li>
                    <li>Horas Extras Dobles: ${row.HorasExtrasDobl}</li>
                    <li>Monto: ${row.MontoExtrasDobl}</li>
                `);
        }
        deducciones.append(table_Deduction);
        movimientos.append(table_Movements);
    }
    else {
        const ID_MonthPerEmployee = e.path[1].getAttribute('ID_MonthPerEmployee');

        const response = await fetch(`/detailMonthInformation?IDMonth=${ID_MonthPerEmployee}`);
        const jsonData = await response.json();

        console.log(ID_MonthPerEmployee);

        for (let row of jsonData.Deducciones) {
            table_Deduction.insertAdjacentHTML("beforeend", `
                    <li>Nombre: ${row.Nombre}</li>
                    <li>Valor: ${row.Valor}</li>
                    <li>Monto: ${row.Monto}</li>
                    <li> </li>
                `);
        }
        deducciones.append(table_Deduction);
    }
}

for (const root of (document.querySelectorAll(".dataContainer[data-url]"))) {
    
    const table = document.createElement("table");
    table.setAttribute("id", "mainTable");

    table.innerHTML = `
                    <thead>
                    </thead>

                    <tbody>
                    </tbody>`;
    root.append(table);
    update(root);
}


// --------------------------------------------------------------------