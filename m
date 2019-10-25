Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFBEBE46F7
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438434AbfJYJTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:19:44 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58924 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408511AbfJYJTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 05:19:43 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DB58ABAF298C5F178F84;
        Fri, 25 Oct 2019 17:19:41 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 25 Oct 2019
 17:19:32 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <willemb@google.com>,
        <deepa.kernel@gmail.com>, <kafai@fb.com>, <arnd@arndb.de>,
        <dh.herrmann@gmail.com>, <zhang.lin16@zte.com.cn>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] sock: remove unneeded semicolon
Date:   Fri, 25 Oct 2019 17:18:36 +0800
Message-ID: <20191025091836.35072-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unneeded semicolon.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 1a7a14b7..0dfd104 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3013,7 +3013,7 @@ int sock_gettstamp(struct socket *sock, void __user *userstamp,
 		return -ENOENT;
 	if (ts.tv_sec == 0) {
 		ktime_t kt = ktime_get_real();
-		sock_write_timestamp(sk, kt);;
+		sock_write_timestamp(sk, kt);
 		ts = ktime_to_timespec64(kt);
 	}
 
-- 
2.7.4


