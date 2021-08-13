Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0592E3EAE5E
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 04:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhHMCGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 22:06:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:30899 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233641AbhHMCG3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 22:06:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="202648433"
X-IronPort-AV: E=Sophos;i="5.84,317,1620716400"; 
   d="scan'208";a="202648433"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 19:06:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,317,1620716400"; 
   d="scan'208";a="504062317"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 12 Aug 2021 19:06:00 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 64DDC580B0E;
        Thu, 12 Aug 2021 19:05:58 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/1] net: pcs: xpcs: Add Pause Mode support for SGMII and 2500BaseX
Date:   Fri, 13 Aug 2021 10:11:29 +0800
Message-Id: <20210813021129.1141216-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGMII/2500BaseX supports Pause frame as defined in the IEEE802.3x
Flow Control standardization.

Add this as a supported feature under the xpcs_sgmii_features struct.

Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/pcs/pcs-xpcs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 63fda3fc40aa..0930ec201cd4 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -65,6 +65,9 @@ static const int xpcs_xlgmii_features[] = {
 };
 
 static const int xpcs_sgmii_features[] = {
+	ETHTOOL_LINK_MODE_Pause_BIT,
+	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+	ETHTOOL_LINK_MODE_Autoneg_BIT,
 	ETHTOOL_LINK_MODE_10baseT_Half_BIT,
 	ETHTOOL_LINK_MODE_10baseT_Full_BIT,
 	ETHTOOL_LINK_MODE_100baseT_Half_BIT,
@@ -75,6 +78,7 @@ static const int xpcs_sgmii_features[] = {
 };
 
 static const int xpcs_2500basex_features[] = {
+	ETHTOOL_LINK_MODE_Pause_BIT,
 	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 	ETHTOOL_LINK_MODE_Autoneg_BIT,
 	ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
-- 
2.25.1

