Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5087618B7F1
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgCSNIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:08:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46345 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgCSNId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:08:33 -0400
Received: by mail-pg1-f194.google.com with SMTP id k191so95471pgc.13
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 06:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pepMrae6ENSPn3EvchLtqsb9vVHWXr5w0v7tU5H5W7c=;
        b=DTait0UqhZBJg/o6uGyfztdmWgd/+brRxu0KnAYGazyYw6bfn/EbJq7DBbqNK1jq59
         znyH9zyZLthW87QmTqIaii90vjHANpEmYbFPVOEr1l5jdAluq3INB1ecW6K5f0XpNhjj
         3udwqa7eD+TJXVSzsvUeG8XEkcC+5k67IixqSY5BoyatBKk9Vx0U4F3KAvNsRXPdazbX
         38G/aI/eRz+dxq5iW9OMRHlUtxGLFsK616M8SgQ6aIu8BUC1UVVFKbJ4g5mplds+JnSA
         TsNejDm343prsxUB7vQlQ98JnGdU6rKkivdLGGWzeEwcRxoDaNhpcaZVXVgEl0e8ouIe
         cnlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pepMrae6ENSPn3EvchLtqsb9vVHWXr5w0v7tU5H5W7c=;
        b=NeuaMKeeEdis5A1vnJzAuYzcHrgbVs80ophbc97FbD12RrtwSmEMZNBHvy6lnYgqd7
         xn3uIe3y87QmUA7e1ZALUcwrLU8Kdl7l/2Z8geLjHjqRtU1p4W4iTgklmtP7hbXRdVZc
         9ArCpQILdj8Zxvd6v1Jg+j1AUnRjbdwcsU0HdGljKQPw4Zn1mEoKqIvYenHQeCXVORZ6
         EOutzcliiK236597bsZcyrws7gQlvh1pBs0g7TOO90xNh78sD8m+5LAj08CGVYEtiX7n
         oMkkuO6YdUKpOXKU8o5ncdXk660MmhUhhuPx4Sl5qYzNSFeVVhqbBsj62NDE96Hs6feO
         4Oog==
X-Gm-Message-State: ANhLgQ3SSDvRZlOMpHGtvUTEbVtNi0fxJIS0LoKySxY95LnZJCjRszVv
        ntfEBet3J13KYUI+FCYIucBpCllMUyE=
X-Google-Smtp-Source: ADFU+vs7Tqd6FwUKfsWw+ZpOtDWnKFGqK32UArukE5zA2sIpTqwAb+3+zYe0/dXjBySS/2USPcaifw==
X-Received: by 2002:a62:a119:: with SMTP id b25mr3906282pff.158.1584623312105;
        Thu, 19 Mar 2020 06:08:32 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm2336292pgk.66.2020.03.19.06.08.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 19 Mar 2020 06:08:28 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 net-next 7/8] octeontx2-af: Remove driver version and fix authorship
Date:   Thu, 19 Mar 2020 18:37:27 +0530
Message-Id: <1584623248-27508-8-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584623248-27508-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584623248-27508-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Removed MODULE_VERSION and fixed MODULE_AUTHOR.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c      | 4 +---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 5ff25bf..557e429 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -21,7 +21,6 @@
 
 #define DRV_NAME	"octeontx2-af"
 #define DRV_STRING      "Marvell OcteonTX2 RVU Admin Function Driver"
-#define DRV_VERSION	"1.0"
 
 static int rvu_get_hwvf(struct rvu *rvu, int pcifunc);
 
@@ -46,10 +45,9 @@ static const struct pci_device_id rvu_id_table[] = {
 	{ 0, }  /* end of table */
 };
 
-MODULE_AUTHOR("Marvell International Ltd.");
+MODULE_AUTHOR("Sunil Goutham <sgoutham@marvell.com>");
 MODULE_DESCRIPTION(DRV_STRING);
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, rvu_id_table);
 
 static char *mkex_profile; /* MKEX profile name */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index d491819..4a72738 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -24,7 +24,6 @@
 
 #define DRV_NAME	"octeontx2-nicpf"
 #define DRV_STRING	"Marvell OcteonTX2 NIC Physical Function Driver"
-#define DRV_VERSION	"1.0"
 
 /* Supported devices */
 static const struct pci_device_id otx2_pf_id_table[] = {
@@ -32,10 +31,9 @@ static const struct pci_device_id otx2_pf_id_table[] = {
 	{ 0, }  /* end of table */
 };
 
-MODULE_AUTHOR("Marvell International Ltd.");
+MODULE_AUTHOR("Sunil Goutham <sgoutham@marvell.com>");
 MODULE_DESCRIPTION(DRV_STRING);
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, otx2_pf_id_table);
 
 enum {
-- 
2.7.4

