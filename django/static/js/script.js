document.addEventListener('DOMContentLoaded', function () {
    var table = document.getElementById('Table');
    var detailsCard = document.getElementById('detailsCard');
    var rows = table.getElementsByTagName('tr');
    var labels = table.getElementsByTagName('th'); // Get the table headings


    // Add click event listener to each row
    for (var i = 0; i < rows.length; i++) {
        rows[i].addEventListener('click', function (event) {
            // Remove 'selected' class from all rows
            for (var j = 0; j < rows.length; j++) {
                rows[j].classList.remove('selected');
            }

            // Add 'selected' class to the clicked row
            this.classList.add('selected');

            // Update details card with staff information
            var cells = this.getElementsByTagName('td');

            detailsCard.innerHTML = `
                <div class="card-content">
                    <p><strong> ${labels[0].innerText}</strong> ${cells[0].innerText}</p>
                    <p><strong> ${labels[1].innerText}</strong> ${cells[1].innerText}</p>
                    <p><strong> ${labels[2].innerText}</strong> ${cells[2].innerText}</p>
                    <p><strong>${labels[3].innerText}</strong> ${cells[3].innerText}</p>
                </div>
                <div class="buttons">
                    <button class="edit-btn">Edit</button>
                    <button class="delete-btn">Delete</button>
                </div>
            `;
        });
    }
});