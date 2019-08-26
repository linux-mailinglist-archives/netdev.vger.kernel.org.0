Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3989CF85
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 14:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbfHZMV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 08:21:26 -0400
Received: from mail.nic.cz ([217.31.204.67]:58480 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731984AbfHZMVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 08:21:22 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 4B4CE140B4F;
        Mon, 26 Aug 2019 14:21:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566822078; bh=2FWHBd0r4P3gmGewTPVaXJmjDkHPxUFc0vSn1YwgNyQ=;
        h=From:To:Date;
        b=jnBoCCTEc8jDGJKFWugG0XiUlz0OHgd4tSHJvBNgujNfUIw0IxOLmOOVzxIqfVGx+
         Q6FsuQ0BfdIO7WQmLpwMuVybwM5R0e8rcCODM0c2nPoKvsfG6UgR2LaTR+082+VyvH
         mQhiDAOIc6DpDO53p64yH12WfFIeKYue45pl9RVc=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v4 5/6] net: dsa: mv88e6xxx: rename port cmode macro
Date:   Mon, 26 Aug 2019 14:21:08 +0200
Message-Id: <20190826122109.20660-6-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190826122109.20660-1-marek.behun@nic.cz>
References: <20190826122109.20660-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic update. We are removing the last underscore from
macros MV88E6XXX_PORT_STS_CMODE_100BASE_X and
MV88E6XXX_PORT_STS_CMODE_1000BASE_X. The 2500base-x version does not
have that underscore. Also PHY_INTERFACE_MODE_ macros do not have it
there.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/port.c   |  4 +--
 drivers/net/dsa/mv88e6xxx/port.h   |  4 +--
 drivers/net/dsa/mv88e6xxx/serdes.c | 48 +++++++++++++++---------------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index d20be5327640..7183c94a92ec 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -411,7 +411,7 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 
 	switch (mode) {
 	case PHY_INTERFACE_MODE_1000BASEX:
-		cmode = MV88E6XXX_PORT_STS_CMODE_1000BASE_X;
+		cmode = MV88E6XXX_PORT_STS_CMODE_1000BASEX;
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 		cmode = MV88E6XXX_PORT_STS_CMODE_SGMII;
@@ -618,7 +618,7 @@ int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
 		else
 			state->interface = PHY_INTERFACE_MODE_RGMII;
 		break;
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 		state->interface = PHY_INTERFACE_MODE_1000BASEX;
 		break;
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 21d2d8f7c8f9..6d7a067da0f5 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -43,8 +43,8 @@
 #define MV88E6XXX_PORT_STS_FLOW_CTL		0x0010
 #define MV88E6XXX_PORT_STS_CMODE_MASK		0x000f
 #define MV88E6XXX_PORT_STS_CMODE_RGMII		0x0007
-#define MV88E6XXX_PORT_STS_CMODE_100BASE_X	0x0008
-#define MV88E6XXX_PORT_STS_CMODE_1000BASE_X	0x0009
+#define MV88E6XXX_PORT_STS_CMODE_100BASEX	0x0008
+#define MV88E6XXX_PORT_STS_CMODE_1000BASEX	0x0009
 #define MV88E6XXX_PORT_STS_CMODE_SGMII		0x000a
 #define MV88E6XXX_PORT_STS_CMODE_2500BASEX	0x000b
 #define MV88E6XXX_PORT_STS_CMODE_XAUI		0x000c
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index d7aadda157d6..e2439f86d351 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -73,8 +73,8 @@ static bool mv88e6352_port_has_serdes(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
 
-	if ((cmode == MV88E6XXX_PORT_STS_CMODE_100BASE_X) ||
-	    (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X) ||
+	if ((cmode == MV88E6XXX_PORT_STS_CMODE_100BASEX) ||
+	    (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX) ||
 	    (cmode == MV88E6XXX_PORT_STS_CMODE_SGMII))
 		return true;
 
@@ -295,7 +295,7 @@ int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane)
 	if (port != 5)
 		return 0;
 
-	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 		*lane = MV88E6341_PORT5_LANE;
@@ -311,13 +311,13 @@ int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane)
 
 	switch (port) {
 	case 9:
-		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 			*lane = MV88E6390_PORT9_LANE0;
 		break;
 	case 10:
-		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 			*lane = MV88E6390_PORT10_LANE0;
@@ -341,53 +341,53 @@ int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane)
 
 	switch (port) {
 	case 2:
-		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				*lane = MV88E6390_PORT9_LANE1;
 		break;
 	case 3:
-		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				*lane = MV88E6390_PORT9_LANE2;
 		break;
 	case 4:
-		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				*lane = MV88E6390_PORT9_LANE3;
 		break;
 	case 5:
-		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				*lane = MV88E6390_PORT10_LANE1;
 		break;
 	case 6:
-		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				*lane = MV88E6390_PORT10_LANE2;
 		break;
 	case 7:
-		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				*lane = MV88E6390_PORT10_LANE3;
 		break;
 	case 9:
-		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
@@ -395,7 +395,7 @@ int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane)
 			*lane = MV88E6390_PORT9_LANE0;
 		break;
 	case 10:
-		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
@@ -476,7 +476,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		return mv88e6390_serdes_power_sgmii(chip, lane, on);
 	case MV88E6XXX_PORT_STS_CMODE_XAUI:
@@ -535,7 +535,7 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 		mode = PHY_INTERFACE_MODE_SGMII;
 		break;
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 		mode = PHY_INTERFACE_MODE_1000BASEX;
 		break;
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
@@ -578,7 +578,7 @@ int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		err = mv88e6390_serdes_irq_enable_sgmii(chip, lane);
 	}
@@ -594,7 +594,7 @@ int mv88e6390_serdes_irq_disable(struct mv88e6xxx_chip *chip, int port,
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		err = mv88e6390_serdes_irq_disable_sgmii(chip, lane);
 	}
@@ -629,7 +629,7 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		err = mv88e6390_serdes_irq_status_sgmii(chip, lane, &status);
 		if (err)
-- 
2.21.0

