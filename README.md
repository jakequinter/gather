<h1 align="center">
  <img alt="riot logo" src="https://github.com/jakequinter/gather/assets/39658269/a4dad136-edba-4f06-8a77-63e442c8a649" width="300"/>
</h1>

## TODO

Migrate from [ocaml](https://github.com/jakequinter/gather/tree/ocaml)

### Server

- [x] setup db
  - [x] users
  - [x] guests
- [ ] setup auth
  - [x] users/register -> register
  - [x] users/login -> login
  - [ ] users/reset_password -> reset_password
  - [ ] users/reset_password/:token -> reset_password/:token
  - [ ] users/settings -> settings
  - [ ] users/settings/confirm_email -> settings/confirm_email/:token
  - [ ] users/log_out -> log_out
  - [ ] users/confrim/:token -> confirm/:token
  - [ ] users/confirm -> confim

### Client

- [x] auth routes
- [ ] guest routes
  - [x] GET (`/guests`)
  - [x] POST (`/guests`) -> `create_guest`
  - [x] PUT (`/guests`) -> `update_guest`
  - [x] DELETE (`/guests`) -> `delete_guest`
- [ ] search
- [x] replace defaulted heroicons w/ sprite.svg
- [x] favicons

### Tests

- [x] views

  - [x] users
  - [x] guests

- [ ] controllers
  - [x] users
  - [ ] guests
  - [ ] download

### CI/CD

- [x] deploy
- [x] setup github actions

### Thoughts

- Maybe add public version of guest pages
  - Something like `/guests/:id`
  - Limited info & no actions
