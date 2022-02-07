Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B36D4AB5C4
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 08:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbiBGHWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 02:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240762AbiBGHQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 02:16:20 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E825C043181;
        Sun,  6 Feb 2022 23:16:17 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so4549068pja.3;
        Sun, 06 Feb 2022 23:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=T1w/kZgCp1e0ajgay5Wpv8mFKvw/7HJMGNopTZCPmrY=;
        b=HzSWDdZOmuNXG9IpIICJMQh28W2wlWrs5hFuTNcAMepOeLwUCAHeFZ8yUaKPHWhRtz
         /Ba/kqhdw8UoCwFUe/vSu5K9LdH9RKW+uXozW7+piQT1BEVPJZL1JQUIEG89FsD3iAX3
         ef23wwwx+R2yROpjKKKK0zzbT3QGsPxleX8HX11MmjSh9oyxMPzXdXR5JAPTJJhxmfjb
         +F25eO7fPFP/wcpep/QQZUozUDaIQAraRXgrXUSjYDFXae4SGT6H4pbk8FGsk+BswxqB
         rw/HPra/g2pLsoQnuhxC3hJF0FW0rPLiqlfeFwRn1k2wQQFQ7HkFceauSKDQwyzy8eK/
         23uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T1w/kZgCp1e0ajgay5Wpv8mFKvw/7HJMGNopTZCPmrY=;
        b=Ydlaurz3ON6oPLIIx10WC0Ul8cDZzcgcLPcCTpN8wY46rbwYstXtEOoLJPGehJMd0c
         mLmHGrQUrWeVvKzp23P1VUiBFU4Tuh2PbZuhm/AUuAQtLC/EGlzcj1Hq76I/XZhjJr8H
         kOw8jFFPixy8833rLEkoaCv9oL0i+Yxu18OnTaBUbDfUyq4KMH+KF+k8DPpziMU4or75
         fxDutzoiTCa+BcH22en0P/c7uxnZyTV4MaPu0HWL7mStUc6fkRFv+jZKfms/yLBC9OsR
         gS+HZ9w1pnHrAd+xYufvm7nkI7LR1kPJ77GpuUxCBg8KbSmntsOgwplSqr4r45DUMdAr
         1RsQ==
X-Gm-Message-State: AOAM533GVj1cOWRdiO0VuGNAnv8JWMV9CBhXAgVGzNo3jzeN/XRNkLKm
        +axZTRLRrL6LGXwdZWe6R9E=
X-Google-Smtp-Source: ABdhPJxITyPsR36dig0tGvi3zMwhWj/bzkOU0HzXYnnmOQfvSjoXuzWjMFBkPECR5+xF7EVUn+qi8Q==
X-Received: by 2002:a17:903:41c8:: with SMTP id u8mr15015673ple.81.1644218176898;
        Sun, 06 Feb 2022 23:16:16 -0800 (PST)
Received: from localhost.localdomain ([103.37.201.178])
        by smtp.gmail.com with ESMTPSA id e12sm10479974pfl.8.2022.02.06.23.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 23:16:16 -0800 (PST)
From:   Ayan Choudhary <ayanchoudhary1025@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org
Cc:     Ayan Choudhary <ayanchoudhary1025@gmail.com>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: Fix checkpatch errors in the module
Date:   Sun,  6 Feb 2022 23:15:00 -0800
Message-Id: <20220207071500.2679-1-ayanchoudhary1025@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qlge module had many checkpatch errors, this patch fixes most of them.
The errors which presently remain are either false positives or
introduce unncessary comments in the code.

Signed-off-by: Ayan Choudhary <ayanchoudhary1025@gmail.com>
---
 drivers/staging/qlge/Kconfig     |  8 +++++---
 drivers/staging/qlge/TODO        |  1 -
 drivers/staging/qlge/qlge.h      | 24 ++++++++++++------------
 drivers/staging/qlge/qlge_main.c | 12 +++++++++---
 drivers/staging/qlge/qlge_mpi.c  | 11 +++++------
 5 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
index 6d831ed67965..21fd3f6e33d6 100644
--- a/drivers/staging/qlge/Kconfig
+++ b/drivers/staging/qlge/Kconfig
@@ -5,7 +5,9 @@ config QLGE
 	depends on ETHERNET && PCI
 	select NET_DEVLINK
 	help
-	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
+		This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
 
-	To compile this driver as a module, choose M here. The module will be
-	called qlge.
+		Say Y here to enable support for QLogic ISP8XXX 10Gb Ethernet cards.
+
+		To compile this driver as a module, choose M here. The module will be
+		called qlge.
diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index c76394b9451b..3b57a36d867c 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -30,4 +30,3 @@
 * fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
   qlge_set_multicast_list()).
 * fix weird indentation (all over, ex. the for loops in qlge_get_stats())
-* fix checkpatch issues
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 55e0ad759250..7de71bcdb928 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -45,9 +45,8 @@
 /* Calculate the number of (4k) pages required to
  * contain a buffer queue of the given length.
  */
-#define MAX_DB_PAGES_PER_BQ(x) \
-		(((x * sizeof(u64)) / DB_PAGE_SIZE) + \
-		(((x * sizeof(u64)) % DB_PAGE_SIZE) ? 1 : 0))
+#define MAX_DB_PAGES_PER_BQ(x) ((((x) * sizeof(u64)) / DB_PAGE_SIZE) + \
+		((((x) * sizeof(u64)) % DB_PAGE_SIZE) ? 1 : 0))
 
 #define RX_RING_SHADOW_SPACE	(sizeof(u64) + \
 		MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN) * sizeof(u64) + \
@@ -1273,7 +1272,7 @@ struct qlge_net_req_iocb {
  */
 struct wqicb {
 	__le16 len;
-#define Q_LEN_V		(1 << 4)
+#define Q_LEN_V		BIT(4)
 #define Q_LEN_CPP_CONT	0x0000
 #define Q_LEN_CPP_16	0x0001
 #define Q_LEN_CPP_32	0x0002
@@ -1308,7 +1307,7 @@ struct cqicb {
 #define FLAGS_LI	0x40
 #define FLAGS_LC	0x80
 	__le16 len;
-#define LEN_V		(1 << 4)
+#define LEN_V		BIT(4)
 #define LEN_CPP_CONT	0x0000
 #define LEN_CPP_32	0x0001
 #define LEN_CPP_64	0x0002
@@ -1365,7 +1364,7 @@ struct tx_ring_desc {
 	struct tx_ring_desc *next;
 };
 
-#define QL_TXQ_IDX(qdev, skb) (smp_processor_id() % (qdev->tx_ring_count))
+#define QL_TXQ_IDX(qdev, skb) (smp_processor_id() % ((qdev)->tx_ring_count))
 
 struct tx_ring {
 	/*
@@ -2030,9 +2029,9 @@ enum {
 	STS_PAUSE_STD = 0x00000040,
 	STS_PAUSE_PRI = 0x00000080,
 	STS_SPEED_MASK = 0x00000038,
-	STS_SPEED_100Mb = 0x00000000,
-	STS_SPEED_1Gb = 0x00000008,
-	STS_SPEED_10Gb = 0x00000010,
+	STS_SPEED_100MB = 0x00000000,
+	STS_SPEED_1GB = 0x00000008,
+	STS_SPEED_10GB = 0x00000010,
 	STS_LINK_TYPE_MASK = 0x00000007,
 	STS_LINK_TYPE_XFI = 0x00000001,
 	STS_LINK_TYPE_XAUI = 0x00000002,
@@ -2072,6 +2071,7 @@ struct qlge_adapter *netdev_to_qdev(struct net_device *ndev)
 
 	return ndev_priv->qdev;
 }
+
 /*
  * The main Adapter structure definition.
  * This structure has all fields relevant to the hardware.
@@ -2097,8 +2097,8 @@ struct qlge_adapter {
 	u32 alt_func;		/* PCI function for alternate adapter */
 	u32 port;		/* Port number this adapter */
 
-	spinlock_t adapter_lock;
-	spinlock_t stats_lock;
+	spinlock_t adapter_lock; /* Spinlock for adapter */
+	spinlock_t stats_lock; /* Spinlock for stats */
 
 	/* PCI Bus Relative Register Addresses */
 	void __iomem *reg_base;
@@ -2116,7 +2116,7 @@ struct qlge_adapter {
 	u32 mailbox_in;
 	u32 mailbox_out;
 	struct mbox_params idc_mbc;
-	struct mutex	mpi_mutex;
+	struct mutex	mpi_mutex; /* Mutex for mpi */
 
 	int tx_ring_size;
 	int rx_ring_size;
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 9873bb2a9ee4..6e4639237334 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3890,7 +3890,7 @@ static int qlge_close(struct net_device *ndev)
 	 * (Rarely happens, but possible.)
 	 */
 	while (!test_bit(QL_ADAPTER_UP, &qdev->flags))
-		msleep(1);
+		usleep_range(100, 1000);
 
 	/* Make sure refill_work doesn't re-enable napi */
 	for (i = 0; i < qdev->rss_ring_count; i++)
@@ -4085,7 +4085,11 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	int i;
 
 	/* Get RX stats. */
-	pkts = mcast = dropped = errors = bytes = 0;
+	pkts = 0;
+	mcast = 0;
+	dropped = 0;
+	errors = 0;
+	bytes = 0;
 	for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
 		pkts += rx_ring->rx_packets;
 		bytes += rx_ring->rx_bytes;
@@ -4100,7 +4104,9 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	ndev->stats.multicast = mcast;
 
 	/* Get TX stats. */
-	pkts = errors = bytes = 0;
+	pkts = 0;
+	errors = 0;
+	bytes = 0;
 	for (i = 0; i < qdev->tx_ring_count; i++, tx_ring++) {
 		pkts += tx_ring->tx_packets;
 		bytes += tx_ring->tx_bytes;
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 96a4de6d2b34..6020e337fc0d 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -935,13 +935,12 @@ static int qlge_idc_wait(struct qlge_adapter *qdev)
 			netif_err(qdev, drv, qdev->ndev, "IDC Success.\n");
 			status = 0;
 			break;
-		} else {
-			netif_err(qdev, drv, qdev->ndev,
-				  "IDC: Invalid State 0x%.04x.\n",
-				  mbcp->mbox_out[0]);
-			status = -EIO;
-			break;
 		}
+		netif_err(qdev, drv, qdev->ndev,
+			  "IDC: Invalid State 0x%.04x.\n",
+			  mbcp->mbox_out[0]);
+		status = -EIO;
+		break;
 	}
 
 	return status;
-- 
2.17.1

