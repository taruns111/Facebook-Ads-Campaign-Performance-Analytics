# 📊 Facebook Ads Campaign Performance Analytics

An end-to-end analytics project that cleans, analyzes, and models Facebook Ads campaign data to uncover what drives clicks, conversions, and approved conversions — and to predict approved conversions for new ad sets. The project spans **Python (EDA + Feature Engineering + ML)**, **SQL**, and a **Power BI** dashboard.

---

## 🎯 Objective

Analyze the performance of 3 Facebook ad campaigns (1,143 ads, ~213M impressions, ~$58.7K spend) to answer:
- Which campaigns, age groups, genders, and interest categories deliver the best ROI?
- Where is ad spend being wasted?
- Can we predict how many *approved* conversions an ad will generate before scaling it?

---

## 🗂️ Project Structure

```
Facebook Ads Campaign Performance Analytics/
├── data/
│   ├── KAG_conversion_data.csv                 # Raw source dataset
│   ├── cleaned_facebook_ads.csv                 # Cleaned dataset (post notebook 01)
│   └── facebook_ads_feature_engineered.csv      # Cleaned + KPI features (post notebook 03)
├── notebook/
│   ├── 01_Data_Loading_and_Cleaning.ipynb       # Load, inspect, clean, type-cast, save
│   ├── 02_Exploratory_Data_Analysis.ipynb       # Univariate, bivariate & correlation EDA
│   ├── 03_Feature_Engineering_and_KPIs.ipynb    # CTR, CPC, CPM, CPA, Conversion Rate, etc.
│   └── 04_Machine_Learning.ipynb                # Model training, tuning, evaluation
│   
├── model/
│   └── facebook_ads_model.pkl                   # Tuned Random Forest Regressor (joblib)
├── Power bi/
│   └── dashboard.pbix                           # 3-page interactive Power BI dashboard
├── SQL/
│   └── facebook_ads_analysis.sql                # Cleaning + campaign/audience SQL queries
├── images/
│   ├── Executive overview.png                   # Dashboard: KPIs, campaign trend, spend split
│   ├── Audience analysis.png                    # Dashboard: age/gender/interest breakdown
│   └── Details.png                               # Dashboard: ad-level drill-through table
├── README.md
├── INSIGHTS.md
└── requirements.txt
```

---

## 🧩 Dataset

Source: [Kaggle — Facebook Ad Campaign (KAG_conversion_data.csv)](https://www.kaggle.com/datasets/tarunsaini9785/kag-conversion-data)

| Column | Description |
|---|---|
| `ad_id` | Unique identifier for the ad |
| `xyz_campaign_id` | Campaign ID (3 campaigns: 916, 936, 1178) |
| `fb_campaign_id` | Facebook's internal campaign ID |
| `age` | Age bracket of the target audience (30-34, 35-39, 40-44, 45-49) |
| `gender` | Target audience gender (M/F) |
| `interest` | Interest category code targeted |
| `impressions` | Number of times the ad was shown |
| `clicks` | Number of clicks the ad received |
| `spent` | Amount spent on the ad (in campaign currency) |
| `Total_Conversion` | Total people who enquired after seeing the ad |
| `Approved_Conversion` | Total people who actually purchased after seeing the ad |

**Engineered KPIs** (notebook 03): `CTR`, `CPC`, `CPM`, `Conversion_rate`, `Approved_Conversion_Rate`, `CPA`, `Cost_Per_Approved`, `Conversions_per_1000`.

---

## 🔧 Pipeline / Workflow

1. **Data Cleaning** (`01_Data_Loading_and_Cleaning.ipynb`) — checked nulls, duplicates, invalid values (negative spend/clicks, approved > total conversions), cast `age` to categorical, renamed columns, saved `cleaned_facebook_ads.csv`.
2. **Exploratory Data Analysis** (`02_Exploratory_Data_Analysis.ipynb`) — univariate distributions (age, gender, interest, impressions, clicks, spend), outlier detection (5th/95th percentile), bivariate breakdowns (age vs. clicks/spend/conversions, gender vs. clicks/conversions), correlation heatmap, top-10 ad rankings, campaign/audience rankings.
3. **Feature Engineering & KPIs** (`03_Feature_Engineering_and_KPIs.ipynb`) — built CTR, CPC, CPM, conversion rate, approved conversion rate, CPA, cost-per-approved, and conversions-per-1000-impressions; handled infinities/NaNs from zero-click ads; saved `facebook_ads_feature_engineered.csv`.
4. **SQL Analysis** (`SQL/facebook_ads_analysis.sql`) — mirrors the cleaning checks and runs campaign-level and audience-level aggregations directly in SQL for a BI-team-friendly version of the analysis.
5. **Machine Learning** (`04_Machine_Learning.ipynb`) — label-encoded `age`/`gender`, trained and compared **Linear Regression, Decision Tree, Random Forest, and XGBoost** regressors to predict `Approved_Conversion`, ran 5-fold cross-validation, tuned the Random Forest via `GridSearchCV`, and saved the best model.
6. **Power BI Dashboard** (`Power bi/dashboard.pbix`) — 3-page report (Executive Overview, Audience Analysis, Details) built on the feature-engineered dataset.

---

## 🤖 Model

- **Algorithm:** Random Forest Regressor (scikit-learn), selected after comparing against Linear Regression, Decision Tree, and XGBoost
- **Target:** `Approved_Conversion`
- **Tuned hyperparameters** (via `GridSearchCV`, 5-fold CV, scoring = R²): `n_estimators=300`, `max_depth=15`
- **Features used:** `ad_id`, `xyz_campaign_id`, `fb_campaign_id`, `interest`, `impressions`, `clicks`, `spent`, `Total_Conversion`, `CTR`, `CPC`, `CPM`, `Conversion_rate`, `Approved_Conversion_Rate`, `CPA`, `Cost_Per_Approved`, `Conversions_per_1000`, `age_encoded`, `gender_encoded`
- **Artifact:** `model/facebook_ads_model.pkl` (saved with `joblib`)

Load it with:
```python
import joblib
model = joblib.load("model/facebook_ads_model.pkl")
predictions = model.predict(X_new)  # X_new must have the same 17 columns, same order
```

> ⚠️ Note: `Total_Conversion` and `Approved_Conversion_Rate`/`Cost_Per_Approved` are derived *from* Approved_Conversion, so this model is best used for **explanatory/what-if analysis** (e.g., "given this spend & CTR profile, what approved-conversion range should I expect?") rather than as a leak-free production predictor. See [INSIGHTS.md](INSIGHTS.md) for a note on this.

---

## 📈 Power BI Dashboard

Three pages, built on `facebook_ads_feature_engineered.csv`:

1. **Executive Overview** — headline KPI cards (spend, impressions, clicks, CTR, conversions), spend trend by campaign, campaign comparison.
2. **Audience Analysis** — performance broken down by age group, gender, and interest category (clicks, spend, conversions, CPA).
3. **Details** — ad-level drill-through table for granular inspection/filtering.

Open `Power bi/dashboard.pbix` in Power BI Desktop to explore interactively.

---

## 🛠️ Tech Stack

| Layer | Tools |
|---|---|
| Data cleaning & EDA | Python, Pandas, NumPy |
| Visualization | Matplotlib, Seaborn |
| Machine Learning | scikit-learn, XGBoost, joblib |
| Database / Querying | SQL |
| BI Dashboard | Power BI (DAX) |
| Notebooks | Jupyter |

---

## ▶️ How to Run

```bash
# 1. Clone/download the project, then install dependencies
pip install -r requirements.txt

# 2. Run notebooks in order
jupyter notebook notebook/01_Data_Loading_and_Cleaning.ipynb
jupyter notebook notebook/02_Exploratory_Data_Analysis.ipynb
jupyter notebook notebook/03_Feature_Engineering_and_KPIs.ipynb
jupyter notebook notebook/04_Machine_Learning.ipynb

# 3. Open the dashboard
# Open "Power bi/dashboard.pbix" in Power BI Desktop

# 4. Run SQL queries
# Load KAG_conversion_data.csv into a `facebook_ads` table and run SQL/facebook_ads_analysis.sql
```

---

## 📌 Key Findings

See [**INSIGHTS.md**](INSIGHTS.md) for the full breakdown. Headline takeaways:

- Total spend: **$58,705** across **213.4M impressions**, **38,165 clicks**, and **1,079 approved conversions** (blended CPA ≈ **$54.4**).
- **Campaign 1178** drove 92% of total ad spend and impressions but had the *highest* CPA (~$64) — scale came at a real cost-efficiency trade-off vs. campaign 916 (CPA ~$6).
- **Men convert more efficiently than women** despite women generating more clicks: male CPA ≈ $41 vs. female CPA ≈ $70.
- The **30–34 age group** is the strongest overall performer — lowest CPA (~$31) combined with high volume — while **45–49** has the highest CPA (~$100).
- Interest codes **16, 29, and 10** are the top-3 approved-conversion drivers; codes **105, 109, 106, 27, 103** have the worst cost-efficiency.

---

## 👤 Author

**Tarun Saini** — Data Analyst Intern, ZeTheta Algorithms Pvt. Ltd.
🔗 [GitHub](https://github.com/taruns111) | 🌐 [Portfolio](https://tarun-saini.vercel.app)
