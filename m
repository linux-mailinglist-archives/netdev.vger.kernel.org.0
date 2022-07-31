Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE470585DC8
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 08:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbiGaGc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 02:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiGaGc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 02:32:58 -0400
Received: from smtp.smtpout.orange.fr (smtp04.smtpout.orange.fr [80.12.242.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9B913D70
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 23:32:57 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id I2VRoU6Vf0UP7I2VRoOECa; Sun, 31 Jul 2022 08:32:56 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 31 Jul 2022 08:32:56 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Max Staudt <max@enpas.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] can: can327: Fix a broken link to Documentation
Date:   Sun, 31 Jul 2022 08:32:52 +0200
Message-Id: <6a54aff884ea4f84b661527d75aabd6632140715.1659249135.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 482a4360c56a ("docs: networking: convert netdevices.txt to
ReST"), Documentation/networking/netdevices.txt has been replaced by
Documentation/networking/netdevices.rst.

Update the comment accordingly to avoid a 'make htmldocs' warning

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/can/can327.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/can327.c b/drivers/net/can/can327.c
index 5da7778d92dc..925e880bf570 100644
--- a/drivers/net/can/can327.c
+++ b/drivers/net/can/can327.c
@@ -827,7 +827,7 @@ static netdev_tx_t can327_netdev_start_xmit(struct sk_buff *skb,
 	netif_stop_queue(dev);
 
 	/* BHs are already disabled, so no spin_lock_bh().
-	 * See Documentation/networking/netdevices.txt
+	 * See Documentation/networking/netdevices.rst
 	 */
 	spin_lock(&elm->lock);
 	can327_send_frame(elm, frame);
-- 
2.34.1

