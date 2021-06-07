Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D912D39DF0F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFGOtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:49:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8062 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGOtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:49:18 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzGNg48DKzYs6T;
        Mon,  7 Jun 2021 22:44:35 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 22:47:22 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <paul@paul-moore.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] netlabel: Fix spelling mistakes
Date:   Mon, 7 Jun 2021 23:01:00 +0800
Message-ID: <20210607150100.2856110-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
Interate  ==> Iterate
sucess  ==> success

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/netlabel/netlabel_domainhash.c | 2 +-
 net/netlabel/netlabel_kapi.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index dc8c39f51f7d..8158a25972b4 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -929,7 +929,7 @@ struct netlbl_dommap_def *netlbl_domhsh_getentry_af6(const char *domain,
  * @cb_arg: argument for the callback function
  *
  * Description:
- * Interate over the domain mapping hash table, skipping the first @skip_bkt
+ * Iterate over the domain mapping hash table, skipping the first @skip_bkt
  * buckets and @skip_chain entries.  For each entry in the table call
  * @callback, if @callback returns a negative value stop 'walking' through the
  * table and return.  Updates the values in @skip_bkt and @skip_chain on
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 5e1239cef000..beb0e573266d 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -719,7 +719,7 @@ int netlbl_catmap_walkrng(struct netlbl_lsm_catmap *catmap, u32 offset)
  * it in @bitmap.  The @offset must be aligned to an unsigned long and will be
  * updated on return if different from what was requested; if the catmap is
  * empty at the requested offset and beyond, the @offset is set to (u32)-1.
- * Returns zero on sucess, negative values on failure.
+ * Returns zero on success, negative values on failure.
  *
  */
 int netlbl_catmap_getlong(struct netlbl_lsm_catmap *catmap,
-- 
2.25.1

