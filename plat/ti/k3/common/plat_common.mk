#
# Copyright (c) 2017-2018, ARM Limited and Contributors. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

# We don't use BL1 or BL2, so BL31 is the first image to execute
RESET_TO_BL31		:=	1
# Only one core starts up at first
COLD_BOOT_SINGLE_CPU	:=	1
# We can choose where a core starts executing
PROGRAMMABLE_RESET_ADDRESS:=	1

# System coherency is managed in hardware
HW_ASSISTED_COHERENCY	:=	1
USE_COHERENT_MEM	:=	0

# A53 erratum for SoC. (enable them all)
ERRATA_A53_826319	:=	1
ERRATA_A53_835769	:=	1
ERRATA_A53_836870	:=	1
ERRATA_A53_843419	:=	1
ERRATA_A53_855873	:=	1

# Leave the caches enabled on core powerdown path
TI_AM65X_WORKAROUND	:=	1
$(eval $(call add_define,TI_AM65X_WORKAROUND))

MULTI_CONSOLE_API	:=	1
TI_16550_MDR_QUIRK	:=	1
$(eval $(call add_define,TI_16550_MDR_QUIRK))

# Libraries
include lib/xlat_tables_v2/xlat_tables.mk

PLAT_INCLUDES		+=	\
				-I${PLAT_PATH}/include			\
				-Iinclude/plat/arm/common/		\
				-Iinclude/plat/arm/common/aarch64/	\
				-I${PLAT_PATH}/common/drivers/sec_proxy	\
				-I${PLAT_PATH}/common/drivers/ti_sci	\

K3_CONSOLE_SOURCES	+=	\
				drivers/console/aarch64/console.S	\
				drivers/ti/uart/aarch64/16550_console.S	\
				${PLAT_PATH}/common/k3_console.c	\

K3_GIC_SOURCES		+=	\
				drivers/arm/gic/common/gic_common.c	\
				drivers/arm/gic/v3/gicv3_main.c		\
				drivers/arm/gic/v3/gicv3_helpers.c	\
				plat/common/plat_gicv3.c		\
				${PLAT_PATH}/common/k3_gicv3.c		\

K3_PSCI_SOURCES		+=	\
				plat/common/plat_psci_common.c		\
				${PLAT_PATH}/common/k3_psci.c		\

K3_SEC_PROXY_SOURCES	+=	\
				${PLAT_PATH}/common/drivers/sec_proxy/sec_proxy.c \

K3_TI_SCI_SOURCES	+=	\
				${PLAT_PATH}/common/drivers/ti_sci/ti_sci.c \

PLAT_BL_COMMON_SOURCES	+=	\
				plat/arm/common/arm_common.c		\
				lib/cpus/aarch64/cortex_a53.S		\
				${XLAT_TABLES_LIB_SRCS}			\
				${K3_CONSOLE_SOURCES}			\

BL31_SOURCES		+=	\
				${PLAT_PATH}/common/k3_bl31_setup.c	\
				${PLAT_PATH}/common/k3_helpers.S	\
				${PLAT_PATH}/common/k3_topology.c	\
				${K3_GIC_SOURCES}			\
				${K3_PSCI_SOURCES}			\
				${K3_SEC_PROXY_SOURCES}			\
				${K3_TI_SCI_SOURCES}			\
