function refreshData() {
  loadVinyls();
  loadArtists();
}

// Fetch vinyls from the backend and update the table
const loadVinyls = async () => {
  try {
    const response = await fetch("/api/vinyls");
    const [data] = await response.json();
    const table = document.getElementById("vinyls-table");
    table.innerHTML = "";

    // Load delete vinyl dropdown
    const deleteVinylDropdown = document.getElementById(
      "delete-vinyl-dropdown"
    );
    // Populate the dropdown
    deleteVinylDropdown.innerHTML = '<option value="">Select a Vinyl</option>';

    // Sort the data in alphabetical order by vinyl name
    data.sort((a, b) => a.title.localeCompare(b.title));

    data.forEach((vinyl) => {
      const row = document.createElement("tr");
      row.innerHTML = `
                        <td>${vinyl.title}</td>
                        <td>${vinyl.artistName}</td>  
                        <td>${vinyl.label}</td>
                        <td>${vinyl.yearReleased}</td>
                    `;
      table.appendChild(row);

      // Load the Delete Vinyl Dropdown
      const option = document.createElement("option");
      option.value = vinyl.vinylID;
      option.textContent = `${vinyl.title} - ${vinyl.artistName} (${vinyl.yearReleased})`;
      deleteVinylDropdown.appendChild(option);
    });
  } catch (error) {
    console.error("Error loading vinyls:", error);
  }
};

// Fetch artists from the backend and update the dropdown
const loadArtists = async () => {
  try {
    const response = await fetch("/api/artists");
    const [data] = await response.json();
    const dropdown = document.getElementById("artist-dropdown");
    // Sort the data in alphabetical order by artistName
    data.sort((a, b) => a.artistName.localeCompare(b.artistName));
    data.forEach((artist) => {
      const option = document.createElement("option");
      option.value = artist.artistID;
      option.textContent = `${artist.artistName}`;
      dropdown.appendChild(option);
    });
  } catch (error) {
    console.error("Error loading artists:", error);
  }
};

// Handle form submission to add a new vinyl

const form = document.getElementById("add-vinyl-form");

form.addEventListener("submit", async function (e) {
  e.preventDefault();

  const formData = new FormData(e.target);
  const vinylData = {
    title: formData.get("title"),
    label: formData.get("label"),
    yearReleased: formData.get("yearReleased"),
    artistID: formData.get("artistID"),
  };
  try {
    const response = await fetch("/api/vinyls/add-vinyl", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(vinylData),
    });
    const data = await response.json();

    if (data.success) {
      alert("Vinyl added successfully!");
      refreshData();
      e.target.reset();
    } else {
      alert("Error adding vinyl: " + data.error);
    }
  } catch (error) {
    console.error("Error:", error);
  }
});

const deleteVinylForm = document.getElementById("delete-vinyl-form");

// Delete a vinyl
deleteVinylForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const vinylID = document.getElementById("delete-vinyl-dropdown").value;

  try {
    const response = await fetch(`/api/vinyls/${vinylID}`, {
      method: "DELETE",
    });
    alert("Vinyl deleted!");
    refreshData();
  } catch (error) {
    console.error("Error deleting vinyl:", error);
    alert("Error deleting vinyl: " + error.message);
  }
});

// Load the vinyls and artists when the page loads
document.addEventListener("DOMContentLoaded", refreshData);
