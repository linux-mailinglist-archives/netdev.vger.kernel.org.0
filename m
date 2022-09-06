Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD545AEC45
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242043AbiIFO0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241802AbiIFOWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:22:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A583F8B9B9;
        Tue,  6 Sep 2022 06:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662472320; x=1694008320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b85nclneF9BX61RtcZxdbpTMJV7DSQfjZ+m4p4X2wC0=;
  b=PFnp4etxuMfRKm6Gohpt9to0dyMpl4kB8NmA2jDUuKfDJzLiUYtlIo/Q
   wGkdCbPF4M748vBPFoeTIO0x+y6mn+wmKZWT/rvlzxqC9SlKrErGvjL/P
   sWJfXyoUrty7tSz5qn5Xdn7Awou5R0rwQ0dsbZax3S6uMrBeRkP+F673Q
   xAaASbbMcU9qnDPZtUoXnhFZjQvS7E7eNLDjqCi3QvUHbwq0RaLZbhL4w
   +YomzI3LvfGz2++I0xb+zy+TGO+dF0pnGf0RgblER3FOqLM3EKtXqJq3j
   usSz7lntR/NV8DCPzqQW1EFP4uizV1WShNLVzxnCzZXbldV1QiJmhPwDu
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="297908809"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="297908809"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 06:50:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="756372522"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 06 Sep 2022 06:49:54 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 5469186; Tue,  6 Sep 2022 16:50:10 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Gene Chen <gene_chen@richtek.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lee Jones <lee@kernel.org>
Subject: [PATCH v3 01/11] leds: add missing includes and forward declarations in leds.h
Date:   Tue,  6 Sep 2022 16:49:54 +0300
Message-Id: <20220906135004.14885-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

