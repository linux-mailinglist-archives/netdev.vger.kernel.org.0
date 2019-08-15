Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D528EBC7
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731901AbfHOMnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:43:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48218 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbfHOMnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 08:43:00 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BE4A41A418727BA19300;
        Thu, 15 Aug 2019 20:42:58 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 15 Aug 2019 20:42:57 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] page_pool: remove unnecessary variable init
Date:   Thu, 15 Aug 2019 20:41:00 +0800
Message-ID: <1565872860-63524-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove variable initializations in functions that
are followed by assignments before use

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/page_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 3272dc7..31187ff 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -61,7 +61,7 @@ static int page_pool_init(struct page_pool *pool,
 struct page_pool *page_pool_create(const struct page_pool_params *params)
 {
 	struct page_pool *pool;
-	int err = 0;
+	int err;
 
 	pool = kzalloc_node(sizeof(*pool), GFP_KERNEL, params->nid);
 	if (!pool)
-- 
2.8.1

