Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD106F0C57
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 21:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjD0TJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 15:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244485AbjD0TJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 15:09:02 -0400
X-Greylist: delayed 494 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Apr 2023 12:08:37 PDT
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790BA49F5;
        Thu, 27 Apr 2023 12:08:36 -0700 (PDT)
Received: from ipservice-092-217-081-249.092.217.pools.vodafone-ip.de ([92.217.81.249] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1ps6qZ-0003Us-CY; Thu, 27 Apr 2023 21:00:03 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Martin Kaiser <martin@kaiser.cx>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: rtl8xxxu: (trivial) remove unnecessary return
Date:   Thu, 27 Apr 2023 20:59:36 +0200
Message-Id: <20230427185936.923777-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a return statement at the end of a void function.

This fixes a checkpatch warning.

WARNING: void function return statements are not generally useful
6206: FILE: ./drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:6206:
+  return;
+}

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index fd8c8c6d53d6..7e7bb11231e3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6281,7 +6281,6 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 cleanup:
 	usb_free_urb(urb);
 	dev_kfree_skb(skb);
-	return;
 }
 
 static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
-- 
2.30.2

