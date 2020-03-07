Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2064117CA18
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCGBE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:04:27 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34105 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgCGBE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 20:04:26 -0500
Received: by mail-pj1-f65.google.com with SMTP id gc16so2168047pjb.1
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 17:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bPVg89V57/nOcUKwqCSha9bVmOVxG6rigL/iaVANxr8=;
        b=f+zpwgTbdsqLwOF4UMXIcIOt7OeFkyKeUl9yO47rHpEJyoKsJaG5rvKY1+HqSjt/05
         1PcyAfRA2ULycWmMEXVFNvnRqnOQd5CX2D0PrvgdfzJ5DvSOMzEq0fXyNUdlffKjsOeK
         kuJa9RvpIzampT5As8qfNbban5BagAYlX2cqpSJPnPAIDKK6DUjFRu5GTvgj/Az0f7Xr
         tbS7TsoUwR/a4LwV9F8oxBmXen9sIQoorrI8FgVWTZCXV4jVCUgYOO8AHwL695yfs27Z
         Xlf2ne2Vw3Cz5974chIRQfZovFyxoddAKpE1eBcKepf6sSRj6Bh5vy86WepStHCZfRZN
         au7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bPVg89V57/nOcUKwqCSha9bVmOVxG6rigL/iaVANxr8=;
        b=IlbOUZsbLSCs7cRQgwZx+AJhLTH2mCRyhW16feLC7SiFY9MpwKWt2IVYOn9mGXcYpC
         gs5uWOFGRKao6Dz2SkpCKmFLy9JCI+1IcwEajZXaw9ZNF0TyM8kx00JluAL4Fa5yahrV
         lXOBp0dJjwsw72pywfkxa6x2xD6dA8N19H2ekoUuj10B9kQfJcuW4haHuDEtW+JAD99q
         pA7lc+zoggDzi6hcNZuhZAsH41veTKPYu3OOBtVLMa0GnZQ8fFTkKXj43XlYaE2eUpjr
         q9JuILVu9RubWvv0Qxd4gbaZ7MNQwAokvlAvXajq++c2895qYFzDdinHDrnoKXp++fGa
         gk0w==
X-Gm-Message-State: ANhLgQ0Ixa2Fn9g7yaMOBUbjI43nU+f84FgLfronbH2EkL5nyKqw8utK
        ajbLqqTZjRiyrp0vc4jWyPx8cww7/TA=
X-Google-Smtp-Source: ADFU+vt8LKUhAgEoLEXoVFQMv4CbHYLcSmrlCXmY5rfusZbNJGZ7i+DKiFJmZGadjAekyEb1IAkzqw==
X-Received: by 2002:a17:90a:4487:: with SMTP id t7mr6277973pjg.104.1583543064563;
        Fri, 06 Mar 2020 17:04:24 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o66sm23224949pfb.93.2020.03.06.17.04.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Mar 2020 17:04:24 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH v4 net-next 8/8] ionic: drop ethtool driver version
Date:   Fri,  6 Mar 2020 17:04:08 -0800
Message-Id: <20200307010408.65704-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307010408.65704-1-snelson@pensando.io>
References: <20200307010408.65704-1-snelson@pensando.io>
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
index 59f8385d591f..23ccc0da2341 100644
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

