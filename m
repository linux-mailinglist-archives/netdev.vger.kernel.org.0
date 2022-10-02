Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BDC5F21F3
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiJBIRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJBIR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:17:27 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41273F1E7
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:17:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3035E20573;
        Sun,  2 Oct 2022 10:17:24 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1XBPks4wqXUS; Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 245FA20539;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 10ECF80004A;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:17:22 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:17:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E18D83182A05; Sun,  2 Oct 2022 10:17:21 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 02/24] xfrm: Drop unused argument
Date:   Sun, 2 Oct 2022 10:16:50 +0200
Message-ID: <20221002081712.757515-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
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

From: Hongbin Wang <wh_bin@126.com>

Drop unused argument from xfrm_policy_match,
__xfrm_policy_eval_candidates and xfrm_policy_eval_candidates.
No functional changes intended.

Signed-off-by: Hongbin Wang <wh_bin@126.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1a0bab920a5..6264680b1f08 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1889,7 +1889,7 @@ EXPORT_SYMBOL(xfrm_policy_walk_done);
  */
 static int xfrm_policy_match(const struct xfrm_policy *pol,
 			     const struct flowi *fl,
-			     u8 type, u16 family, int dir, u32 if_id)
+			     u8 type, u16 family, u32 if_id)
 {
 	const struct xfrm_selector *sel = &pol->selector;
 	int ret = -ESRCH;
@@ -2014,7 +2014,7 @@ static struct xfrm_policy *
 __xfrm_policy_eval_candidates(struct hlist_head *chain,
 			      struct xfrm_policy *prefer,
 			      const struct flowi *fl,
-			      u8 type, u16 family, int dir, u32 if_id)
+			      u8 type, u16 family, u32 if_id)
 {
 	u32 priority = prefer ? prefer->priority : ~0u;
 	struct xfrm_policy *pol;
@@ -2028,7 +2028,7 @@ __xfrm_policy_eval_candidates(struct hlist_head *chain,
 		if (pol->priority > priority)
 			break;
 
-		err = xfrm_policy_match(pol, fl, type, family, dir, if_id);
+		err = xfrm_policy_match(pol, fl, type, family, if_id);
 		if (err) {
 			if (err != -ESRCH)
 				return ERR_PTR(err);
@@ -2053,7 +2053,7 @@ static struct xfrm_policy *
 xfrm_policy_eval_candidates(struct xfrm_pol_inexact_candidates *cand,
 			    struct xfrm_policy *prefer,
 			    const struct flowi *fl,
-			    u8 type, u16 family, int dir, u32 if_id)
+			    u8 type, u16 family, u32 if_id)
 {
 	struct xfrm_policy *tmp;
 	int i;
@@ -2061,8 +2061,7 @@ xfrm_policy_eval_candidates(struct xfrm_pol_inexact_candidates *cand,
 	for (i = 0; i < ARRAY_SIZE(cand->res); i++) {
 		tmp = __xfrm_policy_eval_candidates(cand->res[i],
 						    prefer,
-						    fl, type, family, dir,
-						    if_id);
+						    fl, type, family, if_id);
 		if (!tmp)
 			continue;
 
@@ -2101,7 +2100,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 
 	ret = NULL;
 	hlist_for_each_entry_rcu(pol, chain, bydst) {
-		err = xfrm_policy_match(pol, fl, type, family, dir, if_id);
+		err = xfrm_policy_match(pol, fl, type, family, if_id);
 		if (err) {
 			if (err == -ESRCH)
 				continue;
@@ -2120,7 +2119,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 		goto skip_inexact;
 
 	pol = xfrm_policy_eval_candidates(&cand, ret, fl, type,
-					  family, dir, if_id);
+					  family, if_id);
 	if (pol) {
 		ret = pol;
 		if (IS_ERR(pol))
-- 
2.25.1

