Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D2F58B6A6
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 18:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiHFQCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 12:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiHFQCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 12:02:41 -0400
Received: from smtp.smtpout.orange.fr (smtp-27.smtpout.orange.fr [80.12.242.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1177F5BB
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 09:02:40 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id KMG5odKkXgtndKMG5oXOga; Sat, 06 Aug 2022 18:02:38 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 06 Aug 2022 18:02:38 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] ax88796: Fix some typo in a comment
Date:   Sat,  6 Aug 2022 18:02:36 +0200
Message-Id: <7db4b622d2c3e5af58c1d1f32b81836f4af71f18.1659801746.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/by caused/be caused/
s/ax88786/ax88796/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
s/ax88786/ax88796/ is a guess based on the surrounding comments and the
name of the file.

ax88786 (and even 88786) is not part of the kernel, so it really looks
like a typo to me.
---
 include/net/ax88796.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ax88796.h b/include/net/ax88796.h
index b658471f97f0..303100f08ab8 100644
--- a/include/net/ax88796.h
+++ b/include/net/ax88796.h
@@ -34,8 +34,8 @@ struct ax_plat_data {
 			const unsigned char *buf, int star_page);
 	void (*block_input)(struct net_device *dev, int count,
 			struct sk_buff *skb, int ring_offset);
-	/* returns nonzero if a pending interrupt request might by caused by
-	 * the ax88786. Handles all interrupts if set to NULL
+	/* returns nonzero if a pending interrupt request might be caused by
+	 * the ax88796. Handles all interrupts if set to NULL
 	 */
 	int (*check_irq)(struct platform_device *pdev);
 };
-- 
2.34.1

