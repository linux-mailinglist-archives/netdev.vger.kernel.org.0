Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698E65A264F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbiHZK5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344093AbiHZK46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:56:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33D365258
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:56:55 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0x-0002vJ-H0; Fri, 26 Aug 2022 12:56:39 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0w-0024ZC-5m; Fri, 26 Aug 2022 12:56:38 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0t-00GB4E-Lj; Fri, 26 Aug 2022 12:56:35 +0200
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v4 16/17] net: dsa: microchip: remove unused sgmii variable
Date:   Fri, 26 Aug 2022 12:56:33 +0200
Message-Id: <20220826105634.3855578-17-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826105634.3855578-1-o.rempel@pengutronix.de>
References: <20220826105634.3855578-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This variable is not used. So, remove it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 5 -----
 drivers/net/dsa/microchip/ksz_common.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 18375309233ad..077b4e5c29c7c 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1075,12 +1075,7 @@ void ksz9477_config_cpu_port(struct dsa_switch *ds)
 	for (i = 0; i < dev->info->port_cnt; i++) {
 		if (i == dev->cpu_port)
 			continue;
-		p = &dev->ports[i];
-
 		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
-		if (dev->chip_id == 0x00947700 && i == 6) {
-			p->sgmii = 1;
-		}
 	}
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 99da2092d0d7d..4914cc1c803a4 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -74,7 +74,6 @@ struct ksz_port {
 
 	u32 on:1;			/* port is not disabled by hardware */
 	u32 fiber:1;			/* port is fiber */
-	u32 sgmii:1;			/* port is SGMII */
 	u32 force:1;
 	u32 read:1;			/* read MIB counters in background */
 	u32 freeze:1;			/* MIB counter freeze is enabled */
-- 
2.30.2

