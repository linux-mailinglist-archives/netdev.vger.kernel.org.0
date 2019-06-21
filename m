Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA784EC58
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfFUPlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:41:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46652 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFUPlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 11:41:06 -0400
Received: by mail-pf1-f195.google.com with SMTP id 81so3777107pfy.13;
        Fri, 21 Jun 2019 08:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Aoj0LDY9u1XoPkQxBcF3bn2Pa+FqX3opzjAviuLaNWM=;
        b=Ip23F2gH/oF/bVFpx3SqQJnQpWuWDYDVYN8cs+WcWNE+s2xj5xp2KdkfpRXpeAuykI
         7dRyZK7/qvXJ3mx20w3B3YsKQhjdy8Lz7/fHTqnIDSgYVy7G0iOKxsokqcP2q1qW7dTE
         91DnhKD8J80pu5eFfQTdP9OPFcUYxaROaKdnAgAV1DksbVbd1Hf2QJ8gpZG1vssnwOFq
         UUVK+nt9hWj1lVbEEbjsETDQ/g0UqL7k+lw0fh3YExQKvVgcgn+CCg//9da4SA8y+JeE
         B1YkvzsOXKtVerOzcTTtMaH1KaHm0UosDzXrKkILMyWD/5AD0neQPWWqCPPVdcmWJYYz
         KHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aoj0LDY9u1XoPkQxBcF3bn2Pa+FqX3opzjAviuLaNWM=;
        b=iD25E6Z/I3uMuB32Cb/GfZAvDv+OjtO9Mt182CKqVn4LujTSb4dUyUaR+0Q0AYkPF0
         1KjjC9CwmuXyimfUxlVM6VBBxlrQrI7UcSvOAFQecCybdbGmXgOcsJttNQlzUiNQ3pha
         QZsRZ7PPq72KVS9G0IrUn0Q7M/VeX2Qws6Egjj9Eps4eHD8HO1/sFchXbnThFyexp1Eb
         ovmw/Hj9iOvKwTKM76nMJMTTcjlHQDciwxD/5evUMLol8iXtFLQFCDW/Ecea39/fKVRK
         diZ/70LzAYDvjMUB67S9NveAPYbaXdJ+5636R63w8CkdZhf/xD14P+ZG8AE+p4Hw2eF3
         UnGQ==
X-Gm-Message-State: APjAAAUpkt3yEbtvW/C+ItrHBV6yLWGAB83Y3wetAWuugII5XJ9PXzue
        ZHYBwhQ5TlVbPezyJnL6UMw=
X-Google-Smtp-Source: APXvYqzDQOmbN6ealF+fTcqT/CypEBXpOiru0DZ4Q4FpL8sVFL6yIucuvUoeXMrRa3y8MlNzzISpKw==
X-Received: by 2002:a63:f648:: with SMTP id u8mr18995080pgj.132.1561131664539;
        Fri, 21 Jun 2019 08:41:04 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id m8sm2556940pjs.22.2019.06.21.08.41.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 08:41:04 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v5 1/3] net: fddi: skfp: Rename local PCI defines to match generic PCI defines
Date:   Fri, 21 Jun 2019 21:10:35 +0530
Message-Id: <20190621154037.25245-2-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621154037.25245-1-puranjay12@gmail.com>
References: <20190621154037.25245-1-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the PCI_REV_ID and other local defines to Generic PCI define names
in skfbi.h and drvfbi.c to make it compatible with the pci_regs.h.

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
---
 drivers/net/fddi/skfp/drvfbi.c  | 2 +-
 drivers/net/fddi/skfp/h/skfbi.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

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
index 89557457b352..5f9b631e7515 100644
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
@@ -110,7 +110,7 @@
 #define PCI_66MHZCAP	0x0020	/* Bit 5:	66 MHz PCI bus clock capable */
 #define PCI_NEWCAP	0x0010	/* Bit 4:	New cap. list implemented */
 
-#define PCI_ERRBITS	(PCI_PERR|PCI_SERR|PCI_RMABORT|PCI_STABORT|PCI_DATAPERR)
+#define PCI_ERRBITS	(PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT | PCI_STATUS_SIG_TARGET_ABORT | PCI_STATUS_PARITY)
 
 /*	PCI_REV_ID	8 bit	Revision ID */
 /*	PCI_CLASS_CODE	24 bit	Class Code */
-- 
2.21.0

