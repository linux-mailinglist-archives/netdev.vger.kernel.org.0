Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA146567B5F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiGFBPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiGFBPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:15:43 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 929AA1114A;
        Tue,  5 Jul 2022 18:15:42 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id D350C1E80D40;
        Wed,  6 Jul 2022 09:13:31 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Na7Q1Nnf6YGP; Wed,  6 Jul 2022 09:13:29 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id B96261E80CDE;
        Wed,  6 Jul 2022 09:13:28 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, Yu Zhe <yuzhe@nfschina.com>
Subject: [PATCH] amt: remove unnecessary type castings
Date:   Wed,  6 Jul 2022 09:14:49 +0800
Message-Id: <20220706011449.11269-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unnecessary void* type castings.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 drivers/net/amt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index be2719a3ba70..6b4402c26206 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -1373,11 +1373,11 @@ static void amt_add_srcs(struct amt_dev *amt, struct amt_tunnel_list *tunnel,
 	int i;
 
 	if (!v6) {
-		igmp_grec = (struct igmpv3_grec *)grec;
+		igmp_grec = grec;
 		nsrcs = ntohs(igmp_grec->grec_nsrcs);
 	} else {
 #if IS_ENABLED(CONFIG_IPV6)
-		mld_grec = (struct mld2_grec *)grec;
+		mld_grec = grec;
 		nsrcs = ntohs(mld_grec->grec_nsrcs);
 #else
 	return;
-- 
2.11.0

