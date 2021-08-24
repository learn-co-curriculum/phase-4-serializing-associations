# Serializing Associations

## Learning Goals

- Serialize nested data using `has_many` and `belongs_to`

## Introduction

We have seen how `ActiveModel::Serializer` can be used to easily customize the
JSON being returned for a single model. But what if we have multiple associated
models? As it turns out, that situation can also be handled easily with AMS, by
using the Active Record macros `has_many` and `belongs_to` that we're already
familiar with. In this lesson, we'll learn how to implement serializers for
associated models in our Movie app.

To enable us to do this, we've expanded our movie app to include two more
models. Specifically, we made the following changes:

- Instead of including `director` as an attribute of our `Movie` instances,
  we created a separate `Director` class.
- We modified our app to include movie reviews using a `Review` class.

The relationships we want to model look like this:

```txt
Director -< Movies -< Reviews
```

To implement the `Director` class, we made the following changes to our code:

1. Removed `director` and `female_director` as attributes in our movie migration
   file; added a `director_id` attribute
2. Added a new migration for our `director` model with three attributes: `name`,
   `birthplace` and `female_director`
3. Added the `belongs_to :director` macro to the `Movie` model and the
   `has_many :movies` macro to the `Director` model
4. Added `index` and `show` routes for the `Director` model in `config/routes.rb`
5. Added a `DirectorsController` and created the `index` and `show` actions

To implement the `Review` class, we made the following changes:

1. Added a new migration with four attributes: `author`, `date`, `url`, and
   `movie_id`
2. Added the `has_many :reviews` macro to the `Movie` model and the
   `belongs_to :movie` macro to the `Review` model
3. Added an `index` route for the `Review` model in `config/routes.rb`
4. Created a `ReviewsController` and added the `index` action

Spend a few minutes looking through the code to familiarize yourself with how
everything is set up.

## Using ActiveModel::Serializer with Associated Data

Let's see the updated version of our app in action. To set it up, run:

```console
$ bundle install
$ rails db:migrate db:seed
$ rails s
```

The setup for `Movie` has not changed: you should still be able to navigate to
its `index` and `show` routes, as well as the custom `/movies/:id/summary` and
`movie_summaries` routes we created in the last lesson.

Take a look at the new `index` and `show` routes for `Director` in the browser.
You'll see that the JSON for the directors includes two attributes that we don't
want: `created_at` and `updated_at`. Luckily we know how to fix this — we simply
need to create a serializer for `director` as we did for `movies`:

```console
$ rails g serializer director
```

We can then add the desired attributes to the `directors_serializer` file:

```rb
# app/serializers/director_serializer.rb
class DirectorSerializer < ActiveModel::Serializer
  attributes :id, :name, :birthplace, :female_director
end
```

Now if you navigate to `/directors` or `/directors/:id` you will see that we're
only displaying the desired attributes.

Next, let's take a look at our new `Movie` index route. Now that we've removed
the `director` and `female_director` attributes, the JSON for `movies` no longer
includes any information about director. We need to figure out how to add the
information about each movie's associated director to the JSON being returned by
the `movies` serializer. AMS allows us to do this using the same macros in the
serializers that we use to set up associations in our model files. In this case,
we want our serializer to reflect the fact that `Movie` belongs to `Director`,
so we'll update the serializer as follows:

```rb
# serializers/movie_serializer.rb
class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :year, :length, :description, :poster_url, :category, :discount

  belongs_to :director
end
```

Now if you navigate to `localhost:3000/movies/1`, you should see the following:

```json
{
  "id": 1,
  "title": "The Color Purple",
  "year": 1985,
  "length": 154,
  "description": "Whoopi Goldberg brings Alice Walker's Pulitzer Prize-winning feminist novel to life as Celie, a Southern woman who suffered abuse over decades. A project brought to a hesitant Steven Spielberg by producer Quincy Jones, the film marks Spielberg's first female lead.",
  "poster_url": "https://pisces.bbystatic.com/image2/BestBuy_US/images/products/3071/3071213_so.jpg",
  "category": "Drama",
  "discount": false,
  "director": {
    "id": 1,
    "name": "Steven Spielberg",
    "birthplace": "Cincinnati, OH",
    "female_director": false
  }
}
```

We once again can see the director information for our movie!

We can also set up the relationship in the other direction, by adding the
corresponding macro in our `DirectorSerializer`:

```rb
# serializers/director_serializer.rb
class DirectorSerializer < ActiveModel::Serializer
  attributes :id, :name, :birthplace, :female_director

  has_many :movies
end
```

Because we have included the `has_many` macro in the `Director` serializer, when
we navigate to `localhost:3000/directors/:id`, we can see the list of movies that
belong to that particular director:

```json
{
  "id": 1,
  "name": "Steven Spielberg",
  "birthplace": "Cincinnati, OH",
  "female_director": false,
  "movies": [
    {
      "id": 1,
      "title": "The Color Purple",
      "year": 1985,
      "length": 154,
      "description": "Whoopi Goldberg brings Alice Walker's Pulitzer Prize-winning feminist novel to life as Celie, a Southern woman who suffered abuse over decades. A project brought to a hesitant Steven Spielberg by producer Quincy Jones, the film marks Spielberg's first female lead.",
      "poster_url": "https://pisces.bbystatic.com/image2/BestBuy_US/images/products/3071/3071213_so.jpg",
      "category": "Drama",
      "discount": false
    }
  ]
}
```

**IMPORTANT**: You should only add macros to your serializers if you're sure you
need the data! The level of complexity ramps up quickly as you add more macros,
so keeping them to a minimum will save you headaches in the long run. It's also
good to consider how much data is being sent with each request, since adding more
data means running more SQL code to access that info from different tables in the
database, which will make our responses slower.

Rails automatically uses the appropriate serializer, based on naming
conventions, to display the associated data for each of our models. We can see
that in the example above: Rails has used the `MovieSerializer` to render the
`movie` JSON, so all of the attributes we listed in that serializer are rendered
in the `Director`'s `index` and `show` routes.

With only one Steven Spielberg movie in our data, including all that information
isn't too unreasonable. But what happens when we add the rest of his movies to
our database? We may decide we don't need to include **all** the details of
every movie in this view.

To fix this, we can simply create a new, streamlined serializer:

```console
$ rails g serializer director_movie
```

Here we'll include just the title and year of each of the director's movies:

```rb
class DirectorMovieSerializer < ActiveModel::Serializer
  attributes :title, :year
end
```

Now, if you refresh the page... nothing changes. Why not?

Recall that Rails automatically selects the serializer based on naming
conventions, so it's still using the `DirectorSerializer` to render the data. To
fix this, we need to tell the `DirectorSerializer` that it should be using this
new serializer instead; we need to pass it _explicitly_:

```rb
class DirectorSerializer < ActiveModel::Serializer
  attributes :id, :name, :birthplace, :female_director

  has_many :movies, serializer: DirectorMovieSerializer
end
```

Rails is still using `DirectorSerializer` to render the JSON, but now
`DirectorSerializer` is passing the data request along to the new, simplified
serializer.

Now if you refresh the page, you should see the following:

```json
{
  "id": 1,
  "name": "Steven Spielberg",
  "birthplace": "Cincinnati, OH",
  "female_director": false,
  "movies": [
    {
      "title": "The Color Purple",
      "year": 1985
    }
  ]
}
```

## Deeply Nested Models

Now that we've got the JSON set up the way we want for our associated `Movie`
and `Director` models, we can turn our attention to the `Review` model. Let's
take another look at our model relationships:

```txt
Director -< Movies -< Reviews
```

We've already set up the association in the `Movie` and `Review` model files:

```rb
# app/models/movie.rb
class Movie < ApplicationRecord
  belongs_to :director
  has_many :reviews
end

# app/models/review.rb
class Review < ApplicationRecord
  belongs_to :movie
end
```

Next, we'll create our `review` serializer:

```console
$ rails g serializer review
```

We can also specify the attributes we want to include:

```rb
# app/serializers/review_serializer.rb
class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :author, :date, :url
end
```

We can now go to `localhost:3000/reviews` and see our reviews listed. However,
viewing a list of reviews separately from the information about the movies
they're associated with is not particularly helpful.

What we really want to do is render the information about a movie's reviews
along with the rest of the information about that movie. In fact, we don't
really need to render information about reviews at all _except_ as part of the
data rendered for a particular movie!

Before we figure out how to get that in place, let's follow good programming
practice and delete the code we no longer need: we'll remove the resource for
`review`s from the `routes.rb` file and the `index` action from the
`ReviewsController`.

Once that's done, to get reviews included in the JSON that's returned for a
given movie, we'll simply add the appropriate macro to the `MovieSerializer`:

```rb
class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :year, :length, :description, :poster_url, :category, :discount

  belongs_to :director
  has_many :reviews
end
```

Now if we visit `localhost:3000/movies/1`, we can verify that the reviews are
now included in the movie's JSON.

So let's review where we are: the JSON for directors includes their movies, and
the JSON for movies includes their reviews. Given that, if we visit
`localhost:3000/directors/1`, will we see the full set of nested data?
Unfortunately, no, we won't. Our `Director` JSON will look just the same as it
did before we added the `Review` model:

```json
{
  "id": 1,
  "name": "Steven Spielberg",
  "birthplace": "Cincinnati, OH",
  "female_director": false,
  "movies": [
    {
      "title": "The Color Purple",
      "year": 1985
    }
  ]
}
```

This is because, by default, **AMS only nests associations one level deep**.

This behavior is intended to protect against overly complex JSON that's nested
many layers deep. Luckily, we can override the behavior by using the [include
option][] in the top-level controller — in this case, the `DirectorsController`:

[include option]: https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/adapters.md#include-option

```rb
# app/controllers/directors_controller.rb
class DirectorsController < ApplicationController

  def index
    directors = Director.all
    render json: directors, include: ['movies', 'movies.reviews']
  end

  def show
    director = Director.find(params[:id])
    render json: director, include: ['movies', 'movies.reviews']
  end

end
```

Let's take a look at the render statement in our `show` action:

```rb
render json: director, include: ['movies', 'movies.reviews']
```

This code tells AMS that we want to render information for the `director`, and
to also include information for the `movies` associated with that director, and
for the `reviews` associated with those `movies`.

Finally, because we're using our custom `DirectorMovieSerializer` to render the
movies in our `Director` routes, we also need to add the `has_many :reviews`
macro to that serializer:

```rb
class DirectorMovieSerializer < ActiveModel::Serializer
  attributes :title, :year

  has_many :reviews
end
```

With these changes in place, refresh the page and you should now see this:

```json
{
  "id": 1,
  "name": "Steven Spielberg",
  "birthplace": "Cincinnati, OH",
  "female_director": false,
  "movies": [
    {
      "title": "The Color Purple",
      "year": 1985,
      "reviews": [
        {
          "id": 1,
          "author": "Roger Ebert",
          "date": "December 20, 1985",
          "url": "https://www.rogerebert.com/reviews/the-color-purple-1985"
        },
        {
          "id": 2,
          "author": "Variety Staff",
          "date": "December 31, 1984",
          "url": "https://variety.com/1984/film/reviews/the-color-purple-1200426436/"
        },
        {
          "id": 3,
          "author": "Janet Maslin",
          "date": "December 18, 1985",
          "url": "https://www.nytimes.com/1985/12/18/movies/moviesspecial/the-color-purple.html"
        }
      ]
    }
  ]
}
```

Nice!

## Conclusion

`ActiveModel::Serializer` provides some powerful yet simple-to-use tools for
crafting the JSON our app returns, and it does so in a way that's consistent
with Rails conventions.

To summarize:

- To customize the JSON returned for a resource, create a **serializer** for
  that resource and list the desired attributes.
- The serializer is used **implicitly** by Rails based on naming conventions; to
  override this, custom serializers can be **explicitly** passed in the
  controller.
- AMS enables the use of the `belongs_to` and `has_many` macros in serializers
  to render associated data; these macros should be used sparingly.
- By default, AMS will only nest associations one level deep in the serialized
  JSON. To override this, the `include` option can be used in the controller.

## Resources

- [Getting Started with Active Model Serializer](https://github.com/rails-api/active_model_serializers/blob/0-10-stable/docs/general/getting_started.md)
- [Including Nested Associations](https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/adapters.md#include-option)
