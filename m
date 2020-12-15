Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57CC2DAEDD
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgLOOYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:24:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726844AbgLOOYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:24:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608042160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pUKbJcvmGnTc96V/R2bgLUiIHvvMZ+/c60rJIeR72Hw=;
        b=JSzDIAII+1p58q19aW0bXQKg1dyds87/l244g6Sn1S5+hoPNclezBei7F1gHBrurfWsvmm
        SU6Nn/9LUkuhrk5Ovn8C3UkaFTPIzcNQ0oAWicUlEgMDtv81bouIZO31TZNpF1V/p1Actt
        x7FK2NxEPcQPolcQFfdVyzp0AX7gf+k=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-b1lsZ7pAPKC3IGy6P8iTHQ-1; Tue, 15 Dec 2020 09:22:38 -0500
X-MC-Unique: b1lsZ7pAPKC3IGy6P8iTHQ-1
Received: by mail-qk1-f197.google.com with SMTP id u184so14906103qka.2
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 06:22:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pUKbJcvmGnTc96V/R2bgLUiIHvvMZ+/c60rJIeR72Hw=;
        b=gCxuDWb3USZH7+QNjJTRlO3wAkfcBF7dmbrJGaCjCEjJO/DQsVXwb1wTAcwX+MmtUD
         XJLrS+6ed7WQbjSSX4NjkFKM8yXmz2zTUZ+9mcbD6h30O70souBveNPvAAXPrLHrTPjQ
         +7W0l5q/6HV41QB+3zcr82Vk+h+aJRb01QqcLZVygeIuI946ArL/z0kDc6bjMfJPTqQJ
         Az5lTBUODprCSoqUxkOcSGWcpejm7NitknWi2NVcznp0MCcOAuXScU5ol5GdkCwXr4R/
         TU1vONblrXP+pnErgJ1X6M6NNZlKiuru0NsLQ79QI21Rxn3c1s21EKnSuYWNS7xlt9jj
         waog==
X-Gm-Message-State: AOAM530o7GmtNmsyi8XDV376XsVnOnE6wd4vYL2e/LmBW/34srOtwdfZ
        LzDyX/7YbUfyPGsflc3iYj4/CxrlRQOymNXPfJtmISSnzXP8LBP+yBJ1buAii1Ai96SStBrj3Qr
        v1ipNwue/Yzsq9LAv
X-Received: by 2002:a37:4dd1:: with SMTP id a200mr33611736qkb.457.1608042158366;
        Tue, 15 Dec 2020 06:22:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxD86vigPQxeKVNJ8G3uZAIqn29DpA0AIOv8HcBf/19gJFWtPT5dBQU3ESNkKupSSb5V8qu2A==
X-Received: by 2002:a37:4dd1:: with SMTP id a200mr33611721qkb.457.1608042158199;
        Tue, 15 Dec 2020 06:22:38 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id w30sm17101535qkw.24.2020.12.15.06.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 06:22:37 -0800 (PST)
From:   trix@redhat.com
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] atm: ambassador: remove h from printk format specifier
Date:   Tue, 15 Dec 2020 06:22:28 -0800
Message-Id: <20201215142228.1847161-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

See Documentation/core-api/printk-formats.rst.
h should no longer be used in the format specifier for printk.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/atm/ambassador.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index c039b8a4fefe..6b0fff8c0141 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -2169,7 +2169,7 @@ static void setup_pci_dev(struct pci_dev *pci_dev)
 		pci_lat = (lat < MIN_PCI_LATENCY) ? MIN_PCI_LATENCY : lat;
 
 	if (lat != pci_lat) {
-		PRINTK (KERN_INFO, "Changing PCI latency timer from %hu to %hu",
+		PRINTK (KERN_INFO, "Changing PCI latency timer from %u to %u",
 			lat, pci_lat);
 		pci_write_config_byte(pci_dev, PCI_LATENCY_TIMER, pci_lat);
 	}
@@ -2300,7 +2300,7 @@ static void __init amb_check_args (void) {
   unsigned int max_rx_size;
   
 #ifdef DEBUG_AMBASSADOR
-  PRINTK (KERN_NOTICE, "debug bitmap is %hx", debug &= DBG_MASK);
+  PRINTK (KERN_NOTICE, "debug bitmap is %x", debug &= DBG_MASK);
 #else
   if (debug)
     PRINTK (KERN_NOTICE, "no debugging support");
-- 
2.27.0

