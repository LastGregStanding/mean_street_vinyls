// Get all the artists and create the
const loadArtists = async () => {
  try {
    const response = await fetch("/api/artists");
    const [data] = await response.json();
    const table = document.getElementById("artists-table");
    table.innerHTML = "";
    data.forEach((artist) => {
      const row = document.createElement("tr");
      row.innerHTML = `
                      <td>${artist.artistID}</td>
                      <td>${artist.artistName}</td>
                      <td>${artist.genre}</td>
                      <td>${artist.countryOrigin}</td>
                  `;
      table.appendChild(row);
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

document.addEventListener("DOMContentLoaded", () => loadArtists());
