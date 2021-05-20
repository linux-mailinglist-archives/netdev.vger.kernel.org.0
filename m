Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA73389C14
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 05:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhETDw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 23:52:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3598 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhETDwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 23:52:20 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Flwfl5K9tzQp5K;
        Thu, 20 May 2021 11:47:27 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:58 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH net-next 7/9] net: appletalk: remove leading spaces before tabs
Date:   Thu, 20 May 2021 11:47:52 +0800
Message-ID: <1621482474-26903-8-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
References: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/appletalk/cops.c | 30 +++++++++++++++---------------
 drivers/net/appletalk/ltpc.c |  6 +++---
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index ba8e70a..992e92f 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -609,12 +609,12 @@ static int cops_nodeid (struct net_device *dev, int nodeid)
 
 	if(lp->board == DAYNA)
         {
-        	/* Empty any pending adapter responses. */
+		/* Empty any pending adapter responses. */
                 while((inb(ioaddr+DAYNA_CARD_STATUS)&DAYNA_TX_READY)==0)
                 {
 			outb(0, ioaddr+COPS_CLEAR_INT);	/* Clear interrupts. */
-        		if((inb(ioaddr+DAYNA_CARD_STATUS)&0x03)==DAYNA_RX_REQUEST)
-                		cops_rx(dev);	/* Kick any packets waiting. */
+			if((inb(ioaddr+DAYNA_CARD_STATUS)&0x03)==DAYNA_RX_REQUEST)
+				cops_rx(dev);	/* Kick any packets waiting. */
 			schedule();
                 }
 
@@ -630,13 +630,13 @@ static int cops_nodeid (struct net_device *dev, int nodeid)
                 while(inb(ioaddr+TANG_CARD_STATUS)&TANG_RX_READY)
                 {
 			outb(0, ioaddr+COPS_CLEAR_INT);	/* Clear interrupt. */
-                	cops_rx(dev);          	/* Kick out packets waiting. */
+			cops_rx(dev);          	/* Kick out packets waiting. */
 			schedule();
                 }
 
 		/* Not sure what Tangent does if nodeid picked is used. */
                 if(nodeid == 0)	         		/* Seed. */
-                	nodeid = jiffies&0xFF;		/* Get a random try */
+			nodeid = jiffies&0xFF;		/* Get a random try */
                 outb(2, ioaddr);        		/* Command length LSB */
                 outb(0, ioaddr);       			/* Command length MSB */
                 outb(LAP_INIT, ioaddr); 		/* Send LAP_INIT byte */
@@ -651,13 +651,13 @@ static int cops_nodeid (struct net_device *dev, int nodeid)
 
 		if(lp->board == DAYNA)
 		{
-                	if((inb(ioaddr+DAYNA_CARD_STATUS)&0x03)==DAYNA_RX_REQUEST)
-                		cops_rx(dev);	/* Grab the nodeid put in lp->node_acquire. */
+			if((inb(ioaddr+DAYNA_CARD_STATUS)&0x03)==DAYNA_RX_REQUEST)
+				cops_rx(dev);	/* Grab the nodeid put in lp->node_acquire. */
 		}
 		if(lp->board == TANGENT)
 		{	
 			if(inb(ioaddr+TANG_CARD_STATUS)&TANG_RX_READY)
-                                cops_rx(dev);   /* Grab the nodeid put in lp->node_acquire. */
+				cops_rx(dev);   /* Grab the nodeid put in lp->node_acquire. */
 		}
 		schedule();
 	}
@@ -719,16 +719,16 @@ static irqreturn_t cops_interrupt(int irq, void *dev_id)
 	{
 		do {
 			outb(0, ioaddr + COPS_CLEAR_INT);
-                       	status=inb(ioaddr+DAYNA_CARD_STATUS);
-                       	if((status&0x03)==DAYNA_RX_REQUEST)
-                       	        cops_rx(dev);
-                	netif_wake_queue(dev);
+			status=inb(ioaddr+DAYNA_CARD_STATUS);
+			if((status&0x03)==DAYNA_RX_REQUEST)
+				cops_rx(dev);
+			netif_wake_queue(dev);
 		} while(++boguscount < 20);
 	}
 	else
 	{
 		do {
-                       	status=inb(ioaddr+TANG_CARD_STATUS);
+			status=inb(ioaddr+TANG_CARD_STATUS);
 			if(status & TANG_RX_READY)
 				cops_rx(dev);
 			if(status & TANG_TX_READY)
@@ -855,7 +855,7 @@ static void cops_timeout(struct net_device *dev, unsigned int txqueue)
         if(lp->board==TANGENT)
         {
 		if((inb(ioaddr+TANG_CARD_STATUS)&TANG_TX_READY)==0)
-               		printk(KERN_WARNING "%s: No TX complete interrupt.\n", dev->name);
+			printk(KERN_WARNING "%s: No TX complete interrupt.\n", dev->name);
 	}
 	printk(KERN_WARNING "%s: Transmit timed out.\n", dev->name);
 	cops_jumpstart(dev);	/* Restart the card. */
@@ -897,7 +897,7 @@ static netdev_tx_t cops_send_packet(struct sk_buff *skb,
 	outb(LAP_WRITE, ioaddr);
 
 	if(lp->board == DAYNA)	/* Check the transmit buffer again. */
-        	while((inb(ioaddr+DAYNA_CARD_STATUS)&DAYNA_TX_READY)==0);
+		while((inb(ioaddr+DAYNA_CARD_STATUS)&DAYNA_TX_READY)==0);
 
 	outsb(ioaddr, skb->data, skb->len);	/* Send out the data. */
 
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index c6f73aa..f0e715a 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -935,10 +935,10 @@ static netdev_tx_t ltpc_xmit(struct sk_buff *skb, struct net_device *dev)
 static int __init ltpc_probe_dma(int base, int dma)
 {
 	int want = (dma == 3) ? 2 : (dma == 1) ? 1 : 3;
-  	unsigned long timeout;
-  	unsigned long f;
+	unsigned long timeout;
+	unsigned long f;
   
-  	if (want & 1) {
+	if (want & 1) {
 		if (request_dma(1,"ltpc")) {
 			want &= ~1;
 		} else {
-- 
2.8.1

