Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037AA4D824
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 20:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFTSYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 14:24:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43188 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbfFTSIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 14:08:36 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so2092708pfg.10;
        Thu, 20 Jun 2019 11:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1iF2ZB803XlTIr6nvosftGxcuWC6YkTcPa42GxL7qVg=;
        b=dXqdQ5v4XNwaaSAeTuU/PFr+LTjbmJXHwYjb0XyYvUBuN1fuVNXpXtrzzLLJV2DqFt
         ePdGTtvXjb0HKW6pyn6Do5vapM/0MCv8TfUqpxe+NuLY0Tbjm2c9PN2wm9xlvJmh8e01
         X7A3ISf11wSmgXOCTDj0L2S8xdkXAdDx4MFSspFKaVxhsKfpFsT2eEWA2kFbwUo/wgwX
         2b1zvHol0U7XHUKAWYDsAUqV7C7wwOpbVqzevhBKJS+X+Vm2uxm3o13oraST3skyY+XE
         jsBlIXnFjZMtx+E6qRh+FgSE6FlUEYbM0RqhBmfkxPq5dYpjqEgPk+Lu3nctvRAqg6qY
         JpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1iF2ZB803XlTIr6nvosftGxcuWC6YkTcPa42GxL7qVg=;
        b=nkFgRK/Ipc4KxZL7wookTAJET2Q6QDMBQmY7qBFD0RiFi0RZAzTc9uk+sOoMY0kkHx
         EkmXgDrH8v2tyOWFdj3t0VshlPAArL98WCTTfGDprRzbyFbJfzET39YPfvIz+VDpbevW
         OK3tSuQIx2IP2yQ5PnoNJI16L8cK7NZu9U+PPtq507ndtYU7NXvzWdx7i5/WA+Q6vseK
         rbCCv/pdRv428SiCwLfybzdqy9xPcA2+XfReVAXW6nn+OOVq5bXO+Paa9IP6clHOjrwO
         xtOqmNMzMcDMeEYKhSssDhLOtdKQQB+ybCnP0m6wQf72mEOLUobiE+ovoAvlxkh0Eec7
         ByqQ==
X-Gm-Message-State: APjAAAVayS1x1B8wyevmildZrhzacVDAmt8Gf9kRZYy5GXGTdJBNn7Um
        6xPgk0+CgmgPME53bzxDsl8=
X-Google-Smtp-Source: APXvYqxCWD78/GO2Q+QXxWvVYQNthB+ZkCB4FDaOHC/jm3YD8nwpf6T00fKGG+aufWRx466WdoPyHg==
X-Received: by 2002:aa7:9190:: with SMTP id x16mr119008844pfa.86.1561054115722;
        Thu, 20 Jun 2019 11:08:35 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id 85sm289016pgb.52.2019.06.20.11.08.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 11:08:35 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 1/3] net: fddi: skfp: Rename PCI_REV_ID to PCI_REVISION_ID
Date:   Thu, 20 Jun 2019 23:37:52 +0530
Message-Id: <20190620180754.15413-2-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190620180754.15413-1-puranjay12@gmail.com>
References: <20190620180754.15413-1-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the PCI_REV_ID define to PCI_REVISION_ID in skfbi.h
and drvfbi.c to make it compatible with the pci_regs.h
which defines it as PCI_REVISION_ID.

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
---
 drivers/net/fddi/skfp/drvfbi.c  | 2 +-
 drivers/net/fddi/skfp/h/skfbi.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
index bdd5700e71fa..b324c1acf195 100644
--- a/drivers/net/fddi/skfp/drvfbi.c
+++ b/drivers/net/fddi/skfp/drvfbi.c
@@ -127,7 +127,7 @@ static void card_start(struct s_smc *smc)
 	 *	 at very first before any other initialization functions is
 	 *	 executed.
 	 */
-	rev_id = inp(PCI_C(PCI_REV_ID)) ;
+	rev_id = inp(PCI_C(PCI_REVISION_ID)) ;
 	if ((rev_id & 0xf0) == SK_ML_ID_1 || (rev_id & 0xf0) == SK_ML_ID_2) {
 		smc->hw.hw_is_64bit = TRUE ;
 	} else {
diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
index 89557457b352..a05ce16171be 100644
--- a/drivers/net/fddi/skfp/h/skfbi.h
+++ b/drivers/net/fddi/skfp/h/skfbi.h
@@ -31,7 +31,7 @@
 #define	PCI_DEVICE_ID	0x02	/* 16 bit	Device ID */
 #define	PCI_COMMAND	0x04	/* 16 bit	Command */
 #define	PCI_STATUS	0x06	/* 16 bit	Status */
-#define	PCI_REV_ID	0x08	/*  8 bit	Revision ID */
+#define	PCI_REVISION_ID	0x08	/*  8 bit	Revision ID */
 #define	PCI_CLASS_CODE	0x09	/* 24 bit	Class Code */
 #define	PCI_CACHE_LSZ	0x0c	/*  8 bit	Cache Line Size */
 #define	PCI_LAT_TIM	0x0d	/*  8 bit	Latency Timer */
-- 
2.21.0

