Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0A33886B1
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244195AbhESFiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:38:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4743 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243439AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlM0t6QX8zpfCb;
        Wed, 19 May 2021 13:31:10 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:40 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:39 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>, Armin Wolf <W_Armin@gmx.de>
Subject: [PATCH 19/20] net: 8390: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:52 +0800
Message-ID: <1621402253-27200-20-git-send-email-tanghui20@huawei.com>
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

Cc: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/8390/axnet_cs.c  | 14 +++++++-------
 drivers/net/ethernet/8390/pcnet_cs.c  |  2 +-
 drivers/net/ethernet/8390/smc-ultra.c |  6 +++---
 drivers/net/ethernet/8390/stnic.c     |  2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index 2488bfd..8c321df 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -767,7 +767,7 @@ module_pcmcia_driver(axnet_cs_driver);
   Paul Gortmaker	: tweak ANK's above multicast changes a bit.
   Paul Gortmaker	: update packet statistics for v2.1.x
   Alan Cox		: support arbitrary stupid port mappings on the
-  			  68K Macintosh. Support >16bit I/O spaces
+			  68K Macintosh. Support >16bit I/O spaces
   Paul Gortmaker	: add kmod support for auto-loading of the 8390
 			  module by all drivers that require it.
   Alan Cox		: Spinlocking work, added 'BUG_83C690'
@@ -1091,7 +1091,7 @@ static irqreturn_t ax_interrupt(int irq, void *dev_id)
 	long e8390_base;
 	int interrupts, nr_serviced = 0, i;
 	struct ei_device *ei_local;
-    	int handled = 0;
+	int handled = 0;
 	unsigned long flags;
 
 	e8390_base = dev->base_addr;
@@ -1587,12 +1587,12 @@ static void do_set_multicast_list(struct net_device *dev)
 	}
 	outb_p(E8390_NODMA + E8390_PAGE0, e8390_base + E8390_CMD);
 
-  	if(dev->flags&IFF_PROMISC)
-  		outb_p(E8390_RXCONFIG | 0x58, e8390_base + EN0_RXCR);
+	if(dev->flags&IFF_PROMISC)
+		outb_p(E8390_RXCONFIG | 0x58, e8390_base + EN0_RXCR);
 	else if (dev->flags & IFF_ALLMULTI || !netdev_mc_empty(dev))
-  		outb_p(E8390_RXCONFIG | 0x48, e8390_base + EN0_RXCR);
-  	else
-  		outb_p(E8390_RXCONFIG | 0x40, e8390_base + EN0_RXCR);
+		outb_p(E8390_RXCONFIG | 0x48, e8390_base + EN0_RXCR);
+	else
+		outb_p(E8390_RXCONFIG | 0x40, e8390_base + EN0_RXCR);
 
 	outb_p(E8390_NODMA+E8390_PAGE0+E8390_START, e8390_base+E8390_CMD);
 }
diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
index 9d3b1e0..cac0367 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -1527,7 +1527,7 @@ static const struct pcmcia_device_id pcnet_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("ACCTON", "EN2216-PCMCIA-ETHERNET", 0xdfc6b5b2, 0x5542bfff),
 	PCMCIA_DEVICE_PROD_ID12("Allied Telesis, K.K.", "CentreCOM LA100-PCM-T V2 100/10M LAN PC Card", 0xbb7fbdd7, 0xcd91cc68),
 	PCMCIA_DEVICE_PROD_ID12("Allied Telesis K.K.", "LA100-PCM V2", 0x36634a66, 0xc6d05997),
-  	PCMCIA_DEVICE_PROD_ID12("Allied Telesis, K.K.", "CentreCOM LA-PCM_V2", 0xbb7fBdd7, 0x28e299f8),
+	PCMCIA_DEVICE_PROD_ID12("Allied Telesis, K.K.", "CentreCOM LA-PCM_V2", 0xbb7fBdd7, 0x28e299f8),
 	PCMCIA_DEVICE_PROD_ID12("Allied Telesis K.K.", "LA-PCM V3", 0x36634a66, 0x62241d96),
 	PCMCIA_DEVICE_PROD_ID12("AmbiCom", "AMB8010", 0x5070a7f9, 0x82f96e96),
 	PCMCIA_DEVICE_PROD_ID12("AmbiCom", "AMB8610", 0x5070a7f9, 0x86741224),
diff --git a/drivers/net/ethernet/8390/smc-ultra.c b/drivers/net/ethernet/8390/smc-ultra.c
index 3fe3b4d..1d8ed73 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -347,11 +347,11 @@ static int __init ultra_probe_isapnp(struct net_device *dev)
                                             idev))) {
                         /* Avoid already found cards from previous calls */
                         if (pnp_device_attach(idev) < 0)
-                        	continue;
+				continue;
                         if (pnp_activate_dev(idev) < 0) {
                               __again:
-                        	pnp_device_detach(idev);
-                        	continue;
+				pnp_device_detach(idev);
+				continue;
                         }
 			/* if no io and irq, search for next */
 			if (!pnp_port_valid(idev, 0) || !pnp_irq_valid(idev, 0))
diff --git a/drivers/net/ethernet/8390/stnic.c b/drivers/net/ethernet/8390/stnic.c
index 1f0670c..fbbd7f2 100644
--- a/drivers/net/ethernet/8390/stnic.c
+++ b/drivers/net/ethernet/8390/stnic.c
@@ -114,7 +114,7 @@ static int __init stnic_probe(void)
   /* New style probing API */
   dev = alloc_ei_netdev();
   if (!dev)
-  	return -ENOMEM;
+	return -ENOMEM;
 
 #ifdef CONFIG_SH_STANDARD_BIOS
   sh_bios_get_node_addr (stnic_eadr);
-- 
2.8.1

