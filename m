Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B7B4817BC
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 00:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhL2Xb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 18:31:29 -0500
Received: from mx4.wp.pl ([212.77.101.12]:41901 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233131AbhL2Xb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 18:31:29 -0500
Received: (wp-smtpd smtp.wp.pl 31882 invoked from network); 30 Dec 2021 00:31:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1640820687; bh=6/orFVT7H/2J9y8tPKkvJ4bDCzx6FvSUH53zTrfw+Pk=;
          h=From:To:Subject;
          b=qxXN+n15Qp6g0RokwQAoHz+Onp22zH/a2u5QCIfIrgVWtqjtMeAVckRV2jqFYb12p
           K099Dl7sMjUIUd0D1rec0Ao/IXz4A462gSrCn14c586moA8a11vVj/GMqIadiNCjPm
           kg7KcCV8vsGhFQ5Atd72n98EKH6ZUER3PrGfkLGc=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <davem@davemloft.net>; 30 Dec 2021 00:31:27 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     davem@davemloft.net, kuba@kernel.org, olek2@wp.pl, jgg@ziepe.ca,
        rdunlap@infradead.org, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: lantiq_etop:  remove unnecessary space in cast
Date:   Thu, 30 Dec 2021 00:31:25 +0100
Message-Id: <20211229233125.4439-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 273207a810aafdd24fd9f77aa27ccbda
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [YVPE]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by checkpatch.pl, no space is necessary after a cast.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 072391c494ce..695526b4e1a4 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -496,7 +496,7 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 	netif_trans_update(dev);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	desc->addr = ((unsigned int) dma_map_single(&priv->pdev->dev, skb->data, len,
+	desc->addr = ((unsigned int)dma_map_single(&priv->pdev->dev, skb->data, len,
 						DMA_TO_DEVICE)) - byte_offset;
 	wmb();
 	desc->ctl = LTQ_DMA_OWN | LTQ_DMA_SOP | LTQ_DMA_EOP |
-- 
2.30.2

