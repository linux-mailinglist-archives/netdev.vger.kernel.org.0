Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92DA176DE5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgCCEQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:16:09 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41667 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgCCEQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:16:08 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so886547pgm.8
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cYfFRo4ChYawbVcRRzolQp332s8pe0/gWlieRE1m/lU=;
        b=JZR5u2Y6fqmP7ch3VGyLnAnUswlQ0Bg57IAlQfcMwA80m+FmaEXGFDaqq6OfFgzvDd
         W7N9fu0WkXFrOKhU7Hhsnonbwb260Pv/1GUkxhXOxXcerdYeOe6HOnSBEnp25RKKjVtr
         yQslbDQC0LXTav5MJGYcEP90x1+Se91mms8UCA+zaEKWS7z5RYLPkLweszgV0E1+oyl6
         s9/2hqMvuY9sZzH55WhPNtqoqIZ5lZZNPPqKzSFj9l4g6IhnJ/nwDVvN7Gbn/DMpcmtw
         i29usucRuY3mkjhcGYK/yfSBs9w8D5A6xkdDANsu6LP3FsiAIICguEXmNOJjuUProNth
         TnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cYfFRo4ChYawbVcRRzolQp332s8pe0/gWlieRE1m/lU=;
        b=ovK8BuNWp5r6mOY6GI1Vy1II6SqDiICSO+MW/MCvZ/Th/VQ1+yIto7mZtqdf8Dfe3e
         j2Xydx5dkHNO9DSJlbQHkR3yTKCYT/23JwADqzmqlz0Bhqf4VIpWLFvzWaJhltcb1GiH
         6itpbK6S8L6vb9JiMbS5reLT6Mwqlr2DkH71g24xkaEkJ+WouPcpOKgsm0Z4dAs+bvi3
         DOBbwM+8sFGKs9vMl5DVYUwEKZI2PxJLUSzaTA7OpCqQKK1ojq+xpnBVRqcpuQQwASoN
         pWwk6o9MJZ7ARpjWCwkBWgBTU6dwQqKbnyv/aV9KxAr/BfxQ9anDeNkDJyyy67K7qwC3
         /wBA==
X-Gm-Message-State: ANhLgQ1LMw+FxUByg+S1gmmRhio6htss/9bI/OtkxCtczqFA4NEIGcQp
        ///f7mdYpGc6z6UbGF0aUQ9dnU5nTuM=
X-Google-Smtp-Source: ADFU+vusifx1gRjcMODhaFC7ym0j91+rY4AclRfPAB3/K9JA4iORBQI1wnut8Ci3BHZhJ/mRtiwb0A==
X-Received: by 2002:aa7:8b17:: with SMTP id f23mr2296541pfd.197.1583208967123;
        Mon, 02 Mar 2020 20:16:07 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t7sm396682pjy.1.2020.03.02.20.16.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:16:06 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH net-next 8/8] ionic: drop ethtool driver version
Date:   Mon,  2 Mar 2020 20:15:45 -0800
Message-Id: <20200303041545.1611-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303041545.1611-1-snelson@pensando.io>
References: <20200303041545.1611-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the default kernel version in ethtool drv_info output
and drop the module version.

Cc: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h         | 1 -
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 1 -
 drivers/net/ethernet/pensando/ionic/ionic_main.c    | 7 +++----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index c8ff33da243a..1c720759fd80 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -12,7 +12,6 @@ struct ionic_lif;
 
 #define IONIC_DRV_NAME		"ionic"
 #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
-#define IONIC_DRV_VERSION	"0.20.0-k"
 
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index acd53e27d1ec..bea9b78e0189 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -86,7 +86,6 @@ static void ionic_get_drvinfo(struct net_device *netdev,
 	struct ionic *ionic = lif->ionic;
 
 	strlcpy(drvinfo->driver, IONIC_DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, IONIC_DRV_VERSION, sizeof(drvinfo->version));
 	strlcpy(drvinfo->fw_version, ionic->idev.dev_info.fw_version,
 		sizeof(drvinfo->fw_version));
 	strlcpy(drvinfo->bus_info, ionic_bus_info(ionic),
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index a8e3fb73b465..5428af885fa7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/utsname.h>
+#include <linux/vermagic.h>
 
 #include "ionic.h"
 #include "ionic_bus.h"
@@ -15,7 +16,6 @@
 MODULE_DESCRIPTION(IONIC_DRV_DESCRIPTION);
 MODULE_AUTHOR("Pensando Systems, Inc");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(IONIC_DRV_VERSION);
 
 static const char *ionic_error_to_str(enum ionic_status_code code)
 {
@@ -414,7 +414,7 @@ int ionic_identify(struct ionic *ionic)
 	memset(ident, 0, sizeof(*ident));
 
 	ident->drv.os_type = cpu_to_le32(IONIC_OS_TYPE_LINUX);
-	strncpy(ident->drv.driver_ver_str, IONIC_DRV_VERSION,
+	strncpy(ident->drv.driver_ver_str, UTS_RELEASE,
 		sizeof(ident->drv.driver_ver_str) - 1);
 
 	mutex_lock(&ionic->dev_cmd_lock);
@@ -558,8 +558,7 @@ int ionic_port_reset(struct ionic *ionic)
 
 static int __init ionic_init_module(void)
 {
-	pr_info("%s %s, ver %s\n",
-		IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION, IONIC_DRV_VERSION);
+	pr_info("%s %s\n", IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION);
 	ionic_debugfs_create();
 	return ionic_bus_register_driver();
 }
-- 
2.17.1

