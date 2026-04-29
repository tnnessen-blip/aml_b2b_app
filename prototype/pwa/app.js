const cases = {
  "AML-2048": {
    name: "Nordfjord Import AS",
    risk: 96,
    riskClass: "critical",
    exposure: "kr 4,8 mill.",
    date: "26.04.2026"
  },
  "AML-2035": {
    name: "Berg & Co Holding",
    risk: 88,
    riskClass: "high",
    exposure: "kr 980 000",
    date: "27.04.2026"
  },
  "AML-2017": {
    name: "Elva Trading Ltd",
    risk: 79,
    riskClass: "watch",
    exposure: "kr 1,3 mill.",
    date: "25.04.2026"
  },
  "AML-1988": {
    name: "Sj\u00f8lyst Konsulent",
    risk: 84,
    riskClass: "high",
    exposure: "kr 640 000",
    date: "24.04.2026"
  },
  "AML-1944": {
    name: "M\u00f8llebyen Eiendom",
    risk: 67,
    riskClass: "medium",
    exposure: "kr 2,1 mill.",
    date: "21.04.2026"
  }
};

const caseRows = Array.from(document.querySelectorAll("#caseRows tr"));
const tabButtons = Array.from(document.querySelectorAll(".tabs button"));
const priorityButtons = Array.from(document.querySelectorAll(".priority-item"));
const searchInput = document.querySelector("#globalSearch");
const installButton = document.querySelector("#installAppBtn");
const stateKey = "aml-kontroll-app-state-v1";
let activeFilter = "all";
let deferredInstallPrompt = null;

function readAppState() {
  try {
    return JSON.parse(window.localStorage.getItem(stateKey)) || {};
  } catch {
    return {};
  }
}

function writeAppState(nextState) {
  window.localStorage.setItem(stateKey, JSON.stringify(nextState));
}

function saveCaseStatus(caseId, text, className) {
  const currentState = readAppState();
  const casesState = currentState.cases || {};
  casesState[caseId] = { status: text, className };
  writeAppState({ ...currentState, cases: casesState });
}

function updateCaseStatus(row, text, className) {
  const status = row.querySelector(".status");
  status.textContent = text;
  status.className = className;
  saveCaseStatus(row.dataset.case, text, className);
}

function hydrateAppState() {
  const currentState = readAppState();

  Object.entries(currentState.cases || {}).forEach(([caseId, value]) => {
    const row = caseRows.find((item) => item.dataset.case === caseId);
    if (!row || !value.status || !value.className) return;

    const status = row.querySelector(".status");
    status.textContent = value.status;
    status.className = value.className;
  });

  if (Number.isFinite(currentState.activeAlerts)) {
    document.querySelector("#activeAlerts").textContent = String(currentState.activeAlerts);
  }

  if (currentState.activeDelta) {
    document.querySelector("#activeDelta").textContent = currentState.activeDelta;
  }
}

function selectCase(caseId) {
  const data = cases[caseId];
  if (!data) return;

  document.querySelector("#profileName").textContent = data.name;
  document.querySelector("#profileCase").textContent = caseId;
  document.querySelector("#profileExposure").textContent = data.exposure;
  document.querySelector("#profileDate").textContent = data.date;

  const risk = document.querySelector("#profileRisk");
  risk.textContent = data.risk;
  risk.className = `badge ${data.riskClass}`;

  caseRows.forEach((row) => row.classList.toggle("active-row", row.dataset.case === caseId));
  priorityButtons.forEach((button) => button.classList.toggle("selected", button.dataset.case === caseId));
}

function applyFilters() {
  const query = searchInput.value.trim().toLowerCase();

  caseRows.forEach((row) => {
    const matchesTab = activeFilter === "all" || row.dataset.filter === activeFilter;
    const matchesSearch = row.textContent.toLowerCase().includes(query);
    row.classList.toggle("hidden", !(matchesTab && matchesSearch));
  });
}

tabButtons.forEach((button) => {
  button.addEventListener("click", () => {
    activeFilter = button.dataset.filter;
    tabButtons.forEach((tab) => tab.classList.toggle("active", tab === button));
    applyFilters();
  });
});

priorityButtons.forEach((button) => {
  button.addEventListener("click", () => selectCase(button.dataset.case));
});

caseRows.forEach((row) => {
  row.addEventListener("click", () => selectCase(row.dataset.case));
});

searchInput.addEventListener("input", applyFilters);

document.querySelector("#escalateBtn").addEventListener("click", () => {
  const caseId = document.querySelector("#profileCase").textContent;
  const row = caseRows.find((item) => item.dataset.case === caseId);
  if (!row) return;

  updateCaseStatus(row, "Eskalert", "status review");
});

document.querySelector("#clearBtn").addEventListener("click", () => {
  const caseId = document.querySelector("#profileCase").textContent;
  const row = caseRows.find((item) => item.dataset.case === caseId);
  if (!row) return;

  updateCaseStatus(row, "Lavere risiko", "status closed");

  const activeAlerts = document.querySelector("#activeAlerts");
  const current = Number.parseInt(activeAlerts.textContent, 10);
  const nextAlerts = Math.max(current - 1, 0);
  activeAlerts.textContent = String(nextAlerts);
  document.querySelector("#activeDelta").textContent = "+13";

  const currentState = readAppState();
  writeAppState({ ...currentState, activeAlerts: nextAlerts, activeDelta: "+13" });
});

document.querySelectorAll(".segmented-control button").forEach((button) => {
  button.addEventListener("click", () => {
    document.querySelectorAll(".segmented-control button").forEach((item) => {
      item.classList.toggle("active", item === button);
    });
    drawScenarioChart(button.textContent.trim());
  });
});

function drawScenarioChart(range = "24 t") {
  const canvas = document.querySelector("#scenarioChart");
  const ctx = canvas.getContext("2d");
  const width = canvas.width;
  const height = canvas.height;
  const padding = 24;
  const series = {
    "24 t": [18, 25, 21, 34, 29, 43, 52, 61],
    "7 d": [44, 39, 48, 53, 57, 62, 69, 76],
    "30 d": [58, 61, 56, 64, 72, 70, 82, 91]
  };
  const values = series[range] || series["24 t"];
  const max = Math.max(...values) + 10;
  const min = Math.min(...values) - 10;

  ctx.clearRect(0, 0, width, height);
  ctx.fillStyle = "#fbfaf7";
  ctx.fillRect(0, 0, width, height);

  ctx.strokeStyle = "#ded8cf";
  ctx.lineWidth = 1;
  for (let i = 0; i < 4; i += 1) {
    const y = padding + i * ((height - padding * 2) / 3);
    ctx.beginPath();
    ctx.moveTo(padding, y);
    ctx.lineTo(width - padding, y);
    ctx.stroke();
  }

  const points = values.map((value, index) => {
    const x = padding + index * ((width - padding * 2) / (values.length - 1));
    const y = height - padding - ((value - min) / (max - min)) * (height - padding * 2);
    return { x, y };
  });

  const gradient = ctx.createLinearGradient(0, padding, 0, height - padding);
  gradient.addColorStop(0, "rgba(15, 124, 116, 0.26)");
  gradient.addColorStop(1, "rgba(15, 124, 116, 0)");

  ctx.beginPath();
  ctx.moveTo(points[0].x, height - padding);
  points.forEach((point) => ctx.lineTo(point.x, point.y));
  ctx.lineTo(points[points.length - 1].x, height - padding);
  ctx.closePath();
  ctx.fillStyle = gradient;
  ctx.fill();

  ctx.beginPath();
  points.forEach((point, index) => {
    if (index === 0) ctx.moveTo(point.x, point.y);
    else ctx.lineTo(point.x, point.y);
  });
  ctx.strokeStyle = "#0f7c74";
  ctx.lineWidth = 3;
  ctx.stroke();

  points.forEach((point) => {
    ctx.beginPath();
    ctx.arc(point.x, point.y, 4, 0, Math.PI * 2);
    ctx.fillStyle = "#ffffff";
    ctx.fill();
    ctx.strokeStyle = "#0f7c74";
    ctx.lineWidth = 2;
    ctx.stroke();
  });
}

window.addEventListener("beforeinstallprompt", (event) => {
  event.preventDefault();
  deferredInstallPrompt = event;
  installButton?.classList.remove("hidden");
});

installButton?.addEventListener("click", async () => {
  if (!deferredInstallPrompt) return;

  deferredInstallPrompt.prompt();
  const choice = await deferredInstallPrompt.userChoice;
  if (choice.outcome === "accepted") {
    installButton.classList.add("hidden");
  }
  deferredInstallPrompt = null;
});

window.addEventListener("appinstalled", () => {
  installButton?.classList.add("hidden");
  deferredInstallPrompt = null;
});

if ("serviceWorker" in navigator && ["http:", "https:"].includes(window.location.protocol)) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("./sw.js").catch(() => {
      // The dashboard still works without offline caching.
    });
  });
}

hydrateAppState();
drawScenarioChart();
selectCase("AML-2048");
