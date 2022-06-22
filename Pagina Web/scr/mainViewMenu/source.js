// ---- POP UP ACTIONS
// --------------------------------------------------------------------
function closePopUp() {
    const popUp = document.getElementById("extraInformation_Container");
    popUp.style.display = "none";
}
function showPopUp(e) {
    // const popUp = document.getElementById("extraInformation_Container");
    // popUp.style.display = "flex";

    // updateSpecificData(e);
}
async function updateSpecificData(e) {
    const userID = e.srcElement.innerHTML;
    //console.log(e.path[1].children[0].innerHTML);
    console.log(e.path[1].children[0].innerText);

    const response = await fetch('/specificUser');
}
// --------------------------------------------------------------------

// ---- DATA ACTIONS
// --------------------------------------------------------------------


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
    <th class="headTable"><div>Identificacion</div></th>
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
                            <td class="contentTable" colspan="${columnsNumber}" onclick="showPopUp(event)">
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
                            <td class="contentTable" colspan="${columnsNumber}" onclick="showPopUp(event)">
                                <div class="contentRowTable specialRow">${row.docID}</div>
                                <div class="contentRowTable specialRow">${row.salarioTotal}</div>
                                <div class="contentRowTable specialRow">${row.totalDeducciones}</div>
                                <div class="contentRowTable specialRow">${row.salarioNeto}</div>
                            </td>
                        </tr>
                 `);
        }
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