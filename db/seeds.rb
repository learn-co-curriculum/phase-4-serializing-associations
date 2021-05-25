director1 = Director.create(
  name: "Steven Spielberg",
  birthplace: "Cincinnati, OH",
  female_director: false
)

movie1 = director1.movies.create(
  title: "The Color Purple",
  year: 1985,
  length: 154,
  description: "Whoopi Goldberg brings Alice Walker's Pulitzer Prize-winning feminist novel to life as Celie, a Southern woman who suffered abuse over decades. A project brought to a hesitant Steven Spielberg by producer Quincy Jones, the film marks Spielberg's first female lead.",
  poster_url: "https://pisces.bbystatic.com/image2/BestBuy_US/images/products/3071/3071213_so.jpg",
  category: "Drama",
  discount: false
)

movie1.reviews.create([
  {
    author: "Roger Ebert",
    date: "December 20, 1985",
    url: "https://www.rogerebert.com/reviews/the-color-purple-1985"        
  },
  {
    author: "Variety Staff",
    date: "December 31, 1984",
    url: "https://variety.com/1984/film/reviews/the-color-purple-1200426436/"
  },
  {
    author: "Janet Maslin",
    date: "December 18, 1985",
    url: "https://www.nytimes.com/1985/12/18/movies/moviesspecial/the-color-purple.html"
  }
])

director2 = Director.create(
  name: "Julie Taymor",
  birthplace: "Newton, MA",
  female_director: true
)

director2.movies.create(
  title: "Frida",
  year: 2002,
  length: 123,
  description: "Her portrait, with that thick unibrow and un-waxed upper lip, has become an iconic symbol of feminism. Julie Taymor's biopic takes us behind the canvas to reveal the artist, the activist, the revolutionary. And knowing what we do now about lead actress Selma Hayek's off-screen experience, this film proves an even greater victory.",
  poster_url: "https://m.media-amazon.com/images/M/MV5BYzUxMTU0ZmEtZWE0Ni00NzJlLThhZTUtNDA1ZDZjZDUxYThiXkEyXkFqcGdeQXVyNjk1Njg5NTA@._V1_.jpg",
  category: "Drama",
  discount: false
)

director3 = Director.create(
  name: "Mira Nair",
  birthplace: "Bhubaneshwar, Orissa, India",
  female_director: true
)

director3.movies.create(
  title: "Queen of Katwe",
  year: 2016,
  length: 144,
  description: "Disney has a way of making us feel like pawns in a game of Let's See How Hard We Can Make Them Cry. But that's not the case with Mira Nair's feel-good drama about a Uganda girl's path to chess champ, adapted from an ESPN sports essay. Moms and dads, you want your daughters to grow up to be chess champions.",
  poster_url: "https://www.gstatic.com/tv/thumb/v22vodart/12806084/p12806084_v_v8_ar.jpg",
  category: "Drama",
  discount: false
)
