Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E17B639593
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 12:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiKZLDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 06:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKZLDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 06:03:09 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB25818B2F
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:03:08 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8C25A20199;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 33IsX1xOSy6L; Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0F2162035C;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 079A180004A;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 12:03:06 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 12:03:06 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 297273183C45; Sat, 26 Nov 2022 12:03:06 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 04/10] xfrm: a few coding style clean ups
Date:   Sat, 26 Nov 2022 12:02:57 +0100
Message-ID: <20221126110303.1859238-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221126110303.1859238-1-steffen.klassert@secunet.com>
References: <20221126110303.1859238-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 9 ++++++---
 net/xfrm/xfrm_user.c   | 6 +++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d80519c4e389..a049f91d4446 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4414,7 +4414,8 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	struct xfrm_migrate *mp;
 
 	/* Stage 0 - sanity checks */
-	if ((err = xfrm_migrate_check(m, num_migrate)) < 0)
+	err = xfrm_migrate_check(m, num_migrate);
+	if (err < 0)
 		goto out;
 
 	if (dir >= XFRM_POLICY_MAX) {
@@ -4423,7 +4424,8 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	}
 
 	/* Stage 1 - find policy */
-	if ((pol = xfrm_migrate_policy_find(sel, dir, type, net, if_id)) == NULL) {
+	pol = xfrm_migrate_policy_find(sel, dir, type, net, if_id);
+	if (!pol) {
 		err = -ENOENT;
 		goto out;
 	}
@@ -4445,7 +4447,8 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	}
 
 	/* Stage 3 - update policy */
-	if ((err = xfrm_policy_migrate(pol, m, num_migrate)) < 0)
+	err = xfrm_policy_migrate(pol, m, num_migrate);
+	if (err < 0)
 		goto restore_state;
 
 	/* Stage 4 - delete old state(s) */
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e73f9efc54c1..25de6e8faf8d 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1538,7 +1538,7 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 				  &p->info.saddr, 1,
 				  family);
 	err = -ENOENT;
-	if (x == NULL)
+	if (!x)
 		goto out_noput;
 
 	err = xfrm_alloc_spi(x, p->min, p->max);
@@ -2718,7 +2718,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_encap_tmpl  *encap = NULL;
 	u32 if_id = 0;
 
-	if (attrs[XFRMA_MIGRATE] == NULL)
+	if (!attrs[XFRMA_MIGRATE])
 		return -EINVAL;
 
 	kmp = attrs[XFRMA_KMADDRESS] ? &km : NULL;
@@ -2727,7 +2727,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	err = copy_from_user_migrate((struct xfrm_migrate *)m, kmp, attrs, &n);
+	err = copy_from_user_migrate(m, kmp, attrs, &n);
 	if (err)
 		return err;
 
-- 
2.25.1

