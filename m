Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35F6166037
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgBTO7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBTO7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:21 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4E1B206F4;
        Thu, 20 Feb 2020 14:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210761;
        bh=+JIpHlGXogS4+daEblPn5BSF0HuOG4JYDa5oxAD5hew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMc6OSlVHNOD4G8o+sA/7hBAc/U0fMuvAVEGqNGxz8ZL+mpVvLeiksWG1e4quAC96
         HnhRNiHIKU5ChU+nUCXPcUuEctd7ayiOlKJZvKwu3RHIbydP2vOneLdU4hhfq6DuO3
         ac1pai2wJFI9gusl0noVi5ueEYn8h49bdnuE+3Oo=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 07/16] net/alacritech: Delete driver version
Date:   Thu, 20 Feb 2020 16:58:46 +0200
Message-Id: <20200220145855.255704-8-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220145855.255704-1-leon@kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Use standard variant of the driver version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/alacritech/slicoss.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index 9daef4c8feef..6234fcd844ee 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -26,7 +26,6 @@
 #include "slic.h"

 #define DRV_NAME			"slicoss"
-#define DRV_VERSION			"1.0"

 static const struct pci_device_id slic_id_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ALACRITECH,
@@ -1533,7 +1532,6 @@ static void slic_get_drvinfo(struct net_device *dev,
 	struct slic_device *sdev = netdev_priv(dev);

 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(sdev->pdev), sizeof(info->bus_info));
 }

@@ -1852,4 +1850,3 @@ module_pci_driver(slic_driver);
 MODULE_DESCRIPTION("Alacritech non-accelerated SLIC driver");
 MODULE_AUTHOR("Lino Sanfilippo <LinoSanfilippo@gmx.de>");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
--
2.24.1

