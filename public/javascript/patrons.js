// Load delete patron dropdown
const deletePatronDropdown = document.getElementById("delete-patron-dropdown");
// Populate the dropdown
deletePatronDropdown.innerHTML = '<option value="">Select Patron</option>';

// Fetch patrons from the backend and update the patrons table
const loadPatrons = async () => {
  try {
    const response = await fetch("/api/patrons");
    const [data] = await response.json();
    const table = document.getElementById("patrons-table");
    table.innerHTML = "";

    data.forEach((patron) => {
      // Create a new date object and pass in the membershipDate as an argument
      const date = new Date(patron.membershipDate);
      // Format the date with the Date methods.
      const formattedDate = `${String(date.getMonth() + 1).padStart(
        2,
        "0"
      )}-${String(date.getDate()).padStart(2, "0")}-${date.getFullYear()}`;
      const row = document.createElement("tr");
      row.innerHTML = `
                              <td>${patron.firstName}</td>
                              <td>${patron.lastName}</td>
                              <td>${formattedDate}</td>
                          `;
      table.appendChild(row);

      // Load the Delete Patron Dropdown
      const option = document.createElement("option");
      option.value = patron.patronID;
      option.textContent = `${patron.firstName} ${patron.lastName}`;
      deletePatronDropdown.appendChild(option);
    });
  } catch (error) {
    console.error("Error loading patrons:", error);
  }
};

// Handle form submission to add a new patron
const form = document.getElementById("add-patron-form");
form?.addEventListener("submit", async function (e) {
  e.preventDefault();

  const formData = new FormData(e.target);
  const patronData = {
    firstName: formData.get("firstName"),
    lastName: formData.get("lastName"),
    membershipDate: formData.get("membershipDate"),
  };

  try {
    const response = await fetch("/api/patrons/add-patron", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(patronData),
    });
    const data = await response.json();
    if (data.success) {
      alert("Patron added successfully!");
      loadPatrons();
      e.target.reset();
    } else {
      alert("Error adding patron: " + data.error);
    }
  } catch (error) {
    console.error("Error:", error);
  }
});

const deletePatronForm = document.getElementById("delete-patron-form");

// Delete a patron
deletePatronForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const patronID = document.getElementById("delete-patron-dropdown").value;

  try {
    const response = await fetch(`/api/patrons/${patronID}`, {
      method: "DELETE",
    });
    alert("Patron deleted!");
    loadPatrons();
  } catch (error) {
    console.error("Error deleting patron:", error);
    alert("Error deleting patron: " + error.message);
  }
});

// Set default membership date to today
document.addEventListener("DOMContentLoaded", function () {
  // Load patrons when the page loads
  loadPatrons();
  // Get today's date in YYYY-MM-DD format
  const today = new Date().toISOString().split("T")[0];
  // Prepopulate input field with today's date
  document.getElementById("membershipDate").value = today;
});
