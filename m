Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF18A3A427C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhFKM5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 08:57:11 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23995 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhFKM5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 08:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623416111; x=1654952111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i7uooW7kjebncXi3kdElMhfKYX/VG/ejw92Sdr6yUYc=;
  b=rpFshZUdbtCwJ3R3tiKou1wmGDIbNSW0S7XZ1Mi82yTBL1U/4xC1CD8z
   BROHu2DRM9cxrVeNrNx7y7rFokCDIdhl2oMaZP3wz5bC3U6bCnpmlpSzR
   XfPVsqn2EN82KbDfzd1L4p+p4yj24fWCKTvKFtd9dNDhPMHrgMdfTqmE5
   pFoVTMoIySKOMHZieUF558s8Xp7HusUC8jkqHjvyiB7ENB3i4gHd6JeDc
   ICW5jPOCgd7QFASWliD0vqJ7WQAQa272ctJ30nWyo6BEHDtbysn6nb35j
   Uq3Ow2M41mujwQt3PRpRHL+8f+PW5a9MFKaRkJCzmT9074jx2Z5et6NrO
   g==;
IronPort-SDR: wx1Yf+ux0b5mJWDLaTGZlNEVgHjWZCwq/eiNHazKIe6bd4Ss+rEM68EQgnpLwYiIKh9bAqqjXO
 Pp6UaqAI9Vcy2RQq2SKxTqXghxIQpyXfY70wthr0ZONkhmAPZhsxpDufI37LJ+OPpRWV83ANDq
 00Gq1SmrMBIevbG1ACmvkBXIcljOdLzdQKE7zlyPv1BxVENu9BgJdoMtb6vf+n9JVWdQYikMVV
 a7y9oHdYT7UOQtqtqVygw8k8RFZyBVPe+mFM4ufZO1bE3oU6/njVxYh0FhXrP2Th0+BBJNZh7v
 elE=
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="124398244"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jun 2021 05:55:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 05:55:10 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 11 Jun 2021 05:55:08 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Subject: [PATCH net-next 3/4] net: sfp: add support for 25G BASE-R SFPs
Date:   Fri, 11 Jun 2021 14:54:52 +0200
Message-ID: <20210611125453.313308-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210611125453.313308-1-steen.hegelund@microchip.com>
References: <20210611125453.313308-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 25gbase-r modules. This is needed for the Sparx5 switch.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 drivers/net/phy/sfp-bus.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index e61de66e973b..1db9cea13690 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -392,6 +392,11 @@ EXPORT_SYMBOL_GPL(sfp_parse_support);
 phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 				     unsigned long *link_modes)
 {
+	if (phylink_test(link_modes, 25000baseCR_Full) ||
+	    phylink_test(link_modes, 25000baseKR_Full) ||
+	    phylink_test(link_modes, 25000baseSR_Full))
+		return PHY_INTERFACE_MODE_25GBASER;
+
 	if (phylink_test(link_modes, 10000baseCR_Full) ||
 	    phylink_test(link_modes, 10000baseSR_Full) ||
 	    phylink_test(link_modes, 10000baseLR_Full) ||
-- 
2.32.0

