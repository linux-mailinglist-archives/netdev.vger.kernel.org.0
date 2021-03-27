Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996C734B563
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhC0IOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:14:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15069 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhC0IOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 04:14:35 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6s5W149Kz1BFYb;
        Sat, 27 Mar 2021 16:12:31 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:14:22 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <dsahern@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 5/9] net: 9p: Correct function name errstr2errno() in the kerneldoc comments
Date:   Sat, 27 Mar 2021 16:15:52 +0800
Message-ID: <20210327081556.113140-6-wangxiongfeng2@huawei.com>
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

 net/9p/error.c:207: warning: expecting prototype for errstr2errno(). Prototype was for p9_errstr2errno() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 net/9p/error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/error.c b/net/9p/error.c
index 231f355fa9c6..61c18daf3050 100644
--- a/net/9p/error.c
+++ b/net/9p/error.c
@@ -197,7 +197,7 @@ int p9_error_init(void)
 EXPORT_SYMBOL(p9_error_init);
 
 /**
- * errstr2errno - convert error string to error number
+ * p9_errstr2errno - convert error string to error number
  * @errstr: error string
  * @len: length of error string
  *
-- 
2.20.1

