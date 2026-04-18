$(function () {

  function styleContentToMD() {
    $('#markdown-content-container table').addClass('table');
    $('#markdown-content-container img').addClass('img-responsive');
  }

  $(document).on('docsContentLoaded', styleContentToMD);
  styleContentToMD();
});
