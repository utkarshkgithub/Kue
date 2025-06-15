function initCustomCursor() {
  const cursor = document.querySelector('.custom-cursor');
  
  if (!cursor) {
    console.warn('Custom cursor element not found');
    return;
  }

  // Mouse movement
  document.addEventListener('mousemove', (e) => {
    cursor.style.left = `${e.clientX - 5}px`;
    cursor.style.top = `${e.clientY - 5}px`;
  });

  // Click effects
  document.addEventListener('mousedown', (e) => {
    cursor.classList.add('click');
    if(e.button === 2) { // Right click
      cursor.classList.add('right-click');
    }
  });

  document.addEventListener('mouseup', () => {
    cursor.classList.remove('click', 'right-click');
  });

  // Hover effects
  document.querySelectorAll('a, button, .post, .hover-effect').forEach(element => {
    element.addEventListener('mouseenter', () => {
      cursor.style.transform = 'scale(1.2)';
    });
    element.addEventListener('mouseleave', () => {
      cursor.style.transform = 'scale(1)';
    });
  });
}

document.addEventListener('DOMContentLoaded', () => {
  // Theme Toggle
  const themeToggle = document.getElementById('theme-toggle');
  const savedTheme = localStorage.getItem('theme') || 'dark';
  document.documentElement.setAttribute('data-theme', savedTheme);

  themeToggle.addEventListener('click', () => {
    // Get the current theme dynamically
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
  });

  // Initialize custom cursor
  initCustomCursor();
});