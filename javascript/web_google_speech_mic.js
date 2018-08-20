

var final_transcript = '';
var recognizing = false;
var ignore_onend;
var start_timestamp;

var recognition;

var init = function() {
      if (!('webkitSpeechRecognition' in window)) {
        alert('In order to use the speech interface, you must use Google Chrome')
        upgrade();
      } else {
        recognition = new webkitSpeechRecognition();
        recognition.continuous = true;
        recognition.interimResults = true;

        recognition.onstart = function() {
          recognizing = true;
          alert("Can speak no problem");
          start_img.src = '/../html/mic-animate.gif';
        };

        recognition.onerror = function(event) {
          var eventError = event.error;
          if (eventError == 'no-speech') {
            start_img.src = '/../html/mic.gif';
            alert("No speech was detected. You may need to adjust your microphone settings");
            ignore_onend = true;
          }
          if (eventError == 'audio-capture') {
            start_img.src = '/../html/mic.gif';
            alert(" No microphone was found. Ensure that a microphone is installed and that microphone settings are configured correctly");
            ignore_onend = true;
          }
          if (eventError == 'not-allowed') {
            if (event.timeStamp - start_timestamp < 100) {
              alert('Permission to use microphone was blocked');
            } else {
              alert('Permission to use microphone was denied.');
            }
            ignore_onend = true;
          }
        };

        recognition.onend = function() {
          recognizing = false;
          if (ignore_onend) {
            return;
          }
          start_img.src = '/../html/mic.gif';
          if (!final_transcript) {
            return;
          }
          if (window.getSelection) {
            window.getSelection().removeAllRanges();
            var range = document.createRange();
            window.getSelection().addRange(range);
          }

        };

        recognition.onresult = function(event) {
          var interim_transcript = '';
          for (var i = event.resultIndex; i < event.results.length; ++i) {
            if (event.results[i].isFinal) {

              final_transcript += event.results[i][0].transcript; // not asynch
            }
            else {
              interim_transcript += event.results[i][0].transcript;
              viewModel.speechData(interim_transcript);

            }
            if((event.results[i][0].transcript[event.results[i][0].transcript.length-1] == "." || event.results[i][0].transcript[event.results[i][0].transcript.length-1] == "?")&& event.results[i][0].confidence > 0.83) {
                  recognition.stop();
            }

          }
          final_transcript = capitalize(final_transcript);
          linebreak(final_transcript);
          linebreak(interim_transcript);

          if(final_transcript != '') {
            //console.log("final");
            final_transcript = final_transcript.replace(" Full stop", ".");
            final_transcript = final_transcript.replace("Full stop", ".");
            final_transcript = final_transcript.replace(" full stop", ".");
            final_transcript = final_transcript.replace("full stop", ".");

            final_transcript = final_transcript.replace("information", "Information");
            final_transcript = final_transcript.replace("technology", "Technology");

            viewModel.postSpeechToken(final_transcript);

            final_transcript = '';
            //document.getElementById('text_field').value = final_transcript;
            }
          else
            // document.getElementById('text_field').value = interim_transcript;

          if (final_transcript || interim_transcript)
            showButtons('inline-block');
        };
      }
} // END OF INIT



function upgrade() {
  start_button.style.visibility = 'hidden';
}

var two_line = /\n\n/g;
var one_line = /\n/g;
function linebreak(s) {
  return s.replace(two_line, '<p></p>').replace(one_line, '<br>');
}

var first_char = /\S/;
function capitalize(s) {
  return s.replace(first_char, function(m) { return m.toUpperCase(); });
}


function startButton(event) {

  if (recognizing) {
    recognition.stop();
    return;
  }
  final_transcript = '';
  recognition.lang = select_dialect.value;
  recognition.start();
  ignore_onend = false;

  start_img.src = '/../html/mic-slash.gif';
  showButtons('none');
  start_timestamp = event.timeStamp;
}


var current_style;
function showButtons(style) {
  if (style == current_style) {
    return;
  }
  current_style = style;
}
