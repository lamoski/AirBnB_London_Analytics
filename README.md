# London Airbnb Price Prediction & Pricing Analysis

**Project status:** Data cleaning and exploratory analysis (in progress)  
**Location:** London, United Kingdom  
**Repository:** [AirBnB_London_Analytics](https://github.com/lamoski/AirBnB_London_Analytics)

## Project overview

This project uses London Airbnb listings to study the factors that influence accommodation prices. The longer-term goal is to train machine learning models to predict listing prices and compare predicted prices with advertised prices to identify **potentially overpriced and underpriced listings**.

The project is currently focused on preparing the data. **No model results or pricing classifications are reported yet.**

## Objectives

- Explore the relationship between listing characteristics and advertised prices.
- Prepare a reliable dataset by investigating missing values and unusual records.
- Build and compare Multiple Linear Regression, Random Forest, and XGBoost models.
- Evaluate predictions using MAE, RMSE, and R².
- Compare predicted and advertised prices, then present findings in Power BI.

## Dataset

**Source:** [Inside Airbnb](https://insideairbnb.com/get-the-data/) (London listings; snapshot used for this project).

| Dataset stage | Listings | Notes |
| --- | ---: | --- |
| Original raw data | 91,954 | 90 source columns |
| Selected fields | 91,954 | 24 columns selected for analysis |
| Missing `price` removed | 32,049 | 34.85% of original records |
| Listings retained for analysis | **59,905** | Listings with a recorded target price |

`price` is the target variable. Records with missing prices were excluded because they cannot be used as labelled examples for supervised price prediction. Some manually checked records without prices showed no available booking dates, but this does **not** prove that all such listings are permanently inactive.

### Data architecture

The project follows a **Bronze → Silver → Gold** approach:

- **Bronze:** Keep the original downloaded data unchanged.
- **Silver:** Select relevant columns; examine and clean missing, inconsistent, and unusual values.
- **Gold (planned):** Produce model-ready features, predictions, and analysis tables for reporting.

## Data quality investigation and cleaning decisions

The following missing-value counts were calculated **after removing listings with missing prices**:

| Field | Missing values | % of 59,905 | Investigation / selected approach |
| --- | ---: | ---: | --- |
| `beds` | 1,502 | 2.51% | Grouped median using `room_type` and `accommodates` |
| `minimum_nights` | 298 | 0.50% | Median by `room_type` in the latest cleaning workflow |
| `bathrooms_text` | 92 | 0.15% | Extract numeric counts and bathroom-access information |
| `bathrooms_count` | 98 | 0.16% | Includes six descriptions not parsed as numbers; investigate, then use grouped median with fallback |
| `bedrooms` | 24 | 0.04% | Manually reviewed; 23 recorded as 0 separate bedrooms, one as 1 bedroom |
| `review_scores_rating` | 12,258 | 20.46% | Preserve missingness while an appropriate modelling treatment is decided |
| `review_scores_location` | 12,263 | 20.47% | Preserve missingness while an appropriate modelling treatment is decided |

**Important:** `bathrooms_text` and `bathrooms_count` are different representations of the same bathroom information; their missing counts should not be added together. The imputation strategies above were explored during cleaning. For final model evaluation, medians must be learned from **training data only** and applied to validation/test data to prevent data leakage.

### Beds

Investigation showed that typical bed counts increase with guest capacity. For example, the median number of beds for an entire home/apartment was **1** for two guests, **3** for six guests, and **5** for ten guests. This supports using the median within each combination of `room_type` and `accommodates`, with a broader median as a fallback. The 75th percentile was examined but not chosen as the default because it could systematically overestimate missing bed counts.

### Minimum nights

There were **298** missing `minimum_nights` values. Of these, **297** were in `Room in hotel` properties and **one** was in an `Entire rental unit`. The overall mean minimum stay was **3.74 nights**, compared with a median of **2 nights** and a maximum of **365 nights**. Median imputation was preferred to reduce the influence of very long minimum stays. The current workflow uses a `room_type` median; property-type median imputation was also investigated.

### Bathrooms

Bathroom counts were extracted from descriptions such as `1 bath`, `1.5 baths`, and `10 shared baths`. The extracted numeric values had a mean of approximately **1.35**, a median of **1**, and a maximum of **30**. A further six nonmissing text descriptions did not convert to numeric counts and need checking before the bathroom cleaning is finalised.

Analysis by room type and guest capacity showed that the groups containing missing bathroom values generally had a median of **1**, with room-type medians available as fallback estimates where a smaller group had no valid counts.

In addition, **47** listings were flagged for review because they reported more than five bathrooms while being classified as private, shared, or hotel rooms. Some records may describe bathrooms available across an entire hotel, hostel, or building rather than bathrooms belonging exclusively to the rented accommodation. These records are **not automatically deleted or replaced**: the flag indicates that further investigation is needed.

A proposed `bathroom_access` feature distinguishes descriptions that explicitly state **Shared** or **Private** from **Unspecified** and **Missing**. An unspecified description should not automatically be treated as a private bathroom.

### Bedrooms

Only **24** bedroom values were missing. The listing pages were manually reviewed. Based on this review, **23** listings had no separate bedrooms (including studio-style accommodation), while **one** listing had one bedroom. A value of **0 bedrooms** is valid when a sleeping area is not a separate bedroom.

### Review scores

Some listings have no review ratings, including potentially new or unreviewed properties. Missing reviews will not automatically be replaced with a rating of zero, which could incorrectly imply poor quality. An appropriate missing-value treatment remains to be chosen before modelling.

## Data limitations

- Removing listings without recorded prices may introduce selection bias.
- Missing review scores may reflect new listings or incomplete information, not negative reviews.
- Bathroom counts may refer to building-wide shared facilities rather than the rented unit.
- Rare combinations of room type and guest capacity have fewer observations, making their group medians less reliable.
- Grouped median imputation gives estimated values, not confirmed property details.
- Extreme bed and bathroom counts require careful interpretation; unusual does not necessarily mean incorrect.
- Price comparisons will need to account for property characteristics and modelling uncertainty before calling a listing potentially overpriced or underpriced.

## Tools and methods

- **Python / pandas:** data inspection, cleaning, grouping, and feature preparation
- **Jupyter Notebook / VS Code:** analysis and development
- **Microsoft SQL Server:** planned/ongoing data storage and querying workflow
- **scikit-learn / XGBoost:** planned regression modelling
- **Power BI:** planned interactive reporting
- **Git & GitHub:** version control and project documentation

## Next steps

1. Finalise numeric bathroom extraction, `bathroom_access`, and flagged-record review.
2. Confirm all cleaning operations in one reproducible Silver-stage pipeline.
3. Decide how to represent missing review scores without treating them as zero ratings.
4. Create model-ready features and split data into training and test sets.
5. Fit imputation and other preprocessing using training data only.
6. Compare Linear Regression, Random Forest, and XGBoost using MAE, RMSE, and R².
7. Analyse the differences between actual and predicted prices and build Power BI visuals.

## Data availability

The original London listings CSV is approximately **214.65 MB**, above GitHub's standard **100 MB per-file limit**. It is intentionally kept **outside ordinary Git tracking**. Download the dataset from [Inside Airbnb](https://insideairbnb.com/get-the-data/) and place it in the expected local data directory before running data-dependent notebooks/scripts. The specific snapshot and paths should be documented alongside the final reproducible pipeline.

Suggested `.gitignore` entry for the current local dataset folder:

```gitignore
/Data/listings.csv/
```

## Project note

This README documents progress through the **data investigation and cleaning stage**. Model performance, pricing flags, and dashboard findings will be added when those stages are complete.
