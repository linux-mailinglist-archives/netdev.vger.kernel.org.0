Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5AA394C10
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 13:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhE2Lro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 07:47:44 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2538 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2Lrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 07:47:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fsfnj4Nq1zYrfs;
        Sat, 29 May 2021 19:43:21 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 19:46:03 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 29
 May 2021 19:46:02 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] pktgen: Use BIT(x) macro
Date:   Sat, 29 May 2021 19:45:59 +0800
Message-ID: <20210529114559.24604-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BIT(x) improves readability and safety with respect to shifts.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/core/pktgen.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 3fba429f1f57..2915153458aa 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -218,10 +218,10 @@ static char *pkt_flag_names[] = {
 #define NR_PKT_FLAGS		ARRAY_SIZE(pkt_flag_names)
 
 /* Thread control flag bits */
-#define T_STOP        (1<<0)	/* Stop run */
-#define T_RUN         (1<<1)	/* Start run */
-#define T_REMDEVALL   (1<<2)	/* Remove all devs */
-#define T_REMDEV      (1<<3)	/* Remove one dev */
+#define T_STOP        BIT(0)	/* Stop run */
+#define T_RUN         BIT(1)	/* Start run */
+#define T_REMDEVALL   BIT(2)	/* Remove all devs */
+#define T_REMDEV      BIT(3)	/* Remove one dev */
 
 /* Xmit modes */
 #define M_START_XMIT		0	/* Default normal TX */
-- 
2.17.1

