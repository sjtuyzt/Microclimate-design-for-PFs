import pandas as pd
from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error
import numpy as np

# 读取 Excel 文件
excel_file = pd.ExcelFile('文献数据整理.xlsx')

# 获取所有表名
sheet_names = excel_file.sheet_names

# 初始化一个空的列表来存储每个 sheet 的结果
results = []

# 遍历每个 sheet
for sheet_name in sheet_names:
    df = excel_file.parse(sheet_name)
    # 假设数据的真实值在第一列，预测值在第二列
    y_true = df.iloc[:, 0]
    y_pred = df.iloc[:, 1]

    # 计算 RMSE
    rmse = np.sqrt(mean_squared_error(y_true, y_pred))
    # 计算 NRMSE
    nrmse = rmse / (y_true.max() - y_true.min())
    # 计算 R2
    r2 = r2_score(y_true, y_pred)
    # 计算 MAE
    mae = mean_absolute_error(y_true, y_pred)
    nmae = mae / (y_true.max() - y_true.min())
    # 计算 NMSE，根据要求修改除数为实验值的平方和
    mse = mean_squared_error(y_true, y_pred)
    # 计算真实值的方均值
    mean_squared_value = np.mean(np.square(y_true))
    nmse = mse / mean_squared_value

    # 计算实验值的离散程度，使用标准差
    std_dev = np.std(y_true)

    # 计算变异系数 CV（标准差/均值）
    mean_value = np.mean(y_true)
    cv = std_dev / mean_value if mean_value != 0 else 0

    # 将结果添加到列表中
    results.append({    
        'Author': sheet_name,
        'NMSE': nmse * 100,
        'NRMSE': nrmse * 100,
        'NMAE': nmae * 100,
        'R2': r2,
        '实验值离散程度(标准差)': std_dev,
        '变异系数(CV)': cv
    })

# 将结果列表转换为 DataFrame
result_df = pd.DataFrame(results)
print(result_df)