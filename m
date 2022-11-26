Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12781639596
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 12:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKZLDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 06:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiKZLDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 06:03:09 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A2319008
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:03:09 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E940820536;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ID3RpXv1b4hj; Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2626D2049B;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 205E180004A;
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
        id 25E973183C43; Sat, 26 Nov 2022 12:03:06 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 03/10] xfrm: Remove not-used total variable
Date:   Sat, 26 Nov 2022 12:02:56 +0100
Message-ID: <20221126110303.1859238-4-steffen.klassert@secunet.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Total variable is not used in xfrm_byidx_resize() and can
be safely removed.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index e392d8d05e0c..d80519c4e389 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -605,7 +605,7 @@ static void xfrm_bydst_resize(struct net *net, int dir)
 	xfrm_hash_free(odst, (hmask + 1) * sizeof(struct hlist_head));
 }
 
-static void xfrm_byidx_resize(struct net *net, int total)
+static void xfrm_byidx_resize(struct net *net)
 {
 	unsigned int hmask = net->xfrm.policy_idx_hmask;
 	unsigned int nhashmask = xfrm_new_hash_mask(hmask);
@@ -683,7 +683,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 			xfrm_bydst_resize(net, dir);
 	}
 	if (xfrm_byidx_should_resize(net, total))
-		xfrm_byidx_resize(net, total);
+		xfrm_byidx_resize(net);
 
 	mutex_unlock(&hash_resize_mutex);
 }
-- 
2.25.1

