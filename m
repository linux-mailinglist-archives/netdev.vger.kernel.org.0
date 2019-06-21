Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3D04EBA5
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfFUPOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:14:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35026 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfFUPOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 11:14:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so3542114pgl.2;
        Fri, 21 Jun 2019 08:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Aoj0LDY9u1XoPkQxBcF3bn2Pa+FqX3opzjAviuLaNWM=;
        b=fM1Zw8hT0BrBAuSVgq1zvrljohF97RpbUVxivo0Qvy438t5u3CZNvUIhHpiENg5PwT
         iyw6epymE9cC2MPYiEyBeur+000JZXYFfgxK4PQ/k1wKpR/km8bC0NvEy5/rMFeHdz3l
         qf06gHDmoasoa17WrpXD7WEjC8a7L+uBnS+s+1whtQwq+Fr6+pNJ6iqXuyE+mhvSDYtf
         HHEc0B11zSf/4h22TOurH6PH9248yXU+qZiG95L0GGDG2SzAY9WeFRpjnsYSvLZn2D0O
         tefmDVf6EUUyCj4sGeWSchzyK1JzWWagNCjMTvxAHjotYBklr2nXnJldBi0Ob5ermMSE
         T3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Aoj0LDY9u1XoPkQxBcF3bn2Pa+FqX3opzjAviuLaNWM=;
        b=DzGmBrnl7WvW1BXcKx76rQhUt0b6d8INLaR0XfstcXzhXna8pJyjBw/1JDYCVcJUXC
         L7e1qfF0nfN6vh9u0Z2ke0GSFjxMH+yc4dD61eF/M2qCtcyjahinWsPcxIFVPo+CtP8U
         RS8rUbn5OkJjgsW5dBziNnyb7Jd0y2eZIA93gqngP3l5pc/QmCwXTcT45HtcYeyw9jVW
         ZyglteoZHut9L53aJVEtwXhLT6jL90LKa0Hid7+EVVrZ3yaicmLn/QomErMKd044SyQ4
         JYuiSkbSaMQ94mmeZsV7eaNY/OlibxhIynp9h9t0KJRfxGDHHOAmsfwwA2q8lf2AgAky
         DbTQ==
X-Gm-Message-State: APjAAAXYUHTIMG2iiQy44wUI8EkQEZe6xpK9+o+Wv2jwIt72mo59sH4v
        RB1XkVDKcFV44A7BqWwaOtU=
X-Google-Smtp-Source: APXvYqyZhnjj5XV42ihCFCrbqBXDboaEat+z613KWNvrAVw5c72yTv3EyiLciiqEW28iKAVl8HpKqA==
X-Received: by 2002:a17:90a:9903:: with SMTP id b3mr7300906pjp.80.1561130078234;
        Fri, 21 Jun 2019 08:14:38 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id 25sm3254465pfp.76.2019.06.21.08.14.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 08:14:37 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 1/3] net: fddi: skfp: Rename local PCI defines to match generic PCI defines
Date:   Fri, 21 Jun 2019 20:44:13 +0530
Message-Id: <20190621151415.10795-2-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621151415.10795-1-puranjay12@gmail.com>
References: <20190621151415.10795-1-puranjay12@gmail.com>
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

