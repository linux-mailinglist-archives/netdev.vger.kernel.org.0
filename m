Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162774C025
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbfFSRrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:47:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41815 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729188AbfFSRrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:47:15 -0400
Received: by mail-pl1-f196.google.com with SMTP id m7so105652pls.8;
        Wed, 19 Jun 2019 10:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aPnbuxkp7d8swCVKkF6fMbKARizWJc52LDIS1OUUu6M=;
        b=RgFTxS5ypmTbomR4YJ8U0/M1UG7n4nYTNWIzA1JlHFkTK5DJWGCDtg8aV8ZRNWaKhq
         hSvxZtDEEfb5A5oqXu8q2bjkD7Fxy170rRmUh1hpRlo6fXoFwtDQWqN5Om5a4gu18CIs
         sLgflkc+8wfFM6ZlFOTWoicQNEyvG09brZW+QDPtfYBiC/lLGznYaiGn2ribpWhADyBU
         gk6B2jVUl3wHx67MpLqO5MOguL7T/6PpHJ8l/WX8U+yE4QWOZ9Pjh3fg5pIYZ1o5QNzy
         mrbAJj4MQzXf0N4tbPxGV62c/u6eVBElCw5KIZ+wCNZu0/XK2wkImnJBtRozEpDK2Lkb
         sNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aPnbuxkp7d8swCVKkF6fMbKARizWJc52LDIS1OUUu6M=;
        b=MVRiz2sEJ3KUt6up8PMNsrtxrvmrfAxUJcfttlZN3Dgc30HY2Sfw9TyAu8PQOjAUf6
         qGvYFn3E0gAIY3y/rhaT7RHhLrcM179NFpn4NokhhSzYktjUF0ppl6AGxIIzt5r7Ahb3
         3nHavLZ0fvJ/SwWGPWl59xRGoixM5h+36zrvACl8WBa1wKLY8cdoVYK4ZhQnH6w0f2Mp
         bVzXls6C7OQZGYWz9SKIR3vc3WWg1nEoQmB+yW5Ia/qisEFIXPti2xsHrPwzRBt5aE8u
         xa2EBBNMaVizZdl5FNKUkMy3RmeLi9JF8lvfw9zK6yKmS3cK3lJVMsErySM79IyGN+T5
         FCGw==
X-Gm-Message-State: APjAAAU/IPloO3HxPa9h6FO0VPbUmY0ZHmLPHKm+lplaSWdTWEJ+GeF2
        KULFFKrusqOPz8/ua4nnXiadEBtaiv+loA==
X-Google-Smtp-Source: APXvYqxr/rv+WW/E2rxGMrXHAwpw8EJ2b2BWvd9NPJFREfPvrfyeFxq0XAZ6l0MxratHCb0Z5UAMuA==
X-Received: by 2002:a17:902:9041:: with SMTP id w1mr107640997plz.132.1560966435070;
        Wed, 19 Jun 2019 10:47:15 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id i14sm27786896pfk.0.2019.06.19.10.47.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 10:47:14 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn@helgaas.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] net: fddi: skfp: remove generic PCI defines from skfbi.h
Date:   Wed, 19 Jun 2019 23:16:43 +0530
Message-Id: <20190619174643.21456-1-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skfbi.h defines its own copies of PCI_COMMAND, PCI_STATUS, etc.
remove them in favor of the generic definitions in
include/uapi/linux/pci_regs.h

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
---
 drivers/net/fddi/skfp/h/skfbi.h | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
index 89557457b352..ed144a8e78d1 100644
--- a/drivers/net/fddi/skfp/h/skfbi.h
+++ b/drivers/net/fddi/skfp/h/skfbi.h
@@ -27,29 +27,6 @@
 /*
  * Configuration Space header
  */
-#define	PCI_VENDOR_ID	0x00	/* 16 bit	Vendor ID */
-#define	PCI_DEVICE_ID	0x02	/* 16 bit	Device ID */
-#define	PCI_COMMAND	0x04	/* 16 bit	Command */
-#define	PCI_STATUS	0x06	/* 16 bit	Status */
-#define	PCI_REV_ID	0x08	/*  8 bit	Revision ID */
-#define	PCI_CLASS_CODE	0x09	/* 24 bit	Class Code */
-#define	PCI_CACHE_LSZ	0x0c	/*  8 bit	Cache Line Size */
-#define	PCI_LAT_TIM	0x0d	/*  8 bit	Latency Timer */
-#define	PCI_HEADER_T	0x0e	/*  8 bit	Header Type */
-#define	PCI_BIST	0x0f	/*  8 bit	Built-in selftest */
-#define	PCI_BASE_1ST	0x10	/* 32 bit	1st Base address */
-#define	PCI_BASE_2ND	0x14	/* 32 bit	2nd Base address */
-/* Byte 18..2b:	Reserved */
-#define	PCI_SUB_VID	0x2c	/* 16 bit	Subsystem Vendor ID */
-#define	PCI_SUB_ID	0x2e	/* 16 bit	Subsystem ID */
-#define	PCI_BASE_ROM	0x30	/* 32 bit	Expansion ROM Base Address */
-/* Byte 34..33:	Reserved */
-#define PCI_CAP_PTR	0x34	/*  8 bit (ML)	Capabilities Ptr */
-/* Byte 35..3b:	Reserved */
-#define	PCI_IRQ_LINE	0x3c	/*  8 bit	Interrupt Line */
-#define	PCI_IRQ_PIN	0x3d	/*  8 bit	Interrupt Pin */
-#define	PCI_MIN_GNT	0x3e	/*  8 bit	Min_Gnt */
-#define	PCI_MAX_LAT	0x3f	/*  8 bit	Max_Lat */
 /* Device Dependent Region */
 #define	PCI_OUR_REG	0x40	/* 32 bit (DV)	Our Register */
 #define	PCI_OUR_REG_1	0x40	/* 32 bit (ML)	Our Register 1 */
-- 
2.21.0

