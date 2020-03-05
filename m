Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC8D179F1C
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgCEFXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:23:37 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51616 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgCEFXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:23:36 -0500
Received: by mail-pj1-f68.google.com with SMTP id l8so1973197pjy.1
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RtIYhhu7vszHkRer90QnW0fSQoRZY8VL5n9Nyh6LaXc=;
        b=bzY35VHjsxqzKzo6AJYy3FQVxOLMUCw1rJP9Y46h4kaHKTJyB6REW/C2z20Sdq/2nU
         4fFPpzcACKhJARLRLt8IiOFIFQyHd/QRwwBD5Ud95tZlMVvI+gAF9PL7kpwhkMEY1XXN
         2Tn6JH1FaembMaBZtbKzRirq0KT9lU3zwXwNnpVERZDboSujYtfN5ZK6nJQmpO+bRtwM
         EAEW1KfZAJP8M0zhYRiap3Er3i3fxd9cBd6/MNdwHpuDRZJq68ea/A3eQUSXqRjZSyfy
         rwcLirti/+S9FZOrE0dm8syWr8FBodqjh+o8UxVBHKl/VAbuLXnNdsDBfehoZgR242bG
         Z/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RtIYhhu7vszHkRer90QnW0fSQoRZY8VL5n9Nyh6LaXc=;
        b=Va2/iJkZonT1UrpKnhWyDaf0XY9HtCixhvEDsTCZaHp+A7LPmpqAsw4EvTfb8Fumeg
         IU+6i247yGYyv7JmMXEBpHZwx9x5h9/1qUDENye0nhPStfqde4O2AQ91U/pHv/JYq5f/
         FzAEbpy4/BQd07HEtTtfB5WEg9UObMtIyOELx4I5awNp4J+3nvFiZ7ZqIP1K+WJ/wiUE
         9qbm+fhppo2Ana/i4SoF4ph7heFFty+oWGkyF1D0ZlCCktQnMzcwScr7wRNvdAd/WpNM
         oodkPvEKYo+EVm3Ov2wovdmuwMayKR7Xhj6S5mu6bPFKqeW7EoOGxW95Wc5AtW5CoLiT
         QlkA==
X-Gm-Message-State: ANhLgQ3qJD99VfGs3QiHMMsSWAvwiqh/Pur8X51Yakguni0XbTGGWo4h
        e8foX+iQQz/JaF4ZqcUAjaGYjGYnH7I=
X-Google-Smtp-Source: ADFU+vsIk7Byz2afXRc3YSO/A/G9/suB8o965LpXXq68a0j99OQflpT2gvDj7Wo6J7fttGirMNnrhw==
X-Received: by 2002:a17:902:6ac2:: with SMTP id i2mr6241326plt.221.1583385815549;
        Wed, 04 Mar 2020 21:23:35 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h2sm29337759pgv.40.2020.03.04.21.23.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 21:23:35 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH v3 net-next 8/8] ionic: drop ethtool driver version
Date:   Wed,  4 Mar 2020 21:23:19 -0800
Message-Id: <20200305052319.14682-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305052319.14682-1-snelson@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
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
 drivers/net/ethernet/pensando/ionic/ionic_main.c    | 6 ++----
 3 files changed, 2 insertions(+), 6 deletions(-)

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
index a8e3fb73b465..e4a76e66f542 100644
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
@@ -558,8 +558,6 @@ int ionic_port_reset(struct ionic *ionic)
 
 static int __init ionic_init_module(void)
 {
-	pr_info("%s %s, ver %s\n",
-		IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION, IONIC_DRV_VERSION);
 	ionic_debugfs_create();
 	return ionic_bus_register_driver();
 }
-- 
2.17.1

