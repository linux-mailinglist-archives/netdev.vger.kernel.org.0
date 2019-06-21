Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5914E47A
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 11:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfFUJqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 05:46:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46357 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfFUJqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 05:46:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id v9so3085868pgr.13;
        Fri, 21 Jun 2019 02:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Aoj0LDY9u1XoPkQxBcF3bn2Pa+FqX3opzjAviuLaNWM=;
        b=Q2Yr3ZtQtujkhSv8knGvU6dm182hOceTHvDeLm6vDQERVlYRiBgNgLJDC1WDP7rlJ+
         Wpvfe5BA00PqmTMDUSEilQbfPKKt4CJFCRTdYTl2GLic8YgBMA81gVDuyiOGnYXk9slE
         PvnH55ZGEA/InbWLGDZbLvXrT2Svssoav56Lo6CfaOE8vATzNBRwYJOwU+gOAbAEH8Ip
         0iXu/rxrdL1ZqdDAMGWp5LoW+olUBc1RtFb1DMbTYx2ynxhrs1bgbw+Gn1M3/bZbxqHm
         4ke0b6l7JXSOwTVVypN/Bi3VYee6uu6MerzFcjERASdzvMUDUZZR9DvjZgOwp/5j9hUr
         G6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aoj0LDY9u1XoPkQxBcF3bn2Pa+FqX3opzjAviuLaNWM=;
        b=aCEE/pLwChu9PlMHrMlPgiHBh4AVJo7OLS5gX0Zmy7PGrh9vfHmvZaGscMJwZmWvTU
         T7idlEuBhtIgoLs892zAbKOb2cXx+M9V4nJ8DPfN8aNFS39xULCyNTjEXgtFgkAUUVH/
         dZ9Q9N0zXDBFmqB9L257hkEGDTj9traHW5qym4BKufUnz4DqTPdhf19h6ce10P8wCCPg
         M0fwCb0LilOseAivVOzcbMFdvvmaitHKp3bnePHUEs4P78Oqcf8R6uFXTtAHMBVciX7j
         TeNO9/9AkJ8qKyfeQZOTwAOsOut25GSv4FT0Vhi/WRw7G6oDi2QFIUMmF2oeyF/AqAtV
         y8bA==
X-Gm-Message-State: APjAAAVD9aNQBc8rfkc76bTgSro0hChAAUK0CvQSv+M7qkG2FA2klgRk
        Wv5eOurWSCduZmy6qopN2LI=
X-Google-Smtp-Source: APXvYqxDElJ9wJ0eQsy4Go1cBXgJUqiVfjzJ9Z+3S6BUys6y+Vt4+m6PkKW6oQ/AEkwgL3rpjqI3nA==
X-Received: by 2002:a17:90a:2666:: with SMTP id l93mr5417210pje.16.1561110411373;
        Fri, 21 Jun 2019 02:46:51 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:913:88b1:ac7e:774f:a03c:dcac])
        by smtp.googlemail.com with ESMTPSA id u2sm2147746pjv.9.2019.06.21.02.46.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 02:46:50 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 1/3] net: fddi: skfp: Rename local PCI defines to match generic PCI defines
Date:   Fri, 21 Jun 2019 15:16:05 +0530
Message-Id: <20190621094607.15011-2-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621094607.15011-1-puranjay12@gmail.com>
References: <20190621094607.15011-1-puranjay12@gmail.com>
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

