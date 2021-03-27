Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AE434B565
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhC0IPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:15:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14929 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhC0IOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 04:14:41 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F6s5x5d73zkl3K;
        Sat, 27 Mar 2021 16:12:53 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:14:24 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <dsahern@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 7/9] net: 9p: Correct function names in the kerneldoc comments
Date:   Sat, 27 Mar 2021 16:15:54 +0800
Message-ID: <20210327081556.113140-8-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
References: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following W=1 kernel build warning(s):

 net/9p/client.c:133: warning: expecting prototype for parse_options(). Prototype was for parse_opts() instead
 net/9p/client.c:269: warning: expecting prototype for p9_req_alloc(). Prototype was for p9_tag_alloc() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 net/9p/client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 0a9019da18f3..b7b958f61faf 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -122,7 +122,7 @@ static int get_protocol_version(char *s)
 }
 
 /**
- * parse_options - parse mount options into client structure
+ * parse_opts - parse mount options into client structure
  * @opts: options string passed from mount
  * @clnt: existing v9fs client information
  *
@@ -256,7 +256,7 @@ EXPORT_SYMBOL(p9_fcall_fini);
 static struct kmem_cache *p9_req_cache;
 
 /**
- * p9_req_alloc - Allocate a new request.
+ * p9_tag_alloc - Allocate a new request.
  * @c: Client session.
  * @type: Transaction type.
  * @max_size: Maximum packet size for this request.
-- 
2.20.1

