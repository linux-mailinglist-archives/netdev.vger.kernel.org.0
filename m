Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5335346591
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhCWQm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:42:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:31003 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233224AbhCWQmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 12:42:35 -0400
IronPort-SDR: w3tSc0/ErQxoEhk8UQu+KQ4J/sklvlBPnYc9vkNI+9wszcQc50oU7fLDQF/fP8rQygZtkMaEVx
 do3oqMJ+d1Jw==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="178081796"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="178081796"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 09:42:35 -0700
IronPort-SDR: 2mACqbPw8a6SJ9PSHWd+QyBnkPlurmQQ9aedR+9Ev/lsbTjVsRy5dPD9U693riaeP5jeekb07G
 CV3P8kFID/dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="415070639"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2021 09:42:34 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id DA1F758069F;
        Tue, 23 Mar 2021 09:42:31 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 2/2] net: phy: marvell10g: Add PHY loopback support
Date:   Wed, 24 Mar 2021 00:46:41 +0800
Message-Id: <20210323164641.26059-3-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
References: <20210323164641.26059-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for PHY loopback for Marvell 88x2110 and Marvell 88x3310.

This allow user to perform PHY loopback test using ethtool selftest.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/phy/marvell10g.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b1bb9b8e1e4e..74b64e52ffa2 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -781,6 +781,7 @@ static struct phy_driver mv3310_drivers[] = {
 		.get_tunable	= mv3310_get_tunable,
 		.set_tunable	= mv3310_set_tunable,
 		.remove		= mv3310_remove,
+		.set_loopback	= genphy_c45_loopback,
 	},
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
@@ -796,6 +797,7 @@ static struct phy_driver mv3310_drivers[] = {
 		.get_tunable	= mv3310_get_tunable,
 		.set_tunable	= mv3310_set_tunable,
 		.remove		= mv3310_remove,
+		.set_loopback	= genphy_c45_loopback,
 	},
 };
 
-- 
2.25.1

