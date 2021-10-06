Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9CA423808
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbhJFGfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:35:38 -0400
Received: from mout.perfora.net ([74.208.4.197]:58963 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhJFGff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 02:35:35 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MqaIG-1nBnHF1oWm-00mb2C;
 Wed, 06 Oct 2021 08:33:29 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v2 2/3] ARM: mvebu_v7_defconfig: rebuild default configuration
Date:   Wed,  6 Oct 2021 08:33:20 +0200
Message-Id: <20211006063321.351882-3-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211006063321.351882-1-marcel@ziswiler.com>
References: <20211006063321.351882-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:fe4JLaUy0KZmYbwPWJerceSR27/M2I23d9Sx3SqllgMfyj6DIc3
 09WeiOmUJWCqkPUZBSfnMJsM/zFe5W+9egHcnKlvdJMQkCSgKbhjhunMwlmbly8v35Gg+g1
 LXWJiSRWWORlCBqkcBRhSpQP8CIqybEjM/l4URgJYKzcFtci59GjHV0IdXRBuZIHGmEZmjk
 mGCY+tr8DrpDIVICQMDhw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yzHcSoSB7QM=:wKICiMRb5oXmZNe2UMkwNi
 xmMnDhint23FEG6Ps7z2w4bKPxj3TcMiZJu/apge9r8b0t/gFxaDD2836Xay/qgv+Qh7myru/
 GLcpGPBK4xJduExG/58nTzaVHbRSP2luFksGU73cX7ol+oZQl3wKCGbpSLEo8fci49Mrrkg/u
 AtgcL+YFvhS4OgnSeoiMS2TBcofCQdJiGlyfVRBYX2mq5JLWfxgo5bJghXXV8CAnh20+C1Xxq
 4Zvg2o1ig71qZwgckdDwva9REM8O/u903IGhnHWroItwxWe6J5d6p9QFyDo43F4nE1lmH6wN0
 KcXlbb8DM8WreoJz0B8sVuCUMhok1dF14qvpgu44p3wH6nIK7dWQ/WzebrCpfQT127LDZAu0M
 5Ng6sbS3a9CI23BtIs8IfV4RGIvHO/MylRL9fy6zD5YUDoomNHYleVaOy+2+nrU1UIgQno0HK
 IplsUoJ30Azc4OkV30bkBAS/6bRp59AICrtSL/DCJi3EhiHVGN6tCmLY4cHHY4Y7/sZRqTd9M
 IiDK4r9oQKwqG3n7jwprOW8IQJ+W+cPF2ow+cSKbQNIcw73F2HUEYHeTNvK0JdAs60y3HPzAP
 bmkFfI70ITXFb6dh1kjQvV4M6+vR6gWhen5COQL6Ir5m9nwPFVry8gOMRuQEnoef+bRo39Jwm
 W/CAVQThuDmgmN/1scTJo8Pkh096cZ7ozjnHkIph/Oj1i6Omk8tS2W8MtYdb7UbNZcW7DRoS/
 7z7W5DnrOnKQlfnpMlYFmbKf2k24YmsQpm8Uww==
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---

Changes in v2:
- Add Andrew's reviewed-by tag.

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

