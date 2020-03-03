Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C86B177041
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 08:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgCCHoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 02:44:19 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58697 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgCCHoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 02:44:19 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1j92Dw-0002RY-D2; Tue, 03 Mar 2020 08:44:16 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1j92Dw-00083C-1Q; Tue, 03 Mar 2020 08:44:16 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        david@protonic.nl
Subject: [PATCH v1] net: dsa: sja1105: add 100baseT1_Full support
Date:   Tue,  3 Mar 2020 08:44:14 +0100
Message-Id: <20200303074414.30693-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate 100baseT1_Full to make this driver work with TJA1102 PHY.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 34544b1c30dc..7b5a80ba12bd 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -866,6 +866,7 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, MII);
 	phylink_set(mask, 10baseT_Full);
 	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 100baseT1_Full);
 	if (mii->xmii_mode[port] == XMII_MODE_RGMII)
 		phylink_set(mask, 1000baseT_Full);
 
-- 
2.25.0

