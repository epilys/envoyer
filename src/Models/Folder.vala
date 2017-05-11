/*
 * Copyright 2016 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */
 
public struct Envoyer.FolderStruct {
    string* name;
    int flags;
}

public class Envoyer.Models.Folder : Envoyer.Models.IFolder, GLib.Object {
    private Envoyer.FolderStruct* data;
    
    // It appears that MailCore does the same check for name == "INBOX"
    public bool is_inbox { get { return (data->flags & (1 << 4)) != 0 || data->name == "INBOX"; } }
    public bool is_sent { get { return (data->flags & (1 << 5)) != 0; } }
    public bool is_starred { get { return (data->flags & (1 << 6)) != 0; } }
    public bool is_all_mail { get { return (data->flags & (1 << 7)) != 0; } }
    public bool is_trash { get { return (data->flags & (1 << 8)) != 0; } }
    public bool is_drafts { get { return (data->flags & (1 << 9)) != 0; } }
    public bool is_spam { get { return (data->flags & (1 << 10)) != 0; } }
    public bool is_important { get { return (data->flags & (1 << 11)) != 0; } }
    public bool is_archive { get { return (data->flags & (1 << 12)) != 0; } }
    // is_normal is linked to IMAPFolderFlagFolderTypeMask in MailCore. Perhaps find a more elegant solution...
    public bool is_normal { get { return !is_inbox && !is_trash && !is_sent && !is_spam && !is_starred && !is_important && !is_all_mail && !is_drafts && !is_archive; } }
    public bool is_unified { get { return false; } }
    
    public Envoyer.Models.IFolder.Type folder_type {
        get {
            if (is_inbox) {
                return Envoyer.Models.IFolder.Type.INBOX;
            }

            if (is_trash) {
                return Envoyer.Models.IFolder.Type.TRASH;
            }

            if (is_sent) {
                return Envoyer.Models.IFolder.Type.SENT;
            }
            
            if (is_normal) {
                return Envoyer.Models.IFolder.Type.NORMAL;
            }
            
            if (is_spam) {
                return Envoyer.Models.IFolder.Type.SPAM;
            }
            
            if (is_starred) {
                return Envoyer.Models.IFolder.Type.STARRED;
            }
            
            if (is_all_mail) {
                return Envoyer.Models.IFolder.Type.ALL;
            }
            
            if (is_drafts) {
                return Envoyer.Models.IFolder.Type.DRAFTS;
            }

            if (is_archive) {
                return Envoyer.Models.IFolder.Type.ARCHIVE;
            }
            
            if (is_important) {
                return Envoyer.Models.IFolder.Type.IMPORTANT;
            }

            assert_not_reached ();
        }
    
    }

    public uint unread_count { get { return 0; } }
    public uint total_count { get { return 1; } }
    
    //@TODO trigger unread_count_changed
    //@TODO trigger total_count_changed

    public Gee.LinkedList<Envoyer.Models.ConversationThread> threads_list { 
        owned get {  //@TODO async
            var threads_list_copy = new Gee.LinkedList<Envoyer.Models.ConversationThread> (null);
            
            /*Camel.FolderThreadNode? tree = (Camel.FolderThreadNode?) thread.tree;

            while (tree != null) {
                threads_list_copy.add(new Envoyer.Models.ConversationThread(tree, this));

                tree = (Camel.FolderThreadNode?) tree.next;
            }
            */
            //@TODO async and yield
            threads_list_copy.sort ((first, second) => { // sort descendingly
                if(first.time_received > second.time_received) {
                    return -1;
                } else {
                    return 1;
                }
            });

            return threads_list_copy;
        }
    }

    public string display_name { get { return data->name; } }

    public Folder(Envoyer.FolderStruct* data) {        
        this.data = data;        
    }

    public Camel.MessageInfo get_message_info (string uid) {
        return null;
    }
    
    public Camel.MimeMessage get_mime_message (string uid) {
        //folder.synchronize_message_sync (uid); //@TODO async? also, this should probably happen in a more batch manner
        
        return null;
    }
}
