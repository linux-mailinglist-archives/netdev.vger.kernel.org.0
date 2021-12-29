Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7BF4817D0
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 00:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhL2XwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 18:52:10 -0500
Received: from mx3.wp.pl ([212.77.101.10]:40100 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233398AbhL2XwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 18:52:10 -0500
Received: (wp-smtpd smtp.wp.pl 40934 invoked from network); 30 Dec 2021 00:52:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1640821928; bh=RKZz1uRLzH3qeU7mLbqveXex0uLjiw2FNeWAHJeYmLI=;
          h=From:To:Subject;
          b=M7mgtuRBOx2DnVxswc7P906kfSD4wCfoQixkL7Db07Z93dCaEY9Vc+dgwHbGUTVNn
           ZkqQnZG0hs1pHouMKczDCpBRrgqM1/GORvM+lLxyKWbUJEX5hG6smfnG5QcFq4M4ov
           iYnkYPPs5+FQR7SvE3opLpSMp1eFuc0TxFUDOx8M=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <davem@davemloft.net>; 30 Dec 2021 00:52:08 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     davem@davemloft.net, kuba@kernel.org, olek2@wp.pl, jgg@ziepe.ca,
        rdunlap@infradead.org, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: lantiq_etop:  remove unnecessary space in cast
Date:   Thu, 30 Dec 2021 00:52:06 +0100
Message-Id: <20211229235206.6045-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: b91917f18e785162825f4e61f981bca2
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [caOk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by checkpatch.pl, no space is necessary after a cast.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 1f6808b3ad12..35d22b769f27 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -497,7 +497,7 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 	netif_trans_update(dev);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	desc->addr = ((unsigned int) dma_map_single(&priv->pdev->dev, skb->data, len,
+	desc->addr = ((unsigned int)dma_map_single(&priv->pdev->dev, skb->data, len,
 						DMA_TO_DEVICE)) - byte_offset;
 	/* Make sure the address is written before we give it to HW */
 	wmb();
-- 
2.30.2

