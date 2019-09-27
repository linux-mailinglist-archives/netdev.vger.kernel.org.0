Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D52C028C
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 11:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfI0Jko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 05:40:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34057 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfI0Jko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 05:40:44 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iDmjv-00087L-Ro; Fri, 27 Sep 2019 09:40:39 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: tap: clean up an indentation issue
Date:   Fri, 27 Sep 2019 10:40:39 +0100
Message-Id: <20190927094039.23370-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a statement that is indented too deeply, remove
the extraneous tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/tap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index bcdfb0d88753..a6d63665ad03 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1190,7 +1190,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	kfree_skb(skb);
 err:
 	rcu_read_lock();
-		tap = rcu_dereference(q->tap);
+	tap = rcu_dereference(q->tap);
 	if (tap && tap->count_tx_dropped)
 		tap->count_tx_dropped(tap);
 	rcu_read_unlock();
-- 
2.20.1

