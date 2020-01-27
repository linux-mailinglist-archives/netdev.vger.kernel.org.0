Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03EFC14A14E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgA0J5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:25 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37229 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgA0J5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:23 -0500
Received: by mail-pj1-f67.google.com with SMTP id m13so2899859pjb.2
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e+NhWFsSGbBhhj5u3Z4qE3IS+aoDcKSYH5fx3xfYzSc=;
        b=Hq5mU4cxnnAE8DAmi9iRebk/Dojs0z/kGQyQGL9QqRaN2AixBABl+wxwml1LD/Z6q6
         uQGuhI4yx/8vfPfpVeKH6M/fLncBiPqrG79VLc8RzIN5vvp7WPaU6QQ1OHUA/XeoDb66
         DqLGXAuLPV1TbgPW89o/JK3zjVjB9OPhs8N4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e+NhWFsSGbBhhj5u3Z4qE3IS+aoDcKSYH5fx3xfYzSc=;
        b=EDuGU54UuGeuY2v5kMwpAfi9L9BTn9Wodjap0ojJY3lzHkkhTAwD3yh+Y2GK8vA0b7
         QZBalMcoSpg1dmGApsRxNERZ3V7c81YFZlQoK2x5EuDCNWg6JMafFwPKbQEJPYhrpPly
         i3E7eUvX8aL1lUi2aLNGHxI7DafoKRHX6JPcvFjoQ7jHyZEIFAIstzUB3OF1wJE7r6bF
         EpXeP3UTDUhlulhqVAJF6YM3O2dMrAuNH3GXows7L4xTKToNA5ifZ+h3XZKW5RD1swHS
         dBGljsQVgce13Y26/BKpv2kn/JPW0C7NkCXsamJY4D9t/oe3CEkds424dNibuSgB/3Ca
         C2Zw==
X-Gm-Message-State: APjAAAWEuQhdQYC8TGJLaKhIRBlwCJmIDFd+vV0iZZhvj/PSXgrjvsUD
        Wjj05EEJ2klaVXFcKTdFOzXtG/3GI5g=
X-Google-Smtp-Source: APXvYqywZw6eQmeuL2alAq+dahzbolPkhJs5qCSQvMDiE9NSCrLTJb6p1jCPTrlnTVZwwB8XkCkEYQ==
X-Received: by 2002:a17:902:6b82:: with SMTP id p2mr17516335plk.259.1580119042736;
        Mon, 27 Jan 2020 01:57:22 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:22 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 12/15] bnxt_en: Rename switch_id to dsn
Date:   Mon, 27 Jan 2020 04:56:24 -0500
Message-Id: <1580118987-30052-13-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
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
index cda434b..cabef0b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1848,7 +1848,7 @@ struct bnxt {
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

