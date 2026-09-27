const container   = document.querySelector(".container");
const inputField  = document.querySelector(".Input");
const confirmBtn  = document.querySelector(".ConfirmButton");
const resetBtn    = document.querySelector(".ResetButton");
const exitBtn     = document.querySelector(".Exit");
const godmodeBtn  = document.getElementById("godmodeBtn");
const invisibleBtn = document.getElementById("invisibleBtn");
const healBtn     = document.getElementById("healBtn");
const featureDiv  = document.querySelector(".FeatureButtons");

container.style.display = "none";

window.addEventListener("message", (event) => {
    const data = event.data;

    if (data.action === "openMenu") {
        container.style.display = "flex";
        inputField.value = "";
        inputField.focus();

        if (data.features) {
            godmodeBtn.style.display   = data.features.Godmode   ? "block" : "none";
            invisibleBtn.style.display = data.features.Invisible ? "block" : "none";
            healBtn.style.display      = data.features.Heal      ? "block" : "none";
        }

        godmodeBtn.classList.toggle("active", !!data.godmode);
        invisibleBtn.classList.toggle("active", !!data.invisible);
    }

    if (data.action === "closeMenu") {
        container.style.display = "none";
    }
});

confirmBtn.addEventListener("click", () => {
    const pedName = inputField.value.trim();
    if (!pedName) return;

    fetch(`https://${GetParentResourceName()}/confirm`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pedName: pedName }),
    });
});

inputField.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
        event.preventDefault();
        confirmBtn.click();
    }
});

resetBtn.addEventListener("click", () => {
    fetch(`https://${GetParentResourceName()}/reset`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({}),
    });
});

godmodeBtn.addEventListener("click", () => {
    fetch(`https://${GetParentResourceName()}/godmode`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({}),
    }).then(res => res.json()).then(data => {
        godmodeBtn.classList.toggle("active", data.active);
    });
});

invisibleBtn.addEventListener("click", () => {
    fetch(`https://${GetParentResourceName()}/invisible`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({}),
    }).then(res => res.json()).then(data => {
        invisibleBtn.classList.toggle("active", data.active);
    });
});

healBtn.addEventListener("click", () => {
    fetch(`https://${GetParentResourceName()}/heal`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({}),
    });
});

exitBtn.addEventListener("click", () => {
    fetch(`https://${GetParentResourceName()}/exit`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({}),
    });
});

document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/exit`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({}),
        });
    }
});