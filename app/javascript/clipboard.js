function copyToClipboard() {
  const url = window.location.href;
  navigator.clipboard.writeText(url).then(() => {
    alert('URLをコピーしました');
  }, (error) => {
    console.error('Failed to copy URL: ', error);
  });
}

document.getElementById('js-copy-url').addEventListener('click', e => {
  copyToClipboard();
});
