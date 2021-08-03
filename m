Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6823A3DF3E4
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238196AbhHCRZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbhHCRZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:25:51 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098E5C061798
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 10:25:39 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k4so15321987wrc.0
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 10:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZtgNPYIMF2GH+kBEiYVWNNpqyFEpbchmbi2/jtU99g=;
        b=DUQgQ1QLi+T1hIGIVT1YaG/pDdtuuIjeMpcv9yblDCEuibRXixp4NZiH1D/BGnQ08f
         0lFsQevDaLGXgkSNzjHoy/xl4QEAuOKc66dwk8e6U8GabYP0z9il7ZlfnJff8VhVPHyJ
         BZyCNGQAYInGG/lJJAHcngO9XwN4HmK8d3SHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZtgNPYIMF2GH+kBEiYVWNNpqyFEpbchmbi2/jtU99g=;
        b=quOTTqc/GwoJHqE/MS5QJsBg9yaRtDfN4Yj5+qQUbpGvRXOxqeI34+c/PkOv4ZzosF
         gU3Dr24fi5Nwt8Te/c1aiFWEGwvDcMrUOzJsLpL9cLYe//p/k0t6olXty3lCvcmb/Mma
         xxDDT68eNDdr2657zBp8GfS9AOajAwn8NqI7qyvHq+omwDt5Hl9kmujORc0Q9c30EQY8
         XPifRsxTukpQX1q/micOpSdg91bYJKTvyebTBYegvZaPqvltYN0hpcb9TEwtstIzUd7Q
         hLNQZOs3GWLhoKbAEeJ3FZErQsBwbfnNU8TgVaKB0nKUqFSsiAzac9v1xdIUugsHlbND
         2EWA==
X-Gm-Message-State: AOAM530qH5c8SseXEUaxzvnIj+hf5X43encJ6Mce+WlAnELvlnYBXUfq
        zJXuDzjuLcF0mgwHMW7SbTaNulUWau+l8A==
X-Google-Smtp-Source: ABdhPJxPnIT2g6MrRP1wmlmOzlaYcqr2AKbwg5vdhYveNQZ11lhlqAHU1Zm4XsZcHrz+DFyszd2Dog==
X-Received: by 2002:adf:f847:: with SMTP id d7mr24805041wrq.352.1628011538517;
        Tue, 03 Aug 2021 10:25:38 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id e5sm18489190wrr.36.2021.08.03.10.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:25:38 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     paskripkin@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Petko Manolov <petkan@nucleusys.com>
Subject: [PATCH net v3 2/2] net: usb: pegasus: Remove the changelog and DRIVER_VERSION.
Date:   Tue,  3 Aug 2021 20:25:24 +0300
Message-Id: <20210803172524.6088-3-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803172524.6088-1-petko.manolov@konsulko.com>
References: <20210803172524.6088-1-petko.manolov@konsulko.com>
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
index 22353bab76c8..f18b03be1b87 100644
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
 
@@ -914,7 +889,6 @@ static void pegasus_get_drvinfo(struct net_device *dev,
 	pegasus_t *pegasus = netdev_priv(dev);
 
 	strlcpy(info->driver, driver_name, sizeof(info->driver));
-	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
 	usb_make_path(pegasus->usb, info->bus_info, sizeof(info->bus_info));
 }
 
@@ -1338,7 +1312,7 @@ static void __init parse_id(char *id)
 
 static int __init pegasus_init(void)
 {
-	pr_info("%s: %s, " DRIVER_DESC "\n", driver_name, DRIVER_VERSION);
+	pr_info("%s: " DRIVER_DESC "\n", driver_name);
 	if (devid)
 		parse_id(devid);
 	return usb_register(&pegasus_driver);
-- 
2.30.2

