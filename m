Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9841211229B
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 06:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfLDFoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 00:44:02 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:42594 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfLDFoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 00:44:01 -0500
Received: from localhost.localdomain ([90.126.97.183])
        by mwinf5d51 with ME
        id Zhjw2100L3xPcdm03hjxz8; Wed, 04 Dec 2019 06:43:59 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 04 Dec 2019 06:43:59 +0100
X-ME-IP: 90.126.97.183
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sgruszka@redhat.com, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rt2x00usb: Fix a warning message in 'rt2x00usb_watchdog_tx_dma()'
Date:   Wed,  4 Dec 2019 06:43:55 +0100
Message-Id: <20191204054355.11729-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'forced' is duplicated in the message, axe one of them.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index bc2dfef0de22..92e9e023c349 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -522,7 +522,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_flush_queue);
 
 static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 {
-	rt2x00_warn(queue->rt2x00dev, "TX queue %d DMA timed out, invoke forced forced reset\n",
+	rt2x00_warn(queue->rt2x00dev, "TX queue %d DMA timed out, invoke forced reset\n",
 		    queue->qid);
 
 	rt2x00queue_stop_queue(queue);
-- 
2.20.1

