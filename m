Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D650325D94F
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbgIDNM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:12:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10815 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730414AbgIDNLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 09:11:16 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3F4DD45304F12020F37B;
        Fri,  4 Sep 2020 21:11:14 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 4 Sep 2020
 21:11:12 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <dhowells@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] rxrpc: Remove unused macro rxrpc_min_rtt_wlen
Date:   Fri, 4 Sep 2020 21:08:37 +0800
Message-ID: <20200904130837.20875-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxrpc_min_rtt_wlen is never used after it was introduced.
So better to remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/rxrpc/rtt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/rxrpc/rtt.c b/net/rxrpc/rtt.c
index 928d8b34a3ee..a056c9bcf1d6 100644
--- a/net/rxrpc/rtt.c
+++ b/net/rxrpc/rtt.c
@@ -14,7 +14,6 @@
 #define RXRPC_RTO_MAX	((unsigned)(120 * HZ))
 #define RXRPC_TIMEOUT_INIT ((unsigned)(1*HZ))	/* RFC6298 2.1 initial RTO value	*/
 #define rxrpc_jiffies32 ((u32)jiffies)		/* As rxrpc_jiffies32 */
-#define rxrpc_min_rtt_wlen 300			/* As sysctl_tcp_min_rtt_wlen */
 
 static u32 rxrpc_rto_min_us(struct rxrpc_peer *peer)
 {
-- 
2.17.1

