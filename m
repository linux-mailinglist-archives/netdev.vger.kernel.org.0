Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A10398147
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhFBGng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:43:36 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6132 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhFBGnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:43:14 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvzrP6mGmzYpqV;
        Wed,  2 Jun 2021 14:38:45 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:41:28 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <dhowells@redhat.com>, <marc.dionne@auristor.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] rxrpc: Fix a typo
Date:   Wed, 2 Jun 2021 14:55:08 +0800
Message-ID: <20210602065508.105232-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

targetted  ==> targeted

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/rxrpc/local_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
index 3ce6d628cd75..19e929c7c38b 100644
--- a/net/rxrpc/local_event.c
+++ b/net/rxrpc/local_event.c
@@ -77,7 +77,7 @@ static void rxrpc_send_version_request(struct rxrpc_local *local,
 }
 
 /*
- * Process event packets targetted at a local endpoint.
+ * Process event packets targeted at a local endpoint.
  */
 void rxrpc_process_local_events(struct rxrpc_local *local)
 {
-- 
2.25.1

