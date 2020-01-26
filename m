Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546931499BA
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgAZJDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:53 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33393 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729199AbgAZJDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:51 -0500
Received: by mail-pf1-f193.google.com with SMTP id n7so3408818pfn.0
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iYBzVb6naDldJe4hf7U6l5OHVSRQxMupzpkin4tdgB4=;
        b=MUBK1hYmQS8g+1xp+WJwESchYbI6apJKqfJCSjkQ2qiNcDR03VOD0smP6Zuitp46Yw
         9pcYD2fcYyjr55jaIJX6Q61MpXtt/EHbr8eoEMTuq6RU8nDvSp/OyYDzcsLBfUPblLxU
         aYN5QpJkRz0vPj9c36/HAg4WGfkZ/oT+PTyo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iYBzVb6naDldJe4hf7U6l5OHVSRQxMupzpkin4tdgB4=;
        b=d0nPrDgHKt90Y7Oi7BQ5vaXtGpF60hBlmxpKNqNqgGg3S58VW9b3iG061ESoTP+RqI
         XLikSkQpe0CqpMLujoX2oQ2f5wjYco2x28+SS5TFJdXDYHkVlWJvKt+rqQElmJkOll3I
         uY2rJfPY0w2vcxRYxwsfic7tzEmbY5UcMR2iwAi3WBNKWlgxWZlHwq4pvPMHS0q9JeSr
         RI5A+8X0eC2vxP5MC4ZszJ1zRxqAuZt70mLCc0kzfLFzbY5mjzh8r4qPiyARqnyrRvUd
         sAe6ECSJtiwUD+ooJIZHCR6ZkxLty/c41DGE2J8lhQJc663Q3SMbaSDy8g++LSJCpWjb
         KOfw==
X-Gm-Message-State: APjAAAVhBFBydpA2mIwLCVv5CxG+hAEXfl/GzjPPqSXeGc3u54czLprF
        K7T7iLsCbRML3tJ3P+EgQu9mE2rShgQ=
X-Google-Smtp-Source: APXvYqy8mgSf1lci80RC0rh174mJu8CkVfcFTKTLQREAK4XMgrN9uiLof8RMHCrcbQavOVO4fi1yuA==
X-Received: by 2002:a63:5056:: with SMTP id q22mr13230903pgl.20.1580029431107;
        Sun, 26 Jan 2020 01:03:51 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:50 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 13/16] bnxt_en: Rename switch_id to dsn
Date:   Sun, 26 Jan 2020 04:03:07 -0500
Message-Id: <1580029390-32760-14-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Instead of switch_id, renaming it to dsn will be more meaningful
so that it can be used to display device serial number in follow up
patch via devlink_info command.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 6 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8579415..483935b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11388,8 +11388,8 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 	if (!BNXT_PF(bp) || !(bp->flags & BNXT_FLAG_DSN_VALID))
 		return -EOPNOTSUPP;
 
-	ppid->id_len = sizeof(bp->switch_id);
-	memcpy(ppid->id, bp->switch_id, ppid->id_len);
+	ppid->id_len = sizeof(bp->dsn);
+	memcpy(ppid->id, bp->dsn, ppid->id_len);
 
 	return 0;
 }
@@ -11870,7 +11870,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (BNXT_PF(bp)) {
 		/* Read the adapter's DSN to use as the eswitch switch_id */
-		bnxt_pcie_dsn_get(bp, bp->switch_id);
+		rc = bnxt_pcie_dsn_get(bp, bp->dsn);
 	}
 
 	/* MTU range: 60 - FW defined max */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cb2b833..1f6ea58 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1849,7 +1849,7 @@ struct bnxt {
 	enum devlink_eswitch_mode eswitch_mode;
 	struct bnxt_vf_rep	**vf_reps; /* array of vf-rep ptrs */
 	u16			*cfa_code_map; /* cfa_code -> vf_idx map */
-	u8			switch_id[8];
+	u8			dsn[8];
 	struct bnxt_tc_info	*tc_info;
 	struct list_head	tc_indr_block_list;
 	struct notifier_block	tc_netdev_nb;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 265a68c..35e2a22 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -566,8 +566,8 @@ int bnxt_dl_register(struct bnxt *bp)
 		return 0;
 
 	devlink_port_attrs_set(&bp->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       bp->pf.port_id, false, 0,
-			       bp->switch_id, sizeof(bp->switch_id));
+			       bp->pf.port_id, false, 0, bp->dsn,
+			       sizeof(bp->dsn));
 	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
 	if (rc) {
 		netdev_err(bp->dev, "devlink_port_register failed");
-- 
2.5.1

