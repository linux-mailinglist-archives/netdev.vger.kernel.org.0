Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B253DF103
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbhHCPDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbhHCPDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:03:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18331C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 08:03:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z4so25687410wrv.11
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 08:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mQPG2CGKszriVfUZbmrLajxCbYob3L00rBp8F0Qajpw=;
        b=hgwozPt86X6CfPEsk7Q9Zv/CBogyOUM2NyqIdLt4A3VjzXXkamdltRBCxvaj3gQcr7
         oC4RR0YYTYMTuixdxSAAsmlO4alEdiu2Qb+uRHQB7rXZY5MmZTZFql9NDQp86YLSWJR8
         qs3eoSW7ADCxMOe/mQsp5fmHOuAT8aWWHV/WY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mQPG2CGKszriVfUZbmrLajxCbYob3L00rBp8F0Qajpw=;
        b=UeBvTfbKj2BTu2tTk5xhw8j5nJ5ZvceCOBNXVjyj+DGcnP1tKw+UQY8ZyIPv2YmQJt
         O8kX+cgK2ddzoGHlgIBdEWFNE0KedT2AEx+Xvg9aDJrXtLuKmMR+s8XVpSxQ3ar5g/Tt
         SQP65XKlMcRtnS6LAt21z2rNsahMc4V3+bqUVFQ1tylUoNEETvOhAwGTYR1rbf+Vloma
         Ov431iN1NyAY+crWKUPtovxRYYQaHna6OzKSsCalmaNb6g3/blgREWYi+EZ0ry/JCxwW
         +pwEgHQIlDAWbIAzzA4j5RVF3vb3vhGt+OMnIpKlYPIR/aLhpCFiQdT/75XlyHrXRfYF
         5Mkw==
X-Gm-Message-State: AOAM530oenOk70BOdtAJqIT4/PikMJ0GH9n2jrTygUvm27UWN8sAAcdq
        tc7dXNvB5ImYysaMcrIh6Q1E73LjaBcdSg==
X-Google-Smtp-Source: ABdhPJwVvXECyRdkWB//TD3rEvfl+XO1sU5sILNRagVrY1okeAkdjfU3UCqy3Ag7I1J1pv4EqsXzbg==
X-Received: by 2002:adf:ef85:: with SMTP id d5mr23889607wro.372.1628003007619;
        Tue, 03 Aug 2021 08:03:27 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id l5sm16883641wrc.90.2021.08.03.08.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:03:27 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     paskripkin@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
Subject: [PATCH net 2/2] net: usb: pegasus: Remove the changelog and DRIVER_VERSION.
Date:   Tue,  3 Aug 2021 18:03:17 +0300
Message-Id: <20210803150317.5325-3-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803150317.5325-1-petko.manolov@konsulko.com>
References: <20210803150317.5325-1-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>

These are now deemed redundant.

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
---
 drivers/net/usb/pegasus.c | 30 ++----------------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 924be11ee72c..83260f283a9d 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -1,31 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  Copyright (c) 1999-2013 Petko Manolov (petkan@nucleusys.com)
+ *  Copyright (c) 1999-2021 Petko Manolov (petkan@nucleusys.com)
  *
- *	ChangeLog:
- *		....	Most of the time spent on reading sources & docs.
- *		v0.2.x	First official release for the Linux kernel.
- *		v0.3.0	Beutified and structured, some bugs fixed.
- *		v0.3.x	URBifying bulk requests and bugfixing. First relatively
- *			stable release. Still can touch device's registers only
- *			from top-halves.
- *		v0.4.0	Control messages remained unurbified are now URBs.
- *			Now we can touch the HW at any time.
- *		v0.4.9	Control urbs again use process context to wait. Argh...
- *			Some long standing bugs (enable_net_traffic) fixed.
- *			Also nasty trick about resubmiting control urb from
- *			interrupt context used. Please let me know how it
- *			behaves. Pegasus II support added since this version.
- *			TODO: suppressing HCD warnings spewage on disconnect.
- *		v0.4.13	Ethernet address is now set at probe(), not at open()
- *			time as this seems to break dhcpd.
- *		v0.5.0	branch to 2.5.x kernels
- *		v0.5.1	ethtool support added
- *		v0.5.5	rx socket buffers are in a pool and the their allocation
- *			is out of the interrupt routine.
- *		...
- *		v0.9.3	simplified [get|set]_register(s), async update registers
- *			logic revisited, receive skb_pool removed.
  */
 
 #include <linux/sched.h>
@@ -45,7 +21,6 @@
 /*
  * Version Information
  */
-#define DRIVER_VERSION "v0.9.3 (2013/04/25)"
 #define DRIVER_AUTHOR "Petko Manolov <petkan@nucleusys.com>"
 #define DRIVER_DESC "Pegasus/Pegasus II USB Ethernet driver"
 
@@ -912,7 +887,6 @@ static void pegasus_get_drvinfo(struct net_device *dev,
 	pegasus_t *pegasus = netdev_priv(dev);
 
 	strlcpy(info->driver, driver_name, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
 	usb_make_path(pegasus->usb, info->bus_info, sizeof(info->bus_info));
 }
 
@@ -1334,7 +1308,7 @@ static void __init parse_id(char *id)
 
 static int __init pegasus_init(void)
 {
-	pr_info("%s: %s, " DRIVER_DESC "\n", driver_name, DRIVER_VERSION);
+	pr_info("%s: " DRIVER_DESC "\n", driver_name);
 	if (devid)
 		parse_id(devid);
 	return usb_register(&pegasus_driver);
-- 
2.30.2

