Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B48421EA3
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhJEGFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:05:55 -0400
Received: from mout.perfora.net ([74.208.4.194]:36945 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232245AbhJEGFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:05:50 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0LaEeW-1nDo0R0Ngc-00m1kB;
 Tue, 05 Oct 2021 08:03:49 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v1 3/4] ARM: mvebu_v7_defconfig: rebuild default configuration
Date:   Tue,  5 Oct 2021 08:03:33 +0200
Message-Id: <20211005060334.203818-4-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211005060334.203818-1-marcel@ziswiler.com>
References: <20211005060334.203818-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Ab1X30x0tpz7+4tbct+aeSqoySZZ5hos7ohFSLmNieEbMSDPcML
 5W/H34gv82id5qoK2Vg2gyMtoSpmRfsc/6SR4Ov3dpsoG4tFtm28IgcPSd+gt2UacO+dZK5
 fwfcU3wzihwHrkmT55oVopAWXsktzPOXZzrzXQTyrnUEPIgv7KeALDVjTBAWXw2moMLDzKl
 XQG8zxnnV4rtPEXHn1kGA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rkl9RVNWCto=:tJxVS7DBnuppiHKhgvHGnN
 28sPZaGKCbrxYjmDoKWb9hcxmMBpIjAJjDc/8a7My6ITezpaqIRBlDDpWYL/RSDUsroRY4Por
 r/Irs0X6ta3Mkrf9hAv/1swmJCE5OvXDLnH1kkx+sRpwIuR5b8Ye9QRhZEYH16hbIBO8BLteS
 H6ZnctWJbMikFWcKhLD+GgwVU3r0oU9xkykGdEhowx03jITJ++GLS3JN5TTE2tLeT1UNh9lXD
 BeSgVINqPBcTG0ZZ1m+NfMcuho7rdT/w6elPawqxqOQ6Wo8PywaoVXVlyP3SKfyZohkQdnJWN
 e9nqGR2e940/jglVcWrZNqQxIEt7r2CAD/eBAphnu4uOneQu4ZbA0CpIuHtxv5ax0UCcFAxOs
 27mKU+HXoNWEdiqG8BMssINoZtm/muONQof5D3oUhkUl30A/cyIl4CHlh753b9ZanJPIJbAAL
 Xh35KBN6RmInajJPqnWj9PLyQ4DTutV6JdG+3+t80DSNoWOwPLbhCM2Z0qS1kyUA2PWJUQbDY
 Ny0wovYy6H1ApqZUt+2kU6mF6L1C34gcrlxWZjMK5CJ9M2GNyxrWQWbpp85WP1Dpsmtvi3ahI
 lmnub3UN8dsiGlmVzg+MtH9YVQxBnrUW2UHhiSkzZDxyByJjh4SPeh+Jz0YxgCPRXnlOe5EWS
 F40BtMGrIMvCd50qJnEnmqCS9VDnsNV1zzZ29+z7MRcXXtkBmesZuIP78qYQqU+9dRNcHrCDn
 xAjV7LXfDh4gHPDBgYTy1lMOc9lVmy1XfOOr3Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Run "make mvebu_v7_defconfig; make savedefconfig" to rebuild
mvebu_v7_defconfig

This re-ordered the following configuration options:

CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_PCI=y
CONFIG_PCI_MVEBU=y
CONFIG_CRYPTO_DEV_MARVELL_CESA=y

And dropped the following nowadays obsolete configuration options:

CONFIG_ZBOOT_ROM_TEXT=0x0 (default now anyway since commit 39c3e304567a
 ("ARM: 8984/1: Kconfig: set default ZBOOT_ROM_TEXT/BSS value to 0x0"))
CONFIG_ZBOOT_ROM_BSS=0x0 (ditto)
CONFIG_MTD_M25P80=y (got integrated into MTD_SPI_NOR)

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---

 arch/arm/configs/mvebu_v7_defconfig | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm/configs/mvebu_v7_defconfig b/arch/arm/configs/mvebu_v7_defconfig
index 5e9a9474c93fb..7b713c083a2a7 100644
--- a/arch/arm/configs/mvebu_v7_defconfig
+++ b/arch/arm/configs/mvebu_v7_defconfig
@@ -5,8 +5,6 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_EXPERT=y
 CONFIG_PERF_EVENTS=y
 CONFIG_SLAB=y
-CONFIG_MODULES=y
-CONFIG_MODULE_UNLOAD=y
 CONFIG_ARCH_MVEBU=y
 CONFIG_MACH_ARMADA_370=y
 CONFIG_MACH_ARMADA_375=y
@@ -14,13 +12,8 @@ CONFIG_MACH_ARMADA_38X=y
 CONFIG_MACH_ARMADA_39X=y
 CONFIG_MACH_ARMADA_XP=y
 CONFIG_MACH_DOVE=y
-CONFIG_PCI=y
-CONFIG_PCI_MVEBU=y
 CONFIG_SMP=y
 CONFIG_HIGHMEM=y
-# CONFIG_COMPACTION is not set
-CONFIG_ZBOOT_ROM_TEXT=0x0
-CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_CPU_FREQ=y
@@ -29,6 +22,9 @@ CONFIG_CPU_IDLE=y
 CONFIG_ARM_MVEBU_V7_CPUIDLE=y
 CONFIG_VFP=y
 CONFIG_NEON=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_COMPACTION is not set
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
@@ -40,6 +36,8 @@ CONFIG_BT=y
 CONFIG_BT_MRVL=y
 CONFIG_BT_MRVL_SDIO=y
 CONFIG_CFG80211=y
+CONFIG_PCI=y
+CONFIG_PCI_MVEBU=y
 CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
@@ -51,7 +49,6 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_CFI_STAA=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_PHYSMAP_OF=y
-CONFIG_MTD_M25P80=y
 CONFIG_MTD_RAW_NAND=y
 CONFIG_MTD_NAND_MARVELL=y
 CONFIG_MTD_SPI_NOR=y
@@ -147,10 +144,10 @@ CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_2=y
 CONFIG_NLS_UTF8=y
+CONFIG_CRYPTO_DEV_MARVELL_CESA=y
 CONFIG_PRINTK_TIME=y
+# CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_SCHED_DEBUG is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_USER=y
-CONFIG_CRYPTO_DEV_MARVELL_CESA=y
-- 
2.26.2

