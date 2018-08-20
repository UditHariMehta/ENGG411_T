// helping the user to choose the correct word as token
// return an error statement if the word is not a valid token
var clickHelper = {

      // checks if the correct word is chosen
      postWordClicked: function(data, event) {
            if(data.slice(0, 4) == "Add:") {
                  var slicedToken = data.slice(0, 4);
				  // lookahead table 
                  var lAhead = Lookahead.createLookaheadTable(Lookahead);
                  var catIndex = 0;
                  var cat = $(event.target).parent().parent().siblings().html();
                  for (i = 0; i < Lookahead.cats.length; i++) {
                        if (cat ==  Lookahead.cats[i]) {
                              catIndex = i;
                              break;
                        }
                  }
                  var num = Lookahead.nums[catIndex];
                  var vform = (num == " ") ? "inf" : "fin";
                  var wfm = data.slice(5, data.length);
                  addToLexicon(cat, wfm, vform, num);
                  var pop = textLineData.removeTailNode();

                  viewModel.postToken(pop);

                  viewModel.textAreaStr(viewModel.$text_field.val());

            }
            else if (viewModel.allowInput) {
                  var dataArr = data.split(" ");
                  var s;
                  for (s = 0; s < dataArr.length; s++) {
                        viewModel.postToken(viewModel.token()+dataArr[s]);
                        if(dataArr[s] == "." || dataArr[s] == "?") {
                              viewModel.token(dataArr[s]);
                              viewModel.textAreaStr(viewModel.textAreaStr().slice(0, viewModel.textAreaStr().length-1)+dataArr[s]);
                        }
                        else if (data == ",") {
                              viewModel.textAreaStr(viewModel.textAreaStr().slice(0, viewModel.textAreaStr().length-1)+dataArr[s]+" ");
                        }
                        else {
                              viewModel.textAreaStr(viewModel.textAreaStr()+dataArr[s]+" ");
                              viewModel.firstIndexOfCurrentWord = viewModel.textAreaStr().length;
                              viewModel.loadLookahead();
                        }
                  }

                  if(!viewModel.allowInput) {
                        viewModel.token(viewModel.token()+ dataArr[0]);
                  }
            }
      },

      postAnaExpClicked: function(words) {
            var wordA = ""+words;
            var word = wordA.split(" ");
            if(viewModel.lookUpTable().indexOf(word[0]) != -1) {
                  if(word.length > 1) {
                        for(k = 0; k < word.length; k++) {
                              viewModel.postToken(word[k]);
                              viewModel.textAreaStr(viewModel.textAreaStr()+word[k]+" ");
                        }
                  }
                  else {
                        viewModel.postToken(word[0]);
                        viewModel.textAreaStr(viewModel.textAreaStr()+word[0]+" ");
                  }
                  viewModel.loadLookahead();
            }
			// error message
            else {
                  alert("The anaphoric expression \""+word+"\" is not a valid token and will not be submitted. "+
                  "Please try another input.");
            }
      },


}
