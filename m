Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB7F298A1F
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769270AbgJZKOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1768384AbgJZJrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 05:47:42 -0400
Received: from mail.kernel.org (ip5f5ad5a1.dynamic.kabel-deutschland.de [95.90.213.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 296F320829;
        Mon, 26 Oct 2020 09:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603705662;
        bh=5lHzpILvKYHOsmZv84lgfmyWVXRvs6xXURMjdZd7/44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLuYqSTP+rjpp/Gk0N7/RDhjDA/lLDO46hHQZOMOfcTlw0IfBwDPSM5hU7ZbkcJt2
         Vba4RKVcVAiByT35c3kIalyyYwL8IkWHLMTsyYc0DpqQLHh6fT74g6D4f2nl42wYQS
         hFeL1vnx3GZ0Z/m2HUV8WQ1jP91hC4swqSqbrxmk=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kWz6J-0030t1-Lg; Mon, 26 Oct 2020 10:47:39 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RESEND 1/3] net: phy: fix kernel-doc markups
Date:   Mon, 26 Oct 2020 10:47:36 +0100
Message-Id: <d23c5638c4fd0e7b9f294f2bf647d2386428eb7e.1603705472.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603705472.git.mchehab+huawei@kernel.org>
References: <cover.1603705472.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some functions have different names between their prototypes
and the kernel-doc markup.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/net/phy/mdio_bus.c   | 2 +-
 drivers/net/phy/phy-c45.c    | 2 +-
 drivers/net/phy/phy.c        | 2 +-
 drivers/net/phy/phy_device.c | 2 +-
 drivers/net/phy/phylink.c    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 757e950fb745..e59067c64e97 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -472,7 +472,7 @@ static inline void of_mdiobus_link_mdiodev(struct mii_bus *mdio,
 #endif
 
 /**
- * mdiobus_create_device_from_board_info - create a full MDIO device given
+ * mdiobus_create_device - create a full MDIO device given
  * a mdio_board_info structure
  * @bus: MDIO bus to create the devices on
  * @bi: mdio_board_info structure describing the devices
diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index bd11e62bfdfe..077f2929c45e 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -9,7 +9,7 @@
 #include <linux/phy.h>
 
 /**
- * genphy_c45_setup_forced - configures a forced speed
+ * genphy_c45_pma_setup_forced - configures a forced speed
  * @phydev: target phy_device struct
  */
 int genphy_c45_pma_setup_forced(struct phy_device *phydev)
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 35525a671400..71ed2596acf5 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -489,7 +489,7 @@ void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies)
 EXPORT_SYMBOL(phy_queue_state_machine);
 
 /**
- * phy_queue_state_machine - Trigger the state machine to run now
+ * phy_trigger_machine - Trigger the state machine to run now
  *
  * @phydev: the phy_device struct
  */
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5dab6be6fc38..ea5d5fb42d01 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2735,7 +2735,7 @@ static int phy_get_int_delay_property(struct device *dev, const char *name)
 #endif
 
 /**
- * phy_get_delay_index - returns the index of the internal delay
+ * phy_get_internal_delay - returns the index of the internal delay
  * @phydev: phy_device struct
  * @dev: pointer to the devices device struct
  * @delay_values: array of delays the PHY supports
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fe2296fdda19..1318ccb62bd7 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1649,7 +1649,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 EXPORT_SYMBOL_GPL(phylink_ethtool_set_pauseparam);
 
 /**
- * phylink_ethtool_get_eee_err() - read the energy efficient ethernet error
+ * phylink_get_eee_err() - read the energy efficient ethernet error
  *   counter
  * @pl: a pointer to a &struct phylink returned from phylink_create().
  *
-- 
2.26.2

