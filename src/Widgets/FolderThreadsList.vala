/* 
 * Copyright 2011-2016 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */
 
public class Envoyer.FolderThreadsList : Gtk.Grid { //@TODO move to Widget namespace
    private Gtk.ListBox listbox; //@TODO abstract this
    private Envoyer.Models.IFolder current_folder;

    //@TODO persist scroller state

    public FolderThreadsList () {
        build_ui ();
        connect_signals ();
    }
    
    public new void grab_focus () {
        //@TODO
    }
    
    public void load_folder (Envoyer.Models.IFolder folder) {
        current_folder = folder;
                        
        render_list();
    }

    private void build_ui () { //@TODO abstract this ?
        orientation = Gtk.Orientation.VERTICAL;

        var scroll_box = new Gtk.ScrolledWindow (null, null);
        listbox = new Gtk.ListBox ();
        listbox.set_size_request (200,250);
        scroll_box.set_size_request (200,250);
        listbox.vexpand = true;

        scroll_box.add (listbox);
        this.add (scroll_box);
    }

    private void clear_list () { //@TODO abstract this? 
        listbox.unselect_all ();
        var children = listbox.get_children ();

        foreach (Gtk.Widget child in children) {
            if (child is Gtk.ListBoxRow)
                listbox.remove (child);
        }
    }
    
    private void render_list () {
        clear_list ();

        foreach (var thread in current_folder.threads_list) { 
            listbox.add(new Envoyer.ConversationItem(thread));
        }
    }

    private void connect_signals () {
        listbox.row_selected.connect ((row) => {
            if (row == null) return;
            //if (row is Envoyer.FolderItem  ((Envoyer.FolderItem)row).page.full_path == full_path)
            // @TODO editor.load_file (((Envoyer.PageItem) row).page);
            //editor.give_focus ();
        });
    }
}