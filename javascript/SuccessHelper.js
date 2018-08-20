/**
*     Contains helper functions for when AJAX requests is successful
*
*/


var SuccessHelper = {


      loadSingleTextFile: function(data, textStatus, jqXHR) {
            var s1 = performance.now();
            var r = "";
            var json = JSON.parse(data);
            var s = json.spectext;
            var sentence = "";
            // FORMATS TO READABLE INPUT
            s = s.replace(/%(.)*/g, '');
            s = s.split('\r').join('');
            s = s.split('\n').join('');
            s = s.replace(/\/\*.*\*\//, '');
            s = s.split('\r').join('');
            s = s.split('\n').join('');
            s = s.split('  ').join('');
            s = s.split('.').join(' . ');
            s = s.split('?').join(' ? ');
            s = s.split(', ').join(' , ');


            var nodes = s.split(" ");
            viewModel.init();

            for (i = 0; i < nodes.length; i++) {
                  var x = i;
                  if(nodes[i] != "")
                        viewModel.postToken(nodes[i]);


                  i = x;
                  if (nodes[i] == "." || nodes[i] == "?") {
                        sentence = sentence.slice(0, sentence.length - 1);
                        sentence += nodes[i];

                        textLineData.addSentence(sentence);
                        viewModel.textList.push(sentence);
						viewModel.textAreaStr.push(sentence);




                        if(i != nodes.length-1)
                              viewModel.postToken(" ");
                        sentence = "";

                  }
                  else {
                        sentence+=nodes[i]+" ";

                  }
                  i = x;
            }
            var s2 = performance.now();
            console.log(s2-s1);
            viewModel.$loader.css("visibility","hidden");
      },

      postTokenForLoading: function(data) {
                  var json = JSON.parse(data);
                  viewModel.populateLookUpTable(json);

                  if (word == "." || word == "?") {
                        viewModel.setAsp(json.asp);
                        viewModel.allowInput = true;
                  }

                  if(json.hasOwnProperty('spelling suggestions') || (json.lookahead.length == 0 && !json.hasOwnProperty('asp'))) {
                        viewModel.allowInput = false;
                        alert('"'+word+'" is not a valid token. Please go back and re-enter a token or add to lexicon');
                        viewModel.addButton("Add");
                  }
                  else {
                        viewModel.allowInput = true;
                  }

                  if(json.hasOwnProperty('ana') && word != ".") {
                        viewModel.anaExp(json.ana);
                  }

      }

}
