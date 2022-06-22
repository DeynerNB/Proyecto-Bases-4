async function checkLogIn(root) {

	const response = await fetch(root.dataset.url);
	const responseData = await response.json();
	const statusResponse = responseData.status;

	if (!statusResponse) {
		const nameField = document.getElementById("inputName");
		const passField = document.getElementById("inputPassword");

		nameField.style.animation = "shake .5s";
		passField.style.animation = "shake .5s";
	}
}

for (const root of (document.querySelectorAll(".mainContainer[data-url]"))) {
	checkLogIn(root);
}
