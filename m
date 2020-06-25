Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D05B20A247
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390703AbgFYPpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:45:08 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:35605 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405979AbgFYPpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:45:02 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 625DF1C000D;
        Thu, 25 Jun 2020 15:45:00 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next 4/8] net: phy: mscc: ptp: fix a typo in a comment
Date:   Thu, 25 Jun 2020 17:42:07 +0200
Message-Id: <20200625154211.606591-5-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625154211.606591-1-antoine.tenart@bootlin.com>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a typo in a comment, s/Ths/This/. The patch is cosmetic
only.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index 030a56c9a06d..d4266911efc5 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1564,7 +1564,7 @@ int vsc8584_ptp_probe(struct phy_device *phydev)
 
 	/* Retrieve the shared load/save GPIO. Request it as non exclusive as
 	 * the same GPIO can be requested by all the PHYs of the same package.
-	 * Ths GPIO must be used with the gpio_lock taken (the lock is shared
+	 * This GPIO must be used with the gpio_lock taken (the lock is shared
 	 * between all PHYs).
 	 */
 	vsc8531->load_save = devm_gpiod_get_optional(&phydev->mdio.dev, "load-save",
-- 
2.26.2

