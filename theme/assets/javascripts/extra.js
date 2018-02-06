var nodemcu = nodemcu || {};
(function() {
  "use strict";

  var languageCodeToNameMap = {
    en: "English",
    pl: "Polish"
  };
  var languageNames = values(languageCodeToNameMap);
  var defaultLanguageCode = "en";

  document.addEventListener("DOMContentLoaded", function(event) {

  });

  /**
   * Analyzes the URL of the current page to find out what the selected language is. It's usually
   * part of the location path. The code needs to distinguish between running MkDocs standalone
   * and docs served from RTD. If no valid language could be determined the default language is
   * returned.
   *
   * @returns 2-char language code
   */
  function determineSelectedLanguageCode() {
    var selectedLanguageCode,
      path = window.location.pathname;
    if (window.location.origin.indexOf("readthedocs") > -1) {
      // path is like /en/<branch>/<lang>/build/ -> extract 'lang'
      // split[0] is an '' because the path starts with the separator
      selectedLanguageCode = path.split("/")[3];
    } else if (!window.location.href.startsWith("file://")) {
      // path is like /<lang>/build/ -> extract 'lang'
      selectedLanguageCode = path.substr(1, 2);
    }
    if (!selectedLanguageCode || selectedLanguageCode.length > 2) {
      selectedLanguageCode = defaultLanguageCode;
    }
    return selectedLanguageCode;
  }

  function values(associativeArray) {
    var values = [];
    for (var key in associativeArray) {
      if (associativeArray.hasOwnProperty(key)) {
        values.push(associativeArray[key]);
      }
    }
    return values;
  }
})();
