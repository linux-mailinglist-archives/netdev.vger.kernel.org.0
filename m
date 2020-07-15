Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F0F220D57
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731313AbgGOMsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731301AbgGOMsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:48:51 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8153C061755;
        Wed, 15 Jul 2020 05:48:51 -0700 (PDT)
Received: from Q.local (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5EE3AE06;
        Wed, 15 Jul 2020 14:48:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1594817328;
        bh=Kgt8/WFPvU+BUMz3/GgtXlSI/EzZgvgqx/ZnKmH2xeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjMR5sTqZ0XMrKIeA062CxOdOkm3Rx1Uds4y/N86lkElLEmJfd5g2orGR7bONLJp2
         ReY+GHTjq6WgGXv2m9/qBIGrsfW8ff5E8gtyxq3AvhhOkY0VaFmfc1gZX+sQNyIC05
         T7fuL9KyGbrFG2ASj+dkEfdbwnmzp4DKosy/vkMI=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     trivial@kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Shannon Nelson <snelson@pensando.io>,
        Colin Ian King <colin.king@canonical.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/8] drivers: net: wan: Fix trivial spelling
Date:   Wed, 15 Jul 2020 13:48:34 +0100
Message-Id: <20200715124839.252822-4-kieran.bingham+renesas@ideasonboard.com>
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
    decriptor -> descriptor

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
v2:
 - Fix commit message to reflect actual word replaced
---
 drivers/net/wan/lmc/lmc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 
-- 
2.25.1

