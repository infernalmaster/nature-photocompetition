$(document).ready(function() {
  initTakePart();
});

function initTakePart() {
  // for debug
  // activateStep(2);

  var $prg = $(".prg");
  var prgXHR = function() {
    var xhr = $.ajaxSettings.xhr();
    xhr.upload.onprogress = function(e) {
      var percents = Math.floor((e.loaded / e.total) * 100) + "%";
      $prg.show().text(percents);
    };
    return xhr;
  };
  var prgHide = function() {
    $prg.hide();
  };

  var $takePartContent = $(".js-take-part-content");

  var $steps = $(".js-take-part__step");

  var $navItem = $(".js-take-part__nav-item");

  function activateStep(number) {
    $steps
      .removeClass("active")
      .eq(number)
      .addClass("active");
    $navItem
      .removeClass("active")
      .eq(number)
      .addClass("active");
    $("html, body")
      .stop()
      .animate(
        {
          scrollTop: $takePartContent.offset().top
        },
        300
      );
  }

  $(".js-agree-with-right").click(function() {
    activateStep(1);
  });

  // profile form
  var $profileForm = $(".js-profile-form");

  var $profileFormBtn = $(".js-send-profile");

  $profileForm.validationEngine("attach", {
    promptPosition: "topRight:-150,0",
    scrollOffset: 220
  });
  $profileFormBtn.click(function() {
    if (
      $profileForm.validationEngine("validate", {
        promptPosition: "topRight:-150,0",
        scrollOffset: 220
      })
    ) {
      $profileFormBtn.prop("disabled", true);

      $.post("/save_profile", $profileForm.serialize()).then(
        function(response) {
          $profileFormBtn.prop("disabled", false);
          activateStep(2);
        },
        function(xhr) {
          $profileFormBtn.prop("disabled", false);
          alert("Сталася помилка: " + xhr.responseText);
        }
      );
    }
  });

  $('.js-img-dlt').click(function(e) {
    var container = $(e.target).parents('.js-img-container');

    container
      .find(".js-img-input")
      .val('')

    container
      .find(".js-img-preview")
      .prop("src", '');

    container
      .find(".js-img-title")
      .val('');

    container
      .find(".js-img-dlt")
      .hide();
  });

  function processFileInput(el) {
    if (!el.files || !el.files[0]) {
      return;
    }

    var $el = $(el);

    var file = el.files[0];

    var reader = new FileReader();

    var image = new Image();

    reader.onload = function(_file) {
      image.onload = function() {
        var n = file.name;

        if (file.type !== "image/jpeg") {
          return alert("тільки файли з розширенням jpeg aбо jpg");
        }
        if (this.width >= 2400 || this.height >= 2400) {
          var container = $el.parents('.js-img-container');

          container
            .find(".js-img-preview")
            .prop("src", this.src);

          container
            .find(".js-img-title")
            .val(n.split(".")[0]);

          container
            .find(".js-img-dlt")
            .show();
        } else {
          $el.val("");
          alert("мінімум 2400 px по довшій стороні");
        }
      };
      image.onerror = function() {
        alert("тільки файли з розширенням jpeg aбо jpg");
      };
      image.src = _file.target.result; // url.createObjectURL(file);
    };
    reader.readAsDataURL(file);
  }

  // when press browser back btn
  $(".js-img-input").each(function (i, el) {
    processFileInput(el);
  })

  $(".js-img-input").change(function (e) {
    processFileInput(e.target);
  });

  var $imageForm = $(".js-images-form");

  var $photosFormBtn = $(".js-send-photos");
  $photosFormBtn.click(function() {
    if (
      $imageForm.validationEngine("validate", {
        promptPosition: "topLeft",
        scrollOffset: 220
      })
    ) {
      $photosFormBtn.prop("disabled", true);

      $.ajax({
        url: "/upload",
        type: "POST",
        data: new FormData($imageForm[0]),
        processData: false,
        contentType: false,
        xhr: prgXHR
      }).then(
        function(response) {
          prgHide();
          if (response === 'success') {
            document.location.href = '/success'
          } else {
            var $form = $(response)
            $('body').append($form)
            $form.submit()
          }
        },
        function(xhr) {
          prgHide();
          $photosFormBtn.prop("disabled", false);
          alert("Сталася помилка: " + xhr.responseText + ". Спробуйте ще раз.");
        }
      );
    }
  });

  $(".js-back-from-profile").click(function() {
    activateStep(0);
  });

  $(".js-back-from-photos").click(function() {
    activateStep(1);
  });
}
