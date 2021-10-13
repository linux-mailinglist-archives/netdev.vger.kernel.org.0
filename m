Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D269B42B3AE
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 05:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhJMDh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 23:37:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:59005 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237377AbhJMDhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 23:37:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="208138764"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="208138764"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 20:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="524469776"
Received: from glass.png.intel.com ([10.158.65.69])
  by orsmga001.jf.intel.com with ESMTP; 12 Oct 2021 20:35:18 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: phy: dp83867: add generic PHY loopback
Date:   Wed, 13 Oct 2021 11:41:28 +0800
Message-Id: <20211013034128.2094426-3-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013034128.2094426-1-boon.leong.ong@intel.com>
References: <20211013034128.2094426-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Lay, Kuan Loon" <kuan.loon.lay@intel.com>

TI DP83867 supports loopback enabled using BMCR, so we add
genphy_loopback to the phy driver.

Tested-by: Clement <clement@intel.com>
Signed-off-by: Lay, Kuan Loon <kuan.loon.lay@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/phy/dp83867.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index bb4369b75179..af47c62d6e04 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -878,6 +878,7 @@ static struct phy_driver dp83867_driver[] = {
 
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+		.set_loopback	= genphy_loopback,
 	},
 };
 module_phy_driver(dp83867_driver);
-- 
2.25.1

