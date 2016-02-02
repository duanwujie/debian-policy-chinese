(setq
 org-export-html-style-include-default nil
 org-export-html-style
      "
<style type=\"text/css\">
  html { font-family: Times, serif; font-size: 12pt; }
  .title  { text-align: center; }
  p.verse { margin-left: 3% }
  pre {
        border: 1pt solid #AEBDCC;
        color: #000000;
        background-color: LightSlateGray;
        padding: 5pt;
        font-family: \"Courier New\", courier, monospace;
        font-size: 90%;
        overflow:auto;
  }
  dt { font-weight: bold; }
  div.figure { padding: 0.5em; }
  div.figure p { text-align: center; }
  .linenr { font-size:smaller }
  .code-highlighted {background-color:#ffff00;}
  .org-info-js_info-navigation { border-style:none; }
  #org-info-js_console-label { font-size:10px; font-weight:bold;
                               white-space:nowrap; }
  .org-info-js_search-highlight {background-color:#ffff00; color:#000000;
                                 font-weight:bold; }

  body {
   color: black;
   background-color: white;
   font-family: Palatino, \"Palatino Linotype\", \"Hoefler Text\", \"Times New Roman\", Times, Georgia, Utopia, serif;
  }
  .org-agenda-date          { color: #87cefa;    }
  .org-agenda-structure     { color: #87cefa;    }
  .org-scheduled            { color: #98fb98;    }
  .org-scheduled-previously { color: #ff7f24;    }
  .org-scheduled-today      { color: #98fb98;    }
  .org-tag                  { font-weight: bold; }
  .org-todo                 {
    color: #ffc0cb;
    font-weight: bold;
  }
 
  a:hover { text-decoration: underline; }
  .todo  { font-weight:bold; }
  .done { font-weight:bold; }
  .TODO { color:red; }
  .WAITING { color:orange; }
  .DONE { color:green; }
  .timestamp { color: grey }
  .timestamp-kwd { color: CadetBlue }
  .tag { background-color:lightblue; font-weight:normal }
  .target { background-color: lavender; }
table {
        border-collapse: collapse; /*separate; */
        border: outset 3pt;
        border-spacing: 0pt;
        /* border-spacing: 5pt; */
        }
table td             { vertical-align: top; border: 1px solid; }
table th             { vertical-align: top; border: 2px solid; }
</style>
<script =\"text/javascript\" language=\"JavaScript\" src=\"/styles/org-info.js\"></script>
<script type=\"text/javascript\" language=\"JavaScript\">
/* <![CDATA[ */
org_html_manager.set(\"LOCAL_TOC\", 0);
org_html_manager.set(\"VIEW_BUTTONS\", 1);
org_html_manager.set(\"VIEW\", \"info\");
org_html_manager.set(\"TOC\", 1);
org_html_manager.set(\"MOUSE_HINT\", \"underline\"); // could be a background-color like #eeeeee
org_html_manager.setup ();
/* ]]> */
</script>
")
