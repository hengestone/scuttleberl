#{prefix => "",
  security => false,
  routes => [
            {"/", scuttleberl_main_controller, index}
           ],
 statics => [
             {"/assets/[...]", "assets"}
            ]
}.
