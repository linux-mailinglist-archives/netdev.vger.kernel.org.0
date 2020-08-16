Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D636524590D
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 20:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgHPS4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 14:56:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55304 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729564AbgHPS4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 14:56:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7NpV-009blH-El; Sun, 16 Aug 2020 20:56:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 2/5] net/phy/mdio-i2c: Move header file to include/linux
Date:   Sun, 16 Aug 2020 20:56:08 +0200
Message-Id: <20200816185611.2290056-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200816185611.2290056-1-andrew@lunn.ch>
References: <20200816185611.2290056-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for moving all MDIO drivers into drivers/net/mdio, move
the mdio-i2c header file into include/linux so it can be used by both
the MDIO driver and the SFP code which instantiates I2C MDIO busses.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/mdio-i2c.c                    | 3 +--
 drivers/net/phy/sfp.c                         | 2 +-
 {drivers/net/phy => include/linux}/mdio-i2c.h | 0
 3 files changed, 2 insertions(+), 3 deletions(-)
 rename {drivers/net/phy => include/linux}/mdio-i2c.h (100%)

diff --git a/drivers/net/phy/mdio-i2c.c b/drivers/net/phy/mdio-i2c.c
index 0746e2cc39ae..7f2f4f5a1ed1 100644
--- a/drivers/net/phy/mdio-i2c.c
+++ b/drivers/net/phy/mdio-i2c.c
@@ -10,10 +10,9 @@
  * of their settings.
  */
 #include <linux/i2c.h>
+#include <linux/mdio-i2c.h>
 #include <linux/phy.h>
 
-#include "mdio-i2c.h"
-
 /*
  * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
  * specified to be present in SFP modules.  These correspond with PHY
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index c24b0e83dd32..f75c7cc8f4fa 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -7,6 +7,7 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <linux/mdio-i2c.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
@@ -16,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
-#include "mdio-i2c.h"
 #include "sfp.h"
 #include "swphy.h"
 
diff --git a/drivers/net/phy/mdio-i2c.h b/include/linux/mdio-i2c.h
similarity index 100%
rename from drivers/net/phy/mdio-i2c.h
rename to include/linux/mdio-i2c.h
-- 
2.28.0

