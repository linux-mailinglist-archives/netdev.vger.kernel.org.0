Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A584116071E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 00:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgBPXML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 18:12:11 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38892 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgBPXMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 18:12:10 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so7850024pfc.5
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 15:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kGUopAaLVToq17IGSelhOyyIJLvIfINHYNELER472Hw=;
        b=fE2UEqknXKFxD46B6Dc/DVhwfbj3e207f4NOyQQ0+JmQVnzHTjHBPXu2PClHvQcqH8
         HF03tzRox3B1aNVKMKWbd74iGKFLcac/KXExhqZ1FDxiXd/PsMDTMIPJ+9ZVEWMHwJc4
         RBQnLSWSN7PWWTOX8hMLXqHsRFj/tCaqW0TPJ6Tbi/0026aSU18HFRCaE0EbYHpMXvvC
         DEgLL8JMV2wpNwIXoFACSkjftfa3DW4wQbVdyZ0zoFGCPfh7OL2JI6zRigdpWlb+dc0N
         5VigD1peM+HS3MdFf7yW8rKYWJiacFt9VJcVLpVT2Drc0kTFbVl5Fs6lgKSkxBBajCUF
         deLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kGUopAaLVToq17IGSelhOyyIJLvIfINHYNELER472Hw=;
        b=s/WWCCRplVor2vYrYA980WIF2FHwGWo1AF56zJE+JcwMFPv+34QtqTjwwmS28d60xu
         HiDt26V4/t9ZgK96RsZqx3FE8IQEv6VmTmELu8eYsm5yTyhMQigt2sKV++znSjc5khHP
         B+vK72b3O0uXfZraSfp8r9pMRsK/+fiAg+kcygq2qW0CgJwH2uuPJkyA/tobeqP13Kj9
         eQpu6sbvLMNqUjudc0W+VQd3RsobDauJxRsmSfB7viwQd/OhnX64HHjePS7ZLMm31FGL
         CjKVyyA/8U0qx8uPl46tEKgmDrkErTNFUK0TYj6R9j9CkgIv9uNkv6xxcVoP2v5wRueM
         qIWw==
X-Gm-Message-State: APjAAAV/MJFUNdihVnMnsvryRKACMqdzEYXZ45psIaCVlxzIHaxA9cX6
        85/NISbRSqWQgO0DNvT7gAcMHXePwkd3qg==
X-Google-Smtp-Source: APXvYqyEou4jh5fE6tOnhaurUlfcXPfvVOdRp48Oeh5lK3IpLg446sZYrOY7C+ffum4Os0N/V/COjA==
X-Received: by 2002:aa7:8582:: with SMTP id w2mr13380380pfn.89.1581894730000;
        Sun, 16 Feb 2020 15:12:10 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 70sm14074573pgd.28.2020.02.16.15.12.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:12:09 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/9] ionic: rename rdma eqs field
Date:   Sun, 16 Feb 2020 15:11:51 -0800
Message-Id: <20200216231158.5678-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before adding fields to track the Eth Event Queues, we
need to rename the RDMA Event Queues fields so as to
prevent any confusion as to which set we're working with.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 22 ++++++++++---------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +-
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index bb106a32f416..7d41e7e56ca6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -46,7 +46,7 @@ struct ionic {
 	struct list_head lifs;
 	struct ionic_lif *master_lif;
 	unsigned int nnqs_per_lif;
-	unsigned int neqs_per_lif;
+	unsigned int nrdma_eqs_per_lif;
 	unsigned int ntxqs_per_lif;
 	unsigned int nrxqs_per_lif;
 	DECLARE_BITMAP(lifbits, IONIC_LIFS_MAX);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 15d5b24d89a1..43c8bff02831 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1912,7 +1912,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	netdev->min_mtu = IONIC_MIN_MTU;
 	netdev->max_mtu = IONIC_MAX_MTU;
 
-	lif->neqs = ionic->neqs_per_lif;
+	lif->nrdma_eqs = ionic->nrdma_eqs_per_lif;
 	lif->nxqs = ionic->ntxqs_per_lif;
 
 	lif->ionic = ionic;
@@ -2458,26 +2458,28 @@ int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 int ionic_lifs_size(struct ionic *ionic)
 {
 	struct ionic_identity *ident = &ionic->ident;
-	unsigned int nintrs, dev_nintrs;
+	unsigned int nrdma_eqs_per_lif;
 	union ionic_lif_config *lc;
 	unsigned int ntxqs_per_lif;
 	unsigned int nrxqs_per_lif;
-	unsigned int neqs_per_lif;
 	unsigned int nnqs_per_lif;
-	unsigned int nxqs, neqs;
+	unsigned int dev_nintrs;
 	unsigned int min_intrs;
+	unsigned int nrdma_eqs;
+	unsigned int nintrs;
+	unsigned int nxqs;
 	int err;
 
 	lc = &ident->lif.eth.config;
 	dev_nintrs = le32_to_cpu(ident->dev.nintrs);
-	neqs_per_lif = le32_to_cpu(ident->lif.rdma.eq_qtype.qid_count);
+	nrdma_eqs_per_lif = le32_to_cpu(ident->lif.rdma.eq_qtype.qid_count);
 	nnqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_NOTIFYQ]);
 	ntxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_TXQ]);
 	nrxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_RXQ]);
 
 	nxqs = min(ntxqs_per_lif, nrxqs_per_lif);
 	nxqs = min(nxqs, num_online_cpus());
-	neqs = min(neqs_per_lif, num_online_cpus());
+	nrdma_eqs = min(nrdma_eqs_per_lif, num_online_cpus());
 
 try_again:
 	/* interrupt usage:
@@ -2485,7 +2487,7 @@ int ionic_lifs_size(struct ionic *ionic)
 	 *    1 for each CPU for master lif TxRx queue pairs
 	 *    whatever's left is for RDMA queues
 	 */
-	nintrs = 1 + nxqs + neqs;
+	nintrs = 1 + nxqs + nrdma_eqs;
 	min_intrs = 2;  /* adminq + 1 TxRx queue pair */
 
 	if (nintrs > dev_nintrs)
@@ -2505,7 +2507,7 @@ int ionic_lifs_size(struct ionic *ionic)
 	}
 
 	ionic->nnqs_per_lif = nnqs_per_lif;
-	ionic->neqs_per_lif = neqs;
+	ionic->nrdma_eqs_per_lif = nrdma_eqs;
 	ionic->ntxqs_per_lif = nxqs;
 	ionic->nrxqs_per_lif = nxqs;
 	ionic->nintrs = nintrs;
@@ -2519,8 +2521,8 @@ int ionic_lifs_size(struct ionic *ionic)
 		nnqs_per_lif >>= 1;
 		goto try_again;
 	}
-	if (neqs > 1) {
-		neqs >>= 1;
+	if (nrdma_eqs > 1) {
+		nrdma_eqs >>= 1;
 		goto try_again;
 	}
 	if (nxqs > 1) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 9c5a7dd45f9d..e912f8efb3d5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -149,7 +149,7 @@ struct ionic_lif {
 	struct ionic_qcqst *txqcqs;
 	struct ionic_qcqst *rxqcqs;
 	u64 last_eid;
-	unsigned int neqs;
+	unsigned int nrdma_eqs;
 	unsigned int nxqs;
 	unsigned int ntxq_descs;
 	unsigned int nrxq_descs;
-- 
2.17.1

