# 硕士论文

## 日常命令

```sh
make          # 编译 thesis.tex，生成 build/thesis.pdf
make view     # 编译并打开 PDF（macOS）
make clean    # 清理构建文件，保留 PDF
make cleanall # 清理全部构建文件和 PDF
```

## 环境配置

需要 Git、Make、Python 3 和 Tectonic。本项目已在 macOS + Tectonic 0.17.0 下验证。Python 只使用标准库，无需安装 pip 包。编译不需要另装 MacTeX、TeX Live、latexmk 或 Biber。

### 安装工具

macOS：先安装 Xcode Command Line Tools（提供 Git 和 Make）及 [Homebrew](https://brew.sh/)，再安装 Tectonic 和 Python：

```sh
xcode-select --install  # 已安装则跳过
brew install tectonic python
```

Linux / Windows WSL：安装 Git、Make 和 Python 3。以 Ubuntu 为例：

```sh
sudo apt update
sudo apt install git make python3
```

然后按 [Tectonic 官方安装说明](https://tectonic-typesetting.github.io/book/latest/installation/)安装对应平台的程序，并确保 `tectonic` 在 PATH 中。已有 Conda 时也可使用 `conda install -c conda-forge tectonic`。当前 Makefile 使用 Unix 命令；Windows 请在 WSL 中运行。`make view` 仅适用于 macOS，其他系统手动打开生成的 PDF。Linux / WSL 尚未在本项目实测。

### 准备字体

项目保留 ThuThesis 上游的字体自动选择逻辑。相同配置在不同机器上可能选择不同字体。若要与当前已验证的 PDF 保持一致，需要准备以下字体：

- 中文：宋体 `SimSun`、黑体 `SimHei`、楷体 `KaiTi`、仿宋 `FangSong`。
- 西文：`Times New Roman`、`Arial`、`Courier New`。
- 数学：XITS，由 Tectonic 自动下载。

当前 Mac 使用 Microsoft Word 自带的中文字体。上游会检测 `/Applications/Microsoft Word.app/Contents/Resources/DFonts/` 下的字体。其他机器请通过有授权的 Windows / Office 安装或字体来源准备这些字体，并安装到编译环境可识别的位置。WSL 中也需要单独确认字体可见，不能假设宿主 Windows 的字体已自动可用。字体文件不随仓库分发。

### 首次编译

```sh
git clone https://github.com/cervoliu/mse-thesis.git
cd mse-thesis
tectonic --version
python3 --version
make --version
make
```

首次编译需要联网。Tectonic 会自动下载并缓存宏包和数学字体，并从仓库源码生成模板类文件。成功后得到 `build/thesis.pdf`。请检查 `build/thesis.log` 中的 `Detected fontset`；当前验证环境为 `windows`。同时检查 PDF 中文字体和页面效果。字体缺失时应补齐字体。

缓存齐全后可运行 `make TECTONIC_FLAGS=--only-cached` 验证离线编译。以后新增宏包或字体可能仍需联网。终端只过滤已确认无害的字体路径提示，完整编译输出保存在 `build/tectonic.log`。
