Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B745F629B3
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390589AbfGHTe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:34:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50464 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730494AbfGHTe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:34:58 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so678477wml.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c/VoOijD/o/a9S7SAtsd4MVibZj/e2rPBRywd/KNKUU=;
        b=Jej8YDGPAZ3xqHs9kE10RzEfLg0j7nEbScK/D57+/wIm2KVKybavI7HiCmmixVEFhG
         CMDepNmV4BKZGDzzSxJYfLiX0c7EUvugfCOyd8gKHNKauQqra7wLAVg79kQeB6c7/nZe
         4BLP6TEJlMbfYbPU2tGqCsnjTvBIorSJuq2CihpC2mGlwd3Hf4mlealYM9QfbV9WHpjK
         qLsvq+cIX856AslbT4qHdP+j+gylQvhabqInxWZvdm+BYWV1xUjC2I1OPCvazebJqAU8
         WoJrSSC5ZSVR7mSBalxAFRIhHPSSmDDQ1r6W6s9101oMYOF+HE0yuGET2nia6HTaAnIA
         tEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c/VoOijD/o/a9S7SAtsd4MVibZj/e2rPBRywd/KNKUU=;
        b=WnjQbiRusrVrS/QcpE6lbSw1N2nvSlPeruf87gTh9EHpWP3P+Qfwgdr/XbIgruSZ9Z
         aw7Q0vrLvJbfC1CGW4KErJkZQCPV4ArldcS3Oy2iGmLaflA+CEt+Syi+pLwd40g8l2Uv
         s6tMBcPmTLvAM1TVGFm6YAYzGokVEGFirYXxh/EzKxHKO7kiR8mxrQipyg61KZK6WJLY
         0uAXxDC1Q4Wy3VHx6GQCRVxASMWYwqFpBkuFnnFRXLTOrexA/DrnBaLiS+GPGT1BZmNQ
         eWRATXDP/AIr7mN03iWuIuxYRkf4jii+7YXTSjSrjtFA41ECzeVYpnm74KXOkBXj3l3m
         VgPQ==
X-Gm-Message-State: APjAAAXeVMPgCGkLc10wxbwOqlGvG/6dNf39RbphKc2BTTbklSI76pO/
        61BZlF3LjYvl/RKek/UsRqI0bA==
X-Google-Smtp-Source: APXvYqxudTwX0F1weUky6q85PS7Fiho0hKGuacZFp4xSqQf0r2gqyeXNVYmoyDtgSscv4QXhfxY05w==
X-Received: by 2002:a1c:d185:: with SMTP id i127mr18572929wmg.63.1562614495042;
        Mon, 08 Jul 2019 12:34:55 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e3sm5495750wrt.93.2019.07.08.12.34.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:34:54 -0700 (PDT)
Date:   Mon, 8 Jul 2019 21:34:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 19/19] ionic: Add basic devlink interface
Message-ID: <20190708193454.GF2282@nanopsycho.orion>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-20-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708192532.27420-20-snelson@pensando.io>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 08, 2019 at 09:25:32PM CEST, snelson@pensando.io wrote:
>Add a devlink interface for access to information that isn't
>normally available through ethtool or the iplink interface.
>
>Example:
>	$ ./devlink -j -p dev info pci/0000:b6:00.0
>	{
>	    "info": {
>		"pci/0000:b6:00.0": {
>		    "driver": "ionic",
>		    "serial_number": "FLM18420073",
>		    "versions": {
>			"fixed": {
>			    "fw_version": "0.11.0-50",
>			    "fw_status": "0x1",
>			    "fw_heartbeat": "0x716ce",
>			    "asic_type": "0x0",
>			    "asic_rev": "0x0"
>			}
>		    }
>		}
>	    }
>	}
>
>Signed-off-by: Shannon Nelson <snelson@pensando.io>
>---
> drivers/net/ethernet/pensando/ionic/Makefile  |  2 +-
> drivers/net/ethernet/pensando/ionic/ionic.h   |  1 +
> .../ethernet/pensando/ionic/ionic_bus_pci.c   |  7 ++
> .../ethernet/pensando/ionic/ionic_devlink.c   | 89 +++++++++++++++++++
> .../ethernet/pensando/ionic/ionic_devlink.h   | 12 +++
> 5 files changed, 110 insertions(+), 1 deletion(-)
> create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>
>diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
>index 4f3cfbf36c23..ce187c7b33a8 100644
>--- a/drivers/net/ethernet/pensando/ionic/Makefile
>+++ b/drivers/net/ethernet/pensando/ionic/Makefile
>@@ -5,4 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
> 
> ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_ethtool.o \
> 	   ionic_lif.o ionic_rx_filter.o ionic_txrx.o ionic_debugfs.o \
>-	   ionic_stats.o
>+	   ionic_stats.o ionic_devlink.o
>diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
>index cd08166f73a9..a0034bc5b4a1 100644
>--- a/drivers/net/ethernet/pensando/ionic/ionic.h
>+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>@@ -44,6 +44,7 @@ struct ionic {
> 	DECLARE_BITMAP(intrs, INTR_CTRL_REGS_MAX);
> 	struct work_struct nb_work;
> 	struct notifier_block nb;
>+	struct devlink *dl;
> };
> 
> struct ionic_admin_ctx {
>diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>index 98c12b770c7f..a8c99254489f 100644
>--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>@@ -10,6 +10,7 @@
> #include "ionic_bus.h"
> #include "ionic_lif.h"
> #include "ionic_debugfs.h"
>+#include "ionic_devlink.h"
> 
> /* Supported devices */
> static const struct pci_device_id ionic_id_table[] = {
>@@ -212,9 +213,14 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> 		goto err_out_deinit_lifs;
> 	}
> 
>+	err = ionic_devlink_register(ionic);
>+	if (err)
>+		dev_err(dev, "Cannot register devlink (ignored): %d\n", err);
>+
> 	return 0;
> 
> err_out_deinit_lifs:
>+	ionic_devlink_unregister(ionic);
> 	ionic_lifs_deinit(ionic);
> err_out_free_lifs:
> 	ionic_lifs_free(ionic);
>@@ -247,6 +253,7 @@ static void ionic_remove(struct pci_dev *pdev)
> 	struct ionic *ionic = pci_get_drvdata(pdev);
> 
> 	if (ionic) {
>+		ionic_devlink_unregister(ionic);
> 		ionic_lifs_unregister(ionic);
> 		ionic_lifs_deinit(ionic);
> 		ionic_lifs_free(ionic);
>diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>new file mode 100644
>index 000000000000..fbbfcdde292f
>--- /dev/null
>+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>@@ -0,0 +1,89 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>+
>+#include <linux/module.h>
>+#include <linux/netdevice.h>
>+
>+#include "ionic.h"
>+#include "ionic_bus.h"
>+#include "ionic_lif.h"
>+#include "ionic_devlink.h"
>+
>+struct ionic_devlink {
>+	struct ionic *ionic;
>+};
>+
>+static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
>+			     struct netlink_ext_ack *extack)
>+{
>+	struct ionic *ionic = *(struct ionic **)devlink_priv(dl);
>+	struct ionic_dev *idev = &ionic->idev;
>+	char buf[16];
>+	u32 val;
>+
>+	devlink_info_driver_name_put(req, DRV_NAME);
>+
>+	devlink_info_version_fixed_put(req, "fw_version",
>+				       idev->dev_info.fw_version);
>+
>+	val = ioread8(&idev->dev_info_regs->fw_status);
>+	snprintf(buf, sizeof(buf), "0x%x", val);
>+	devlink_info_version_fixed_put(req, "fw_status", buf);
>+
>+	val = ioread32(&idev->dev_info_regs->fw_heartbeat);
>+	snprintf(buf, sizeof(buf), "0x%x", val);
>+	devlink_info_version_fixed_put(req, "fw_heartbeat", buf);
>+
>+	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_type);
>+	devlink_info_version_fixed_put(req, "asic_type", buf);
>+
>+	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_rev);
>+	devlink_info_version_fixed_put(req, "asic_rev", buf);
>+
>+	devlink_info_serial_number_put(req, idev->dev_info.serial_num);
>+
>+	return 0;
>+}
>+
>+static const struct devlink_ops ionic_dl_ops = {
>+	.info_get	= ionic_dl_info_get,
>+};
>+
>+int ionic_devlink_register(struct ionic *ionic)
>+{
>+	struct devlink *dl;
>+	struct ionic **ip;
>+	int err;
>+
>+	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic *));

Oups. Something is wrong with your flow. The devlink alloc is allocating
the structure that holds private data (per-device data) for you. This is
misuse :/

You are missing one parent device struct apparently.

Oh, I think I see something like it. The unused "struct ionic_devlink".


>+	if (!dl) {
>+		dev_warn(ionic->dev, "devlink_alloc failed");
>+		return -ENOMEM;
>+	}
>+
>+	ip = (struct ionic **)devlink_priv(dl);
>+	*ip = ionic;
>+	ionic->dl = dl;
>+
>+	err = devlink_register(dl, ionic->dev);
>+	if (err) {
>+		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
>+		goto err_dl_free;
>+	}
>+
>+	return 0;
>+
>+err_dl_free:
>+	ionic->dl = NULL;
>+	devlink_free(dl);
>+	return err;
>+}
>+
>+void ionic_devlink_unregister(struct ionic *ionic)
>+{
>+	if (!ionic->dl)
>+		return;
>+
>+	devlink_unregister(ionic->dl);
>+	devlink_free(ionic->dl);
>+}
>diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>new file mode 100644
>index 000000000000..35528884e29f
>--- /dev/null
>+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
>@@ -0,0 +1,12 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>+
>+#ifndef _IONIC_DEVLINK_H_
>+#define _IONIC_DEVLINK_H_
>+
>+#include <net/devlink.h>
>+
>+int ionic_devlink_register(struct ionic *ionic);
>+void ionic_devlink_unregister(struct ionic *ionic);
>+
>+#endif /* _IONIC_DEVLINK_H_ */
>-- 
>2.17.1
>
