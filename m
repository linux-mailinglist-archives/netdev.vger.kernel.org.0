Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88DC160721
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 00:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgBPXMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 18:12:16 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41088 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgBPXMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 18:12:14 -0500
Received: by mail-pg1-f194.google.com with SMTP id 70so8037539pgf.8
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 15:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vcgBucx+pYpKP8fSaw2AkML3FBEnyG69pj2H6N58rz8=;
        b=q/ILbC6HDVeazsFttbkm2D30RirFUDoA+8V2pwC2i0YWGL3Y2jaum7Spv8p6YHGMgc
         e6XaiMerVMGJmJVc3O3Ge+SdeJzUnhxqgl8vbFSIYksOBUyJkud7MS/i/8QBH4g9bWJC
         +2FwxYj18SRyTp4lKMvCYEH/rkFvF4bchKrimOS00deRMF0LFQyprdOuhwsOz+ya+F53
         g+vgu3+TfKQl4dLZe7Fu3EXvZSkdlp2TqmZfkOWc1XkAL0A1GobJhjf4jZK79yL0qRVe
         DCZ7R9lBFRNrp74Dp568xu996zhF2rHbcN5OfY5xUNCrpomR7WjEWfIZRZgk8gNDrwGV
         SXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vcgBucx+pYpKP8fSaw2AkML3FBEnyG69pj2H6N58rz8=;
        b=Xeiv98O1NRS8Mszq+iEnjrvfKUVwt2pKl9gUCiFyqorNlJ8Jas/wSFSOwqidDWIT/u
         Rs2Dbo21jcUo6jIDzHP8KYsa/Qi0dlPQsU9fmPB4g3d5BdS1JgFd9ENRj9RG2lm3i2in
         9wZQyHV4Fz5Q0RVe0rmT06wnA0NWBP2qG8o20J32CAVe2AkIKiV5UyubSvapmzcfusFI
         FCqBsJEAEEbIsspa7uj6/tjQE814j/o3/iIpOjSEA7Yfg9lDJ0z44hWTiSl9EOy5lu+3
         raIpsZ8P1K5liAb4vRyP/WM8JAfnFeQi4qTwptS9aafvEwTv0nanzrdjgcPqkgA0Id0N
         5uow==
X-Gm-Message-State: APjAAAXUDdq84DtmOR9GTep0zstTvOllZs6FY2P1LL61pMfCdZfSRMhe
        0tIWVzykBVLrrVTQtYBcKUvmJ53a4D7BtA==
X-Google-Smtp-Source: APXvYqwmI/0Lr9MY/I1g7kzHBx5LC5Q7y+Rx19kMlSLPGXXKTaLFneJmdABObvG9APaqgWSq71TE0A==
X-Received: by 2002:a62:547:: with SMTP id 68mr14050897pff.217.1581894732670;
        Sun, 16 Feb 2020 15:12:12 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 70sm14074573pgd.28.2020.02.16.15.12.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:12:12 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/9] ionic: rename napi irq functions
Date:   Sun, 16 Feb 2020 15:11:54 -0800
Message-Id: <20200216231158.5678-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make room for similar functions for Event Queue handling.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 58f23760769f..1eb3bd4016ce 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -121,7 +121,7 @@ static void ionic_link_status_check_request(struct ionic_lif *lif)
 	}
 }
 
-static irqreturn_t ionic_isr(int irq, void *data)
+static irqreturn_t ionic_napi_isr(int irq, void *data)
 {
 	struct napi_struct *napi = data;
 
@@ -130,7 +130,7 @@ static irqreturn_t ionic_isr(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int ionic_request_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
+static int ionic_request_napi_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct ionic_intr_info *intr = &qcq->intr;
 	struct device *dev = lif->ionic->dev;
@@ -145,7 +145,7 @@ static int ionic_request_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	snprintf(intr->name, sizeof(intr->name),
 		 "%s-%s-%s", IONIC_DRV_NAME, name, q->name);
 
-	return devm_request_irq(dev, intr->vector, ionic_isr,
+	return devm_request_irq(dev, intr->vector, ionic_napi_isr,
 				0, intr->name, &qcq->napi);
 }
 
@@ -654,7 +654,7 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi,
 		       NAPI_POLL_WEIGHT);
 
-	err = ionic_request_irq(lif, qcq);
+	err = ionic_request_napi_irq(lif, qcq);
 	if (err) {
 		netif_napi_del(&qcq->napi);
 		return err;
@@ -2113,7 +2113,7 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi,
 		       NAPI_POLL_WEIGHT);
 
-	err = ionic_request_irq(lif, qcq);
+	err = ionic_request_napi_irq(lif, qcq);
 	if (err) {
 		netdev_warn(lif->netdev, "adminq irq request failed %d\n", err);
 		netif_napi_del(&qcq->napi);
-- 
2.17.1

