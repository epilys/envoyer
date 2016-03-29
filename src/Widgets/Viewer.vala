public class ENotes.Viewer : WebKit.WebView {
    public string CSS;
    private File temp_file;

    public Viewer () {
        load_css ();

        string file = "/tmp/notes-up-render-" + GLib.Environment.get_user_name ();
        temp_file = File.new_for_path (file);
    }

    public void load_css () {
        CSS = ENotes.settings.render_stylesheet;
        if (CSS == "") {
            CSS = DEFAULT_CSS;
        }
    }

    public void load_string (string page_content) {
        if (headerbar.get_mode () == 1) return;

        string html;
        process_frontmatter (page_content, out html);
    }

    private string[] process_frontmatter (string raw_mk, out string processed_mk) {
        string[] map = {};

        processed_mk = null;

        // Parse frontmatter
        if (raw_mk.length > 4 && raw_mk[0:4] == "---\n") {
            int i = 0;
            bool valid_frontmatter = true;
            int last_newline = 3;
            int next_newline;
            string line = "";
            while (true) {
                next_newline = raw_mk.index_of_char('\n', last_newline + 1);
                if (next_newline == -1) { // End of file
                    valid_frontmatter = false;
                    break;
                }

                line = raw_mk[last_newline+1:next_newline];
                last_newline = next_newline;

                if (line == "---") { // End of frontmatter
                    break;
                }

                var sep_index = line.index_of_char(':');
                if (sep_index != -1) {
                    map += line[0:sep_index-1];
                    map += line[sep_index+1:line.length];
                } else { // No colon, invalid frontmatter
                    valid_frontmatter = false;
                    break;
                }

                i++;
            }

            if (valid_frontmatter) { // Strip frontmatter if it's a valid one
                processed_mk = raw_mk[last_newline:raw_mk.length];
            }
        }

        if (processed_mk == null) {
            processed_mk = raw_mk;
        }

        return map;
    }

    private string process (string raw_mk) {
        string processed_mk;
        process_frontmatter (raw_mk, out processed_mk);

        var mkd = new Markdown.Document (processed_mk.data);
        mkd.compile ();

        string result;
        mkd.get_document (out result);

        string html = "<!doctype html><meta charset=utf-8><head>";
        html += "<style>"+ CSS +"</style>";
        html += "</head><body><div class=\"markdown-body\">";
        html += result;
        html += "</div></body></html>";

        return html;
    }

private const string DEFAULT_CSS = """
html,
body {
    margin: 1em;

    background-color: #fff;

    font-size: 16px;
    font-family: "Open Sans", "Droid Sans", Helvetica, sans-serif;
    font-weight: 400;
    color: #333;
}

body * {
    max-width: 800px;
    margin-left: auto;
    margin-right: auto;
}

/**************
* Text Styles *
**************/

a{
    color: #08c;
    text-decoration: none;
}

a:focus{
    outline: none;
    text-decoration: underline;
}

h1,
h2,
h3,
h4,
h5,
h6{
    margin: 1.5em 0 0.25em;
    padding: 0;
    text-align: left;
}

h4,
h5,
h6{
    margin-top: 2em;
    margin-bottom: 0;
}

h1{
    margin-top: 0;

    font-family: "Raleway", "Open Sans", "Droid Sans", Helvetica, sans-serif;
    font-size: 3rem;
    font-weight: 200;
    text-align: center;
}

h2 {
    font-size: 2rem;
    font-weight: 600;
}

h3{
    font-size: 1.5rem;
    font-weight: 600;

    opacity: 0.8;
}

h4{
    font-size: 1.125rem;
    font-weight: 300;
}

h5{
    font-size: 1rem;
    font-weight: 600;
}

p {
    text-align: left;
}

/*******
* Code *
*******/

code{
    display: inline-block;
    padding: 0 0.25em;

    background-color: #f3f3f3;

    border: 1px solid #ddd;
    border-radius: 3px;

    font-family: "Droid Sans Mono","DejaVu Mono",mono;
    font-weight: normal;
    color: #403a36;
}

pre code{
    display: block;
    margin: 1em auto;
    overflow-x: scroll;
}

/***********
* Keyboard *
***********/

kbd{
    padding: 2px 4px;
    margin: 3px;

    background-color: #eee;
    background-image: linear-gradient(to bottom, #eee, #fff);

    border: 1px solid #a5a5a5;
    border-radius: 3px;

    box-shadow: inset 0 1px 0 0 #fff,
        inset 0 -2px 0px 0 #d9d9d9,
        0 1px 2px 0 rgba(0,0,0,0.1);

    font-family: inherit;
    font-size: inherit;
    font-weight: 500;
    color: #4d4d4d;
}

/*********
* Images *
*********/

img{
    display: block;
    margin: 1em auto;
    max-width: 100%;
}

/******************
* Horizontal Rule *
******************/

hr{
    margin: 2em;
    height: 1px;

    background-image: -webkit-linear-gradient(left, rgba(0,0,0,0), rgba(0,0,0,0.5), rgba(0,0,0,0));

    border: 0;
}


/********
* Table *
********/

table {
    border-collapse: collapse;
}

th, td {
    padding: 8px;
}

tr:nth-child(even){background-color: #fafafa}


blockquote {
    border-left: 4px solid #dddddd;
    padding: 0 15px;
    color: #777777;
}

blockquote > :first-child {
    margin-top: 0;
}

blockquote > :last-child {
    margin-bottom: 0;
}
""";}
