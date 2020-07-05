Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73319214E8A
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgGESbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:31:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgGESbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 14:31:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1js9Q3-003itj-9C; Sun, 05 Jul 2020 20:31:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 4/7] net: phy: Make  phy_10gbit_fec_features_array static
Date:   Sun,  5 Jul 2020 20:29:18 +0200
Message-Id: <20200705182921.887441-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705182921.887441-1-andrew@lunn.ch>
References: <20200705182921.887441-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This array is not used outside of phy_device.c, so make it static.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d2e1193b032c..03cada335ace 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -105,10 +105,9 @@ const int phy_10gbit_features_array[1] = {
 };
 EXPORT_SYMBOL_GPL(phy_10gbit_features_array);
 
-const int phy_10gbit_fec_features_array[1] = {
+static const int phy_10gbit_fec_features_array[1] = {
 	ETHTOOL_LINK_MODE_10000baseR_FEC_BIT,
 };
-EXPORT_SYMBOL_GPL(phy_10gbit_fec_features_array);
 
 __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_10gbit_full_features) __ro_after_init;
 EXPORT_SYMBOL_GPL(phy_10gbit_full_features);
-- 
2.27.0.rc2

