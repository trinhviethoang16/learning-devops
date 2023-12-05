db.auth(root, rootPass)

dbAdmin = db.getSiblingDB('admin')
dbAdmin.createUser(
  {
    user: "tridang",
    pwd: "abc123",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
);

dbUser = db.getSiblingDB('user');
dbUser.createUser(
  {
    user: "hoang1",
    pwd: "abc123",
    roles: [ { role: "readWrite", db: "user" },
             { role: "read", db: "user" } ]
  }
);

dbUser.createUser(
  {
    user: "hoang2",
    pwd: "abc123",
    roles: [ { role: "readWrite", db: "user" },
             { role: "read", db: "user" } ]
  }
);