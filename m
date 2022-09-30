Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DAD5F04CE
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 08:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiI3GbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 02:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiI3GbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 02:31:21 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9767112261B;
        Thu, 29 Sep 2022 23:31:19 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mf0cy72YSzlVkF;
        Fri, 30 Sep 2022 14:26:58 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 14:31:17 +0800
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 14:31:17 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] can: j1939: j1939_session_tx_eoma(): fix debug info
Date:   Fri, 30 Sep 2022 14:52:08 +0800
Message-ID: <1664520728-4644-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "%s" instead of "%p" to print function name in debug info.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/can/j1939/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index d7d86c9..6ec48a4 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -985,7 +985,7 @@ static int j1939_session_tx_eoma(struct j1939_session *session)
 	/* wait for the EOMA packet to come in */
 	j1939_tp_set_rxtimeout(session, 1250);
 
-	netdev_dbg(session->priv->ndev, "%p: 0x%p\n", __func__, session);
+	netdev_dbg(session->priv->ndev, "%s: 0x%p\n", __func__, session);
 
 	return 0;
 }
-- 
2.9.5

