Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2779E5EEDA4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 08:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiI2GNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 02:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiI2GNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 02:13:00 -0400
Received: from mail-m963.mail.126.com (mail-m963.mail.126.com [123.126.96.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10D4A12CCB3;
        Wed, 28 Sep 2022 23:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=7GV0e
        uD6vPdFm3kaa1QQFrLuAxuAkyqQaXQLID2TiJU=; b=HzX7wbEeEundaoj9x7fDg
        /THRc8+M8TXDBnS+9MaNrxWuGKbOacZ2tuhiKTPk0Vbya2hA1rpCo9tsEE+ans9g
        2zvaA9v5gEH08H03MEM3htQGGjCY8nC4qkHgzKTwH2bqcQ99qgwAg21RZgCKdfFZ
        9HalGIwu3093YrHH7Nd4z8=
Received: from localhost.localdomain (unknown [39.99.236.58])
        by smtp8 (Coremail) with SMTP id NORpCgAXHtJBNzVjxuegDA--.20948S2;
        Thu, 29 Sep 2022 14:12:18 +0800 (CST)
From:   Hongbin Wang <wh_bin@126.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ip6_vti:Remove the space before the comma
Date:   Thu, 29 Sep 2022 02:12:05 -0400
Message-Id: <20220929061205.2690864-1-wh_bin@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NORpCgAXHtJBNzVjxuegDA--.20948S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrWF43KrW3WF1xGryDXFyDtrb_yoWxWrb_ta
        srAw40vr18Ary8Can5Zw12yFyS9w1ayF4rCFZ7J34vka15Gr98AF4DWryrCrZrWr95KryU
        WFyqga4UXrWayjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbLvKUUUUUU==
X-Originating-IP: [39.99.236.58]
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbibQKLolpEBkAnkwAAsq
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There should be no space before the comma

Signed-off-by: Hongbin Wang <wh_bin@126.com>
---
 net/ipv6/ip6_vti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 8fe59a79e800..f1572449bdc9 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -154,7 +154,7 @@ vti6_tnl_link(struct vti6_net *ip6n, struct ip6_tnl *t)
 {
 	struct ip6_tnl __rcu **tp = vti6_tnl_bucket(ip6n, &t->parms);
 
-	rcu_assign_pointer(t->next , rtnl_dereference(*tp));
+	rcu_assign_pointer(t->next, rtnl_dereference(*tp));
 	rcu_assign_pointer(*tp, t);
 }
 
-- 
2.25.1

