Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1383C13E6
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 15:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhGHNMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 09:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhGHNMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 09:12:45 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AE2C061760
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 06:10:03 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id g4so5553564qkl.1
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 06:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization:mime-version
         :content-transfer-encoding;
        bh=0gWa5OAetARENJ/C2A+ypYSxjA1n75Wtbf8cIeVt5lw=;
        b=rVpqeS3ADm4epyS1551pFg7IVyjQMyOeHU0pqBt9vhTHyoEjam9cabNZiCh81qZbYr
         6i8HPNamfdtZN4vthwnXgk7a3MYgo8JrRFbvh9Nw+MHz4nuDMZVNZmxE28WAnDVLCCSS
         ESpUD0dm+ZQ5Zt2GolDEbwGoVJvwxv6jD2UwrEIIEzXyUYuQe+AkaGkCTOqa/E+EjRlp
         DJIEB0RhcW5JdBN/rilZvvakEEzRwl4rV4lejFp1g74/PGf65kpO7lb4aU0rhw/dJ2Yo
         llVDDf9Yo3RdtQYHsTkjCS/vsLWm1KjjTTpgUPnA2fuRtmFgqeRyQ91LksLHI2sUv+CK
         C5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization
         :mime-version:content-transfer-encoding;
        bh=0gWa5OAetARENJ/C2A+ypYSxjA1n75Wtbf8cIeVt5lw=;
        b=T2zOdlYcsynS4Aj0NyWgwzK2sZB0kQGWZFdM/kYP7P9267IfKJTdX/Qz/i1YXxVudh
         hEZar4OQtijL5hSuR/pxb2UV8TibN3LA0ljcUzN9CWj43Nl7A+fjxjBLy/wn8s/YfvSh
         Wbn5Jvk4ZUw5HfkzaqtspweOXJcB93yKYr5Y4y7A4CaX7oOAnyUezCgsB/OPFCq1/20V
         KCDkMSACHvZLFHBdt8f95EKsx3fXjcGwDCjEIP7WUAGUepu0jV1fnGunNA8zkQMj72dO
         bO12UGWp4V5+5E65Lvuu0J8VM8HXbWGe8tO8UGZ7Cj5UaTLA2yPC/zCRFTubJeriP2sM
         2WDw==
X-Gm-Message-State: AOAM5329gwSppHQ9jAzkH513/UdZIiW5dW8E/4wjK00SKvTd1tMpxhKO
        zaOeEhBWasITu4iaYOsC/20Yww==
X-Google-Smtp-Source: ABdhPJxwni2+Rg+Xd/d8J/l4eMGB7XpS0gH0BWTx9TyALUC9kwCBwF6z1zM95wWWL9QVmLb17JemgA==
X-Received: by 2002:a05:620a:1998:: with SMTP id bm24mr18790901qkb.422.1625749802194;
        Thu, 08 Jul 2021 06:10:02 -0700 (PDT)
Received: from iron-maiden.localnet ([50.225.136.98])
        by smtp.gmail.com with ESMTPSA id o126sm951685qka.74.2021.07.08.06.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 06:10:01 -0700 (PDT)
From:   Carlos Bilbao <bilbao@vt.edu>
To:     gregkh@linuxfoundation.org
Cc:     alexander.deucher@amd.com, davem@davemloft.net,
        mchehab+huawei@kernel.org, kuba@kernel.org,
        James.Bottomley@hansenpartnership.com, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: Follow the indentation coding standard on printks
Date:   Thu, 08 Jul 2021 09:10:01 -0400
Message-ID: <2784471.e9J7NaK4W3@iron-maiden>
Organization: Virginia Tech
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix indentation of printks that start at the beginning of the line. Change this 
for the right number of space characters, or tabs if the file uses them. 

Signed-off-by: Carlos Bilbao <bilbao@vt.edu>
---
 drivers/atm/eni.c                      | 2 +-
 drivers/atm/iphase.c                   | 2 +-
 drivers/atm/suni.c                     | 4 ++--
 drivers/atm/zatm.c                     | 8 ++++----
 drivers/net/ethernet/dec/tulip/de4x5.c | 2 +-
 drivers/net/sb1000.c                   | 4 ++--
 drivers/parisc/iosapic.c               | 4 ++--
 drivers/parisc/sba_iommu.c             | 2 +-
 8 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 422753d52244..6d10fd62ba7e 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1456,7 +1456,7 @@ static int start_tx(struct atm_dev *dev)
 
 static void foo(void)
 {
-printk(KERN_INFO
+  printk(KERN_INFO
   "tx_complete=%d,dma_complete=%d,queued=%d,requeued=%d,sub=%d,\n"
   "backlogged=%d,rx_enqueued=%d,rx_dequeued=%d,putting=%d,pushed=%d\n",
   tx_complete,dma_complete,queued,requeued,submitted,backlogged,
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index bc8e8d9f176b..65bb700cd5af 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -1246,7 +1246,7 @@ static void rx_intr(struct atm_dev *dev)
                ((iadev->rx_pkt_cnt - iadev->rx_tmp_cnt) == 0)) {
         for (i = 1; i <= iadev->num_rx_desc; i++)
                free_desc(dev, i);
-printk("Test logic RUN!!!!\n");
+        printk("Test logic RUN!!!!\n");
         writew( ~(RX_FREEQ_EMPT|RX_EXCP_RCVD),iadev->reass_reg+REASS_MASK_REG);
         iadev->rxing = 1;
      }
diff --git a/drivers/atm/suni.c b/drivers/atm/suni.c
index 21e5acc766b8..149605cdb859 100644
--- a/drivers/atm/suni.c
+++ b/drivers/atm/suni.c
@@ -328,8 +328,8 @@ static int suni_start(struct atm_dev *dev)
 		timer_setup(&poll_timer, suni_hz, 0);
 		poll_timer.expires = jiffies+HZ;
 #if 0
-printk(KERN_DEBUG "[u] p=0x%lx,n=0x%lx\n",(unsigned long) poll_timer.list.prev,
-    (unsigned long) poll_timer.list.next);
+	printk(KERN_DEBUG "[u] p=0x%lx,n=0x%lx\n",(unsigned long) poll_timer.list.prev,
+	    (unsigned long) poll_timer.list.next);
 #endif
 		add_timer(&poll_timer);
 	}
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index cf5fffcf98a1..4fb89ed47311 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -380,7 +380,7 @@ static void poll_rx(struct atm_dev *dev,int mbx)
 			pos = zatm_dev->mbx_start[mbx];
 		cells = here[0] & uPD98401_AAL5_SIZE;
 #if 0
-printk("RX IND: 0x%x, 0x%x, 0x%x, 0x%x\n",here[0],here[1],here[2],here[3]);
+		printk("RX IND: 0x%x, 0x%x, 0x%x, 0x%x\n",here[0],here[1],here[2],here[3]);
 {
 unsigned long *x;
 		printk("POOL: 0x%08x, 0x%08x\n",zpeekl(zatm_dev,
@@ -403,14 +403,14 @@ EVENT("error code 0x%x/0x%x\n",(here[3] & uPD98401_AAL5_ES) >>
 		skb = ((struct rx_buffer_head *) bus_to_virt(here[2]))->skb;
 		__net_timestamp(skb);
 #if 0
-printk("[-3..0] 0x%08lx 0x%08lx 0x%08lx 0x%08lx\n",((unsigned *) skb->data)[-3],
+		printk("[-3..0] 0x%08lx 0x%08lx 0x%08lx 0x%08lx\n",((unsigned *) skb->data)[-3],
   ((unsigned *) skb->data)[-2],((unsigned *) skb->data)[-1],
   ((unsigned *) skb->data)[0]);
 #endif
 		EVENT("skb 0x%lx, here 0x%lx\n",(unsigned long) skb,
 		    (unsigned long) here);
 #if 0
-printk("dummy: 0x%08lx, 0x%08lx\n",dummy[0],dummy[1]);
+		printk("dummy: 0x%08lx, 0x%08lx\n",dummy[0],dummy[1]);
 #endif
 		size = error ? 0 : ntohs(((__be16 *) skb->data)[cells*
 		    ATM_CELL_PAYLOAD/sizeof(u16)-3]);
@@ -664,7 +664,7 @@ static int do_tx(struct sk_buff *skb)
 		EVENT("dsc (0x%lx)\n",(unsigned long) dsc,0);
 	}
 	else {
-printk("NONONONOO!!!!\n");
+		printk("NONONONOO!!!!\n");
 		dsc = NULL;
 #if 0
 		u32 *put;
diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index b125d7faefdf..155cfe8800cd 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -3169,7 +3169,7 @@ dc2114x_autoconf(struct net_device *dev)
 
     default:
 	lp->tcount++;
-printk("Huh?: media:%02x\n", lp->media);
+	printk("Huh?: media:%02x\n", lp->media);
 	lp->media = INIT;
 	break;
     }
diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index e88af978f63c..54a7c7613434 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -760,7 +760,7 @@ sb1000_rx(struct net_device *dev)
 
 	insw(ioaddr, (unsigned short*) st, 1);
 #ifdef XXXDEBUG
-printk("cm0: received: %02x %02x\n", st[0], st[1]);
+	printk("cm0: received: %02x %02x\n", st[0], st[1]);
 #endif /* XXXDEBUG */
 	lp->rx_frames++;
 
@@ -805,7 +805,7 @@ printk("cm0: received: %02x %02x\n", st[0], st[1]);
 		/* get data length */
 		insw(ioaddr, buffer, NewDatagramHeaderSize / 2);
 #ifdef XXXDEBUG
-printk("cm0: IP identification: %02x%02x  fragment offset: %02x%02x\n", buffer[30], buffer[31], buffer[32], buffer[33]);
+		printk("cm0: IP identification: %02x%02x  fragment offset: %02x%02x\n", buffer[30], buffer[31], buffer[32], buffer[33]);
 #endif /* XXXDEBUG */
 		if (buffer[0] != NewDatagramHeaderSkip) {
 			if (sb1000_debug > 1)
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 8a3b0c3a1e92..5d27c23e6429 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -633,7 +633,7 @@ static void iosapic_unmask_irq(struct irq_data *d)
 	printk("\n");
 }
 
-printk("iosapic_enable_irq(): sel ");
+	printk("iosapic_enable_irq(): sel ");
 {
 	struct iosapic_info *isp = vi->iosapic;
 
@@ -642,7 +642,7 @@ printk("iosapic_enable_irq(): sel ");
 		printk(" %x", d1);
 	}
 }
-printk("\n");
+	printk("\n");
 #endif
 
 	/*
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index dce4cdf786cd..c3381facdfc5 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1550,7 +1550,7 @@ static void sba_hw_init(struct sba_device *sba_dev)
 
 
 #if 0
-printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\n", PAGE0->mem_boot.hpa,
+	printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\n", PAGE0->mem_boot.hpa,
 	PAGE0->mem_boot.spa, PAGE0->mem_boot.pad, PAGE0->mem_boot.cl_class);
 
 	/*
-- 
2.25.1



