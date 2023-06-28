-- #############################################################
-- ########## create and initialize the tables #################

-- create the table for the locations
create table locations
(
    id           bigint auto_increment primary key not null,
    locationName varchar(1000)                     not null,
    locationCode varchar(1000) unique              not null
);

-- create the table for the streets
create or replace table streets
(
    id          bigint auto_increment not null primary key,
    location_ID bigint                not null references locations (id),
    streetName  varchar(1000)         not null,
    streetCode  varchar(1000)         not null
);

-- create the table for the litter categories
-- (Restmüll, Restmüll Container, Gelber Sack, Biomüll, Papier)
create table litterCategory
(
    id                  bigint auto_increment primary key not null,
    category            varchar(1000),
    category_identifier varchar(200)
);

alter table litterCategory
    add column category_identifier varchar(200) not null;
alter table litterCategory
    modify column category_identifier varchar(200) not null,
    add unique (category_identifier);
select *
from litterCategory;

-- create the table for the collection dates
create table collectionDates
(
    id                bigint auto_increment primary key not null,
    location_id       bigint references locations (id),
    street_id         bigint references streets (id),
    litterCategory_id bigint                            not null references litterCategory (id),
    date              varchar(1000)
);

-- user section

-- create the table for the subscribers
create table subscribers
(
    id          bigint auto_increment primary key not null,
    name        varchar(1000)                     not null,
    email       varchar(1000) unique              not null,
    mail_hash   varchar(1000)                     not null,
    location_id bigint references locations (id),
    street_id   bigint references streets (id)
);

-- create the table for the litter categories a subscriber is interested in
create table subscribersLitterCategory
(
    id                bigint auto_increment primary key not null,
    subscriber_id     bigint references subscribers (id),
    litterCategory_id bigint references litterCategory (id)
);

-- create the table for the settings (when to notify) of a subscriber
create table subscribersSettings
(
    id                     bigint auto_increment primary key not null,
    subscriber_id          bigint references subscribers (id),
    notificationTime       varchar(1000),
    notificationDaysBefore varchar(1000)
);

drop table if exists subscribersSettings, subscribersLitterCategory, subscribers;

-- initialize the litter categories
-- (they are fixed)
insert into litterCategory(category)
values ('Restmüll'),
       ('Restmüll Container'),
       ('Gelber Sack'),
       ('Biomüll'),
       ('Papier');

update litterCategory
set category_identifier = 'residual'
where category = 'Restmüll';
update litterCategory
set category_identifier = 'residual_container'
where category = 'Restmüll Container';
update litterCategory
set category_identifier = 'recycling'
where category = 'Gelber Sack';
update litterCategory
set category_identifier = 'bio'
where category = 'Biomüll';
update litterCategory
set category_identifier = 'paper'
where category = 'Papier';


-- #############################################################
-- ######## procedures to insert data into the tables ##########
-- ########### if the data does not exist already ##############

-- insert a location if it does not exist already
-- needs:
--    - newLocationName: the name of the location to be added
--    - newLocationCode: the code of the location to be added
DELIMITER //
CREATE PROCEDURE InsertLocationIfNotExists(IN newLocationName VARCHAR(1000), IN newLocationCode VARCHAR(1000))
BEGIN
    IF NOT EXISTS (SELECT * FROM locations WHERE locationName = newLocationName AND locationCode = newLocationCode) THEN
        INSERT INTO locations (locationName, locationCode) VALUES (newLocationName, newLocationCode);
    END IF;
END//
DELIMITER ;

-- insert a street if it does not exist already
-- needs:
--    - newLocationName: the name of the location where the street belongs to
--    - newStreetName: the name of the street to be added
--    - newStreetCode: the code of the street to be added
DELIMITER //
create procedure insertStreetIfNotExists(IN newLocationName varchar(1000), IN newStreetName varchar(1000),
                                         IN newStreetCode varchar(1000))
begin
    declare newLocationId bigint;
    select id into newLocationId from locations where locationName = newLocationName;
    if not exists(select *
                  from streets
                  where location_ID = newLocationId
                    and streetName = newStreetName
                    and streetCode = newStreetCode) then
        insert into streets (location_ID, streetName, streetCode) values (newLocationId, newStreetName, newStreetCode);
    end if;
end //
delimiter ;

-- insert a street if it does not exist already by using the location ID instead of the location name
-- needs:
--    - newLocationID: the ID of the location where the street belongs to
--                    (has to be fetched from the locations table first)
--    - newStreetName: the name of the street to be added
--    - newStreetCode: the code of the street to be added
DELIMITER //
create procedure insertStreetIfNotExistsWithLocationID(IN newLocationID bigint, IN newStreetName varchar(1000),
                                                       IN newStreetCode varchar(1000))
begin
    if not exists(select *
                  from streets
                  where location_ID = newLocationID
                    and streetName = newStreetName
                    and streetCode = newStreetCode) then
        insert into streets (location_ID, streetName, streetCode) values (newLocationId, newStreetName, newStreetCode);
    end if;
end //
delimiter ;

-- insert a collection date if it does not exist already
-- needs:
--    - newLocationName: the name of the location where the collection date belongs to
--    - newStreetName: the name of the street where the collection date belongs to
--    - newLitterCategory: the litter category, which will be collected on the collection date
--    - newDate: the date of the collection date
delimiter //
create or replace procedure insertCollectionDateIfNotExists(IN newLocationName varchar(1000),
                                                            IN newStreetName varchar(1000),
                                                            IN newLitterCategory varchar(1000),
                                                            IN newDate varchar(1000))
begin
    declare newLocationId bigint;
    declare newStreetId bigint;
    declare newLitterCategoryId bigint;
    select id into newLocationId from locations where locationName = newLocationName;
    select id into newStreetId from streets where location_ID = newLocationId and streetName = newStreetName;
    select id into newLitterCategoryId from litterCategory where category = newLitterCategory;
    if not exists(select *
                  from collectionDates
                  where location_id = newLocationId
                    and street_id = newStreetId
                    and litterCategory_id = newLitterCategory
                    and date = newDate) then
        insert into collectionDates (location_id, street_id, litterCategory_id, date)
        values (newLocationId, newStreetId, newLitterCategoryId, newDate);
    end if;
end //
delimiter ;


-- insert a subscriber if it does not exist already
-- and save its settings
-- needs:
--    - newEmail: the email of the subscriber to be added
--    - newLocationName: the name of the location where the subscriber lives
--    - newStreetName: the name of the street where the subscriber lives
--    - newNotificationTime: the time when the subscriber wants to be notified
--    - newNotificationDaysBefore: the number of days before the collection date the subscriber wants to be notified
--    - newCategories: the categories the subscriber wants to be notified about
--      (comma separated list of categories' identifiers)
delimiter //
create or replace procedure insertOrUpdateSubscriber(IN newName varchar(1000), IN newEmail varchar(1000),
                                                     IN newLocationCode varchar(1000),
                                                     IN newStreetCode varchar(1000),
                                                     IN newNotificationTime varchar(1000),
                                                     IN newNotificationDaysBefore varchar(1000),
                                                     IN newCategories varchar(1000))
begin
    declare _newLocationId bigint;
    declare _newStreetId bigint;
    declare _newSubscriberId bigint;
    declare _newLitterCategoryId bigint;
    declare _category varchar(1000);
    declare _categories varchar(1000);
    declare _newEmailHash varchar(1000);


    -- get the IDs for the given location and street
    select id into _newLocationId from locations where locationCode = newLocationCode;
    select id into _newStreetId from streets where location_ID = _newLocationId and streetCode = newStreetCode;

    -- TODO: maybe extend email hash to email+salt hash
    select SHA2(newEmail, 256) into _newEmailHash;

    -- save or update the user
    if not exists(select * from subscribers where email = newEmail) then
        insert into subscribers (name, email, mail_hash, location_id, street_id)
        values (newName, newEmail, _newEmailHash, _newLocationId, _newStreetId);
    else
        update subscribers
        set name        = newName,
            location_id = _newLocationId,
            street_id   = _newStreetId
        where email = newEmail;
    end if;

    -- get the id of the created or updated user
    select id into _newSubscriberId from subscribers where email = newEmail;

    -- save or update the notification settings of the user
    if not exists(select * from subscribersSettings where subscriber_id = _newSubscriberId)
    then
        insert into subscribersSettings (subscriber_id, notificationTime, notificationDaysBefore)
        values (_newSubscriberId, newNotificationTime, newNotificationDaysBefore);
    else
        update subscribersSettings
        set notificationTime       = newNotificationTime,
            notificationDaysBefore = newNotificationDaysBefore
        where subscriber_id = _newSubscriberId;
    end if;

    -- get the categories, the user is already interested in

    -- delete all categories, the user is interested in
    delete from subscribersLitterCategory where subscriber_id = _newSubscriberId;
    -- save or update the categories, the user is interested in

    -- remove all spaces from the categories string
    set _categories = REPLACE(newCategories, ' ', '');
    -- iterate over the categories string and save the first occurring category in each case
    while LOCATE(',', _categories) > 0
        do
            -- get the first category
            set _category = SUBSTRING(_categories, 1, LOCATE(',', _categories) - 1);
            -- save the remaining categories back to the variable
            set _categories = SUBSTRING(_categories, LOCATE(',', _categories) + 1);

            -- get the id of the category
            select id into _newLitterCategoryId from litterCategory where category_identifier = _category;
            -- save the category
            insert into subscribersLitterCategory (subscriber_id, litterCategory_id)
            values (_newSubscriberId, _newLitterCategoryId);
        end while;
    -- save the last category
    select id into _newLitterCategoryId from litterCategory where category_identifier = _categories;
    insert into subscribersLitterCategory (subscriber_id, litterCategory_id)
    values (_newSubscriberId, _newLitterCategoryId);
end //
delimiter ;

delimiter //
create procedure unsubscribeUserByHash(IN userToRemoveEmailHash varchar(1000))
begin
    -- declare variables
    declare _userToRemoveId bigint;

    -- get the id of the user to remove
    select id into _userToRemoveId from subscribers where mail_hash = userToRemoveEmailHash;

    -- delete the user's settings
    delete from subscribersSettings where subscriber_id = _userToRemoveId;

    -- delete the user's categories
    delete from subscribersLitterCategory where subscriber_id = _userToRemoveId;

    -- delete the user
    delete from subscribers where id = _userToRemoveId;
end //
delimiter ;

-- #############################################################
-- ########### views to get assembled data from the ############
-- ########### tables in a more convenient way #################

-- view to get the collection dates
-- with attributes:
--    - locationName: the name of the location
--    - streetName: the name of the street
--    - date: the date of the collection date
--    - category: the litter category, which will be collected on the collection date
create or replace view collectionDatesView as
select l.locationName, s.streetName, cd.date, lc.category, lc.category_identifier
from locations l
         join streets s on l.id = s.location_ID
         join collectionDates cd on s.id = cd.street_id
         join litterCategory lc on lc.id = cd.litterCategory_id;

-- view to get the collection dates
-- with all attributes from the tables
create or replace view collectionDatesViewAll as
select l.id           as location_id,
       l.locationName as location_name,
       l.locationCode as location_code,
       s.id           as street_id,
       s.streetName   as street_name,
       s.streetCode   as street_code,
       cd.id          as collection_date_id,
       cd.date        as collection_date_date,
       lc.id          as litter_category_id,
       lc.category    as litter_category
from locations l
         join streets s on l.id = s.location_ID
         join collectionDates cd on cd.location_id = l.id and s.id = cd.street_id
         join litterCategory lc on lc.id = cd.litterCategory_id;


-- view to get the locations with their streets
-- with attributes:
--    - locationName: the name of the location
--    - streetName: the name of the street
create or replace view locationsWithStreetsView as
select locationName, streetName
from locations
         join streets on locations.id = streets.location_ID;


-- view to get the subscriber with its settings
-- with attributes:
--    - name: the name of the subscriber
--    - email: the email of the subscriber
--    - locationName: the name of the location where the subscriber lives
--    - streetName: the name of the street where the subscriber lives
--    - notificationTime: the time when the subscriber wants to be notified
--    - notificationDaysBefore: the number of days before the collection date the subscriber wants to be notified
create or replace view subscribersView as
select subscribers.id as subscriber_id,
       name,
       email,
       mail_hash,
       locationName,
       locationCode,
       streetName,
       streetCode,
       notificationTime,
       notificationDaysBefore
from subscribers
         join subscribersSettings sS on subscribers.id = sS.subscriber_id
         join locations l on subscribers.location_id = l.id
         join streets s on subscribers.street_id = s.id;


-- view to get the categories of a subscriber
-- with attributes:
--     - email: the email of the subscriber
--     - category: the category the subscriber is interested in
--     - category_identifier: the identifier of the category
create view subscribersCategoriesView as
select email, category, category_identifier
from subscribers
         join subscribersLitterCategory sLC on subscribers.id = sLC.subscriber_id
         join litterCategory lC on sLC.litterCategory_id = lC.id;

-- view to get all information about upcoming collection dates, which will affect any subscriber
-- with attributes
--     - collectionDate: the date of a litter collection
--     - category: the category of a litter collection
--     - category_identifier: the universal identifier of a litter category
--     - locationName: the name of location the subscriber is interested in
--     - streetName: the name of street the subscriber is interested in
--     - email: the email of the subscriber (used to identify and to notify)
--     - notificationTime: the time the subscriber wants to be notified on
--     - notificationDaysBefore: the amount of days before a collection date a user wants to be notified
create or replace view subscriberNotificationInformationView as
select date    as collectionDate,
       category,
       group_concat(category order by category desc) as categories,
       category_identifier,
       l.locationName,
       s.streetName,
       sV.email,
       sV.mail_hash,
       sV.name as firstName,
       sV.notificationTime,
       sV.notificationDaysBefore
from collectionDates cD
         join litterCategory lC on cD.litterCategory_id = lC.id
         join locations l on cD.location_id = l.id
         join streets s on cD.street_id = s.id
         join subscribersView sV on l.locationCode = sV.locationCode and s.streetCode = sV.streetCode
where cD.date >= current_date
  and category_identifier in (select category_identifier from subscribersCategoriesView where email = sV.email)
group by date, email
order by cD.date;

-- view to get information, which subscriber has to be notified next (with extra information)
-- but only the ones who want to be notified at the current hour
-- with attributes:
--     - collectionDate: the date of a litter collection
--     - category: the category of a litter collection
--     - category_identifier: the universal identifier of a litter category
--     - locationName: the name of location the subscriber is interested in
--     - streetName: the name of street the subscriber is interested in
--     - email: the email of the subscriber (used to identify and to notify)
--     - notificationTime: the time the subscriber wants to be notified on
--     - notificationDaysBefore: the amount of days before a collection date a user wants to be notified
create or replace view subscribersToNotifyWithInformationView as
select *
from subscriberNotificationInformationView
where collectionDate = DATE_ADD(current_date, INTERVAL notificationDaysBefore DAY)
  and HOUR(notificationTime) = HOUR(current_time);

-- #############################################################
-- #################### example queries ########################

select *
from locationsWithStreetsView;
select *
from collectionDatesView;
select *
from collectionDatesViewAll;

select *
from locations;
select count(*)
from streets;
select count(*)
from collectionDates;
select *
from collectionDates
order by location_id desc, street_id desc
limit 10;
select *
from collectionDates
order by id desc
limit 10;

select *
from litterCategory;
select *
from subscribers;
select *
from subscribersSettings;
select *
from subscribersLitterCategory;

select *
from subscribersView;
select *
from subscribersCategoriesView;

select count(*), subscriber_id
from subscribersView
where mail_hash = '973dfe463ec85785f5f95af5ba3906eedb2d931c24e69824a89ea65dba4e813b'; -- hash of 'test@example.com'


select *
from subscribersToNotifyWithInformationView;

select * from subscribersToNotifyWithInformationView;