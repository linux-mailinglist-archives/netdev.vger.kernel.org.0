Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4340529E69
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiEQJpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiEQJpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:45:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C2847AD3;
        Tue, 17 May 2022 02:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652780710; x=1684316710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V5Bz/2ER+IXDmrGvFCoFgwklVvMB1f614I67El7r2a4=;
  b=Vmx/cHSnvnNopZVUy3n22wFe2ltt4P+bhlULoeMuomyMi6ss50Kauv89
   up2vyxQEUeusCG5pRSsU0q+PqhRVvUi/cb6gJkS332QqkD0p4rC76fk2s
   8qBMAPukph1LFGYU3g63/DD/c6eP3qacY53f0Xwvj86kP51/AKdbxj+JU
   p24tknprbYj+xLCrRhtwkBqgPlRjiAEvWijip1YdhZ8A+fTQmOY4Odkwa
   zZM8AYC+imyP80JH+KHlIeUaX9rJUqNXRjmZI3EUK7lBdJn4Ir5J1yFQz
   qxbqdbk81GbwB/jzZeDAzr+JLD1bpBYpw3Ry6GTWADFBYuCN7ok/CXh+u
   g==;
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="156361045"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 May 2022 02:45:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 17 May 2022 02:45:09 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 17 May 2022 02:45:03 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net-next 9/9] net: dsa: microchip: remove unused members in ksz_device
Date:   Tue, 17 May 2022 15:13:33 +0530
Message-ID: <20220517094333.27225-10-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220517094333.27225-1-arun.ramadoss@microchip.com>
References: <20220517094333.27225-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The name, regs_size and overrides members in struct ksz_device are
unused. Hence remove it.
And host_mask is used in only place of ksz8795.c file, which can be
replaced by dev->info->cpu_ports

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 3 +--
 drivers/net/dsa/microchip/ksz_common.h | 4 ----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 9d6d3c69fd47..12a599d5e61a 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1360,7 +1360,7 @@ static int ksz8_setup(struct dsa_switch *ds)
 	ether_addr_copy(alu.mac, eth_stp_addr);
 	alu.is_static = true;
 	alu.is_override = true;
-	alu.port_forward = dev->host_mask;
+	alu.port_forward = dev->info->cpu_ports;
 
 	ksz8_w_sta_mac_table(dev, 0, &alu);
 
@@ -1476,7 +1476,6 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	dev->ds->ops = &ksz8_switch_ops;
 
 	dev->cpu_port = fls(dev->info->cpu_ports) - 1;
-	dev->host_mask = dev->info->cpu_ports;
 	dev->phy_port_cnt = dev->info->port_cnt - 1;
 	dev->port_mask = (BIT(dev->phy_port_cnt) - 1) | dev->info->cpu_ports;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index de963f0f83e2..8500eaedad67 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -73,7 +73,6 @@ struct ksz_port {
 struct ksz_device {
 	struct dsa_switch *ds;
 	struct ksz_platform_data *pdata;
-	const char *name;
 	const struct ksz_chip_data *info;
 
 	struct mutex dev_mutex;		/* device access */
@@ -94,7 +93,6 @@ struct ksz_device {
 	int cpu_port;			/* port connected to CPU */
 	int phy_port_cnt;
 	phy_interface_t compat_interface;
-	u32 regs_size;
 	bool synclko_125;
 	bool synclko_disable;
 
@@ -106,8 +104,6 @@ struct ksz_device {
 	u16 mirror_rx;
 	u16 mirror_tx;
 	u32 features;			/* chip specific features */
-	u32 overrides;			/* chip functions set by user */
-	u16 host_mask;
 	u16 port_mask;
 };
 
-- 
2.33.0

