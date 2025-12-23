import streamlit as st
import numpy as np
import pandas as pd
import joblib
import matplotlib.pyplot as plt
import seaborn as sns

# Load trained model and scaler
model = joblib.load("demand_pricing_model.pkl")
scaler = joblib.load("demand_pricing_scaler.pkl")

st.title("📈 Demand Forecasting & Price Elasticity Simulator")

st.write("Enter product details below:")

# Collect inputs
price = st.number_input("Price", min_value=0.0, value=50.0)
freight_value = st.number_input("Freight Value", min_value=0.0, value=10.0)
year = st.slider("Year", 2016, 2020, 2018)
month = st.slider("Month", 1, 12, 6)
effective_price = st.number_input("Effective Price", min_value=0.0, value=60.0)
month_sin = np.sin(2 * np.pi * month / 12)
month_cos = np.cos(2 * np.pi * month / 12)
lag_quantity = st.number_input("Lag Quantity", min_value=0.0, value=5.0)
lag_price = st.number_input("Lag Price", min_value=0.0, value=50.0)
avg_freight_per_category = st.number_input("Avg Freight per Category", min_value=0.0, value=8.0)
avg_price_per_category = st.number_input("Avg Price per Category", min_value=0.0, value=55.0)
day = st.slider("Day of Month", 1, 31, 15)
day_of_week = st.slider("Day of Week (0=Mon)", 0, 6, 2)
is_weekend = st.selectbox("Is Weekend", [0, 1])
avg_price_per_seller = st.number_input("Avg Price per Seller", min_value=0.0, value=50.0)
avg_freight_per_seller = st.number_input("Avg Freight per Seller", min_value=0.0, value=10.0)
category_price_rank = st.number_input("Category Price Rank", min_value=0.0, value=3.0)
seller_freight_rank = st.number_input("Seller Freight Rank", min_value=0.0, value=2.0)
product_price_std = st.number_input("Product Price Std Dev", min_value=0.0, value=5.0)
product_avg_price = st.number_input("Product Avg Price", min_value=0.0, value=50.0)
product_total_orders = st.number_input("Product Total Orders", min_value=0.0, value=100.0)
seller_total_orders = st.number_input("Seller Total Orders", min_value=0.0, value=200.0)
product_category_encoded = st.number_input("Product Category (Encoded)", min_value=0, max_value=50, value=10)

# Prepare input data
base_input = np.array([[price, freight_value, year, month, effective_price,
                        month_sin, month_cos, lag_quantity, lag_price,
                        avg_freight_per_category, avg_price_per_category,
                        day, day_of_week, is_weekend, avg_price_per_seller,
                        avg_freight_per_seller, category_price_rank,
                        seller_freight_rank, product_price_std,
                        product_avg_price, product_total_orders,
                        seller_total_orders, product_category_encoded]])

if st.button("Predict Quantity"):
    input_scaled = scaler.transform(base_input)
    prediction = model.predict(input_scaled)[0]
    predicted_quantity = int(round(prediction))
    st.success(f"🎯 Predicted Quantity Sold: {predicted_quantity} units")

    # Elasticity simulation
    st.subheader("📉 Price Elasticity Simulation")
    st.write("Simulating how demand & revenue change with price variation...")

    price_changes = np.arange(-0.5, 0.6, 0.1)  # -50% to +50%
    simulations = []

    for change in price_changes:
        new_price = price * (1 + change)
        modified_input = base_input.copy()
        modified_input[0][0] = new_price  # Update price
        modified_input[0][4] = new_price  # Update effective_price

        scaled_input = scaler.transform(modified_input)
        new_quantity = model.predict(scaled_input)[0]
        revenue = new_price * new_quantity

        simulations.append({
            'Price Change (%)': f"{change*100:.0f}%",
            'New Price': round(new_price, 2),
            'Predicted Quantity': round(new_quantity),
            'Revenue': round(revenue)
        })

    sim_df = pd.DataFrame(simulations)

    # Show table
    st.dataframe(sim_df)

    # Plotting
    st.subheader("📊 Revenue Impact Chart")
    sns.set(style="whitegrid")
    fig, ax = plt.subplots(figsize=(8, 5))
    sns.barplot(data=sim_df, x="Price Change (%)", y="Revenue", palette="Blues_d", ax=ax)
    ax.set_title("💸 Revenue vs. Price Change")
    st.pyplot(fig)

    # Show optimal price
    best_row = sim_df.loc[sim_df['Revenue'].idxmax()]
    st.success(f"💡 Optimal Price: ₹{best_row['New Price']} for Max Revenue: ₹{best_row['Revenue']}")

    import seaborn as sns
print("Seaborn is installed.")

import sys
print(sys.executable)
