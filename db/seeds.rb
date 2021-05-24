  
movie1 = Movie.new(
    {
      title: "The Color Purple",
      year: 1985,
      length: 154,
      description: "Whoopi Goldberg brings Alice Walker's Pulitzer Prize-winning feminist novel to life as Celie, a Southern woman who suffered abuse over decades. A project brought to a hesitant Steven Spielberg by producer Quincy Jones, the film marks Spielberg's first female lead.",
      poster_url: "https://pisces.bbystatic.com/image2/BestBuy_US/images/products/3071/3071213_so.jpg",
      category: "Drama",
      discount: false
    }
)

movie1.create_director(
  {
    name: "Steven Spielberg",
    birthplace: "Cincinnati, OH",
    sex: "male"
  }
)

movie1.save


movie2 = Movie.new(
      {
      title: "Frida",
      year: 2002,
      length: 123,
      description: "Her portrait, with that thick unibrow and un-waxed upper lip, has become an iconic symbol of feminism. Julie Taymor's biopic takes us behind the canvas to reveal the artist, the activist, the revolutionary. And knowing what we do now about lead actress Selma Hayek's off-screen experience, this film proves an even greater victory.",
      poster_url: "https://m.media-amazon.com/images/M/MV5BYzUxMTU0ZmEtZWE0Ni00NzJlLThhZTUtNDA1ZDZjZDUxYThiXkEyXkFqcGdeQXVyNjk1Njg5NTA@._V1_.jpg",
      category: "Drama",
      discount: false
    }
)

movie2.create_director(
  {
    name: "Julie Taymor",
    birthplace: "Newton, MA",
    sex: "female"
  }
)

movie2.save


movie3 = Movie.new(
      {
      title: "Queen of Katwe",
      year: 2016,
      length: 144,
      description: "Disney has a way of making us feel like pawns in a game of Let's See How Hard We Can Make Them Cry. But that's not the case with Mira Nair's feel-good drama about a Uganda girl's path to chess champ, adapted from an ESPN sports essay. Moms and dads, you want your daughters to grow up to be chess champions.",
      poster_url: "https://www.gstatic.com/tv/thumb/v22vodart/12806084/p12806084_v_v8_ar.jpg",
      category: "Drama",
      discount: false
    }
)

movie3.create_director(
  {
    name: "Mira Nair",
    birthplace: "Bhubaneshwar, Orissa, India",
    sex: "female"
  }
)

movie3.save