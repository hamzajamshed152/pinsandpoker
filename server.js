const express = require("express");
const app = express();
const server = require("http").createServer(app);
const io = require("socket.io")(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST", "PATCH", "DELETE"],
        credentials: true,
        transports: ["websocket", "polling"],
    },
});

const mysql = require("mysql");
const con_mysql = mysql.createPool({
    host: "localhost",
    user: "pinsandpoker_user",
    password: "!@3&a$arHS1G",
    database: "pinsandpoker_main",
    debug: true,
    charset: "utf8mb4",
});

// SOCKET.IO CONNECTION
io.on("connection", function (socket) {
    console.log("Socket connected:", socket.id);

    // JOIN GROUP ROOM BASED ON group_id
    socket.on("get_messages", function (object) {
        const group_id = object.group_id;
        socket.join(group_id);
        console.log(`Joined group: ${group_id}`);

        // Mark messages as read
        read_all_messages(object, function (response) {
            if (response) {
                console.log("All messages marked as read for group:", group_id);
            }
        });

        // Fetch messages
        get_messages(object, function (response) {
            if (response) {
                io.to(group_id).emit("response", {
                    object_type: "get_messages",
                    data: response,
                });
            } else {
                io.to(group_id).emit("error", {
                    object_type: "get_messages",
                    message: "Unable to fetch messages",
                });
            }
        });
    });

    // HANDLE SEND MESSAGE EVENT
    socket.on("send_message", function (object) {
        const group_id = object.group_id;
        const sended_by = object.sended_by;

        send_message(object, function (response) {
            if (response) {
                io.to(group_id).emit("response", {
                    object_type: "get_message",
                    data: response,
                });
                console.log(`Message sent by ${sended_by} in group ${group_id}`);
            } else {
                io.to(group_id).emit("error", {
                    object_type: "get_message",
                    message: "Unable to send message",
                });
            }
        });
    });

    socket.on("disconnect", function () {
        console.log("Socket disconnected:", socket.id);
    });
});

// READ ALL MESSAGES FUNCTION
const read_all_messages = (object, callback) => {
    const { group_id, sended_by } = object;

    con_mysql.getConnection((err, connection) => {
        if (err) return callback(false);

        connection.query(
            `UPDATE chats 
             SET seen = '1' 
             WHERE group_id = ? AND sended_by != ?`,
            [group_id, sended_by],
            (error) => {
                connection.release();
                callback(!error);
            }
        );
    });
};

// GET MESSAGES FUNCTION
const get_messages = (object, callback) => {
    const { group_id } = object;

    con_mysql.getConnection((err, connection) => {
        if (err) return callback(false);

        connection.query(
            `SELECT 
                users.player_id AS sended_by, 
                users.full_name, 
                users.avatar, 
                chats.message, 
                chats.type, 
                chats.seen, 
                chats.created_at 
             FROM chats
             INNER JOIN users ON chats.sended_by = users.player_id
             WHERE chats.group_id = ?
             ORDER BY chats.created_at ASC`,
            [group_id],
            (error, data) => {
                connection.release();
                callback(error ? false : data);
            }
        );
    });
};

// SEND MESSAGE FUNCTION
const send_message = (object, callback) => {
    const { group_id, sended_by, message, type } = object;

    con_mysql.getConnection((err, connection) => {
        if (err) return callback(false);

        const sanitized_message = mysql_real_escape_string(message);
        connection.query(
            `INSERT INTO chats (group_id, sended_by, message, type, created_at) 
             VALUES (?, ?, ?, ?, NOW())`,
            [group_id, sended_by, sanitized_message, type],
            (error, result) => {
                if (error) {
                    connection.release();
                    return callback(false);
                }

                // Fetch the newly inserted message
                connection.query(
                    `SELECT 
                        users.player_id AS sended_by, 
                        users.full_name, 
                        users.avatar, 
                        chats.message, 
                        chats.type, 
                        chats.seen, 
                        chats.created_at 
                     FROM chats
                     INNER JOIN users ON chats.sended_by = users.player_id
                     WHERE chats.id = ?`,
                    [result.insertId],
                    (error, data) => {
                        connection.release();
                        callback(error ? false : data[0]);
                    }
                );
            }
        );
    });
};

// ESCAPE MYSQL INPUTS
function mysql_real_escape_string(str) {
    return str.replace(/[\0\x08\x09\x1a\n\r"'\\\%]/g, (char) => {
        switch (char) {
            case "\0":
                return "\\0";
            case "\x08":
                return "\\b";
            case "\x09":
                return "\\t";
            case "\x1a":
                return "\\z";
            case "\n":
                return "\\n";
            case "\r":
                return "\\r";
            case "'":
            case '"':
            case "\\":
            case "%":
                return "\\" + char;
            default:
                return char;
        }
    });
}

// START SERVER
server.listen(3007, () => {
    console.log("Server is running on port 3007");
});
