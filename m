Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D50818D808
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgCTS6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:58:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44427 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbgCTS6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:58:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id b72so3741368pfb.11
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 11:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pepMrae6ENSPn3EvchLtqsb9vVHWXr5w0v7tU5H5W7c=;
        b=g3QFOcFvj19GMNR5sSTAUKM5qP8nsO1ArBquSKXjpabJ5T+oCbEqQmp8NjjlBKu5tp
         X4jnKB5Qf8B0VVHtznbkKmh8sRbGmqUKhmayvqaRWWNmCk/iJsn7X3HCX16FBLNRgWQV
         M4LXk2ejjjGa4Z2LY95ajEIufiqcaU1r/NsLoKW0t3Nb0z5d/98Qq++iND+OQyGuCeX/
         YqHQNnyn1F+DMZwqUvU344QqgnsYprl5XORakxqspuVrWOz2srCoplAPWmLegcHreFdu
         KkScCwROpAA3EOV9RGtgPNV7/Xo/CGg7haA77PXAl+PagYFxPu4jC2oJsZz8Q1XFGyBo
         0XSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pepMrae6ENSPn3EvchLtqsb9vVHWXr5w0v7tU5H5W7c=;
        b=dvw+CVwD66TX7Up/zlEp4WYKNaupAdWLu6AO4WIYpEMk94Jcj8UUvz+Px+supGX9HO
         5BzMlJcKdsQ7DhJtq0VtyIIi/SeMAR9DnjpDsXxYvle9yJm6QcpBMGHb3ElfLCz7wVbm
         OMhvdh58t75ihuYu9ArMIjDipqa5gwRB8FwWaFSQW3vDRnEAvjV4JuGm8Jy5tpf4wsR/
         Pp6g/TwmXaL9sRU8+Iydol2MaQJkCg69k3muV0HIQLgvWTmBroJO9ztU0fDz8zNbKBOn
         JS2L2bsL6lAs6sdW6dA30Ix++r8BoZ5G1YqUqzSw4UAwsA6kShXbeI+cJ37IdZRtuoKF
         QOwg==
X-Gm-Message-State: ANhLgQ2++6Mf+XswfN3XGtRxUU4SmWc+VSlDnQZ2R2/77cDf4wcUwnKn
        NtnN7oMO6UL+N6bQoRiWlYYEL6ychEE=
X-Google-Smtp-Source: ADFU+vt9NNIV155e1C7Y5oC3Ex/EdkL+Xl03rn2qtAJ6PK3lepXoqxKVbPR/WifslAqdoamABZm/rw==
X-Received: by 2002:a63:1e44:: with SMTP id p4mr10120332pgm.367.1584730680652;
        Fri, 20 Mar 2020 11:58:00 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id l59sm2407044pjb.2.2020.03.20.11.57.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Mar 2020 11:58:00 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 net-next 7/8] octeontx2-af: Remove driver version and fix authorship
Date:   Sat, 21 Mar 2020 00:27:25 +0530
Message-Id: <1584730646-15953-8-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
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

