Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1390125674B
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgH2Lwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:52:50 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44034 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727981AbgH2Lwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:52:30 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 465B3D695F0029F60DA8;
        Sat, 29 Aug 2020 19:52:26 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 19:52:16 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <tuong.t.lien@dektech.com.au>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] tipc: Remove unused macro TIPC_NACK_INTV
Date:   Sat, 29 Aug 2020 19:52:14 +0800
Message-ID: <20200829115214.17912-1-yuehaibing@huawei.com>
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
 net/tipc/link.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index b7362556da95..a2989f22ebb6 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -216,11 +216,6 @@ enum {
 #define TIPC_BC_RETR_LIM  (jiffies + msecs_to_jiffies(10))
 #define TIPC_UC_RETR_TIME (jiffies + msecs_to_jiffies(1))
 
-/*
- * Interval between NACKs when packets arrive out of order
- */
-#define TIPC_NACK_INTV (TIPC_MIN_LINK_WIN * 2)
-
 /* Link FSM states:
  */
 enum {
-- 
2.17.1


