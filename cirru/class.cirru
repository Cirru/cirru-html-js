div
  div
    :class a
  div
    :class a b c d

  div
    :class a (@ b) (@ c) d

  div
    :class a
      @if (@ b)
        div b
        div c
  div
    :class a
      @if (@ b) b c