Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A6B1AFA52
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 14:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgDSM6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 08:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgDSM6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 08:58:25 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA15C061A0C;
        Sun, 19 Apr 2020 05:58:24 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j1so3180903wrt.1;
        Sun, 19 Apr 2020 05:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rHT9Pl48uHcOEaMkHi0B8U1hGuWxpSdVrpJzMEcgxps=;
        b=MkE3jHcmISuA7dtz1w/s79H0tvgc3dV1G9XCaTyN8q8inP9AcB5ibeuLoktLPwZUuE
         IiLrGroFU5kTYVGyVA9hou65gsJ0cf19ThsnU7/JxndfXQxLen8ZzjliFD79qG8SAEZE
         nrKGZ3SYxzCRTwyGKpbWyHhUT5uIlN/C1LXcaHy4yqQ36NHioaL5H2P0O+u2cDUDNL22
         GZHqRma0GrUGxTrKz6380PSHjZof4Yc/H9nUtgdep13fdnqe3gG4NlQ8CYZiGcbOlJUG
         +Wi5Ku1cxEGXNpr3v4KXmFHZ0HzYQUxvYU2FgszS/a+6B3MiTtttrcsuzpeOAWkIKIpR
         VioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rHT9Pl48uHcOEaMkHi0B8U1hGuWxpSdVrpJzMEcgxps=;
        b=jZpc9Gkjm9hBB82x3yEiGqL+liTFDDVlbvtRtPqiaW3bJ4MX6X8u4a1WY0oZYDsxkz
         l2w3/zTmFAzHU4sx8hLfjeY4Om3d/9gcPapEqZpe3bUXbMIjI0tcGoSvVW5kDajqx1j+
         XWS36BzCyIRSfQHIaEPUF84Wo1VUJlcdENUME4YOw5R3pQmUqWkjJlhqhU9e7OOH8yxP
         1RgYMllsg6mDZVBfwi2tVR2c5R3+8v53K1djjOXZ2ViI7W1zbtud+4kl8xlXp3slt9Nv
         JssEIagx5JXcOsrzGegvBjepzzVO7yHtbFFxyNXlYA87kJAdcHyIvQSWgco/H09AoZ7I
         wPMw==
X-Gm-Message-State: AGi0PuYIQQLohxjqbN/CdEzWsQZngyqRlNxxYruCVKdS/NnW+RjRyY+Z
        76Bj1VaR9ksV2DnxrRF/2IA=
X-Google-Smtp-Source: APiQypLEhaf54w8e1b/U0vSvCJ1C7VQIa+V43c3OvtoGt11ueRX0TRIxyh5rHFPN9EpvOfMaWCOgmQ==
X-Received: by 2002:adf:f48f:: with SMTP id l15mr7545408wro.161.1587301103671;
        Sun, 19 Apr 2020 05:58:23 -0700 (PDT)
Received: from xps ([80.215.14.241])
        by smtp.gmail.com with ESMTPSA id 1sm15594846wmz.13.2020.04.19.05.58.22
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 19 Apr 2020 05:58:22 -0700 (PDT)
From:   Mathieu Dolmen <mathieu.dolmen@gmail.com>
To:     manishc@marvell.com
Cc:     GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Mathieu Dolmen <mathieu.dolmen@gmail.com>
Subject: [PATCH] staging: qlge: cleanup indent in qlge_main.c
Date:   Sun, 19 Apr 2020 14:57:12 +0200
Message-Id: <20200419125712.27506-1-mathieu.dolmen@gmail.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup indentation style in qlge_main.c.
Fix 2 warnings found by checkpatch.pl.

Signed-off-by: Mathieu Dolmen <mathieu.dolmen@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index c92820f07968..d6b78c200383 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4125,11 +4125,11 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	/* Get RX stats. */
 	pkts = mcast = dropped = errors = bytes = 0;
 	for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
-			pkts += rx_ring->rx_packets;
-			bytes += rx_ring->rx_bytes;
-			dropped += rx_ring->rx_dropped;
-			errors += rx_ring->rx_errors;
-			mcast += rx_ring->rx_multicast;
+		pkts += rx_ring->rx_packets;
+		bytes += rx_ring->rx_bytes;
+		dropped += rx_ring->rx_dropped;
+		errors += rx_ring->rx_errors;
+		mcast += rx_ring->rx_multicast;
 	}
 	ndev->stats.rx_packets = pkts;
 	ndev->stats.rx_bytes = bytes;
@@ -4140,9 +4140,9 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	/* Get TX stats. */
 	pkts = errors = bytes = 0;
 	for (i = 0; i < qdev->tx_ring_count; i++, tx_ring++) {
-			pkts += tx_ring->tx_packets;
-			bytes += tx_ring->tx_bytes;
-			errors += tx_ring->tx_errors;
+		pkts += tx_ring->tx_packets;
+		bytes += tx_ring->tx_bytes;
+		errors += tx_ring->tx_errors;
 	}
 	ndev->stats.tx_packets = pkts;
 	ndev->stats.tx_bytes = bytes;
-- 
2.25.3

