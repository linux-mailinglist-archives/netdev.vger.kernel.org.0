Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51BD3974D9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhFAOEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:04:30 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3370 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbhFAOE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:04:29 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FvYfv2KfBz67YR;
        Tue,  1 Jun 2021 21:59:03 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:02:45 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <pablo@netfilter.org>, <laforge@gnumonks.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <osmocom-net-gprs@lists.osmocom.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] gtp: Fix a typo
Date:   Tue, 1 Jun 2021 22:16:25 +0800
Message-ID: <20210601141625.4131445-1-zhengyongjun3@huawei.com>
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

Suppport  ==> Support

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 39c00f050fbd..1c9023d47e00 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -436,7 +436,7 @@ static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 	gtp1->length	= htons(payload_len);
 	gtp1->tid	= htonl(pctx->u.v1.o_tei);
 
-	/* TODO: Suppport for extension header, sequence number and N-PDU.
+	/* TODO: Support for extension header, sequence number and N-PDU.
 	 *	 Update the length field if any of them is available.
 	 */
 }
-- 
2.25.1

