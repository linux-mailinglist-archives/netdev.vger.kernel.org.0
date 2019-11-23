Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2C6107DC3
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKWI04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:56 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34307 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfKWI0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:54 -0500
Received: by mail-pj1-f67.google.com with SMTP id bo14so4218925pjb.1
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R7eA6P/7QBFDk6xOWNAzETuBd01IhfXzVmDoVF/d0lc=;
        b=iJLVIoYZWCIpgI0buI1N2O2IUNioskabZbTf5QsRPGcu4+J79SibZfhaKNqHJ4GGhC
         yzwEUTaNzd1zR/xKm44hsT9XE0kJMhQrMSiyGhuRObN/eATdeflYFB4Ffpuufa+xNBk/
         B5oVVaaiBVRg6d34eACvqTuhS/bqsRY2IB26Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R7eA6P/7QBFDk6xOWNAzETuBd01IhfXzVmDoVF/d0lc=;
        b=AA11iI904WdWJZJyqPzDoSWuEOv/y0oeVA22rCbnYRYwr+uinCQI+DRS3Rt9JNStC0
         AT90j/zU1KLqfY3mSk44sadla00qQVQKsNKJbngDGSanRa4OeJt61gWoH+AGBEOa7+IF
         QejwzQgjD75hhSPvp1gLI9PG+dvAT8g1niP0K4bfilOMS2NsyBVR3MoCh7HZ45Nu7qcH
         mUKPJ0ugJxBFQ1hyNradCY3TR0bef5+yZJfJ3BdoCNDpv4zTj8ixSs2KlpCqGFAcW+Oj
         tewPBvhNPpAMSY6NYq0OKXisUFISKKa0WDYH1WDN2EhlTT0U/OqGVFfTfstG61jBpoZr
         Ozmw==
X-Gm-Message-State: APjAAAXwgUKP7TEzZ+uary9iImRw34XG0whQ5SWIF4L3iNkZ9QtLEeR0
        uLU7cc2YjamGdnv8+CraAQyGFQ==
X-Google-Smtp-Source: APXvYqwdMIHp4XlVw/V7xHeWtDzFQidkV02GojWEBkiBnx6h4Oo/3+GeHVGAw993iWGiPIi1UE7PEA==
X-Received: by 2002:a17:902:9692:: with SMTP id n18mr18430154plp.152.1574497613500;
        Sat, 23 Nov 2019 00:26:53 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:52 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 14/15] bnxt_en: Rename switch_id to dsn
Date:   Sat, 23 Nov 2019 03:26:09 -0500
Message-Id: <1574497570-22102-15-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
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
index 85983f0..76b398d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11343,8 +11343,8 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 	if (!BNXT_PF(bp))
 		return -EOPNOTSUPP;
 
-	ppid->id_len = sizeof(bp->switch_id);
-	memcpy(ppid->id, bp->switch_id, ppid->id_len);
+	ppid->id_len = sizeof(bp->dsn);
+	memcpy(ppid->id, bp->dsn, ppid->id_len);
 
 	return 0;
 }
@@ -11822,7 +11822,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (BNXT_PF(bp)) {
 		/* Read the adapter's DSN to use as the eswitch switch_id */
-		rc = bnxt_pcie_dsn_get(bp, bp->switch_id);
+		rc = bnxt_pcie_dsn_get(bp, bp->dsn);
 		if (rc)
 			goto init_err_pci_clean;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 505af5c..9ce9b1d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1845,7 +1845,7 @@ struct bnxt {
 	enum devlink_eswitch_mode eswitch_mode;
 	struct bnxt_vf_rep	**vf_reps; /* array of vf-rep ptrs */
 	u16			*cfa_code_map; /* cfa_code -> vf_idx map */
-	u8			switch_id[8];
+	u8			dsn[8];
 	struct bnxt_tc_info	*tc_info;
 	struct list_head	tc_indr_block_list;
 	struct notifier_block	tc_netdev_nb;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index acb2dd6..1c456fc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -488,8 +488,8 @@ int bnxt_dl_register(struct bnxt *bp)
 	}
 
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

