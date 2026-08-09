const weddingDate = new Date('2026-10-24T14:00:00');

function updateCountdown() {
  const el = document.getElementById('countdown');
  if (!el) return;
  const diff = weddingDate.getTime() - Date.now();
  const days = Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)));
  el.textContent = `${days} days`;
}

updateCountdown();
setInterval(updateCountdown, 60_000);
