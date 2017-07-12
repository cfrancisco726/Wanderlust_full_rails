<html lang="en">

<head>
  <meta charset="utf-8">
  <title>jQuery UI Autocomplete</title>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
  <style>
    #city {
      width: 25em;
    }
  </style>
  <script>
    $(function() {
      function log(message) {
        $("<div>").text(message).prependTo("#log");
        $("#log").scrollTop(0);
      }
      $("#city").autocomplete({
        source: function(request, response) {
          $.ajax({
            url: "http://api.sandbox.amadeus.com/v1.2/airports/autocomplete",
            dataType: "json",
            data: {
              apikey: "P9Xuv7e4586ThMfR3nHlkojwJCR7ZHfe",
              term: request.term
            },
            success: function(data) {
              response(data);
            }
          });
        },
        minLength: 3,
        select: function(event, ui) {
          log(ui.item ?
            "Selected: " + ui.item.label :
            "Nothing selected, input was " + this.value);
        },
        open: function() {
          $(this).removeClass("ui-corner-all").addClass("ui-corner-top");
        },
        close: function() {
          $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
        }
      });
    });
  </script>
</head>

<body>
  <div class="ui-widget">
    <label for="city">Your city: </label>
    <input id="city">
  </div>
  <div class="ui-widget" style="margin-top:2em; font-family:Arial">
    Result:
    <div id="log" style="height: 200px; width: 300px; overflow: auto;" class="ui-widget-content"></div>
  </div>
</body>

</html>
