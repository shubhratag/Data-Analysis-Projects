use group6;
alter table movies add constraint pk_movies primary key (movieId);

use group6;
alter table genome_tags add constraint pk_gtags primary key (tagId);

use group6;
alter table tags add constraint pk_tags primary key (userId,movieId, tag, movie_timestamp);


ALTER TABLE ratings
DROP PRIMARY KEY;

CREATE index i_ratings
ON ratings(userId, movieId);

alter table ratings add constraint pk_ratings primary key (userId,movieId);

CREATE index i_genomescores
ON genome_scores(movieId, tagId);

alter table genome_scores add constraint pk_gscores primary key (movieId, tagId);

alter table tags add constraint foreign key (movieId) references movies(movieId);

alter table ratings add constraint foreign key (movieId) references movies(movieId);

/*--------- Ending in error --------------------------*/
alter table genome_tags add constraint foreign key (tag) references tags(tag);

alter table genome_scores add constraint foreign key (movieId) references movies(movieId);

alter table genome_scores add constraint foreign key (tagId) references genome_tags(tagId);