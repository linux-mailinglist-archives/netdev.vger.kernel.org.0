Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8B92DA849
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 07:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgLOGz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 01:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgLOGzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 01:55:08 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E756EC0617A7;
        Mon, 14 Dec 2020 22:54:42 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c79so13908284pfc.2;
        Mon, 14 Dec 2020 22:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=29XGAclPGmuftpF/yRuuyN4mHi9SUrsaBzPMlpIbVk4=;
        b=Y0sWTMz3GtOW+SmGW4/kBQJooG9l5zU2ce4DP/GKIYB+vbXPrAH41sdsKeo8StG2eX
         D9aMgLppBy3WnWpz3ZPZ/sCD6cu5FNjJJIriBodjw2Fg9XZRKywOKgPF9/Y8ksiEsBtC
         Fb8AftFmxDA/c66vElS+bcBszXqyyh7YLHIxQdsnJoTwb6AgCK7C6Kk8ecJo0V0uuYbb
         MTaMLK3zo9/Z5ndLVpk/JcRcww+cIR5WKh9wZolHRjA2ezytLPfkeZ1iiO60x4T5ODlb
         c3oW5ZqQftlnbrcTpA4cTS1m+ufokdEDI6s05q6dyI9AavCbRV7blRHIVecmIdgNpZTq
         Fi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=29XGAclPGmuftpF/yRuuyN4mHi9SUrsaBzPMlpIbVk4=;
        b=MSr4kVDxnPHUtSXJpSRSxr8CSOKuy7Flk9jf/gLniRqcNjvJmCN7Ao4IMGECKlECsI
         nSQQSPB5Ukvw07L169Sg5Y/B0uTgcl4C+tvm3FmFQ89pXWXvIEAea1gynT2rdefvk5+2
         67GfIVm5KtSAEdNuAeCa6zyOH1OUcmDJ2bs6InqBKMuW53mVwfxyhHM4OGmtJGuQGKPl
         Aob5mBlvY7sqwakUVhsDZRwVaFq25Hyrg5StJ2X2eQFf1IR2l534VQJ4KGN0mB3XWCmC
         AQkazV/dRBW04N3Ahk+Q2P3/FxxdwlkndWB5CENJF5JD8TkkuVvnpvHbTBChsqfnS1Eh
         dRhw==
X-Gm-Message-State: AOAM531hsDl27q1ieXWfhYvHXTXS5mmxL85tDO6sgq3XZ/eVzdCqBkgP
        bqTvYIxvOenrRwGnj/iBfOU=
X-Google-Smtp-Source: ABdhPJz37IEUIyxeO+UQiYDgMJuF4g8CxUpaxXTiy5jOZ9RjJYgHKKxuGBsDrHgSR/uAKnRnWfrAag==
X-Received: by 2002:a63:d542:: with SMTP id v2mr27601912pgi.250.1608015282364;
        Mon, 14 Dec 2020 22:54:42 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id na6sm19124134pjb.12.2020.12.14.22.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 22:54:41 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 2/2] nfc: s3fwrn5: Remove unused NCI prop commands
Date:   Tue, 15 Dec 2020 15:54:01 +0900
Message-Id: <20201215065401.3220-3-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215065401.3220-1-bongsu.jeon@samsung.com>
References: <20201215065401.3220-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Remove the unused NCI prop commands that s3fwrn5 driver doesn't use.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/nci.c | 25 -------------------------
 drivers/nfc/s3fwrn5/nci.h | 22 ----------------------
 2 files changed, 47 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/nci.c b/drivers/nfc/s3fwrn5/nci.c
index 103bf5c92bdc..f042d3eaf8f6 100644
--- a/drivers/nfc/s3fwrn5/nci.c
+++ b/drivers/nfc/s3fwrn5/nci.c
@@ -21,31 +21,11 @@ static int s3fwrn5_nci_prop_rsp(struct nci_dev *ndev, struct sk_buff *skb)
 }
 
 static struct nci_driver_ops s3fwrn5_nci_prop_ops[] = {
-	{
-		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
-				NCI_PROP_AGAIN),
-		.rsp = s3fwrn5_nci_prop_rsp,
-	},
-	{
-		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
-				NCI_PROP_GET_RFREG),
-		.rsp = s3fwrn5_nci_prop_rsp,
-	},
 	{
 		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
 				NCI_PROP_SET_RFREG),
 		.rsp = s3fwrn5_nci_prop_rsp,
 	},
-	{
-		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
-				NCI_PROP_GET_RFREG_VER),
-		.rsp = s3fwrn5_nci_prop_rsp,
-	},
-	{
-		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
-				NCI_PROP_SET_RFREG_VER),
-		.rsp = s3fwrn5_nci_prop_rsp,
-	},
 	{
 		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
 				NCI_PROP_START_RFREG),
@@ -61,11 +41,6 @@ static struct nci_driver_ops s3fwrn5_nci_prop_ops[] = {
 				NCI_PROP_FW_CFG),
 		.rsp = s3fwrn5_nci_prop_rsp,
 	},
-	{
-		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
-				NCI_PROP_WR_RESET),
-		.rsp = s3fwrn5_nci_prop_rsp,
-	},
 };
 
 void s3fwrn5_nci_get_prop_ops(struct nci_driver_ops **ops, size_t *n)
diff --git a/drivers/nfc/s3fwrn5/nci.h b/drivers/nfc/s3fwrn5/nci.h
index 23c0b28f247a..a80f0fb082a8 100644
--- a/drivers/nfc/s3fwrn5/nci.h
+++ b/drivers/nfc/s3fwrn5/nci.h
@@ -11,9 +11,6 @@
 
 #include "s3fwrn5.h"
 
-#define NCI_PROP_AGAIN		0x01
-
-#define NCI_PROP_GET_RFREG	0x21
 #define NCI_PROP_SET_RFREG	0x22
 
 struct nci_prop_set_rfreg_cmd {
@@ -25,23 +22,6 @@ struct nci_prop_set_rfreg_rsp {
 	__u8 status;
 };
 
-#define NCI_PROP_GET_RFREG_VER	0x24
-
-struct nci_prop_get_rfreg_ver_rsp {
-	__u8 status;
-	__u8 data[8];
-};
-
-#define NCI_PROP_SET_RFREG_VER	0x25
-
-struct nci_prop_set_rfreg_ver_cmd {
-	__u8 data[8];
-};
-
-struct nci_prop_set_rfreg_ver_rsp {
-	__u8 status;
-};
-
 #define NCI_PROP_START_RFREG	0x26
 
 struct nci_prop_start_rfreg_rsp {
@@ -70,8 +50,6 @@ struct nci_prop_fw_cfg_rsp {
 	__u8 status;
 };
 
-#define NCI_PROP_WR_RESET	0x2f
-
 void s3fwrn5_nci_get_prop_ops(struct nci_driver_ops **ops, size_t *n);
 int s3fwrn5_nci_rf_configure(struct s3fwrn5_info *info, const char *fw_name);
 
-- 
2.17.1

