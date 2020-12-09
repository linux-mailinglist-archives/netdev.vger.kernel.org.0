Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FF12D434D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732402AbgLINc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:32:57 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8737 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732376AbgLINc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:32:56 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CrdHQ0ntlzknZB;
        Wed,  9 Dec 2020 21:31:30 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 21:32:00 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: rxrpc: convert comma to semicolon
Date:   Wed, 9 Dec 2020 21:32:28 +0800
Message-ID: <20201209133228.996-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/rxrpc/recvmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 2c842851d72e..fef3573fdc8b 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -69,7 +69,7 @@ bool __rxrpc_set_call_completion(struct rxrpc_call *call,
 	if (call->state < RXRPC_CALL_COMPLETE) {
 		call->abort_code = abort_code;
 		call->error = error;
-		call->completion = compl,
+		call->completion = compl;
 		call->state = RXRPC_CALL_COMPLETE;
 		trace_rxrpc_call_complete(call);
 		wake_up(&call->waitq);
-- 
2.22.0

