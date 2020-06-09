Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BDD1F3B0F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 14:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgFIMro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 08:47:44 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:54248 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgFIMqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 08:46:31 -0400
Received: from Q.local (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id BF9701227;
        Tue,  9 Jun 2020 14:46:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1591706788;
        bh=jIDnNlqQO8hAVuTBSxCrpbpRndavULdtblkTlqt+A/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMQo4K5+weFVoq0+O9ilxiYdak5BJs+Zl0EZ4GXf3KB/gljQMgkHUHn9dZC+9GK+K
         bvqRyBw+URwzIVfZa7DNNq2crk9+6BP3ygsbK7ICnHBoERNcBHIYxzp04RPQoQH/Rp
         Ng5LBBrhbT65j0VTMzNMLLNoKR2mBA6zxfnEdxTA=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jiri Kosina <trivial@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        Shannon Nelson <snelson@pensando.io>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Wenwen Wang <wenwen@cs.uga.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        ath10k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH10K WIRELESS
        DRIVER),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS))
Subject: [PATCH 05/17] drivers: net: Fix trivial spelling
Date:   Tue,  9 Jun 2020 13:45:58 +0100
Message-Id: <20200609124610.3445662-6-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200609124610.3445662-1-kieran.bingham+renesas@ideasonboard.com>
References: <20200609124610.3445662-1-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The word 'descriptor' is misspelled throughout the tree.

Fix it up accordingly:
    decriptors -> descriptors

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/net/wan/lmc/lmc_main.c        | 2 +-
 drivers/net/wireless/ath/ath10k/usb.c | 2 +-
 drivers/net/wireless/ath/ath6kl/usb.c | 2 +-
 drivers/net/wireless/cisco/airo.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index a20f467ca48a..842def21e089 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -2063,7 +2063,7 @@ static void lmc_driver_timeout(struct net_device *dev, unsigned int txqueue)
     /*
      * Chip seems to have locked up
      * Reset it
-     * This whips out all our decriptor
+     * This whips out all our descriptor
      * table and starts from scartch
      */
 
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index b7daf344d012..05a620ff6fe2 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -824,7 +824,7 @@ static int ath10k_usb_setup_pipe_resources(struct ath10k *ar,
 
 	ath10k_dbg(ar, ATH10K_DBG_USB, "usb setting up pipes using interface\n");
 
-	/* walk decriptors and setup pipes */
+	/* walk descriptors and setup pipes */
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
 
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 53b66e9434c9..5372e948e761 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -311,7 +311,7 @@ static int ath6kl_usb_setup_pipe_resources(struct ath6kl_usb *ar_usb)
 
 	ath6kl_dbg(ATH6KL_DBG_USB, "setting up USB Pipes using interface\n");
 
-	/* walk decriptors and setup pipes */
+	/* walk descriptors and setup pipes */
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
 
diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 827bb6d74815..e3ad77666ba8 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -2450,7 +2450,7 @@ static void mpi_unmap_card(struct pci_dev *pci)
 
 /*************************************************************
  *  This routine assumes that descriptors have been setup .
- *  Run at insmod time or after reset  when the decriptors
+ *  Run at insmod time or after reset when the descriptors
  *  have been initialized . Returns 0 if all is well nz
  *  otherwise . Does not allocate memory but sets up card
  *  using previously allocated descriptors.
-- 
2.25.1

