
div
  @each list
    .name (@ name)
    .value (@ value)

    div
      @each nest
        .name (@ name)
        .value (@ value)