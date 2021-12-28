Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09F2480D91
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 23:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhL1WAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 17:00:35 -0500
Received: from mx3.wp.pl ([212.77.101.9]:14153 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231492AbhL1WAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 17:00:35 -0500
Received: (wp-smtpd smtp.wp.pl 23131 invoked from network); 28 Dec 2021 23:00:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1640728833; bh=blzl0iSwsCu8d6JwxVYWL2/OChqfdnbP0nogUxCuWjk=;
          h=From:To:Subject;
          b=Aix8rG7eP+tBFrWzDXiY6Y3PEi2eO9F0qM4Y18o7DrNvA6vQEx0kHmPhdnoY6+8gA
           +5TVmhHh8nqaw5kDQrWDtuXGYcL/uGH8gSte2OPc6ad0/5SCQpUR6324mmAMmSr1Jm
           lQ23JwCBcK+IM/Ko4yPPW6i/BtXCWDp21fUaHWFU=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <davem@davemloft.net>; 28 Dec 2021 23:00:33 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     davem@davemloft.net, kuba@kernel.org, olek2@wp.pl,
        rdunlap@infradead.org, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: lantiq_etop: add blank line after declaration
Date:   Tue, 28 Dec 2021 23:00:31 +0100
Message-Id: <20211228220031.71576-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 6f90afbd3f23a876307914754d1d2177
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [0WM0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a missing line after the declaration and
fixes the checkpatch warning:

WARNING: Missing a blank line after declarations
+		int desc;
+		for (desc = 0; desc < LTQ_DESC_NUM; desc++)

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 072391c494ce..78257cbe7fb6 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -218,6 +218,7 @@ ltq_etop_free_channel(struct net_device *dev, struct ltq_etop_chan *ch)
 		free_irq(ch->dma.irq, priv);
 	if (IS_RX(ch->idx)) {
 		int desc;
+
 		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
 			dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 	}
-- 
2.30.2

