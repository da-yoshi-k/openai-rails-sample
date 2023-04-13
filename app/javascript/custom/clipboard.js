document.addEventListener('turbo:load', function () {
  console.log("test");
  const copyButton = document.getElementById('js-copy-url');
  if (copyButton) {
    copyButton.addEventListener('click', function () {
      const url = window.location.href;
      navigator.clipboard.writeText(url).then(() => {
        alert('URLをコピーしました');
      }, (error) => {
        console.error('Failed to copy URL: ', error);
      });
    });
  }
});
