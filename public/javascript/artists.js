// Get all the artists and create the
const loadArtists = async () => {
  try {
    const response = await fetch("/api/artists");
    const [data] = await response.json();
    const table = document.getElementById("artists-table");

    // Load delete artist dropdown
    const deleteArtistDropdown = document.getElementById(
      "delete-artist-dropdown"
    );
    // Populate the dropdown
    deleteArtistDropdown.innerHTML = '<option value="">Select Artist</option>';

    table.innerHTML = "";
    // Sort the data in alphabetical order by artistName
    data.sort((a, b) => a.artistName.localeCompare(b.artistName));
    data.forEach((artist) => {
      const row = document.createElement("tr");
      row.innerHTML = `
                      <td>${artist.artistID}</td>
                      <td>${artist.artistName}</td>
                      <td>${artist.genre}</td>
                      <td>${artist.countryOrigin}</td>
                  `;
      table.appendChild(row);

      // Load the Delete Vinyl Dropdown
      const option = document.createElement("option");
      option.value = artist.artistID;
      option.textContent = `${artist.artistName}`;
      deleteArtistDropdown.appendChild(option);
    });
  } catch (error) {
    console.error("Error loading artists:", error);
  }
};

// Add new artist with a form submission
const form = document.getElementById("add-artist-form");
form?.addEventListener("submit", async (e) => {
  e.preventDefault();

  const formData = new FormData(e.target);
  const artistData = {
    artistName: formData.get("artistName"),
    genre: formData.get("genre"),
    countryOrigin: formData.get("countryOrigin"),
  };

  try {
    const response = await fetch("/api/artists/add-artist", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(artistData),
    });

    const data = await response.json();
    if (data.success) {
      alert("Artist added successfully!");
      loadArtists();
      form.reset();
    } else {
      alert("Error adding artist: " + (data.error || "Unknown error"));
    }
  } catch (error) {
    console.error("Error:", error);
    alert("An unexpected error occured. Please try again");
  }
});

const deleteArtistForm = document.getElementById("delete-artist-form");

// Delete an artist
deleteArtistForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const artistID = document.getElementById("delete-artist-dropdown").value;

  try {
    const response = await fetch(`/api/artists/${artistID}`, {
      method: "DELETE",
    });
    alert("Artist deleted!");
    loadArtists();
  } catch (error) {
    console.error("Error deleting artist:", error);
    alert("Error deleting vinyl: " + error.message);
  }
});

document.addEventListener("DOMContentLoaded", () => loadArtists());
