function refreshData() {
  loadRentalTable();
  vinylDropdown();
  patronDropdown();
  deleteRentalDropdown();
  updateReturnDateDropdown();
}

// Get the rentals and fill the rental table
const loadRentalTable = async () => {
  try {
    const response = await fetch("/api/rentals/");
    const [data] = await response.json();
    const table = document.getElementById("rentals-table");
    table.innerHTML = "";

    data.forEach((rental) => {
      let formattedDateOfRental;

      //   If there is a rental date
      if (rental.rentalDate) {
        const dateString = rental.rentalDate.split("T")[0];
        // Format the date
        const [year, month, day] = dateString.split("-");
        formattedDateOfRental = `${parseInt(month)}-${parseInt(day)}-${year}`;
      } else {
        formattedDateOfRental = "Unknown";
      }

      // Default return date is "Not Returned"
      let formattedDateOfReturn = "Not Returned";

      // If the returnDate exists and is not null
      if (rental.returnDate && rental.returnDate !== null) {
        try {
          const dateString = rental.returnDate.split("T")[0];

          const [year, month, day] = dateString.split("-");

          if (year && month && day) {
            formattedDateOfReturn = `${parseInt(month)}-${parseInt(
              day
            )}-${year}`;
          }
        } catch (error) {
          // If any error occurs during parsing, use the default
          formattedDateOfReturn = "Not Returned";
        }
      }
      const row = document.createElement("tr");
      row.innerHTML = `
                          <td>${rental.vinylTitle}</td>
                          <td>${rental.patronName}</td>
                          <td>${formattedDateOfRental}</td>
                          <td>${formattedDateOfReturn}</td>

                      `;
      table.appendChild(row);
    });
  } catch (error) {
    console.error("Error loading rentals:", error);
  }
};

// Load the Return Date dropdown
const updateReturnDateDropdown = async function () {
  try {
    const response = await fetch("/api/rentals/");
    const [data] = await response.json();

    // Load update return dropdown
    const updateReturnDateDropdown = document.getElementById(
      "update-return-date-dropdown"
    );

    // Populate the update return dropdown
    updateReturnDateDropdown.innerHTML =
      '<option value="">Select a Rental</option>';

    data.forEach((rental) => {
      const option = document.createElement("option");
      option.value = rental.rentalID;
      option.textContent = `${rental.patronName} - ${rental.vinylTitle}`;
      updateReturnDateDropdown.appendChild(option);
    });
  } catch (error) {}
};

// Load the delete rental dropdwon
const deleteRentalDropdown = async function () {
  try {
    const response = await fetch("/api/rentals/");
    const [data] = await response.json();
    // Load rental dropdown
    const deleteRentalDropdown = document.getElementById(
      "delete-rental-dropdown"
    );
    // Populate the rental dropdown
    deleteRentalDropdown.innerHTML =
      '<option value="">Select a Rental</option>';

    data.forEach((rental) => {
      const option = document.createElement("option");
      option.value = rental.rentalID;
      option.textContent = `${rental.patronName} - ${rental.vinylTitle}`;
      deleteRentalDropdown.appendChild(option);
    });
  } catch (error) {}
};

// Load vinyls
const vinylDropdown = async () => {
  try {
    const response = await fetch("/api/vinyls");
    const [data] = await response.json();
    const vinylDropdown = document.getElementById("vinyl-dropdown");

    vinylDropdown.innerHTML = '<option value="">Select a Vinyl</option>';

    // Sort alphabetically by vinyl title
    data.sort((a, b) => a.title.localeCompare(b.title));

    data.forEach((vinyl) => {
      const option = document.createElement("option");
      option.value = vinyl.vinylID;
      option.textContent = `${vinyl.title} (${vinyl.yearReleased})`;

      vinylDropdown.appendChild(option);
    });
  } catch (error) {
    console.error("Error loading vinyls:", error);
  }
};

// Fetch patrons from the backend and update the patrons table
const patronDropdown = async () => {
  try {
    const response = await fetch("/api/patrons");
    const [data] = await response.json();

    const patronDropdown = document.getElementById("patron-dropdown");

    if (!patronDropdown) {
      console.error("Dropdown elements not found.");
      return;
    }

    patronDropdown.innerHTML = '<option value="">Select a Patron</option>';

    data.sort((a, b) => a.firstName.localeCompare(b.firstName));

    data.forEach((patron) => {
      let formattedDate = "Unknown";
      if (patron.membershipDate) {
        const date = new Date(patron.membershipDate);
        formattedDate = `${
          date.getMonth() + 1
        }-${date.getDate()}-${date.getFullYear()}`;
      }

      const option = document.createElement("option");
      option.value = patron.patronID;
      option.textContent = `${patron.firstName} ${patron.lastName} (Joined: ${formattedDate})`;

      patronDropdown.appendChild(option);
    });
  } catch (error) {
    console.error("Error loading patrons:", error);
  }
};

// Update return date form submission
const updateReturnDateForm = document.getElementById("update-return-date-form");
updateReturnDateForm.addEventListener("submit", async function (e) {
  e.preventDefault();

  const formData = new FormData(e.target);
  const rentalID = formData.get("rentalID");
  const newReturnDate = new Date(formData.get("newReturnDate"));

  const response = await fetch(`/api/rentals/${rentalID}`);
  const [rentalDetails] = await response.json();

  const rentalDate = new Date(rentalDetails.rentalDate);

  // Make sure the return date is after the rental date
  if (newReturnDate < rentalDate) {
    alert("Return date must be after rental date.");
    return;
  }

  // If validation passes, update the return date
  const updateData = {
    rentalID: rentalID,
    newReturnDate: formData.get("newReturnDate"),
  };

  const returnDateResponse = await fetch(`/api/rentals/${rentalID}`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(updateData),
  });
  if (returnDateResponse.ok) {
    refreshData();
  } else {
    alert("Failed to update return date");
  }
});

// Add rental form submission
const addRentalForm = document.getElementById("add-rental-form");
addRentalForm.addEventListener("submit", async function (e) {
  e.preventDefault();

  const formData = new FormData(e.target);
  const rentalData = {
    vinylID: formData.get("vinylID"),
    patronID: formData.get("patronID"),
    rentalDate: formData.get("rentalDate"),
  };

  const response = await fetch("/api/rentals/add-rental", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(rentalData),
  });
  if (response) {
    alert("Rental added successfully!");
    refreshData();
    e.target.reset();
  } else {
    alert("Error adding rental: " + response.error);
  }
});

// Delete a rental for submission
const deleteRentalForm = document.getElementById("delete-rental-form");
deleteRentalForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const rentalID = document.getElementById("delete-rental-dropdown").value;

  try {
    const response = await fetch(`/api/rentals/${rentalID}`, {
      method: "DELETE",
    });
    alert("Rental deleted!");
    refreshData();
  } catch (error) {
    console.error("Error deleting rental:", error);
    alert("Error deleting rental: " + error.message);
  }
});

// Initialize everything when the page loads
document.addEventListener("DOMContentLoaded", refreshData);
