Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD78216380
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 03:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgGGBuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 21:50:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgGGBt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 21:49:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsck6-003wC2-Ok; Tue, 07 Jul 2020 03:49:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 4/7] net: phy: Make  phy_10gbit_fec_features_array static
Date:   Tue,  7 Jul 2020 03:49:36 +0200
Message-Id: <20200707014939.938621-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707014939.938621-1-andrew@lunn.ch>
References: <20200707014939.938621-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This array is not used outside of phy_device.c, so make it static.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 98be28567c65..cf3505e2f587 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -106,10 +106,9 @@ const int phy_10gbit_features_array[1] = {
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

