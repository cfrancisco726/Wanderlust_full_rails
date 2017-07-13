$(document).ready(function() {

  // debugger
  $('body').on("click", '.save-flight-button', function(e){
    e.preventDefault();
    $.ajax({
      url: $(e.target).attr('href'),
      method: 'get'
    })

    })
  })


