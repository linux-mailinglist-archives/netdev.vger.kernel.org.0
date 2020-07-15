Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19972220D5A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbgGOMs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:48:58 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:60220 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731318AbgGOMsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:48:55 -0400
Received: from Q.local (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2101FE41;
        Wed, 15 Jul 2020 14:48:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1594817331;
        bh=kFIqceJw8NJZHT+p2m2bRFvh6h9ZXyO/LjXEWTcfRHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqQHNtg/IkjKuIO0R4p0XOGb/rHonJ4HsTDFkXA/K42MVA2dd7Z7R8WTOViv82kyY
         y5aaX4/rlvjNjECzMX72xCkoYu4CZcVOpO3kQd92tUFZGCYOTWUIH5xw+wxFwp04r4
         OJ31alJ95QdwDj+3pitjPlvHijwo87233OzrJjGc=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     trivial@kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wenwen Wang <wenwen@cs.uga.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        ath10k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH10K WIRELESS
        DRIVER),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 4/8] drivers: net: wireless: Fix trivial spelling
Date:   Wed, 15 Jul 2020 13:48:35 +0100
Message-Id: <20200715124839.252822-5-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200715124839.252822-1-kieran.bingham+renesas@ideasonboard.com>
References: <20200715124839.252822-1-kieran.bingham+renesas@ideasonboard.com>
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
 drivers/net/wireless/ath/ath10k/usb.c | 2 +-
 drivers/net/wireless/ath/ath6kl/usb.c | 2 +-
 drivers/net/wireless/cisco/airo.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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

