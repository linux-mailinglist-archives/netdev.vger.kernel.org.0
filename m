Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB92F21D3
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732861AbfKFWhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:37:02 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:57377 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731985AbfKFWhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:37:00 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9234D23E4B;
        Wed,  6 Nov 2019 23:36:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573079817;
        bh=ruB/mLOIj7Ep9U0y+TkZ982uHDBp1AabCTy8ebmugCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfoRr9adeqXdb+9nLffERiSaLlxIbeDUNLFCqLKrxQrYgcY4BqbetlAlED03XTqjp
         CUFF0E1Obh+sUQswQ02abfda7Oo7lOyo2E5CpSReM5Omy6AVGUKmc5EDpEOHZxZiP7
         NcnFqX+lxOgUe/SWDV9GRtDYRije5EIlq5/V3sCs=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v2 5/6] net: phy: at803x: fix the PHY names
Date:   Wed,  6 Nov 2019 23:36:16 +0100
Message-Id: <20191106223617.1655-6-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106223617.1655-1-michael@walle.cc>
References: <20191106223617.1655-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix at least the displayed strings. The actual name of the chip is
AR803x.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 716672edd415..4434d501cd4f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -2,7 +2,7 @@
 /*
  * drivers/net/phy/at803x.c
  *
- * Driver for Atheros 803x PHY
+ * Driver for Qualcomm Atheros AR803x PHY
  *
  * Author: Matus Ujhelyi <ujhelyi.m@gmail.com>
  */
@@ -109,7 +109,7 @@
 #define ATH8035_PHY_ID 0x004dd072
 #define AT803X_PHY_ID_MASK			0xffffffef
 
-MODULE_DESCRIPTION("Atheros 803x PHY driver");
+MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
 
@@ -706,9 +706,9 @@ static int at803x_read_status(struct phy_device *phydev)
 
 static struct phy_driver at803x_driver[] = {
 {
-	/* ATHEROS 8035 */
+	/* Qualcomm Atheros AR8035 */
 	.phy_id			= ATH8035_PHY_ID,
-	.name			= "Atheros 8035 ethernet",
+	.name			= "Qualcomm Atheros AR8035",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
@@ -721,9 +721,9 @@ static struct phy_driver at803x_driver[] = {
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 }, {
-	/* ATHEROS 8030 */
+	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
-	.name			= "Atheros 8030 ethernet",
+	.name			= "Qualcomm Atheros AR8030",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
@@ -736,9 +736,9 @@ static struct phy_driver at803x_driver[] = {
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 }, {
-	/* ATHEROS 8031/8033 */
+	/* Qualcomm Atheros AR8031/AR8033 */
 	.phy_id			= ATH8031_PHY_ID,
-	.name			= "Atheros 8031/8033 ethernet",
+	.name			= "Qualcomm Atheros AR8031/AR8033",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
@@ -754,7 +754,7 @@ static struct phy_driver at803x_driver[] = {
 }, {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
-	.name			= "Atheros AR9331 built-in PHY",
+	.name			= "Qualcomm Atheros AR9331 built-in PHY",
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
 	.suspend		= at803x_suspend,
-- 
2.20.1

