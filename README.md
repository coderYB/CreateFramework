# CreateFramework


1.创建一个project选择framework

2.创建名为：XXX的工程

3.添加需要打包到framework的方法

4.在XXX.h(工程名.h)中导入需要暴露给用户的头文件：格式为#import<XXX(工程名)/YYYYY(暴露给用户的方法类的名字).h>

5.修改为静态库：TARGETS->Build Settings->

1).Linking中：Mach-O Type 修改为Static Library、Link With Standard Library 修改为 NO 、Dead Code Stripping 修改为NO
2).Architectures中：Architectures ->选择other 添加armv7s 、 Build Active Architecture Only 修改为 NO


TARGETS->Build Phases->

Compile Sources 中添加所有需要打包到framework中方法的.m文件 （一般Xcode默认添加）

Headers 中 把我们需要暴露给用户的头文件移动到public中


6.到目前为止基本的创建framework工作已经完成，那么如何提供给其他人用呢？目前为止我们可以通过选择虚拟器或者真机生成framework,这种方式生成的framework是分开使用对应的虚拟器和真机。这种方式很复杂，下面我们用脚本来生成虚拟器和真机通用的framework。

7.创建Aggregate：file -> new -> target -> Aggregate 

8. TARGETS 中选中创建好的Aggregate 展开Target Dependencies 点击 + 添加framework

9.点击左上角（Target Dependencies上方）+  选择New Run Script Phase 创建可执行的脚本文件


10.添加可执行的脚本文件：

# Sets the target folders and the final framework product.
# 如果工程名称和Framework的Target名称不一样的话，要自定义FMKNAME
# 例如: FMK_NAME = "MyFramework"
FMK_NAME=${PROJECT_NAME}

# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework
# Working dir will be deleted after the framework creation.
WRK_DIR=${BUILD_ROOT}
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework


# -configuration ${CONFIGURATION}
# Clean and Building both architectures.
#xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos -arch armv7 -arch armv7s -arch arm64 clean build
#xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator -arch x86_64 clean build

# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"

# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
cp -r "${SRCROOT}/Products/"

#rm -r "${WRK_DIR}"

open "${SRCROOT}/Products/"



11.将framework 及 aggregate 的 scheme 中 Build Configuration 修改为Release

12. framework 模拟器及真机各编译一遍 、aggregate选择真机模式编译，编译成功自动弹出.framework文件
