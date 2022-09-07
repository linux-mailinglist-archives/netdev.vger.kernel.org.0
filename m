Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF34E5AFC64
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiIGG3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiIGG27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:28:59 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6719C1FA;
        Tue,  6 Sep 2022 23:28:57 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MMsgR1qt7z1P87L;
        Wed,  7 Sep 2022 14:25:07 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 14:28:55 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 14:28:54 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xuhaoyue1@hisilicon.com>, <pabeni@redhat.com>,
        <edumazet@google.com>, <huangdaode@huawei.com>,
        <liangwenpeng@huawei.com>, <liyangyang20@huawei.com>
Subject: [PATCH net-next 3/3] net: amd: Switch and case should be at the same indent
Date:   Wed, 7 Sep 2022 14:28:12 +0800
Message-ID: <20220907062812.2259309-4-xuhaoyue1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20220907062812.2259309-1-xuhaoyue1@hisilicon.com>
References: <20220907062812.2259309-1-xuhaoyue1@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guofeng Yue <yueguofeng@hisilicon.com>

Cleaning some static warnings of indent.

Signed-off-by: Guofeng Yue <yueguofeng@hisilicon.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
---
 drivers/net/ethernet/amd/amd8111e.c   | 35 +++++++++++++--------------
 drivers/net/ethernet/amd/atarilance.c |  6 ++---
 drivers/net/ethernet/amd/nmclan_cs.c  | 14 +++++------
 3 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 7b4d9bbb079c..ea6cfc2095e1 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -185,24 +185,23 @@ static void amd8111e_set_ext_phy(struct net_device *dev)
 	advert = amd8111e_mdio_read(dev, lp->ext_phy_addr, MII_ADVERTISE);
 	tmp = advert & ~(ADVERTISE_ALL | ADVERTISE_100BASE4);
 	switch (lp->ext_phy_option) {
-
-		default:
-		case SPEED_AUTONEG: /* advertise all values */
-			tmp |= (ADVERTISE_10HALF | ADVERTISE_10FULL |
-				ADVERTISE_100HALF | ADVERTISE_100FULL);
-			break;
-		case SPEED10_HALF:
-			tmp |= ADVERTISE_10HALF;
-			break;
-		case SPEED10_FULL:
-			tmp |= ADVERTISE_10FULL;
-			break;
-		case SPEED100_HALF:
-			tmp |= ADVERTISE_100HALF;
-			break;
-		case SPEED100_FULL:
-			tmp |= ADVERTISE_100FULL;
-			break;
+	default:
+	case SPEED_AUTONEG: /* advertise all values */
+		tmp |= (ADVERTISE_10HALF | ADVERTISE_10FULL |
+			ADVERTISE_100HALF | ADVERTISE_100FULL);
+		break;
+	case SPEED10_HALF:
+		tmp |= ADVERTISE_10HALF;
+		break;
+	case SPEED10_FULL:
+		tmp |= ADVERTISE_10FULL;
+		break;
+	case SPEED100_HALF:
+		tmp |= ADVERTISE_100HALF;
+		break;
+	case SPEED100_FULL:
+		tmp |= ADVERTISE_100FULL;
+		break;
 	}
 
 	if(advert != tmp)
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index e5c6d99957cd..3222c48ce6ae 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -581,15 +581,15 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 
 	/* Get the ethernet address */
 	switch( lp->cardtype ) {
-	  case OLD_RIEBL:
+	case OLD_RIEBL:
 		/* No ethernet address! (Set some default address) */
 		eth_hw_addr_set(dev, OldRieblDefHwaddr);
 		break;
-	  case NEW_RIEBL:
+	case NEW_RIEBL:
 		lp->memcpy_f(addr, RIEBL_HWADDR_ADDR, ETH_ALEN);
 		eth_hw_addr_set(dev, addr);
 		break;
-	  case PAM_CARD:
+	case PAM_CARD:
 		i = IO->eeprom;
 		for( i = 0; i < 6; ++i )
 			addr[i] =
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 684b412c77fd..823a329a921f 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -485,10 +485,10 @@ static int mace_read(mace_private *lp, unsigned int ioaddr, int reg)
   unsigned long flags;
 
   switch (reg >> 4) {
-    case 0: /* register 0-15 */
+  case 0: /* register 0-15 */
       data = inb(ioaddr + AM2150_MACE_BASE + reg);
       break;
-    case 1: /* register 16-31 */
+  case 1: /* register 16-31 */
       spin_lock_irqsave(&lp->bank_lock, flags);
       MACEBANK(1);
       data = inb(ioaddr + AM2150_MACE_BASE + (reg & 0x0F));
@@ -512,10 +512,10 @@ static void mace_write(mace_private *lp, unsigned int ioaddr, int reg,
   unsigned long flags;
 
   switch (reg >> 4) {
-    case 0: /* register 0-15 */
+  case 0: /* register 0-15 */
       outb(data & 0xFF, ioaddr + AM2150_MACE_BASE + reg);
       break;
-    case 1: /* register 16-31 */
+  case 1: /* register 16-31 */
       spin_lock_irqsave(&lp->bank_lock, flags);
       MACEBANK(1);
       outb(data & 0xFF, ioaddr + AM2150_MACE_BASE + (reg & 0x0F));
@@ -567,13 +567,13 @@ static int mace_init(mace_private *lp, unsigned int ioaddr,
    * Or just set ASEL in PHYCC below!
    */
   switch (if_port) {
-    case 1:
+  case 1:
       mace_write(lp, ioaddr, MACE_PLSCC, 0x02);
       break;
-    case 2:
+  case 2:
       mace_write(lp, ioaddr, MACE_PLSCC, 0x00);
       break;
-    default:
+  default:
       mace_write(lp, ioaddr, MACE_PHYCC, /* ASEL */ 4);
       /* ASEL Auto Select.  When set, the PORTSEL[1-0] bits are overridden,
 	 and the MACE device will automatically select the operating media
-- 
2.30.0

