Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E374311924
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhBFC4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhBFCsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:48:13 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55531C08EE0D;
        Fri,  5 Feb 2021 16:02:04 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id g15so4715442pjd.2;
        Fri, 05 Feb 2021 16:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PJ80fdCmMT1P+VtLli/flQCRhOFHUdkBaPCQbxwDFDo=;
        b=dkkiAv7hMRAPn4kEu+JEf+Lw07Tf9980wubmaJRo9gtc9VFexITWtoNLnzKBStbcuc
         aisPupH+L+uD01/2c/F9PvsYfWxSMWV2RgZxXNOljUqDZp+Toga4/mIyj5WR4orhSqlI
         FbglJdc01BS9jm5w25Yj4/AiMaXutDVFJ0w07uUUZmQHp9WCkcZqtSMkE8mumnqL84fx
         e/EYQca+40snE94lo7jPQgTw5wZ/qq+iyRUSwryPaEfeWKFcBJXzr/pU3QMlEaiLUDv8
         sjWWqgFYYJEFBwF4SLCAq3khDbu4QIoq8KDS1aGg7ymJDZnWcn631lL8IdknwkRBssOJ
         Y8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PJ80fdCmMT1P+VtLli/flQCRhOFHUdkBaPCQbxwDFDo=;
        b=pL5Zqc/FaiQ1wzAH9NWh4tjR6aPAOr5arZaCJq3+47df92uUfyhXElgYQAbGla1TYT
         cttnucvkK0ewmSRq20FTUbHryCdozzEP2mXe2gNYwHCtwUztE3w0+73LIysoLpf418+R
         M0IPBLWgiULmXiK32NIbkAU+cESJzVXtUU34fXHiqcuwdz7PuSuY7vDBTLy8+yqR/eYl
         W0mlAIVJ04hO0BZ2piqeTSTFevPloWsozvivKW5O4J685ZCQtd+7XeC+XTAuYCVLvqax
         UDQWz8su14oq2u/WFoZpAINhxJVBJhZsiYHaDYc+0LFdUgRITspa+LoyDFqcMRjPd/ZC
         OrQQ==
X-Gm-Message-State: AOAM533BttKUoIJwuTnK00Ks3V6COGz4YaqEyRwwAircTHrZoKAIq7e/
        aWAjJKnsrcs4fg5Uw4YoJGk=
X-Google-Smtp-Source: ABdhPJy8ggxnqj2M5F8JVZt/c+cLGug/20JzzZV4sOKHu50suMZ+RNHuKSb8MI+XorEOM3cWd54zRg==
X-Received: by 2002:a17:90a:4a84:: with SMTP id f4mr6525939pjh.231.1612569723784;
        Fri, 05 Feb 2021 16:02:03 -0800 (PST)
Received: from amypc-samantha.home ([47.145.126.51])
        by smtp.gmail.com with ESMTPSA id r189sm11771724pgr.10.2021.02.05.16.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 16:02:03 -0800 (PST)
From:   Amy Parker <enbyamy@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, akpm@linux-foundation.org,
        rppt@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amy Parker <enbyamy@gmail.com>
Subject: [PATCH 1/3] drivers/net/ethernet/amd: Correct spacing around C keywords
Date:   Fri,  5 Feb 2021 16:01:44 -0800
Message-Id: <20210206000146.616465-2-enbyamy@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206000146.616465-1-enbyamy@gmail.com>
References: <20210206000146.616465-1-enbyamy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many C keywords and their statements are not formatted correctly
per the kernel style guide. Their spacing makes them harder to read
and to maintain. This patch updates their spacing to follow the
style guide.

Signed-off-by: Amy Parker <enbyamy@gmail.com>
---
 drivers/net/ethernet/amd/atarilance.c | 36 +++++++++++++--------------
 drivers/net/ethernet/amd/sun3lance.c  | 30 +++++++++++-----------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 961796abab35..141244c5ca4e 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -88,7 +88,7 @@ MODULE_LICENSE("GPL");
 	do {										\
 		if (lance_debug >= n)					\
 			printk a;							\
-	} while( 0 )
+	} while (0)
 
 #ifdef LANCE_DEBUG_PROBE
 # define PROBE_PRINT(a)	printk a
@@ -359,7 +359,7 @@ static void *slow_memcpy( void *dst, const void *src, size_t len )
 {	char *cto = dst;
 	const char *cfrom = src;
 
-	while( len-- ) {
+	while (len--) {
 		*cto++ = *cfrom++;
 		MFPDELAY();
 	}
@@ -387,7 +387,7 @@ struct net_device * __init atarilance_probe(int unit)
 		netdev_boot_setup_check(dev);
 	}
 
-	for( i = 0; i < N_LANCE_ADDR; ++i ) {
+	for (i = 0; i < N_LANCE_ADDR; ++i) {
 		if (lance_probe1( dev, &lance_addr_list[i] )) {
 			found = 1;
 			err = register_netdev(dev);
@@ -583,7 +583,7 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 		   init_rec->slow_flag ? " (slow memcpy)" : "" );
 
 	/* Get the ethernet address */
-	switch( lp->cardtype ) {
+	switch (lp->cardtype) {
 	  case OLD_RIEBL:
 		/* No ethernet address! (Set some default address) */
 		memcpy(dev->dev_addr, OldRieblDefHwaddr, ETH_ALEN);
@@ -593,7 +593,7 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 		break;
 	  case PAM_CARD:
 		i = IO->eeprom;
-		for( i = 0; i < 6; ++i )
+		for (i = 0; i < 6; ++i)
 			dev->dev_addr[i] =
 				((((unsigned short *)MEM)[i*2] & 0x0f) << 4) |
 				((((unsigned short *)MEM)[i*2+1] & 0x0f));
@@ -610,7 +610,7 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 	spin_lock_init(&lp->devlock);
 
 	MEM->init.mode = 0x0000;		/* Disable Rx and Tx. */
-	for( i = 0; i < 6; i++ )
+	for (i = 0; i < 6; i++)
 		MEM->init.hwaddr[i] = dev->dev_addr[i^1]; /* <- 16 bit swap! */
 	MEM->init.filter[0] = 0x00000000;
 	MEM->init.filter[1] = 0x00000000;
@@ -700,9 +700,9 @@ static void lance_init_ring( struct net_device *dev )
 										 : (o) < RIEBL_RSVD_END)			 \
 				(o) = RIEBL_RSVD_END;										 \
 		}																	 \
-	} while(0)
+	} while (0)
 
-	for( i = 0; i < TX_RING_SIZE; i++ ) {
+	for (i = 0; i < TX_RING_SIZE; i++) {
 		CHECK_OFFSET(offset);
 		MEM->tx_head[i].base = offset;
 		MEM->tx_head[i].flag = TMD1_OWN_HOST;
@@ -712,7 +712,7 @@ static void lance_init_ring( struct net_device *dev )
 		offset += PKT_BUF_SZ;
 	}
 
-	for( i = 0; i < RX_RING_SIZE; i++ ) {
+	for (i = 0; i < RX_RING_SIZE; i++) {
 		CHECK_OFFSET(offset);
 		MEM->rx_head[i].base = offset;
 		MEM->rx_head[i].flag = TMD1_OWN_CHIP;
@@ -748,12 +748,12 @@ static void lance_tx_timeout (struct net_device *dev, unsigned int txqueue)
 						  lp->dirty_tx, lp->cur_tx,
 						  lp->tx_full ? " (full)" : "",
 						  lp->cur_rx ));
-			for( i = 0 ; i < RX_RING_SIZE; i++ )
+			for (i = 0 ; i < RX_RING_SIZE; i++)
 				DPRINTK( 2, ( "rx #%d: base=%04x blen=%04x mlen=%04x\n",
 							  i, MEM->rx_head[i].base,
 							  -MEM->rx_head[i].buf_length,
 							  MEM->rx_head[i].msg_length ));
-			for( i = 0 ; i < TX_RING_SIZE; i++ )
+			for (i = 0 ; i < TX_RING_SIZE; i++)
 				DPRINTK( 2, ( "tx #%d: base=%04x len=%04x misc=%04x\n",
 							  i, MEM->tx_head[i].base,
 							  -MEM->tx_head[i].length,
@@ -827,7 +827,7 @@ lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev->stats.tx_bytes += skb->len;
 	dev_kfree_skb( skb );
 	lp->cur_tx++;
-	while( lp->cur_tx >= TX_RING_SIZE && lp->dirty_tx >= TX_RING_SIZE ) {
+	while (lp->cur_tx >= TX_RING_SIZE && lp->dirty_tx >= TX_RING_SIZE) {
 		lp->cur_tx -= TX_RING_SIZE;
 		lp->dirty_tx -= TX_RING_SIZE;
 	}
@@ -866,7 +866,7 @@ static irqreturn_t lance_interrupt( int irq, void *dev_id )
 
 	AREG = CSR0;
 
-	while( ((csr0 = DREG) & (CSR0_ERR | CSR0_TINT | CSR0_RINT)) &&
+	while (((csr0 = DREG) & (CSR0_ERR | CSR0_TINT | CSR0_RINT)) &&
 		   --boguscnt >= 0) {
 		handled = 1;
 		/* Acknowledge all of the current interrupt sources ASAP. */
@@ -882,7 +882,7 @@ static irqreturn_t lance_interrupt( int irq, void *dev_id )
 		if (csr0 & CSR0_TINT) {			/* Tx-done interrupt */
 			int dirty_tx = lp->dirty_tx;
 
-			while( dirty_tx < lp->cur_tx) {
+			while (dirty_tx < lp->cur_tx) {
 				int entry = dirty_tx & TX_RING_MOD_MASK;
 				int status = MEM->tx_head[entry].flag;
 
@@ -969,7 +969,7 @@ static int lance_rx( struct net_device *dev )
 				  MEM->rx_head[entry].flag ));
 
 	/* If we own the next entry, it's a new packet. Send it up. */
-	while( (MEM->rx_head[entry].flag & RMD1_OWN) == RMD1_OWN_HOST ) {
+	while ((MEM->rx_head[entry].flag & RMD1_OWN) == RMD1_OWN_HOST) {
 		struct lance_rx_head *head = &(MEM->rx_head[entry]);
 		int status = head->flag;
 
@@ -997,7 +997,7 @@ static int lance_rx( struct net_device *dev )
 			else {
 				skb = netdev_alloc_skb(dev, pkt_len + 2);
 				if (skb == NULL) {
-					for( i = 0; i < RX_RING_SIZE; i++ )
+					for (i = 0; i < RX_RING_SIZE; i++)
 						if (MEM->rx_head[(entry+i) & RX_RING_MOD_MASK].flag &
 							RMD1_OWN_CHIP)
 							break;
@@ -1093,7 +1093,7 @@ static void set_multicast_list( struct net_device *dev )
 		 * filtering. */
 		memset( multicast_table, (num_addrs == 0) ? 0 : -1,
 				sizeof(multicast_table) );
-		for( i = 0; i < 4; i++ )
+		for (i = 0; i < 4; i++)
 			REGA( CSR8+i ) = multicast_table[i];
 		REGA( CSR15 ) = 0; /* Unset promiscuous mode */
 	}
@@ -1128,7 +1128,7 @@ static int lance_set_mac_address( struct net_device *dev, void *addr )
 	}
 
 	memcpy( dev->dev_addr, saddr->sa_data, dev->addr_len );
-	for( i = 0; i < 6; i++ )
+	for (i = 0; i < 6; i++)
 		MEM->init.hwaddr[i] = dev->dev_addr[i^1]; /* <- 16 bit swap! */
 	lp->memcpy_f( RIEBL_HWADDR_ADDR, dev->dev_addr, 6 );
 	/* set also the magic for future sessions */
diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index 00ae1081254d..ca7b6e483d2a 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -80,7 +80,7 @@ MODULE_LICENSE("GPL");
 	do {  \
 		if (lance_debug >= n)  \
 			printk a; \
-	} while( 0 )
+	} while (0)
 
 
 /* we're only using 32k of memory, so we use 4 TX
@@ -332,7 +332,7 @@ static int __init lance_probe( struct net_device *dev)
 	ioaddr_probe[1] = CSR0;
 	ioaddr_probe[0] = CSR0_INIT | CSR0_STOP;
 
-	if(ioaddr_probe[0] != CSR0_STOP) {
+	if (ioaddr_probe[0] != CSR0_STOP) {
 		ioaddr_probe[0] = tmp1;
 		ioaddr_probe[1] = tmp2;
 
@@ -377,7 +377,7 @@ static int __init lance_probe( struct net_device *dev)
 		   dev->irq);
 
 	/* copy in the ethernet address from the prom */
-	for(i = 0; i < 6 ; i++)
+	for (i = 0; i < 6 ; i++)
 	     dev->dev_addr[i] = idprom->id_ethaddr[i];
 
 	/* tell the card it's ether address, bytes swapped */
@@ -462,7 +462,7 @@ static void lance_init_ring( struct net_device *dev )
 	lp->new_rx = lp->new_tx = 0;
 	lp->old_rx = lp->old_tx = 0;
 
-	for( i = 0; i < TX_RING_SIZE; i++ ) {
+	for (i = 0; i < TX_RING_SIZE; i++) {
 		MEM->tx_head[i].base = dvma_vtob(MEM->tx_data[i]);
 		MEM->tx_head[i].flag = 0;
  		MEM->tx_head[i].base_hi =
@@ -471,7 +471,7 @@ static void lance_init_ring( struct net_device *dev )
 		MEM->tx_head[i].misc = 0;
 	}
 
-	for( i = 0; i < RX_RING_SIZE; i++ ) {
+	for (i = 0; i < RX_RING_SIZE; i++) {
 		MEM->rx_head[i].base = dvma_vtob(MEM->rx_data[i]);
 		MEM->rx_head[i].flag = RMD1_OWN_CHIP;
 		MEM->rx_head[i].base_hi =
@@ -539,18 +539,18 @@ lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		REGA(CSR3) = CSR3_BSWP;
 		dev->stats.tx_errors++;
 
-		if(lance_debug >= 2) {
+		if (lance_debug >= 2) {
 			int i;
 			printk("Ring data: old_tx %d new_tx %d%s new_rx %d\n",
 			       lp->old_tx, lp->new_tx,
 			       lp->tx_full ? " (full)" : "",
 			       lp->new_rx );
-			for( i = 0 ; i < RX_RING_SIZE; i++ )
+			for (i = 0 ; i < RX_RING_SIZE; i++)
 				printk( "rx #%d: base=%04x blen=%04x mlen=%04x\n",
 					i, MEM->rx_head[i].base,
 					-MEM->rx_head[i].buf_length,
 					MEM->rx_head[i].msg_length);
-			for( i = 0 ; i < TX_RING_SIZE; i++ )
+			for (i = 0 ; i < TX_RING_SIZE; i++)
 				printk("tx #%d: base=%04x len=%04x misc=%04x\n",
 				       i, MEM->tx_head[i].base,
 				       -MEM->tx_head[i].length,
@@ -586,7 +586,7 @@ lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 #ifdef CONFIG_SUN3X
 	/* this weirdness doesn't appear on sun3... */
-	if(!(DREG & CSR0_INIT)) {
+	if (!(DREG & CSR0_INIT)) {
 		DPRINTK( 1, ("INIT not set, reinitializing...\n"));
 		REGA( CSR0 ) = CSR0_STOP;
 		lance_init_ring(dev);
@@ -668,7 +668,7 @@ static irqreturn_t lance_interrupt( int irq, void *dev_id)
 	DREG = csr0 & (CSR0_TINT | CSR0_RINT | CSR0_IDON);
 
 	/* clear errors */
-	if(csr0 & CSR0_ERR)
+	if (csr0 & CSR0_ERR)
 		DREG = CSR0_BABL | CSR0_MERR | CSR0_CERR | CSR0_MISS;
 
 
@@ -688,7 +688,7 @@ static irqreturn_t lance_interrupt( int irq, void *dev_id)
 //				       MEM->tx_head[i].flag);
 //		}
 
-		while( old_tx != lp->new_tx) {
+		while (old_tx != lp->new_tx) {
 			struct lance_tx_head *head = &(MEM->tx_head[old_tx]);
 
 			DPRINTK(3, ("on tx_ring %d\n", old_tx));
@@ -712,10 +712,10 @@ static irqreturn_t lance_interrupt( int irq, void *dev_id)
 					REGA(CSR0) = CSR0_STRT | CSR0_INEA;
 					return IRQ_HANDLED;
 				}
-			} else if(head->flag & (TMD1_ENP | TMD1_STP)) {
+			} else if (head->flag & (TMD1_ENP | TMD1_STP)) {
 
 				head->flag &= ~(TMD1_ENP | TMD1_STP);
-				if(head->flag & (TMD1_ONE | TMD1_MORE))
+				if (head->flag & (TMD1_ONE | TMD1_MORE))
 					dev->stats.collisions++;
 
 				dev->stats.tx_packets++;
@@ -889,7 +889,7 @@ static void set_multicast_list( struct net_device *dev )
 {
 	struct lance_private *lp = netdev_priv(dev);
 
-	if(netif_queue_stopped(dev))
+	if (netif_queue_stopped(dev))
 		/* Only possible if board is already started */
 		return;
 
@@ -908,7 +908,7 @@ static void set_multicast_list( struct net_device *dev )
 		 * filtering. */
 		memset( multicast_table, (num_addrs == 0) ? 0 : -1,
 				sizeof(multicast_table) );
-		for( i = 0; i < 4; i++ )
+		for (i = 0; i < 4; i++)
 			REGA( CSR8+i ) = multicast_table[i];
 		REGA( CSR15 ) = 0; /* Unset promiscuous mode */
 	}
-- 
2.29.2

