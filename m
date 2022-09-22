Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118845E5DA1
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiIVIjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiIVIjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:39:02 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCC4AA369
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 01:39:01 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MY7rC5jSfz14S4W;
        Thu, 22 Sep 2022 16:34:51 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 16:38:59 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <cuigaosheng1@huawei.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next,v2 3/4] net: Remove unused inline function sk_nulls_node_init()
Date:   Thu, 22 Sep 2022 16:38:56 +0800
Message-ID: <20220922083857.1430811-4-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922083857.1430811-1-cuigaosheng1@huawei.com>
References: <20220922083857.1430811-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All uses of sk_nulls_node_init() have
been removed since commit dbca1596bbb0 ("ping: convert to RCU
lookups, get rid of rwlock"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 include/net/sock.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 96a31026e35d..08038a385ef2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -744,11 +744,6 @@ static inline void sk_node_init(struct hlist_node *node)
 	node->pprev = NULL;
 }
 
-static inline void sk_nulls_node_init(struct hlist_nulls_node *node)
-{
-	node->pprev = NULL;
-}
-
 static inline void __sk_del_node(struct sock *sk)
 {
 	__hlist_del(&sk->sk_node);
-- 
2.25.1

