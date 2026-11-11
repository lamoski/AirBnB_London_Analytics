--SCHEMA CREATION

CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO

Select * from sys.schemas

=======================================================================================================================================
=======================================================================================================================================
SELECT  id,name,host_name,
    host_is_superhost,
  
    host_listings_count,
    host_identity_verified,
    neighbourhood_cleansed,
    
    latitude,
    longitude,
    property_type,
    room_type,
    accommodates,

    bathrooms_text,
    bedrooms,
    beds,
    amenities,
    price,
    price_quote_price_per_night,
    price_quote_raw,
    minimum_nights,
    calendar_last_scraped,
    number_of_reviews,
    review_scores_rating,
    review_scores_location FROM Bronze.Listings_London
      where  bathrooms_text is null




    SELECT bathrooms_text FROM Bronze.Listings_London
    where  bathrooms_text is null

