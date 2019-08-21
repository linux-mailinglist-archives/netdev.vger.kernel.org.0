Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2CC987CB
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbfHUX1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:27:32 -0400
Received: from mail.nic.cz ([217.31.204.67]:38050 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730354AbfHUX1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:27:31 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 9CAC0140CA0;
        Thu, 22 Aug 2019 01:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566430045; bh=E7F+vGa3fzycjpGJ80ov4wiVdIjLZlr10tUczqNV4Wk=;
        h=From:To:Date;
        b=udjLDH62VhAp+x1smoKfAzJKNdAY20PZPmuoFMMZ1vPLOTFMouEAE6XkEKY41LuNk
         BFd41Kcw/lMg+iMnixhW7oHAh9Yy/L0ZtaiMwLtQONDM5rMQrJsgDiiG4zrAJw9VY8
         i4syPRUQiGssZZ4WCw91QIFtd+JdEIP8CTiVjF9Y=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 07/10] net: dsa: mv88e6xxx: rename port cmode macro
Date:   Thu, 22 Aug 2019 01:27:21 +0200
Message-Id: <20190821232724.1544-8-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821232724.1544-1-marek.behun@nic.cz>
References: <20190821232724.1544-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
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
---
 drivers/net/dsa/mv88e6xxx/port.c   |  4 +--
 drivers/net/dsa/mv88e6xxx/port.h   |  4 +--
 drivers/net/dsa/mv88e6xxx/serdes.c | 50 +++++++++++++++---------------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 092176fd3d90..b1f66ea833ed 100644
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
index 5c5e8e7397eb..cd48670f46ae 100644
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
index 87c967e7f1ae..fd27b60875e0 100644
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
 
@@ -305,7 +305,7 @@ int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	if (port != 5)
 		return -ENODEV;
 
-	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 		return MV88E6341_PORT5_LANE;
@@ -319,13 +319,13 @@ int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 
 	switch (port) {
 	case 9:
-		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 			return MV88E6390_PORT9_LANE0;
 		return -ENODEV;
 	case 10:
-		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 			return MV88E6390_PORT10_LANE0;
@@ -345,53 +345,53 @@ int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 
 	switch (port) {
 	case 2:
-		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				return MV88E6390_PORT9_LANE1;
 		return -ENODEV;
 	case 3:
-		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				return MV88E6390_PORT9_LANE2;
 		return -ENODEV;
 	case 4:
-		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				return MV88E6390_PORT9_LANE3;
 		return -ENODEV;
 	case 5:
-		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				return MV88E6390_PORT10_LANE1;
 		return -ENODEV;
 	case 6:
-		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				return MV88E6390_PORT10_LANE2;
 		return -ENODEV;
 	case 7:
-		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASE_X)
+			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
 				return MV88E6390_PORT10_LANE3;
 		return -ENODEV;
 	case 9:
-		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
@@ -399,7 +399,7 @@ int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 			return MV88E6390_PORT9_LANE0;
 		return -ENODEV;
 	case 10:
-		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
@@ -471,7 +471,7 @@ static int mv88e6390_serdes_power_lane(struct mv88e6xxx_chip *chip, int port,
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		return mv88e6390_serdes_power_sgmii(chip, lane, on);
 	case MV88E6XXX_PORT_STS_CMODE_XAUI:
@@ -570,7 +570,7 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 		mode = PHY_INTERFACE_MODE_SGMII;
 		break;
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 		mode = PHY_INTERFACE_MODE_1000BASEX;
 		break;
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
@@ -613,7 +613,7 @@ int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		err = mv88e6390_serdes_irq_enable_sgmii(chip, lane);
 	}
@@ -629,7 +629,7 @@ int mv88e6390_serdes_irq_disable(struct mv88e6xxx_chip *chip, int port,
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		err = mv88e6390_serdes_irq_disable_sgmii(chip, lane);
 	}
@@ -664,7 +664,7 @@ static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-	case MV88E6XXX_PORT_STS_CMODE_1000BASE_X:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
 		err = mv88e6390_serdes_irq_status_sgmii(chip, lane, &status);
 		if (err)
@@ -771,7 +771,7 @@ int mv88e6341_serdes_power(struct mv88e6xxx_chip *chip, int port, bool on)
 	if (lane < 0)
 		return lane;
 
-	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASE_X ||
+	if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 		return mv88e6390_serdes_power_sgmii(chip, lane, on);
-- 
2.21.0

