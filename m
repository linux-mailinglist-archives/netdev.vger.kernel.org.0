Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24643A96D6
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhFPKGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:06:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4810 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbhFPKGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:06:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4gdl6Tt9zWmqc;
        Wed, 16 Jun 2021 17:59:39 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:40 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH v2 net-next 3/8] net: phy: delete repeated words of comments
Date:   Wed, 16 Jun 2021 18:01:21 +0800
Message-ID: <1623837686-22569-4-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

There are some repeated words in some comments, they should be deleted.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/phy/phy-c45.c | 2 +-
 drivers/net/phy/sfp.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index f4816b7..c617dbc 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -172,7 +172,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_config_aneg);
  * @phydev: target phy_device struct
  *
  * Disable auto-negotiation in the Clause 45 PHY. The link parameters
- * parameters are controlled through the PMA/PMD MMD registers.
+ * are controlled through the PMA/PMD MMD registers.
  *
  * Returns zero on success, negative errno code on failure.
  */
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 37f722c..34e9021 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2153,7 +2153,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
 	case SFP_S_INIT:
 		if (event == SFP_E_TIMEOUT && sfp->state & SFP_F_TX_FAULT) {
-			/* TX_FAULT is still asserted after t_init or
+			/* TX_FAULT is still asserted after t_init
 			 * or t_start_up, so assume there is a fault.
 			 */
 			sfp_sm_fault(sfp, SFP_S_INIT_TX_FAULT,
-- 
2.8.1

