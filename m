Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7C2274C17
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgIVW3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 18:29:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgIVW3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 18:29:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKqmf-00FofE-8Q; Wed, 23 Sep 2020 00:29:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 1/2] net: phy: Fixup kernel doc
Date:   Wed, 23 Sep 2020 00:29:02 +0200
Message-Id: <20200922222903.3769629-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200922222903.3769629-1-andrew@lunn.ch>
References: <20200922222903.3769629-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing parameter documentation, or fixup wrong parameter names.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/mdio.h | 3 ++-
 include/linux/phy.h  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 3a88b699b758..dbd69b3d170b 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -306,7 +306,7 @@ static inline u32 linkmode_adv_to_mii_10gbt_adv_t(unsigned long *advertising)
 /**
  * mii_10gbt_stat_mod_linkmode_lpa_t
  * @advertising: target the linkmode advertisement settings
- * @adv: value of the C45 10GBASE-T AN STATUS register
+ * @lpa: value of the C45 10GBASE-T AN STATUS register
  *
  * A small helper function that translates C45 10GBASE-T AN STATUS register bits
  * to linkmode advertisement settings. Other bits in advertising aren't changed.
@@ -371,6 +371,7 @@ struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr);
 
 /**
  * mdio_module_driver() - Helper macro for registering mdio drivers
+ * @_mdio_driver: driver to register
  *
  * Helper macro for MDIO drivers which do not do anything special in module
  * init/exit. Each module may only use this macro once, and calling it
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3a09d2bf69ea..4901b2637059 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1566,8 +1566,9 @@ static inline int mdiobus_register_board_info(const struct mdio_board_info *i,
 
 
 /**
- * module_phy_driver() - Helper macro for registering PHY drivers
+ * phy_module_driver() - Helper macro for registering PHY drivers
  * @__phy_drivers: array of PHY drivers to register
+ * @__count: Numbers of members in array
  *
  * Helper macro for PHY drivers which do not do anything special in module
  * init/exit. Each module may only use this macro once, and calling it
-- 
2.28.0

