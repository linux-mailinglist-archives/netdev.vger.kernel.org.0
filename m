Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD3055EAC7
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiF1RO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiF1RO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:14:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B06F2CCBD;
        Tue, 28 Jun 2022 10:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656436493; x=1687972493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wVM6MHqJ/3CzokUzpdzu9UEnvRuwP6DusvD+3MpK4b8=;
  b=E4r8dRUEw/gMPDYQFoN2ZSbTH252rgaDBnCgc6r3znB9p1sjO3dgg3bn
   4YSwvepjggWsLYJMmyyGkos4w7/HEt05sYo6+x0/YmIbyyoJQJdkvnIsx
   L3M//LJc7X3eakb3zelxcul1gn3ZuxYqJt3TSLS7wkm6SirJfaU6X/ii4
   Zwtqa68Vbuh7o3284en2V/YZTbbadK2xMzPfXoCTuM7YYRL7Lv23H4f1X
   P7AAbzJsCYKdLxUdE1Igj6LQMS0hTX1/wJV572Hu2aeVUgoTNyYf+bWDu
   z3ulfSQwqa0fhcGKE4VVFn+2yo5takAWXRb0GD4wtVayZ5su9oWgi2kwL
   g==;
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="102138314"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2022 10:14:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Jun 2022 10:14:49 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 28 Jun 2022 10:14:38 -0700
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
Subject: [Patch net-next 4/7] net: dsa: microchip: remove the struct ksz8
Date:   Tue, 28 Jun 2022 22:43:26 +0530
Message-ID: <20220628171329.25503-5-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628171329.25503-1-arun.ramadoss@microchip.com>
References: <20220628171329.25503-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the struct ksz8 from ksz8.h which is no longer
needed. The platform bus specific details are now deferenced through
dev->priv.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8.h        |  4 ----
 drivers/net/dsa/microchip/ksz8863_smi.c | 17 +++--------------
 drivers/net/dsa/microchip/ksz_spi.c     | 10 +---------
 3 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index a4a2dc889b30..42c50cc4d853 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -12,10 +12,6 @@
 #include <net/dsa.h>
 #include "ksz_common.h"
 
-struct ksz8 {
-	void *priv;
-};
-
 int ksz8_setup(struct dsa_switch *ds);
 u32 ksz8_get_port_addr(int port, int offset);
 void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member);
diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index d71df05b8b7b..5247fdfb964d 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -26,11 +26,9 @@ static int ksz8863_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
 	struct mdio_device *mdev;
 	u8 reg = *(u8 *)reg_buf;
 	u8 *val = val_buf;
-	struct ksz8 *ksz8;
 	int i, ret = 0;
 
-	ksz8 = dev->priv;
-	mdev = ksz8->priv;
+	mdev = dev->priv;
 
 	mutex_lock_nested(&mdev->bus->mdio_lock, MDIO_MUTEX_NESTED);
 	for (i = 0; i < val_len; i++) {
@@ -55,13 +53,11 @@ static int ksz8863_mdio_write(void *ctx, const void *data, size_t count)
 {
 	struct ksz_device *dev = ctx;
 	struct mdio_device *mdev;
-	struct ksz8 *ksz8;
 	int i, ret = 0;
 	u32 reg;
 	u8 *val;
 
-	ksz8 = dev->priv;
-	mdev = ksz8->priv;
+	mdev = dev->priv;
 
 	val = (u8 *)(data + 4);
 	reg = *(u32 *)data;
@@ -142,17 +138,10 @@ static int ksz8863_smi_probe(struct mdio_device *mdiodev)
 {
 	struct regmap_config rc;
 	struct ksz_device *dev;
-	struct ksz8 *ksz8;
 	int ret;
 	int i;
 
-	ksz8 = devm_kzalloc(&mdiodev->dev, sizeof(struct ksz8), GFP_KERNEL);
-	if (!ksz8)
-		return -ENOMEM;
-
-	ksz8->priv = mdiodev;
-
-	dev = ksz_switch_alloc(&mdiodev->dev, ksz8);
+	dev = ksz_switch_alloc(&mdiodev->dev, mdiodev);
 	if (!dev)
 		return -ENOMEM;
 
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 344ff92db099..69fabb190f26 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -14,7 +14,6 @@
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
 
-#include "ksz8.h"
 #include "ksz_common.h"
 
 #define KSZ8795_SPI_ADDR_SHIFT			12
@@ -45,16 +44,9 @@ static int ksz_spi_probe(struct spi_device *spi)
 	struct device *ddev = &spi->dev;
 	struct regmap_config rc;
 	struct ksz_device *dev;
-	struct ksz8 *ksz8;
 	int i, ret = 0;
 
-	ksz8 = devm_kzalloc(&spi->dev, sizeof(struct ksz8), GFP_KERNEL);
-	if (!ksz8)
-		return -ENOMEM;
-
-	ksz8->priv = spi;
-
-	dev = ksz_switch_alloc(&spi->dev, ksz8);
+	dev = ksz_switch_alloc(&spi->dev, spi);
 	if (!dev)
 		return -ENOMEM;
 
-- 
2.36.1

