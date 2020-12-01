Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A84F2CADA5
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387632AbgLAUq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgLAUqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:46:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8881EC061A48
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 12:45:13 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWN-0002sj-39; Tue, 01 Dec 2020 21:45:11 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWK-0002bY-2A; Tue, 01 Dec 2020 21:45:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 01/11] net: dsa: microchip: ksz8795: remove unused last_port variable
Date:   Tue,  1 Dec 2020 21:44:56 +0100
Message-Id: <20201201204506.13473-2-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201204506.13473-1-m.grzeschik@pengutronix.de>
References: <20201201204506.13473-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable last_port is not used anywhere, this patch removes it.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v2: - unchanged
---
 drivers/net/dsa/microchip/ksz8795.c    | 1 -
 drivers/net/dsa/microchip/ksz_common.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 1e101ab56cea1..8a3d2e6072835 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1163,7 +1163,6 @@ static int ksz8795_switch_detect(struct ksz_device *dev)
 			id2 = 0x65;
 	} else if (id2 == CHIP_ID_94) {
 		dev->port_cnt--;
-		dev->last_port = dev->port_cnt;
 		id2 = 0x94;
 	}
 	id16 &= ~0xff;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index cf866e48ff664..629700a637024 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -72,7 +72,6 @@ struct ksz_device {
 	int reg_mib_cnt;
 	int mib_cnt;
 	int mib_port_cnt;
-	int last_port;			/* ports after that not used */
 	phy_interface_t compat_interface;
 	u32 regs_size;
 	bool phy_errata_9477;
-- 
2.29.2

