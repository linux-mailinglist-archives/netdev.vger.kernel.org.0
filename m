Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AB15359F9
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345709AbiE0HKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345729AbiE0HJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:09:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7299495A7;
        Fri, 27 May 2022 00:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653635281; x=1685171281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u8Hp5u9csQkyXeas2+BActtDR5Tip47bvRlV9FSKYD0=;
  b=KgwLMf98LYU70Q5ej8wlXhgVjcjhb+QdM8CTFrYEuaxbXXYPBvfgHRyo
   G4/FlKvwSZCTI2VqULbMoIx8NHczvm2dVf22yweP+NQIl/E81Z7wfO9QP
   Vz4g0dtidONm9Mj1UyML7NLaUNa5cmzPx56nP5vdPz6uY6ZO2V3EjSkcQ
   pQ0gWQRZ+j1UtvShuuQgy+JG6XfodOj0CnqCU2rYw/0hskvcoZm69Pmxq
   +d5fAIPDeYS8tcBS00LmKAQWg8J9yO2tJsMYESuu/FSk90sDt7Xr9Myz7
   KRtyyR56bUv00z/h/MbpNFYD3GM1fCgdZAjZ+LF/OuCXSpdqIFmkc/i1h
   g==;
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="165953669"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 May 2022 00:08:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 27 May 2022 00:08:00 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 27 May 2022 00:07:55 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [RFC Patch net-next 16/17] net: dsa: microchip: common menuconfig for ksz series switch
Date:   Fri, 27 May 2022 12:33:57 +0530
Message-ID: <20220527070358.25490-17-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527070358.25490-1-arun.ramadoss@microchip.com>
References: <20220527070358.25490-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the two different menuconfig for ksz9477 and ksz8795
to single ksz_common. so that it can be extended for the other switch
like lan937x. And removes the export_symbols for the extern functions in
the ksz_common.h.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/Kconfig      | 28 +++++++++-----------------
 drivers/net/dsa/microchip/Makefile     |  7 ++++---
 drivers/net/dsa/microchip/ksz_common.c |  3 ---
 3 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index c9e2a8989556..d21ff069e5aa 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -1,39 +1,29 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config NET_DSA_MICROCHIP_KSZ_COMMON
-	select NET_DSA_TAG_KSZ
-	tristate
-
-menuconfig NET_DSA_MICROCHIP_KSZ9477
-	tristate "Microchip KSZ9477 series switch support"
+menuconfig NET_DSA_MICROCHIP_KSZ_COMMON
+	tristate "Microchip KSZ8795/KSZ9477 series switch support"
 	depends on NET_DSA
-	select NET_DSA_MICROCHIP_KSZ_COMMON
+	select NET_DSA_TAG_KSZ
 	help
-	  This driver adds support for Microchip KSZ9477 switch chips.
+	  This driver adds support for Microchip KSZ9477 series switch and
+	  KSZ8795/KSZ88x3 switch chips.
 
 config NET_DSA_MICROCHIP_KSZ9477_I2C
 	tristate "KSZ9477 series I2C connected switch driver"
-	depends on NET_DSA_MICROCHIP_KSZ9477 && I2C
+	depends on NET_DSA_MICROCHIP_KSZ_COMMON && I2C
 	select REGMAP_I2C
 	help
 	  Select to enable support for registering switches configured through I2C.
 
 config NET_DSA_MICROCHIP_KSZ9477_SPI
 	tristate "KSZ9477 series SPI connected switch driver"
-	depends on NET_DSA_MICROCHIP_KSZ9477 && SPI
+	depends on NET_DSA_MICROCHIP_KSZ_COMMON && SPI
 	select REGMAP_SPI
 	help
 	  Select to enable support for registering switches configured through SPI.
 
-menuconfig NET_DSA_MICROCHIP_KSZ8795
-	tristate "Microchip KSZ8795 series switch support"
-	depends on NET_DSA
-	select NET_DSA_MICROCHIP_KSZ_COMMON
-	help
-	  This driver adds support for Microchip KSZ8795/KSZ88X3 switch chips.
-
 config NET_DSA_MICROCHIP_KSZ8795_SPI
 	tristate "KSZ8795 series SPI connected switch driver"
-	depends on NET_DSA_MICROCHIP_KSZ8795 && SPI
+	depends on NET_DSA_MICROCHIP_KSZ_COMMON && SPI
 	select REGMAP_SPI
 	help
 	  This driver accesses KSZ8795 chip through SPI.
@@ -43,7 +33,7 @@ config NET_DSA_MICROCHIP_KSZ8795_SPI
 
 config NET_DSA_MICROCHIP_KSZ8863_SMI
 	tristate "KSZ series SMI connected switch driver"
-	depends on NET_DSA_MICROCHIP_KSZ8795
+	depends on NET_DSA_MICROCHIP_KSZ_COMMON
 	select MDIO_BITBANG
 	help
 	  Select to enable support for registering switches configured through
diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 2a03b21a3386..4cf4755e6426 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -1,8 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_common.o
-obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477)		+= ksz9477.o
+obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_switch.o
+ksz_switch-objs := ksz_common.o
+ksz_switch-objs += ksz9477.o
+ksz_switch-objs += ksz8795.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
-obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 835b9e2767d1..44d62ceff427 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -576,7 +576,6 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 
 	spin_unlock(&mib->stats64_lock);
 }
-EXPORT_SYMBOL_GPL(ksz_r_mib_stats64);
 
 static void ksz_get_stats64(struct dsa_switch *ds, int port,
 			    struct rtnl_link_stats64 *s)
@@ -747,7 +746,6 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 		memset(mib->counters, 0, dev->info->mib_cnt * sizeof(u64));
 	}
 }
-EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
 
 static int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg)
 {
@@ -974,7 +972,6 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 
 	ksz_update_port_member(dev, port);
 }
-EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
 
 static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 						  int port,
-- 
2.36.1

