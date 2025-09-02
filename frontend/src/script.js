document.addEventListener('DOMContentLoaded', function () {

    const contactForm = document.getElementById('contactForm');
    const emailInput = document.getElementById('emailInput');
    const subjectInput = document.getElementById('subjectInput');
    const messageTextarea = document.getElementById('messageTextarea');

    const apiUrl = 'https://ulhhqf6ej4.execute-api.eu-central-1.amazonaws.com/prod/contact'

    contactForm.addEventListener('submit', function (event) {

        event.preventDefault();

        const formData = {
            sender_mail: emailInput.value,
            subject: subjectInput.value,
            message: messageTextarea.value
        };

        console.log("Form sent! Data collected:");
        console.log(formData);

        fetch(apiUrl, {
            method: 'POST',
            body: JSON.stringify(formData)
        });
        alert("Form sent! Data collected:");
        contactForm.reset();

    });
});