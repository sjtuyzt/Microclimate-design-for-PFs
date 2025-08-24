### ggplot2绘制雨云图 ###

# 清除环境中的所有对象
rm(list = ls())
# 安装并加载 extrafont 包
# 安装 TOSTER 包
install.packages("TOSTER")
# 加载R包
library(ggplot2)
library(ggpubr)
library(gghalves)
library(readxl)  # 用于读取Excel文件
library(tidyr)   # 用于数据转换

# 加载 TOSTER 包
library(TOSTER)
library(extrafont)

# 导入字体
font_import()  # 只需运行一次
loadfonts(device = "win")  # 对于Windows用户
windowsFonts(TNR = windowsFont("Times New Roman"))

# 读取数据
data <- read_excel("Violin1.xlsx")

# 查看数据的前几行
head(data)

# 确保D1, D2, D3列存在
if (!all(c("H1", "H2", "H3","H4","H5") %in% colnames(data))) {
  stop("数据中缺少列")
}

# 将数据转换为长格式
data_long <- pivot_longer(data, cols = c("H1", "H2", "H3","H4","H5"), names_to = "group", values_to = "value")

# 查看转换后的数据
head(data_long)

# 提供配色
ordercolors <- c("coral1", "lightslateblue", "olivedrab3", "goldenrod1", "gray")

# 绘图
ggplot(data = data_long, 
       aes(x = group, y = value, fill = group)) +
  # 半提琴图
  geom_half_violin(side = "r", color = NA, alpha = 0.4, trim = FALSE) +
  # 半箱线图
  geom_half_boxplot(side = "r", errorbar.draw = TRUE, width = 0.2, linewidth = 0.8) +
  # 半散点图
  geom_half_point_panel(side = "L", shape = 21, size = 6,alpha = 0.6, color = "white") +
  # 填色
  scale_fill_manual(values = ordercolors) +
  # y轴取值范围及刻度
  scale_y_continuous(
    limits = c(20, 30),  # 设置y轴范围
    breaks = seq(20, 30, by = 2),  # 设置主刻度
    minor_breaks = seq(20, 30, by = 1),  # 设置小刻度
    expand = c(0, 0)  # 移除边距
  ) +
  ## x，y轴标签和标题
  labs(y = "Temperature(℃)",
       x = NULL)+ 
  # x轴注释旋转
  theme(axis.text.x = element_text(angle = 0)) +
  # 辅助线: 值的均值
  ## geom_hline(yintercept = mean(data_long$value, na.rm = TRUE), linetype = 2) +
  # 主题风格调整
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    legend.position = "none",
    panel.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(size = 2, color = "black", fill = NA),
    
    axis.text = element_text(size = 24, color = "black", family = "TNR"),
    axis.title.y = element_text(size = 24, family = "TNR"), 
    axis.line = element_line(size = 0, colour = "black"),
    axis.ticks = element_line(size = 0.8, color = "black"),
    axis.ticks.length = unit(-5, "pt"),  # 主刻度长度
    
    # 设置背景大小
    aspect.ratio = 1  # 使背景为8x8的比例
  ) 
  # +
  
  # 统计分析: 非参数检验，全局KW检验
  # stat_compare_means(method = "kruskal.test", label.y = 28.5, size = 6, vjust = -1, hjust= -1.2)
  
  # 统计分析: 等效性检验
  ## stat_compare_means(method = "tost", label.y = 21, size = 5, hjust = -0.25)
