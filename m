Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5102D97A8
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438560AbgLNLrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438530AbgLNLrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:47:35 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBB0C0613CF;
        Mon, 14 Dec 2020 03:47:10 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id e2so12316689pgi.5;
        Mon, 14 Dec 2020 03:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/sj5dLXt24sh61lvcsgpABuLIqlJqFU1rHY/mqcSIRs=;
        b=frhHmzOc78dpdY1fADjgVo/mxFIHVbEU45s7IyfZGPQVvWXx0j5l0SCs5C/M+soRMd
         ZIt76MoWwLaVYJep7A86+QgVB5W6hMn23rzTDfu76lh3LB8irMhbVN7xStLIG4ORGt7M
         95u5QbAH9gH6CRbylNLDQaeOhQKsuev0YNY5KepbOMeZksdYHps+o9dYoqFY0iuwP8zO
         JCunHZqKYOmg62jH68SknpbPyqDVpD7JdOJ5L+hO1R160imwBZHTOYzeTKZXrjoH5xVQ
         mwZwmvpOr/XRUbaqheAOeklqKSAe2VlVDQGcm6Mc6msUn+6oJP93O0+KjEsg6ofO2pRq
         /W2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/sj5dLXt24sh61lvcsgpABuLIqlJqFU1rHY/mqcSIRs=;
        b=U5tbwA//zZOlyycYWwCVagE+LM3tjcHt6OOXRW8OmugZrYYpUcDsEtisuerUH2/sGf
         n3Jbc5kygj+OFgfCR/miq5nMr+nQN7uJEmHKceeTbQHROPJWFndFwsfuGqj+Fv51R3GR
         RT/dFO42Lo48mq9tfbQ5QDPc36wEN31p1c64JBDhycqOAxwVqMjs8hydapfNt5n37OBe
         NwEzVbX5JhjtgpmK61uzyinZOqcQspEUvDX/2MALMz3JPy59j4Ka525PjXvcPk22hL4i
         fzsbbXTXrX2uLDibeWSUsEmVi/AEXmu9sHcaUAzuw1N9WaZkUKc4F+sLY3qevfHNQNgS
         LywQ==
X-Gm-Message-State: AOAM531+oUJsxGVX59rOoqQXmXB9YXteDmgMYOBNolfW6MVVbQeNhcXA
        HNaXhqmAJ/dWCup17WnKEyU=
X-Google-Smtp-Source: ABdhPJxUEEax5L2fx/qRE2NzO+kFIVY2bl1ZbTZrfXfq6QuwFn9jjM+qgx9cYb5Jr30J+L3o03Kv9Q==
X-Received: by 2002:a63:eb4b:: with SMTP id b11mr23926208pgk.351.1607946429816;
        Mon, 14 Dec 2020 03:47:09 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id h18sm2294116pfo.172.2020.12.14.03.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 03:47:08 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next] nfc: s3fwrn5: Remove unused nci prop commands
Date:   Mon, 14 Dec 2020 20:46:58 +0900
Message-Id: <20201214114658.27771-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

remove the unused nci prop commands that samsung driver doesn't use.

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

