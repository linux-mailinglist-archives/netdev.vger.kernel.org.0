Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE63256748
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgH2Luz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:50:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10348 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727772AbgH2Luv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:50:51 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8BAFAB63DE5421EBD3CF;
        Sat, 29 Aug 2020 19:50:46 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 19:50:36 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] tipc: Remove unused macro TIPC_FWD_MSG
Date:   Sat, 29 Aug 2020 19:50:26 +0800
Message-ID: <20200829115026.4304-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree any more.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/tipc/socket.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 2679e97e0389..fd5bfaab8661 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -52,7 +52,6 @@
 #define NAGLE_START_MAX		1024
 #define CONN_TIMEOUT_DEFAULT    8000    /* default connect timeout = 8s */
 #define CONN_PROBING_INTV	msecs_to_jiffies(3600000)  /* [ms] => 1 h */
-#define TIPC_FWD_MSG		1
 #define TIPC_MAX_PORT		0xffffffff
 #define TIPC_MIN_PORT		1
 #define TIPC_ACK_RATE		4       /* ACK at 1/4 of of rcv window size */
-- 
2.17.1


