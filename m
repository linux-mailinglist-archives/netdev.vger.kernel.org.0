Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E364F65C091
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbjACNMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237662AbjACNMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:12:37 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10429FD3E;
        Tue,  3 Jan 2023 05:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672751557; x=1704287557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b85nclneF9BX61RtcZxdbpTMJV7DSQfjZ+m4p4X2wC0=;
  b=And5CoS5AYO+F1LcLzpVB1+b6JPQ9qKguZD102C7kdEMHGTNk3g+RmKh
   34ZrnkRi88Dw+qBYXi5TfADU44h4cmT/ySKDxRVdAU/miISoamFS+STkU
   mgRqfUBOu3M5BI8OUcE4EStmS64hhaiEWyPslf5ZKJ4kQudQvUEq9j028
   UCRGVPVlfzgJOGjA6tMkbKYRgNwnaPUAtLVb3FXxWFjF3mQPtQVvk5SE4
   yfp0gS9lnbi0tRIFvtuOMqn1xk9u/1f8Duea5tLWY+Pg9p2UMGc8vElAY
   fnTdTY61mKMyA3c2B9YrZ8nl3PFZaYRE8LASk86VLN7FgADN2G0eX31jr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="322887924"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="322887924"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 05:12:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="685397926"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="685397926"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 03 Jan 2023 05:12:28 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 79000F4; Tue,  3 Jan 2023 15:13:00 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gene Chen <gene_chen@richtek.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v4 01/11] leds: add missing includes and forward declarations in leds.h
Date:   Tue,  3 Jan 2023 15:12:46 +0200
Message-Id: <20230103131256.33894-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing includes and forward declarations to leds.h. While at it,
replace headers by forward declarations and vise versa.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/leds.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index ba4861ec73d3..499aea1e59b9 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -10,17 +10,21 @@
 
 #include <dt-bindings/leds/common.h>
 #include <linux/device.h>
-#include <linux/kernfs.h>
-#include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
+#include <linux/types.h>
 #include <linux/workqueue.h>
 
-struct device;
-struct led_pattern;
+struct attribute_group;
 struct device_node;
+struct fwnode_handle;
+struct gpio_desc;
+struct kernfs_node;
+struct led_pattern;
+struct platform_device;
+
 /*
  * LED Core
  */
@@ -508,7 +512,6 @@ struct led_properties {
 	const char	*label;
 };
 
-struct gpio_desc;
 typedef int (*gpio_blink_set_t)(struct gpio_desc *desc, int state,
 				unsigned long *delay_on,
 				unsigned long *delay_off);
-- 
2.35.1

