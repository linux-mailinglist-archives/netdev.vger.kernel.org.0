Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C385EC4C2
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiI0NmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiI0NmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:42:20 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E55AE11A6
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 06:42:19 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4McLKk64y4z1P6vx;
        Tue, 27 Sep 2022 21:38:02 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 21:42:17 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <dchickles@marvell.com>, <sburla@marvell.com>,
        <fmanlunas@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH] net: liquidio: Remove unused struct lio_trusted_vf_ctx
Date:   Tue, 27 Sep 2022 13:39:40 +0000
Message-ID: <20220927133940.104181-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 6870957ed5bc("liquidio: make soft command calls synchronous"), no
one use struct lio_trusted_vf_ctx, so remove it.

Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index bee35ce60171..d312bd594935 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -92,11 +92,6 @@ static int octeon_console_debug_enabled(u32 console)
 /* time to wait for possible in-flight requests in milliseconds */
 #define WAIT_INFLIGHT_REQUEST	msecs_to_jiffies(1000)
 
-struct lio_trusted_vf_ctx {
-	struct completion complete;
-	int status;
-};
-
 struct oct_link_status_resp {
 	u64 rh;
 	struct oct_link_info link_info;
-- 
2.17.1

