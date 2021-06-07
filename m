Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A102539DF20
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhFGOt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:49:56 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4499 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFGOty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:49:54 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzGPN5Xk2zZf0T;
        Mon,  7 Jun 2021 22:45:12 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 22:48:00 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jchapman@katalix.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] l2tp: Fix spelling mistakes
Date:   Mon, 7 Jun 2021 23:01:37 +0800
Message-ID: <20210607150137.2856585-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
negociated  ==> negotiated
dont  ==> don't

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/l2tp/l2tp_ip.c  | 2 +-
 net/l2tp/l2tp_ppp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 97ae1255fcb6..60aa990ea72e 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -488,7 +488,7 @@ static int l2tp_ip_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 	}
 
-	/* We dont need to clone dst here, it is guaranteed to not disappear.
+	/* We don't need to clone dst here, it is guaranteed to not disappear.
 	 *  __dev_xmit_skb() might force a refcount if needed.
 	 */
 	skb_dst_set_noref(skb, &rt->dst);
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index aea85f91f059..bf35710127dd 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -226,7 +226,7 @@ static void pppol2tp_recv(struct l2tp_session *session, struct sk_buff *skb, int
 	/* If the first two bytes are 0xFF03, consider that it is the PPP's
 	 * Address and Control fields and skip them. The L2TP module has always
 	 * worked this way, although, in theory, the use of these fields should
-	 * be negociated and handled at the PPP layer. These fields are
+	 * be negotiated and handled at the PPP layer. These fields are
 	 * constant: 0xFF is the All-Stations Address and 0x03 the Unnumbered
 	 * Information command with Poll/Final bit set to zero (RFC 1662).
 	 */
-- 
2.25.1

