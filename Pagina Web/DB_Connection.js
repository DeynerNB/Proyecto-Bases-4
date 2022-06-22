const sql = require("mssql");

const dbConfig = {
	user: "sa",
    password: "sa",
    server: "DESKTOP-MP45Q2D",
    database: "TerceraTareaProgramada",
    trustServerCertificate: true,
};
const PersonalDB = {
	user: "mainUser",
    password: "1234",
    server: "LAPTOP-8KE4ISMN",
    database: "Proyecto4_BasePruebas_A8",
    trustServerCertificate: true,
};

const getConnection = async () => {
	try {
		return await sql.connect(PersonalDB);
	}
	catch(error) {
		console.log(`Error con la conexion: ${error}`);
	}
}

module.exports = {getConnection, sql};