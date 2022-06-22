const Router = require("express").Router;
const router = Router();
const sqlManager = require("./DB_Connection.js");

let activeUser = '';
let activePass = '';
let trusted_User = true;

// Authenticate if the user exists
router.post('/authentication', async (req, res) => {
	const param_UserName = req.body.userName;
	const param_UserPass = req.body.userPassword;

	const pool   = await sqlManager.getConnection();
	const result = await pool
							.request()
							.input('in_NombreUsuario', param_UserName)
							.input('in_ContrasenaUsuario', param_UserPass)
							.output('out_ResultCode', 0)
							.execute('SP_LoginUsuario');
	pool.close();

	if (result.output.out_ResultCode == 0) {
		trusted_User = false;
		res.redirect('/');
		return;
	}
	activeUser = param_UserName;
	activePass = param_UserPass;
	res.redirect('/list');

});
router.get('/auth', async (req, res) => {
	res.json({'status': trusted_User});
	trusted_User = true;
});
router.get('/data', async (req, res) => {
	const pool   = await sqlManager.getConnection();
	const result = await pool
							.request()
							.input('in_NombreUsuario', activeUser)
							.input('in_ContrasenaUsuario', activePass)
							.execute('SP_MostrarPlanillaSemanal');
	pool.close();

	res.json({'mode':'listarPlanillaSemanal', 'data': result.recordset});
});




module.exports = router;