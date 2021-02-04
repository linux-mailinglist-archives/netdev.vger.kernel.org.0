Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E836A30EFF7
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 10:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhBDJua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 04:50:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41749 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbhBDJu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 04:50:28 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l7bGi-0001fi-6J; Thu, 04 Feb 2021 09:49:44 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dwc-xlgmac: Fix spelling mistake in function name
Date:   Thu,  4 Feb 2021 09:49:44 +0000
Message-Id: <20210204094944.51460-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in the function name alloc_channles_and_rings.
Fix this by renaming it to alloc_channels_and_rings.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c | 2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-net.c  | 2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
index 8c4195a9a2cc..589797bad1f9 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-desc.c
@@ -634,7 +634,7 @@ static int xlgmac_map_tx_skb(struct xlgmac_channel *channel,
 
 void xlgmac_init_desc_ops(struct xlgmac_desc_ops *desc_ops)
 {
-	desc_ops->alloc_channles_and_rings = xlgmac_alloc_channels_and_rings;
+	desc_ops->alloc_channels_and_rings = xlgmac_alloc_channels_and_rings;
 	desc_ops->free_channels_and_rings = xlgmac_free_channels_and_rings;
 	desc_ops->map_tx_skb = xlgmac_map_tx_skb;
 	desc_ops->map_rx_buffer = xlgmac_map_rx_buffer;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 26aa7f32151f..26d178f8616b 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -654,7 +654,7 @@ static int xlgmac_open(struct net_device *netdev)
 	pdata->rx_buf_size = ret;
 
 	/* Allocate the channels and rings */
-	ret = desc_ops->alloc_channles_and_rings(pdata);
+	ret = desc_ops->alloc_channels_and_rings(pdata);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac.h b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
index cab3e40a86b9..8598aaf3ec99 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac.h
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
@@ -379,7 +379,7 @@ struct xlgmac_channel {
 } ____cacheline_aligned;
 
 struct xlgmac_desc_ops {
-	int (*alloc_channles_and_rings)(struct xlgmac_pdata *pdata);
+	int (*alloc_channels_and_rings)(struct xlgmac_pdata *pdata);
 	void (*free_channels_and_rings)(struct xlgmac_pdata *pdata);
 	int (*map_tx_skb)(struct xlgmac_channel *channel,
 			  struct sk_buff *skb);
-- 
2.29.2

