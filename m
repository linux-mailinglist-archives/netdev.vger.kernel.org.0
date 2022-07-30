Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239CE58595A
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 11:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiG3JMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 05:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiG3JMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 05:12:20 -0400
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E69A14D1F;
        Sat, 30 Jul 2022 02:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=SCfPf
        hJ87HAhYDJZQauyiCi8fuafYr/8A9EeHXs8eF0=; b=S1Nk0kBzo7QLH1JtCNYCn
        taOsRfDK7r9fclcOmM2J/Q774WBhdsOzpmzW1moqimHzgSYFOXVNSraL3jbFZJ5+
        fxiabY1StVlVyPq91FKsDWUgqMULDUIGqxHUuac1SQGZwkSaCDV2vAQ83ILFDtrI
        z349AA6qdJwYku/YUbxrP4=
Received: from localhost.localdomain (unknown [123.58.221.99])
        by smtp3 (Coremail) with SMTP id G9xpCgC301yq9eRiGiU1SQ--.7389S2;
        Sat, 30 Jul 2022 17:11:07 +0800 (CST)
From:   studentxswpy@163.com
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie Shaowen <studentxswpy@163.com>,
        Hacash Robot <hacashRobot@santino.com>
Subject: [PATCH net-next] net: dsa: Fix spelling mistakes and cleanup code
Date:   Sat, 30 Jul 2022 17:11:02 +0800
Message-Id: <20220730091102.3101859-1-studentxswpy@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgC301yq9eRiGiU1SQ--.7389S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr4rXrWrXryUtw43XF1DWrg_yoW3ZFb_ZF
        yIyF4rXr4fXayvka1UKrWFqFWIgw48Ar1ku3WY9rWDu3s5Zr45Gan5WFnxG3y7uFWj9FZ8
        Zrn0qF95t3sxWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8qQ6tUUUUU==
X-Originating-IP: [123.58.221.99]
X-CM-SenderInfo: xvwxvv5qw024ls16il2tof0z/xtbBEQtOJFaEJ33OYQAAsX
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
 net/dsa/tag_brcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 96dbb8ee2fee..4d538f4c3884 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -103,7 +103,7 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 
 	brcm_tag = skb->data + offset;
 
-	/* Set the ingress opcode, traffic class, tag enforcment is
+	/* Set the ingress opcode, traffic class, tag enforcement is
 	 * deprecated
 	 */
 	brcm_tag[0] = (1 << BRCM_OPCODE_SHIFT) |
-- 
2.25.1

