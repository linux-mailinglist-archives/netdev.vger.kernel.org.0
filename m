Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2300E1CE9E6
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgELBAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgELA77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:59:59 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50349C061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:59 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s20so4656358plp.6
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UObqaypPRYSobeTST/hMovGZlgrEr2gWcmfJ11/M8rs=;
        b=D1Hz3o+y46X1bTTAXnzizfGm9dvfDwaZjhsXbB6kSYi9jTkJckHzElXLga1P7jrUeC
         VqsnRWvNVKsMOu6gdnRyJK4AMkjo5jMkBUf89p8ZqGECHkssxdw6NeLbCSr7/T4rjjzr
         WC+LSz0qicbPbQNv4S9/NmXEnqBzOJPwoICTZJQlT8PodNVg6ieWzaxvDq03WDK7gyO+
         RP+oHl/IDB54g3t6e/xfSo22dOFZuJA0tNSMPQ9CoTeo6aWHbWQ9KYZEblKWarMRvvnn
         qBRRw8VZWDuKkLnqQhHAddpqr7TJsYBMW3LZXHW0HNzaLCryR4zWNR9igQcQX1r3N681
         Tzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UObqaypPRYSobeTST/hMovGZlgrEr2gWcmfJ11/M8rs=;
        b=KVVV4W0ss4Dzvc7EXFBBvnxW38u0s1wSAdJBYmI0HnPJN9fVFd8dkznAlIdhMUYKeL
         XT0DaH7RyAfciXDldxfWce8Vzt7ZiCoBbSjmbblSJrlN0NR+QZljoE2tRopbyix3F4ww
         dCqnOru918BJf2X0RqvmoB5o/ncdlfs9YBDcDpWlQkv3oNoGVC9Pq6TOM8BAp7r2d4UV
         0sp/QzVm0KebeSpdOQ7RZSSl6DpQw/Hti+6t+CEpSgwW5cdkN33zXGrByIViXvEZRnVw
         yCUkYHnBYuCRorSIH6pZSC+/f+w6IQnjA9lJJCQJUSF9EFJE9TUNhlqlw3lxdrnjav9f
         GBQg==
X-Gm-Message-State: AGi0PuZs0VFOPE9xQhOG0HoAKN6uMOXHn8x0oaBDj+UQMsToZLOSPlAl
        xheTPfBoModkZr2U94RemcpucGRWWGs=
X-Google-Smtp-Source: APiQypI0BStxSzrPGMoEZLTQosrBBS6n0+yPa9T7iPnD5V7sn1kEG0yPmnNJA9EwUWEbMehB0pAezQ==
X-Received: by 2002:a17:90a:648d:: with SMTP id h13mr24991267pjj.12.1589245198504;
        Mon, 11 May 2020 17:59:58 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:57 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 08/10] ionic: more ionic name tweaks
Date:   Mon, 11 May 2020 17:59:34 -0700
Message-Id: <20200512005936.14490-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up a few more local names that need an "ionic" prefix.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.h     | 10 +++++-----
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 13 +++++++------
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     |  4 ++--
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 33519a8765eb..525434f10025 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -182,7 +182,7 @@ struct ionic_desc_info {
 	void *cb_arg;
 };
 
-#define QUEUE_NAME_MAX_SZ		32
+#define IONIC_QUEUE_NAME_MAX_SZ		32
 
 struct ionic_queue {
 	u64 dbell_count;
@@ -207,14 +207,14 @@ struct ionic_queue {
 	unsigned int desc_size;
 	unsigned int sg_desc_size;
 	unsigned int pid;
-	char name[QUEUE_NAME_MAX_SZ];
+	char name[IONIC_QUEUE_NAME_MAX_SZ];
 };
 
-#define INTR_INDEX_NOT_ASSIGNED		-1
-#define INTR_NAME_MAX_SZ		32
+#define IONIC_INTR_INDEX_NOT_ASSIGNED	-1
+#define IONIC_INTR_NAME_MAX_SZ		32
 
 struct ionic_intr_info {
-	char name[INTR_NAME_MAX_SZ];
+	char name[IONIC_INTR_NAME_MAX_SZ];
 	unsigned int index;
 	unsigned int vector;
 	u64 rearm_count;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 170e72f31197..f7e3ce3de04d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -12,10 +12,11 @@
 #include "ionic_stats.h"
 
 static const char ionic_priv_flags_strings[][ETH_GSTRING_LEN] = {
-#define PRIV_F_SW_DBG_STATS		BIT(0)
+#define IONIC_PRIV_F_SW_DBG_STATS	BIT(0)
 	"sw-dbg-stats",
 };
-#define PRIV_FLAGS_COUNT ARRAY_SIZE(ionic_priv_flags_strings)
+
+#define IONIC_PRIV_FLAGS_COUNT ARRAY_SIZE(ionic_priv_flags_strings)
 
 static void ionic_get_stats_strings(struct ionic_lif *lif, u8 *buf)
 {
@@ -58,7 +59,7 @@ static int ionic_get_sset_count(struct net_device *netdev, int sset)
 		count = ionic_get_stats_count(lif);
 		break;
 	case ETH_SS_PRIV_FLAGS:
-		count = PRIV_FLAGS_COUNT;
+		count = IONIC_PRIV_FLAGS_COUNT;
 		break;
 	}
 	return count;
@@ -75,7 +76,7 @@ static void ionic_get_strings(struct net_device *netdev,
 		break;
 	case ETH_SS_PRIV_FLAGS:
 		memcpy(buf, ionic_priv_flags_strings,
-		       PRIV_FLAGS_COUNT * ETH_GSTRING_LEN);
+		       IONIC_PRIV_FLAGS_COUNT * ETH_GSTRING_LEN);
 		break;
 	}
 }
@@ -557,7 +558,7 @@ static u32 ionic_get_priv_flags(struct net_device *netdev)
 	u32 priv_flags = 0;
 
 	if (test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
-		priv_flags |= PRIV_F_SW_DBG_STATS;
+		priv_flags |= IONIC_PRIV_F_SW_DBG_STATS;
 
 	return priv_flags;
 }
@@ -567,7 +568,7 @@ static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 	struct ionic_lif *lif = netdev_priv(netdev);
 
 	clear_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state);
-	if (priv_flags & PRIV_F_SW_DBG_STATS)
+	if (priv_flags & IONIC_PRIV_F_SW_DBG_STATS)
 		set_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state);
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 9bf142446645..4da94c07d1d3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -199,7 +199,7 @@ static int ionic_intr_alloc(struct ionic_lif *lif, struct ionic_intr_info *intr)
 
 static void ionic_intr_free(struct ionic *ionic, int index)
 {
-	if (index != INTR_INDEX_NOT_ASSIGNED && index < ionic->nintrs)
+	if (index != IONIC_INTR_INDEX_NOT_ASSIGNED && index < ionic->nintrs)
 		clear_bit(index, ionic->intrs);
 }
 
@@ -455,7 +455,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 			cpumask_set_cpu(new->intr.cpu,
 					&new->intr.affinity_mask);
 	} else {
-		new->intr.index = INTR_INDEX_NOT_ASSIGNED;
+		new->intr.index = IONIC_INTR_INDEX_NOT_ASSIGNED;
 	}
 
 	new->cq.info = devm_kzalloc(dev, sizeof(*new->cq.info) * num_descs,
-- 
2.17.1

