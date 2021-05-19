Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F29F3886B6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhESFib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:38:31 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3595 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243219AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlM1h6D2vzsRT6;
        Wed, 19 May 2021 13:31:52 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:37 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 14/20] net: sis: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:47 +0800
Message-ID: <1621402253-27200-15-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/sis/sis900.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 620c26f..ca9c00b 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -678,12 +678,12 @@ static int sis900_mii_probe(struct net_device *net_dev)
 	/* Reset phy if default phy is internal sis900 */
         if ((sis_priv->mii->phy_id0 == 0x001D) &&
 	    ((sis_priv->mii->phy_id1&0xFFF0) == 0x8000))
-        	status = sis900_reset_phy(net_dev, sis_priv->cur_phy);
+		status = sis900_reset_phy(net_dev, sis_priv->cur_phy);
 
         /* workaround for ICS1893 PHY */
         if ((sis_priv->mii->phy_id0 == 0x0015) &&
             ((sis_priv->mii->phy_id1&0xFFF0) == 0xF440))
-            	mdio_write(net_dev, sis_priv->cur_phy, 0x0018, 0xD200);
+		mdio_write(net_dev, sis_priv->cur_phy, 0x0018, 0xD200);
 
 	if(status & MII_STAT_LINK){
 		while (poll_bit) {
@@ -727,7 +727,7 @@ static int sis900_mii_probe(struct net_device *net_dev)
 static u16 sis900_default_phy(struct net_device * net_dev)
 {
 	struct sis900_private *sis_priv = netdev_priv(net_dev);
- 	struct mii_phy *phy = NULL, *phy_home = NULL,
+	struct mii_phy *phy = NULL, *phy_home = NULL,
 		*default_phy = NULL, *phy_lan = NULL;
 	u16 status;
 
@@ -1339,18 +1339,18 @@ static void sis900_timer(struct timer_list *t)
 	} else {
 	/* Link ON -> OFF */
                 if (!(status & MII_STAT_LINK)){
-                	netif_carrier_off(net_dev);
+			netif_carrier_off(net_dev);
 			if(netif_msg_link(sis_priv))
-                		printk(KERN_INFO "%s: Media Link Off\n", net_dev->name);
+				printk(KERN_INFO "%s: Media Link Off\n", net_dev->name);
 
-                	/* Change mode issue */
-                	if ((mii_phy->phy_id0 == 0x001D) &&
-			    ((mii_phy->phy_id1 & 0xFFF0) == 0x8000))
-               			sis900_reset_phy(net_dev,  sis_priv->cur_phy);
+			/* Change mode issue */
+			if ((mii_phy->phy_id0 == 0x001D) &&
+				((mii_phy->phy_id1 & 0xFFF0) == 0x8000))
+					sis900_reset_phy(net_dev,  sis_priv->cur_phy);
 
 			sis630_set_eq(net_dev, sis_priv->chipset_rev);
 
-                	goto LookForLink;
+			goto LookForLink;
                 }
 	}
 
@@ -2331,7 +2331,7 @@ static int sis900_set_config(struct net_device *dev, struct ifmap *map)
 		case IF_PORT_10BASE2: /* 10Base2 */
 		case IF_PORT_AUI: /* AUI */
 		case IF_PORT_100BASEFX: /* 100BaseFx */
-                	/* These Modes are not supported (are they?)*/
+			/* These Modes are not supported (are they?)*/
 			return -EOPNOTSUPP;
 
 		default:
-- 
2.8.1

