# 📊 Insights Report — Facebook Ads Campaign Performance Analytics

Based on `data/facebook_ads_feature_engineered.csv` (1,143 ads across 3 campaigns).

## 1. Headline Numbers

| Metric | Value |
|---|---|
| Total Spend | $58,705.23 |
| Total Impressions | 213,434,828 |
| Total Clicks | 38,165 |
| Total (raw) Conversions | 3,264 |
| Total Approved Conversions | 1,079 |
| Overall CTR | 0.018% |
| Overall CPC | $1.54 |
| Blended CPA (per approved conversion) | $54.41 |
| Overall lead-to-sale approval rate | 33.1% |

**Read:** Out of every 3 people who enquire (raw conversion), roughly 1 actually becomes an approved/paying customer — this approval rate is the single biggest lever on true ROI, more than clicks or CTR alone.

---

## 2. Campaign-Level Performance

| Campaign | Ads | Impressions | Clicks | Spend | Approved Conv. | CPC | CPA | Approval Rate |
|---|---|---|---|---|---|---|---|---|
| **916** | 54 | 482,925 | 113 | small | 47 | $1.32 | **$6.24** | 41.4% |
| **936** | 464 | 8.1M | 1,984 | mid | 220 | $1.46 | $15.81 | 34.1% |
| **1178** | 625 | 204.8M | 36,068 | large (~92% of total) | 812 | $1.54 | **$63.83** | 32.7% |

**Insight:** Campaign 1178 is the volume driver — it absorbs almost all the budget and impressions — but efficiency drops sharply as it scales. Campaign 916, while tiny, is by far the most cost-efficient (CPA ~10x lower than 1178). This is a classic scale-vs-efficiency trade-off: worth investigating whether 1178's audience/creative can be tightened to bring CPA down, or whether budget should be reallocated to replicate 916's targeting recipe at larger scale.

---

## 3. Gender Performance

| Gender | Spend | Clicks | CTR | Approved Conv. | CPA |
|---|---|---|---|---|---|
| Female | $34,503 | 23,878 | 0.021% | 495 | $69.70 |
| Male | $24,203 | 14,287 | 0.014% | 584 | **$41.44** |

**Insight:** Women click more (higher CTR, more raw engagement) but men convert more efficiently — more approved conversions on less spend. This mirrors the EDA notebook's finding: *"females click more on the ads but male approved more conversion."* If the goal is approved sales rather than engagement, shifting more budget toward male-targeted ad sets (or tightening the female funnel's approval step) could lower blended CPA.

---

## 4. Age Group Performance

| Age | Spend | Clicks | CTR | Approved Conv. | CPA |
|---|---|---|---|---|---|
| **30–34** | $15,252 | 9,483 | 0.014% | 494 | **$30.88** |
| 35–39 | $11,112 | 7,094 | 0.017% | 207 | $53.68 |
| 40–44 | $11,590 | 7,736 | 0.020% | 170 | $68.17 |
| 45–49 | $20,751 | 13,852 | 0.022% | 208 | $99.76 |

**Insight:** 30–34 is the standout segment — best CPA *and* the most approved conversions of any age bracket, despite not having the highest spend or CTR. 45–49 has the best raw CTR but by far the worst CPA (3.2x worse than 30–34), suggesting clicks from this group convert to sales far less reliably. Reallocating a larger share of the 45–49 budget toward 30–34 targeting is the single highest-leverage audience move available in this data.

---

## 5. Interest Category Performance

**Top 5 by approved conversions:**

| Interest Code | Spend | Clicks | Approved Conv. | CPA |
|---|---|---|---|---|
| 16 | $8,085 | 5,144 | 141 | $57.34 |
| 29 | $5,045 | 3,315 | 132 | $38.22 |
| 10 | $5,086 | 3,317 | 91 | $55.89 |
| 15 | $2,597 | 1,609 | 63 | $41.23 |
| 27 | $5,176 | 3,409 | 54 | $95.85 |

**Worst cost-efficiency (min. 5 approved conversions):**

| Interest Code | Approved Conv. | CPA |
|---|---|---|
| 105 | 6 | $107.97 |
| 109 | 8 | $101.98 |
| 106 | 5 | $96.43 |
| 27 | 54 | $95.85 |
| 103 | 5 | $95.83 |

**Insight:** Interest 29 stands out as the best all-around performer — 2nd-highest volume of approved conversions at one of the lowest CPAs ($38.22). Interest 27 is a caution flag: it drives decent volume (54 approved conversions) but at nearly $96 CPA, more than 2.5x interest 29's efficiency — a strong candidate to pause or re-test creative on. Interest codes in the 100+ range consistently show poor cost-efficiency and low volume, suggesting these niche interest targets aren't resonating with the current creative/offer.

---

## 6. Funnel Efficiency Note

No ad had literal zero recorded spend on clicks (all click-generating ads had non-zero spend), but 207 of 1,143 ads (18%) generated **zero clicks** at some measurable impression cost — these represent pure top-of-funnel waste and are good candidates for a "kill list" before the next budget cycle.

---

## 7. Correlation & Modeling Notes

- The EDA notebook's correlation heatmap flags several KPI pairs with correlation **> 0.90** (e.g., impressions↔clicks, clicks↔spend, Total_Conversion↔Approved_Conversion) — expected given they're mechanically linked, but it means clicks and spend alone are strong proxies for volume, while **approval rate** is the metric that actually differentiates quality.
- Four regression models were compared to predict `Approved_Conversion` (Linear Regression, Decision Tree, Random Forest, XGBoost); **Random Forest** was selected and tuned via `GridSearchCV` to `n_estimators=300, max_depth=15`.
- **Caveat:** because `Total_Conversion`, `Approved_Conversion_Rate`, and `Cost_Per_Approved` are mathematically derived from `Approved_Conversion`, the model largely re-derives the target from near-duplicate signals. It's useful for **descriptive/what-if scenario analysis** on historical-style ads, but for a true forward-looking predictor (e.g., predicting approved conversions from a *new, unlaunched* ad), retrain using only pre-launch-available features: `impressions`, `clicks`, `spent`, `CTR`, `CPC`, `CPM`, `age_encoded`, `gender_encoded`, `interest`.

---

## 8. Recommendations Summary

1. **Reallocate budget toward the 30–34 age group** and male-targeted ad sets — both show the best cost-per-approved-conversion.
2. **Audit Campaign 1178's targeting/creative** — it drives volume but its CPA is ~10x campaign 916's; even a partial efficiency gain here would have an outsized dollar impact given it's 92% of total spend.
3. **Pause or re-test interest codes 27, 105, 106, 109, 103** — consistently high CPA with low-to-moderate volume.
4. **Double down on interest 29** — best combination of volume and efficiency.
5. **Build a "zero-click ad" exclusion rule** into future campaign QA — 18% of ads spent budget with no engagement at all.
6. **Retrain the ML model on pre-launch-only features** if the goal is to *forecast* new ad performance rather than explain historical performance.
