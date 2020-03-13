Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381B71843FB
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgCMJn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:43:26 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:52658 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgCMJn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 05:43:26 -0400
Received: by mail-pj1-f43.google.com with SMTP id f15so3874835pjq.2
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 02:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hh6KqYNTBZmUluUTxoQaRzg7K8olpbqaR6qYlN8qUU4=;
        b=M7G40oKMZ8lKqVGsUBIggrO0klgQNwFkdu+Zxg1cQzIgSshasFs9LxmVcuroKm6nMa
         Il8lJY5YBuDxvhsFbxXVOVbKTjX0S/RG9XWXrG5aRUEyvP6MWTle8kiyFsB+yveNm7jx
         tvghYpFdGIR4b8dWwOhATBfOPYtqR7r+pMg0KeFxQx4X2z+31HDNMK+pxH3UvcL7UTFm
         PksYVltfTnMMUVxGUMQ9ooWzM8IsUNITZUo17qtn5QO9gRJrFIl50wuYPaBHWE+l0aDy
         soe6vcbFqQUvzZco/AqIAbiZo/Zmok7RPimfpECglckvew4+orf6nMW12Kx8SHZAGiox
         HDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hh6KqYNTBZmUluUTxoQaRzg7K8olpbqaR6qYlN8qUU4=;
        b=s5B29FVVlsV/vhLqwK4l+TFou1sB5PK6EkWkuPIX0O6//5MC7rXBwoFPVK9hQpY3HC
         GxUPtn0RIkDGb/VjTkJa3XprDH1f9hvfmpBimrDqOE++fgiaFE76V7u6FcfCEQzbKKMK
         8za8CBhpn5hZAL2ZAwhEs9k7zroNkWuwlqevLE7Q9qkeuREc0irFG3UnQ2L3x+y6dZwJ
         +ISXrgUiC4RYKQH8Tt8++tuOtkY6ceU4qDIvvQN+D2+HKahShCPlwV5VnCx2vANlerOn
         50gl97zDRVBcYw0J6Dntn6PXBczg44BlzNqT9dZnzBhEe+0gJkQump7nWPjncEkX4Fbp
         lMIA==
X-Gm-Message-State: ANhLgQ30c20TXLKxJQyy9N63rBBD5wO8k17QcHhtDnODcOAdKbYrpX+C
        rjcUR3HP089gr8MxQwkXZSy7DDu2HlI=
X-Google-Smtp-Source: ADFU+vv1JtawMYSd5C036UoiPPyVoWdzSIzmVTHD4JpK8gkcV/ZkPru6Dh2kG3rOXWF2UeCAM4+e3A==
X-Received: by 2002:a17:90a:8905:: with SMTP id u5mr8615790pjn.137.1584092604763;
        Fri, 13 Mar 2020 02:43:24 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v67sm13896386pfc.120.2020.03.13.02.43.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 13 Mar 2020 02:43:24 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 net-next 7/7] octeontx2-af: Remove driver version and fix authorship
Date:   Fri, 13 Mar 2020 15:12:46 +0530
Message-Id: <1584092566-4793-8-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 6564f45..71415d7 100644
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

