table! {
    attachments (id) {
        id -> Integer,
        message_id -> Integer,
        file_name -> Text,
        mime_type -> Text,
        character_set -> Text,
        content_id -> Text,
        content_location -> Text,
        part_id -> Text,
        encoding -> Integer,
        data -> Binary,
        is_inline -> Integer,
    }
}

table! {
    folders (folder_id) {
        folder_id -> Integer,
        folder_name -> Text,
        owning_identity -> Text,
        flags -> Integer,
        unread_count -> Integer,
        total_count -> Integer,
    }
}

table! {
    identities (id) {
        id -> Integer,
        email_address -> Text,
        gmail_access_token -> Text,
        gmail_refresh_token -> Text,
        identity_type -> Text,
        expires_at -> Timestamp,
        full_name -> Text,
        account_name -> Text,
    }
}

table! {
    messages (id) {
        id -> Integer,
        message_id -> Text,
        subject -> Text,
        owning_folder -> Text,
        time_received -> Integer,
        from -> Text,
        sender -> Text,
        to -> Text,
        cc -> Text,
        bcc -> Text,
        html_content -> Text,
        plain_text_content -> Text,
        references -> Text,
        in_reply_to -> Text,
        uid -> Integer,
        modification_sequence -> Integer,
        seen -> Bool,
        flagged -> Bool,
        draft -> Bool,
        deleted -> Bool,
    }
}

allow_tables_to_appear_in_same_query!(attachments, folders, identities, messages,);
