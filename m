Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BA858598D
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 11:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiG3JYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 05:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiG3JYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 05:24:33 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39B5A371BA;
        Sat, 30 Jul 2022 02:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=hF2DO
        aRt/pxHxZxnmPjeSO4oUxx6kb1yBjEEW0805qk=; b=f9KbprtUT5ZHEjIG0xV08
        d3hPGZKipzcFzru0/70SY27BPhfX5G6IygV8jvpX8zn0JsOOrCqDTBomTQXxt0+H
        pzGWekuLQmpfsI2UNBs3pXt0YoY5bhaMGLjvC/WvloppXRw5XwBFLHZF762KVClj
        WnZM9jiRyoELr4pup+mtGE=
Received: from localhost.localdomain (unknown [123.58.221.99])
        by smtp5 (Coremail) with SMTP id HdxpCgCnUgt1+ORisGddRQ--.28329S2;
        Sat, 30 Jul 2022 17:23:03 +0800 (CST)
From:   studentxswpy@163.com
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie Shaowen <studentxswpy@163.com>,
        Hacash Robot <hacashRobot@santino.com>
Subject: [PATCH v2 net-next] net: dsa: Fix spelling mistakes and cleanup code
Date:   Sat, 30 Jul 2022 17:22:54 +0800
Message-Id: <20220730092254.3102875-1-studentxswpy@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgCnUgt1+ORisGddRQ--.28329S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr45Zw47XF4UJrWkKryrXrb_yoWktFX_Za
        1IvF4rJr17XayvyF4qkF1FyFW09ay8Ar1kuw1YgrZrW3s5ZrW5ua95WrnxC3yUuFWS9Fsx
        Zr90qasay345GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8D8n5UUUUU==
X-Originating-IP: [123.58.221.99]
X-CM-SenderInfo: xvwxvv5qw024ls16il2tof0z/1tbiqxhOJFUMe2H8RAAAsi
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie Shaowen <studentxswpy@163.com>

fix follow spelling misktakes:
	desconstructed ==> deconstructed
	enforcment ==> enforcement

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: Xie Shaowen <studentxswpy@163.com>
---
 net/dsa/tag_brcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 96dbb8ee2fee..16889ea3e0a7 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -34,7 +34,7 @@
 /* Newer Broadcom tag (4 bytes) */
 #define BRCM_TAG_LEN	4
 
-/* Tag is constructed and desconstructed using byte by byte access
+/* Tag is constructed and deconstructed using byte by byte access
  * because the tag is placed after the MAC Source Address, which does
  * not make it 4-bytes aligned, so this might cause unaligned accesses
  * on most systems where this is used.
@@ -103,7 +103,7 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 
 	brcm_tag = skb->data + offset;
 
-	/* Set the ingress opcode, traffic class, tag enforcment is
+	/* Set the ingress opcode, traffic class, tag enforcement is
 	 * deprecated
 	 */
 	brcm_tag[0] = (1 << BRCM_OPCODE_SHIFT) |
-- 
2.25.1

