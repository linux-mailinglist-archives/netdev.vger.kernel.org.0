Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B43178977
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgCDEUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:20:31 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52764 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgCDEUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:20:30 -0500
Received: by mail-pj1-f66.google.com with SMTP id lt1so312540pjb.2
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 20:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RtIYhhu7vszHkRer90QnW0fSQoRZY8VL5n9Nyh6LaXc=;
        b=Y5asKhSFRQgBVo7i1EGAIT7YuDSDA20t2VHNWsn0691ETCFnzMWoE886n4w+R8IYSF
         lIezhJ2NRISYbCiFf0N7sgMd0qg9rfTX8g55Pfc83jns3yk/UQOjikvQcmOJCLkXu3hp
         biUdN67ABC4mBx7wwCgZQPzDMHge3qL6UMzlW2+IzUp4j5emHuMv+TBCMTorT4LQfj2A
         mC7U232zgRjbB8pR0hrCfObEJi4henA6IJvMrhRy4ya96BhhBaN6O6bHFJgISxdlmQZi
         FZruhmDxC7n/5qGEMKNKx/WztoRMHFoW0y7mXH6wgcpiTD2SBIrP4C0L+FT1bTClPzrL
         oJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RtIYhhu7vszHkRer90QnW0fSQoRZY8VL5n9Nyh6LaXc=;
        b=rwMf50b7nwZSf6hpznjuLmyuhc/saWzKpn5iX/9fEtbAEZYtfCDMe3QYcd+f9drZjH
         I6ZKsiGcTZGcwe6deFUgTvWJbRv49WXHsEUwmmAgVdDo5x4l2mfaewpKh8WXOpqTAauM
         z/LXKB6Z9XPbpeSB6p8s18MhnISmAb/SJNcyc5mAGidGbtFXn+yVFxfRCglvR6KJDz5D
         Zvm1GRyGBhTV/Wb/hzJe0qr8UPAGgMOSIkPVNuWUiSznb/8qiPxntkQ49ZfPpOZNT3+a
         X4tPVB+ONHhL8/mUNyILlJJPKCdM48oCPMBm0+LOG1RWs50/LKpnPiWLDsoJo2MgoSQ9
         D/aw==
X-Gm-Message-State: ANhLgQ0xwkiCC/oUHDbE8ZiEOEWqKf+37USLifKw+mtTuNJ7lCSKauAB
        KcN+mO3WIen2hgAArAP8Pkd04g==
X-Google-Smtp-Source: ADFU+vtCI6kGEhrskL1+VzeRVyU67YSR4rKM/DoQQjHbUrY8CfQvP1fOMWCzAGnIAYacvhDMk0B/eA==
X-Received: by 2002:a17:90a:e795:: with SMTP id iz21mr1037315pjb.81.1583295629248;
        Tue, 03 Mar 2020 20:20:29 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm671702pjo.28.2020.03.03.20.20.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:20:28 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH v2 net-next 8/8] ionic: drop ethtool driver version
Date:   Tue,  3 Mar 2020 20:20:13 -0800
Message-Id: <20200304042013.51970-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304042013.51970-1-snelson@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
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

