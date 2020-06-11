Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5851F60BE
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 06:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgFKEHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 00:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgFKEHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 00:07:54 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0EFC08C5C1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 21:07:53 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k1so1719139pls.2
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 21:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=rHsS/xGFMbGmBYnBz1wkXDsgi4xw5sNPxE43/rjjC+M=;
        b=hAtskhse1S5Joo1cRvd0bANUjJX8Gk2rdGgJAXSGB1YIXPxeBYg04HZ5c1R3yCR8Kl
         s4S2cBm9wn4pUH7R2ZxsX/xByKq2ELmR28rlEtPNgMmVnBs0VSw4lGZwALC7bcCApcdp
         mPjWRqq0sbmXzp9iJuBTJLGZRqDhtnrRuEG/eHI8FXOx57VmuhKO30f4gLuyxoQjv+1J
         GkoGmSEUhZe22HRuPhFzgQUq3QoWpL8kvUqIJ/v9DvXxsLmtExhjlCd1z0LKXdwnHEc4
         dfTKeUaOwO21JeS2u9Bfb2St9g/hTVOzibqPnb+j9gkYR7CU/vqsvz9ho5qKjN577Fzc
         gn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rHsS/xGFMbGmBYnBz1wkXDsgi4xw5sNPxE43/rjjC+M=;
        b=okRp9Q83lsAPdaqHpdE9c1kBxLNzLefyXAtG7IHYwPGLAu3vt8tLjChQ+q1w4QtXDR
         N+qOG+YhuhvP3wonIpygiYimqJzXKNooOwra10tEFQJUHSQpl7vQUYGjbNgKkY6/5ERT
         sQBqUH5K7WunMyL3urT0nON6EfwdNNluqv4tL9kg75aydrO68bDH3xkn1Pvx1AHvNWrc
         4OmUW1gNJoATPvYg8m9d84apROmZ7llMYF4xoPxBwUzNElLjYHDJa0xfaTM84H/s0O2/
         0q92fBZS5Pkvjy2mOkBMwsQeP4ytwpfQPekVE6/xDN1ZGCw/lvWx7C30N6ZiGf3xWSTW
         PXJw==
X-Gm-Message-State: AOAM531FHajBf1Vck9JnqqhaKdhsHHXAk3Z25wVzSNJ9HtsFAM18nCOQ
        KH2mMphnf9ljCsWG+2Acbe9GEVJt5aM=
X-Google-Smtp-Source: ABdhPJzIPCVR8rS+oYdjHr/D2A15I9xfrUUCPiX1/WCyUvbcz8x8FtGAz4r4Kc+VME1P96tPLboGJQ==
X-Received: by 2002:a17:902:8ecc:: with SMTP id x12mr2395510plo.32.1591848473144;
        Wed, 10 Jun 2020 21:07:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n4sm1483536pfq.9.2020.06.10.21.07.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jun 2020 21:07:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: remove support for mgmt device
Date:   Wed, 10 Jun 2020 21:07:39 -0700
Message-Id: <20200611040739.4109-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We no longer support the mgmt device in the ionic driver,
so remove the device id and related code.

Fixes: b3f064e9746d ("ionic: add support for device id 0x1004")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h         |  2 --
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c |  6 ------
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c |  4 ----
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     | 13 -------------
 4 files changed, 25 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 23ccc0da2341..f5a910c458ba 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -17,7 +17,6 @@ struct ionic_lif;
 
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
-#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT	0x1004
 
 #define DEVCMD_TIMEOUT  10
 
@@ -42,7 +41,6 @@ struct ionic {
 	struct dentry *dentry;
 	struct ionic_dev_bar bars[IONIC_BARS_MAX];
 	unsigned int num_bars;
-	bool is_mgmt_nic;
 	struct ionic_identity ident;
 	struct list_head lifs;
 	struct ionic_lif *master_lif;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 60fc191a35e5..0ac6acbc5f31 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -15,7 +15,6 @@
 static const struct pci_device_id ionic_id_table[] = {
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF) },
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF) },
-	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT) },
 	{ 0, }	/* end of table */
 };
 MODULE_DEVICE_TABLE(pci, ionic_id_table);
@@ -225,9 +224,6 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, ionic);
 	mutex_init(&ionic->dev_cmd_lock);
 
-	ionic->is_mgmt_nic =
-		ent->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT;
-
 	/* Query system for DMA addressing limitation for the device. */
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(IONIC_ADDR_LEN));
 	if (err) {
@@ -252,8 +248,6 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	pci_set_master(pdev);
-	if (!ionic->is_mgmt_nic)
-		pcie_print_link_status(pdev);
 
 	err = ionic_map_bars(ionic);
 	if (err)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 273c889faaad..2d590e571133 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -77,10 +77,6 @@ int ionic_devlink_register(struct ionic *ionic)
 		return err;
 	}
 
-	/* don't register the mgmt_nic as a port */
-	if (ionic->is_mgmt_nic)
-		return 0;
-
 	devlink_port_attrs_set(&ionic->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
 			       0, false, 0, NULL, 0);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index fbc36e9e4729..9d8c969f21cb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -99,9 +99,6 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
 		return;
 
-	if (lif->ionic->is_mgmt_nic)
-		return;
-
 	link_status = le16_to_cpu(lif->info->status.link_status);
 	link_up = link_status == IONIC_PORT_OPER_STATUS_UP;
 
@@ -1193,10 +1190,6 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	netdev_features_t features;
 	int err;
 
-	/* no netdev features on the management device */
-	if (lif->ionic->is_mgmt_nic)
-		return 0;
-
 	/* set up what we expect to support by default */
 	features = NETIF_F_HW_VLAN_CTAG_TX |
 		   NETIF_F_HW_VLAN_CTAG_RX |
@@ -2594,12 +2587,6 @@ int ionic_lifs_register(struct ionic *ionic)
 {
 	int err;
 
-	/* the netdev is not registered on the management device, it is
-	 * only used as a vehicle for napi operations on the adminq
-	 */
-	if (ionic->is_mgmt_nic)
-		return 0;
-
 	INIT_WORK(&ionic->nb_work, ionic_lif_notify_work);
 
 	ionic->nb.notifier_call = ionic_lif_notify;
-- 
2.17.1

