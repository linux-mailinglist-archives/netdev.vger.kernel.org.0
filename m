Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F218A6D5D07
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbjDDKUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbjDDKTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:19:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67EAE79
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:18:59 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkU-00008E-4U; Tue, 04 Apr 2023 12:18:46 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkT-008tRv-DJ; Tue, 04 Apr 2023 12:18:45 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkR-005nnF-M9; Tue, 04 Apr 2023 12:18:43 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v1 3/7] net: dsa: microchip: ksz8: Make ksz8_r_sta_mac_table() static
Date:   Tue,  4 Apr 2023 12:18:38 +0200
Message-Id: <20230404101842.1382986-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404101842.1382986-1-o.rempel@pengutronix.de>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As ksz8_r_sta_mac_table() is only used within ksz8795.c, there is no need
to export it. Make the function static for better encapsulation.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8.h    | 2 --
 drivers/net/dsa/microchip/ksz8795.c | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index ad2c3a72a576..d87f8ebc6323 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -21,8 +21,6 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
 int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
 int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 			 u8 *fid, u8 *src_port, u8 *timestamp, u16 *entries);
-int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
-			 struct alu_struct *alu);
 void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 			  struct alu_struct *alu);
 void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt);
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ee68e166fc44..fc079d6eee80 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -457,8 +457,8 @@ int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 	return rc;
 }
 
-int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
-			 struct alu_struct *alu)
+static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
+				struct alu_struct *alu)
 {
 	u32 data_hi, data_lo;
 	const u8 *shifts;
-- 
2.39.2

