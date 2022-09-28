Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BF95ED852
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbiI1I6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiI1I61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:58:27 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADE7D8279
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:58:20 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mcr170TmVzpVQm;
        Wed, 28 Sep 2022 16:55:23 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 28 Sep
 2022 16:58:15 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>
CC:     <yuancan@huawei.com>
Subject: [PATCH] net/tipc: Remove unused struct distr_queue_item
Date:   Wed, 28 Sep 2022 08:56:36 +0000
Message-ID: <20220928085636.71749-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 09b5678c778f("tipc: remove dead code in tipc_net and relatives"),
struct distr_queue_item is not used any more and can be removed as well.

Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 net/tipc/name_distr.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 8267b751a526..190b49c5cbc3 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -41,14 +41,6 @@
 
 int sysctl_tipc_named_timeout __read_mostly = 2000;
 
-struct distr_queue_item {
-	struct distr_item i;
-	u32 dtype;
-	u32 node;
-	unsigned long expires;
-	struct list_head next;
-};
-
 /**
  * publ_to_item - add publication info to a publication message
  * @p: publication info
-- 
2.17.1

