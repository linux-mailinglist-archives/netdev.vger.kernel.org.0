Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59034B567
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhC0IPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:15:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14931 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhC0IOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 04:14:55 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F6s5x5QPYzkl3G;
        Sat, 27 Mar 2021 16:12:53 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:14:23 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <dsahern@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 6/9] 9p/trans_fd: Correct function name p9_mux_destroy() in the kerneldoc
Date:   Sat, 27 Mar 2021 16:15:53 +0800
Message-ID: <20210327081556.113140-7-wangxiongfeng2@huawei.com>
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

 net/9p/trans_fd.c:881: warning: expecting prototype for p9_mux_destroy(). Prototype was for p9_conn_destroy() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 net/9p/trans_fd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index fa158397bb63..f4dd0456beaf 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -872,7 +872,7 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
 }
 
 /**
- * p9_mux_destroy - cancels all pending requests of mux
+ * p9_conn_destroy - cancels all pending requests of mux
  * @m: mux to destroy
  *
  */
-- 
2.20.1

