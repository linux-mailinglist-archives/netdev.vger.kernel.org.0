Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF67387497
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 11:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347686AbhERJF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 05:05:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2969 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241978AbhERJF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 05:05:57 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FkqkR2MSfzCtfK;
        Tue, 18 May 2021 17:01:51 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 17:04:13 +0800
Received: from code-website.localdomain (10.175.127.227) by
 dggpeml500012.china.huawei.com (7.185.36.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 17:04:13 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <paul@paul-moore.com>
CC:     <netdev@vger.kernel.org>, <zhangjinhao2@huawei.com>,
        <yuehaibing@huawei.com>
Subject: [PATCH net-next] cipso: correct comments of cipso_v4_cache_invalidate()
Date:   Tue, 18 May 2021 17:11:41 +0800
Message-ID: <20210518091141.2316684-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since cipso_v4_cache_invalidate() has no return value, so drop
related descriptions in its comments.

Fixes: 446fda4f2682 ("[NetLabel]: CIPSOv4 engine")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 net/ipv4/cipso_ipv4.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index bfaf327e9d12..d6e3a92841e3 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -187,8 +187,7 @@ static int __init cipso_v4_cache_init(void)
  * cipso_v4_cache_invalidate - Invalidates the current CIPSO cache
  *
  * Description:
- * Invalidates and frees any entries in the CIPSO cache.  Returns zero on
- * success and negative values on failure.
+ * Invalidates and frees any entries in the CIPSO cache.
  *
  */
 void cipso_v4_cache_invalidate(void)
-- 
2.17.1

