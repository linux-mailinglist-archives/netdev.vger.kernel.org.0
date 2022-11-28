Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A57C63A7C5
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiK1MCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiK1MAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4741A061
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:48 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoR-0005I3-Ff; Mon, 28 Nov 2022 13:00:39 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoP-000oBA-RD; Mon, 28 Nov 2022 13:00:38 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoO-00H6RD-Js; Mon, 28 Nov 2022 13:00:36 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v1 20/26] net: dsa: microchip: make ksz8_r_sta_mac_table() static
Date:   Mon, 28 Nov 2022 13:00:28 +0100
Message-Id: <20221128120034.4075562-21-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128120034.4075562-1-o.rempel@pengutronix.de>
References: <20221128120034.4075562-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is used only in ksz8795.c, no need to export it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8.h    | 2 --
 drivers/net/dsa/microchip/ksz8795.c | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index a28fa7cd4d98..ed72ec626593 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -19,8 +19,6 @@ void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port);
 void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
 int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
-int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
-			 struct alu_struct *alu);
 void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
 			  struct alu_struct *alu);
 void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt);
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 31c77e086a9d..1c08103c9f50 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -456,8 +456,8 @@ static int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 	return ret;
 }
 
-int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
-			 struct alu_struct *alu)
+static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
+				struct alu_struct *alu)
 {
 	u32 data_hi, data_lo;
 	const u8 *shifts;
-- 
2.30.2

