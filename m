Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC20926FE08
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgIRNQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:16:31 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13264 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726174AbgIRNQb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:16:31 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7855075E8274D5D3465C;
        Fri, 18 Sep 2020 21:16:27 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 21:16:17 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <tuong.t.lien@dektech.com.au>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] tipc: Remove unused macro CF_SERVER
Date:   Fri, 18 Sep 2020 21:16:15 +0800
Message-ID: <20200918131615.20124-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is no used any more, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/tipc/topsrv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 1489cfb941d8..5f6f86051c83 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -48,7 +48,6 @@
 #define MAX_SEND_MSG_COUNT	25
 #define MAX_RECV_MSG_COUNT	25
 #define CF_CONNECTED		1
-#define CF_SERVER		2
 
 #define TIPC_SERVER_NAME_LEN	32
 
-- 
2.17.1

