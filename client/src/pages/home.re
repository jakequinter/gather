[@react.component]
let make = () => {
  let auth = Context.AuthContext.useAuth();

  let userExists = auth.user |> Belt.Option.isSome;

  React.useEffect1(
    () => {
      if (!auth.loading) {
        switch (auth.user) {
        | None => ReasonReactRouter.push("/login")
        | Some(_) => ()
        };
      };
      None;
    },
    [|auth.loading, userExists|],
  );

  if (auth.loading) {
    <div> {React.string("Loading...")} </div>;
  } else {
    switch (auth.user) {
    | Some(user) =>
      <div>
        <Components.Link to_="/login">
          {React.string("Go to login, " ++ user.email)}
        </Components.Link>
        <button onClick={_ => auth.logout()}>
          {React.string("Logout")}
        </button>
      </div>
    | None => React.null
    };
  };
};
