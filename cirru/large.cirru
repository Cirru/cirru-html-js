#demo-create-box
  #demo-create
    :data-lang-text demo-create
  input#demo-input
    :data-lang-placeholder demo-input

@rich more
  #demo-more-box
    #demo-more
      :data-lang-text demo-more
    #demo-more-list
      @each room
        .demo-more-room
          span.demo-name
            @ topic
          span.demo-join
            :data-lang-text demo-join
            :data-id (@ id)

#demo-joined-box
  #demo-joined
    :data-lang-text demo-joined
  @rich joined
    #demo-joined-list
      @each joined
        .demo-joined-room
          .demo-name
            @ topic
          span.demo-checked
            = ✔