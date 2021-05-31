Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD493953BF
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 03:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhEaBtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 21:49:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2476 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhEaBtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 21:49:11 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FtdPv27Zjz68nL;
        Mon, 31 May 2021 09:44:35 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 31 May 2021 09:47:29 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-sctp@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] sctp: sm_statefuns: Fix spelling mistakes
Date:   Mon, 31 May 2021 10:01:10 +0800
Message-ID: <20210531020110.2920255-1-zhengyongjun3@huawei.com>
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

Fix some spelling mistakes in comments:
genereate ==> generate
correclty ==> correctly
boundries ==> boundaries
failes ==> fails

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/sctp/sm_statefuns.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index fd1e319eda00..68e7d14c3799 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -608,7 +608,7 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct net *net,
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_COOKIE_ECHOED));
 
-	/* SCTP-AUTH: genereate the assocition shared keys so that
+	/* SCTP-AUTH: generate the assocition shared keys so that
 	 * we can potentially signe the COOKIE-ECHO.
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_SHKEY, SCTP_NULL());
@@ -838,7 +838,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 
 	/* Add all the state machine commands now since we've created
 	 * everything.  This way we don't introduce memory corruptions
-	 * during side-effect processing and correclty count established
+	 * during side-effect processing and correctly count established
 	 * associations.
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
@@ -2950,7 +2950,7 @@ enum sctp_disposition sctp_sf_do_9_2_reshutack(
 						  commands);
 
 	/* Since we are not going to really process this INIT, there
-	 * is no point in verifying chunk boundries.  Just generate
+	 * is no point in verifying chunk boundaries.  Just generate
 	 * the SHUTDOWN ACK.
 	 */
 	reply = sctp_make_shutdown_ack(asoc, chunk);
@@ -3560,7 +3560,7 @@ enum sctp_disposition sctp_sf_do_9_2_final(struct net *net,
 		goto nomem_chunk;
 
 	/* Do all the commands now (after allocation), so that we
-	 * have consistent state if memory allocation failes
+	 * have consistent state if memory allocation fails
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
 
-- 
2.25.1

