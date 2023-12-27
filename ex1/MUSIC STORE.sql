5REM:***********MUSIC STORE***************
REM:------------------------------------

REM:Droping tables:song,sungby,album,studio,musician,artist

drop table sungby cascade constraints;
drop table artist cascade constraints;
drop table song cascade constraints;
drop table album cascade constraints;
drop table musician cascade constraints;
drop table studio cascade constraints;


REM:Creating tables

CREATE TABLE musician(
musicianid int ,
name varchar(255),
birthplace varchar(255)
);

CREATE TABLE studio(
name_studio varchar(255),
address varchar(255),
phoneno varchar(10)
);


CREATE TABLE album(
name varchar(255),
albumid int ,
release_year int ,
no_of_tracks int ,
studioname varchar(255),
genre varchar(3),
musician_id int
);

CREATE TABLE artist(
artistid int,
artistname varchar(255)
);

CREATE TABLE sungby(
album_id int,
artist_id int,
track_no int,
rec_date date
);

CREATE TABLE song(
album__id int,
track_no int,
songname varchar(15),
length int,
songgenre varchar(3)
);



REM:Alter table questions

REM:1) The genre for Album can be generally categorized as CAR for 
REM:Carnatic, DIV for Divine, MOV for Movies, POP for Pop songs.

ALTER TABLE album
ADD CONSTRAINT genre CHECK(genre in ('CAR','DIV','MOV','POP'));

REM:------------------------------------------------------------
REM:2) The genre for Song can be PHI for philosophical, REL for relationship, 
REM:LOV for duet, DEV for devotional, PAT for patriotic type of songs.

ALTER TABLE song 
ADD CONSTRAINT songgenre CHECK(songgenre in ('PHI','REL','LOV','DEV','PAT'));
REM:------------------------------------------------------------

REM:3) The artist ID, album ID, musician ID, and track number, studio name 
REM:are used to retrieve tuple(s) individually from respective relations.

ALTER TABLE musician 
ADD PRIMARY KEY(musicianid);

ALTER TABLE studio
ADD PRIMARY KEY(name_studio);

ALTER TABLE album
ADD PRIMARY KEY(albumid);

ALTER TABLE artist
ADD PRIMARY KEY(artistid);

ALTER TABLE song
ADD PRIMARY KEY(track_no);
ALTER TABLE sungby
ADD PRIMARY KEY(track_no,album_id);
REM:------------------------------------------------------------

REM:4) Ensure that the artist, musician, song, sungby and studio can not be 
REM:removed without deleting the album details.

ALTER TABLE album
ADD CONSTRAINT fk_album_studioname
FOREIGN KEY(studioname) REFERENCES studio(name_studio);

ALTER TABLE album
ADD CONSTRAINT fk_musician_id 
FOREIGN KEY(musician_id) REFERENCES musician(musicianid);
REM:------------------------------------------------------------

REM:5) A song may be sung by more than one artist. The same artist may 
REM:sing for more than one track in the same album. Similarly an artist can 
REM:sing for different album(s).

ALTER TABLE sungby
ADD CONSTRAINT FK_album_id
FOREIGN KEY(album_id) REFERENCES album(albumid);

ALTER TABLE sungby
ADD CONSTRAINT FK_artist_id
FOREIGN KEY(artist_id) REFERENCES artist(artistid);

ALTER TABLE sungby
ADD CONSTRAINT FK_track_no
FOREIGN KEY(track_no) REFERENCES song(track_no);

ALTER TABLE song
ADD CONSTRAINT fkalbum_id
FOREIGN KEY(album__id) REFERENCES album(albumid);
REM:------------------------------------------------------------

REM:6)It was learnt that the artists do not have the same name.

ALTER TABLE artist
ADD UNIQUE(artistname);
REM:------------------------------------------------------------

REM:7) The number of tracks in an album must always be recorded.

ALTER TABLE album
MODIFY no_of_tracks int NOT NULL;
REM:------------------------------------------------------------

REM:8) The length of each song must be greater than 7 for PAT songs.

ALTER TABLE song
ADD CONSTRAINT checkgenre 
CHECK(songgenre='PAT' AND length>7);

REM:------------------------------------------------------------

REM:9) The year of release of an album can not be earlier than 1945
ALTER TABLE album
ADD CONSTRAINT release_year CHECK(release_year>=1945);

REM:------------------------------------------------------------

REM:10) It is necessary to represent the gender of an artist in the table.

ALTER TABLE artist
ADD gender varchar(255);
REM:------------------------------------------------------------

REM:11)The first few words of the lyrics constitute the song name. The
REM:song name has to accommodate some of the words (in lyrics).
ALTER TABLE Song 
MODIFY songname varchar(30);
REM:------------------------------------------------------------

 
REM:12)The phone number of each studio should be different

ALTER TABLE studio
ADD UNIQUE(phoneno);
REM:------------------------------------------------------------

REM:13) An artist who sings a song for a particular track of an album REM:can not be recorded without the record_date.

ALTER TABLE sungby 
MODIFY rec_date DATE NOT NULL;
REM:------------------------------------------------------------

REM:14)It was decided to include the genre NAT for nature songs.

ALTER TABLE song
MODIFY CHECK(songgenre in ('PHI','REL','LOV','DEV','PAT','NAT'));
REM:------------------------------------------------------------

REM:15)Due to typo-error, there may be a possibility of false information.
REM:Hence while deleting the song information, make sure that all the
REM:corresponding information are also deleted.

ALTER TABLE sungby
DROP CONSTRAINT FK_artist_id;

ALTER TABLE sungby 
DROP CONSTRAINT FK_album_id;

ALTER TABLE sungby 
DROP CONSTRAINT FK_track_no;

ALTER TABLE sungby
ADD FOREIGN KEY (album_id) REFERENCES album(albumid)
ON DELETE CASCADE;

ALTER TABLE sungby
ADD CONSTRAINT fk_artist_id
FOREIGN KEY (artist_id) REFERENCES artist(artistid)
ON DELETE CASCADE;

ALTER TABLE sungby
ADD FOREIGN KEY (track_no) REFERENCES song(track_no)
ON DELETE CASCADE;
REM:------------------------------------------------------------










  

