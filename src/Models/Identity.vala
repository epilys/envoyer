/*
 * Copyright 2016 Andrei-Costin Zisu
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

public class Envoyer.Models.Identity : GLib.Object {
    public void* imap_session { get; construct set; }
    public void* smtp_session { get; construct set; }
    public string account_name { get; construct set; }
    public Address address { get; construct set; }

    public async Identity (string username, string password, string full_name, string account_name) {
        Object(
            account_name: account_name,
            imap_session: MailCoreInterface.Imap.connect (username, password),
            smtp_session: MailCoreInterface.Smtp.connect (username, password),
            address: new Address (full_name, account_name)
        );
    }

    public async Gee.Collection <Folder> fetch_folders () {
        var folders = yield MailCoreInterface.Imap.fetch_folders (imap_session);

        foreach (var item in folders) {
            item.identity = this;
        }

        return folders;
    }

    public Gee.Collection <ConversationThread> fetch_threads (Folder folder) {
        var messages = MailCoreInterface.Imap.fetch_messages (imap_session, folder.name);

        foreach (var item in messages) {
            item.identity = this;
            item.folder = folder;
        }

        var threader = new Envoyer.Util.ThreadingHelper ();

        return threader.process_messages (messages);
    }

    public string get_html_for_message (Message message) {
        return MailCoreInterface.Imap.get_html_for_message (imap_session, message.folder.name, message);
    }

    public void send_message (Message message) {
        message.from = address;

        MailCoreInterface.Smtp.send_message (smtp_session, message);
    }
}
