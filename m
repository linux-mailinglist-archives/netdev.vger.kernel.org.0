Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50A4425E49
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhJGU7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:59:17 -0400
Received: from mout.perfora.net ([74.208.4.197]:58571 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232543AbhJGU7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:59:16 -0400
Received: from toolbox.toradex.int ([66.171.181.186]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MI42y-1mUipk1gxa-003t2P;
 Thu, 07 Oct 2021 22:57:10 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v3 2/3] ARM: mvebu_v7_defconfig: rebuild default configuration
Date:   Thu,  7 Oct 2021 22:56:58 +0200
Message-Id: <20211007205659.702842-3-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211007205659.702842-1-marcel@ziswiler.com>
References: <20211007205659.702842-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dVQHDubzEHWi/vPPtC1zIp/mMQYrmcRwZCzkBOl73qsCv7IQ6TN
 9un4BHc54FBI4woQZre54qbG4iar3nsGDu41jyFfNyVxSpbWe5utMTHKPjQxOw2v8y/DMqb
 wXBrNro2e85calr3RWsENwaadxRUpxLV31DMFTzEkGsaXEAZNtzNCSsE4zFayGB/t09gOOq
 n6HolRAGIgEvwPuaEcrWA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tiAB1e0/+TI=:2pFmrsJ+soMC1Vi2v3Cbdb
 /FxmLBHIrrTeZioWOFhc+9dc0VXcUhNWfhBU5ErYFEfIyDCpTqibi8J7H8D0hz1xQ/MBXb/Sy
 TiEcG10fUkm8jSasCayYU3+DMuUMdADECxq/E8PJuRaUXCgBoOjNv2IVbfrrEuzxYxHAGG88D
 axNsgc2hHTubFHdsQT0S5QHyn9Pv+TJ7RjRbTGlqmKQ08sJ62Oa9CIniS3F+bqtv77Wsxo9kw
 twVODCjqx/Xyz+4OfJgP5Pw7TUOaBGmxjAWrCXDEZ/5OvY//tvV5qFxFQakEffcNV0J9TAfxj
 fbKZcLCTVxbG4RZhrldlnXPlH9YVduwl5EiVchmEutLMdzV2GjgoVXGoFNldJbDXIZOKxXA0R
 zN/3Lioy7OEL8+Dln9VO+57bkx2WGezop/PNo9z/Ojom8N4TGUamnIxPfs3RvCBzBFIl5eVUQ
 OokOm3ILdBj+sxVZaLSP3kqxGTVxXcFE32vwbEyJYZxhYiGqYbkqf8+qzw4UZd9b6W3YwLf65
 aG+wToeWl2XwJhwZ6MqVWnsccAM/kk97TiTPPceVLdVM4uX8xd60fGcyqa5eSXjUlPeXXm/Kq
 eXerkVGKwQp+UIajkSMJdgXep3krpuOP7JTQZTslXxhfMjgcrPepRUiQAVSaAXbRuUDfHq5XF
 +8/Si3wHtx0euqQdIkKGGpmdtmzpxXb51QenE1yZuV9v9cf3TBRPXnTCfqhfvkGKvWu+kxS4p
 slt7o68AOjHkTro0HOIv4tngeGghWkMvGz73Iw==
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

(no changes since v2)

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

