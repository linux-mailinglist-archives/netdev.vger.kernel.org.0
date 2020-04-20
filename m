Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9B01B18CB
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgDTVvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:51:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:63045 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgDTVve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:51:34 -0400
IronPort-SDR: aW54VVt+krT8AR8NIkOkBx47Q+7ptdaMN4KYYkynvQ9h715GVOYJEgm+aNWmU9Uezg6rM8nbUc
 gTQ1zldNukJw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 14:51:33 -0700
IronPort-SDR: S4rPRDlcvKQkJUdJ8Ikh8rJSgiknIg9jCzUamifGqHa+KJT8B6vNme29UrpBTBveWyd/hOiAFj
 odSe4QjuDkrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="273314471"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 20 Apr 2020 14:51:31 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 00D57403; Tue, 21 Apr 2020 00:51:22 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 5/5] net: bcmgenet: Drop too many parentheses in bcmgenet_probe()
Date:   Tue, 21 Apr 2020 00:51:21 +0300
Message-Id: <20200420215121.17735-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
References: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to have parentheses around plain pointer variable or
negation operator. Drop them for good.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 2c9881032a24..20aba79becce 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3529,7 +3529,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (device_get_phy_mode(&pdev->dev) == PHY_INTERFACE_MODE_INTERNAL)
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
-	if ((pd) && (!IS_ERR_OR_NULL(pd->mac_address)))
+	if (pd && !IS_ERR_OR_NULL(pd->mac_address))
 		ether_addr_copy(dev->dev_addr, pd->mac_address);
 	else
 		if (!device_get_mac_address(&pdev->dev, dev->dev_addr, ETH_ALEN))
-- 
2.26.1

