$ ->
  $('.js-tags input').select2
    tags: true
    tokenSeparators: [",", " "]
    width: '100%'
    initSelection: (e, callback) ->
      data = []
      $(e.val().split(",")).each ->
        data.push
          id: this
          text: this
      callback(data)
    createSearchChoice: (term) ->
      valid_term = term.replace /[^-_\+\.#a-z0-9]/ig, ''
      {id: valid_term, text: valid_term}
    query: (q) ->
      id = q.element.data('id')
      $.ajax
        url: '/tags/suggest'
        data:
          q: q.term
          star_id: id
        dataType: 'json'
        success: (data) =>
          q.callback
            results: data

  $('.js-tags').on 'click', ->
    $(this).find('input').select2('open')

  $('.js-tags input').on 'change', (e) ->
    id = $(e.target).data('id')
    if e.added
      $.post "/stars/#{ id }/tag/#{ encodeURIComponent e.added.id }"
    if e.removed
      $.post "/stars/#{ id }/tag/#{ encodeURIComponent e.removed.id }",
        _method: 'delete'
