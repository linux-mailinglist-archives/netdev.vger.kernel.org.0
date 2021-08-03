Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4913DF255
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhHCQTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbhHCQTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:19:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F19C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:19:08 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n11so12812647wmd.2
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4zNuprb0CCbLcX0BCO/Vmuhc+tre2dbgOKUzdyp12/8=;
        b=hjoP0epXFXEUTdAzy9jr1qOqhtHMOXShZgeWjgylfBWmLL1XCwR0feUNTBX59OVqeI
         jvSLp8tk2XNqb4PUFDAf2CQ1Q73KA5P0eJu8qa9iRQ95kHQzhocQ8SnP0lT/zaGDf5Gm
         nBQehJ982UyeBZuWYQ4A9Rqddn2XfAMPC7DNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4zNuprb0CCbLcX0BCO/Vmuhc+tre2dbgOKUzdyp12/8=;
        b=Ox0nFG0qU+pg8dPsjQrhSvUKn+yUFYRsDwX46zZkZRmbr4iQJcwVqsoXWj7+HvTxE/
         BW3dVqJqFL+2IqaFhpiAKrCP+40Iuekxk9sNyteXSjq97o2LX1/42Un2w1W19HdarX/k
         /HN0Pft7Ol0IZY3vWU2TMGNOyMK9aq6w51oV1mjPvGbc+10yUMvi4RsGSlPA3aYNUn+T
         G2CDVxmFilmZ/p/DnuKo/8f6/uj9/kwAgc88jTTNxdrDF05h0/FPqmDxkQU2L+TUdkUN
         yw+BDJjVm2mXGau0Be9HQ1P2mFIhhvauw6bxkrtoFwwyPtsiWwcw+I1hKqkKn5QaSCSP
         Bnaw==
X-Gm-Message-State: AOAM530upDphULhJ8EyM8mHk5vpZpayFv+uKkFmlAOD7X+BkAT0T+WRB
        z8VOUFYIVCzvmqBzef1VNUnEMcuNEk1r9A==
X-Google-Smtp-Source: ABdhPJyvOyKqWf9fXfMuz0ncs0zdBIRehZ3xYv7gfsT919dUaELAtaJAoifJ/C2dHUgVFTspXxIBcg==
X-Received: by 2002:a1c:19c1:: with SMTP id 184mr2217369wmz.98.1628007547274;
        Tue, 03 Aug 2021 09:19:07 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id d24sm3028223wmb.42.2021.08.03.09.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:19:07 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     paskripkin@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
Subject: [PATCH net v2 2/2] Remove the changelog and DRIVER_VERSION.
Date:   Tue,  3 Aug 2021 19:18:53 +0300
Message-Id: <20210803161853.5904-3-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803161853.5904-1-petko.manolov@konsulko.com>
References: <20210803161853.5904-1-petko.manolov@konsulko.com>
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
index 06e3ae6209b0..e48b59fc7326 100644
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
 
@@ -1336,7 +1310,7 @@ static void __init parse_id(char *id)
 
 static int __init pegasus_init(void)
 {
-	pr_info("%s: %s, " DRIVER_DESC "\n", driver_name, DRIVER_VERSION);
+	pr_info("%s: " DRIVER_DESC "\n", driver_name);
 	if (devid)
 		parse_id(devid);
 	return usb_register(&pegasus_driver);
-- 
2.30.2

