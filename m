Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1BC50295
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfFXGzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:55:45 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:36909 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726944AbfFXGzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:55:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 269E845889;
        Mon, 24 Jun 2019 16:45:19 +1000 (AEST)
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vWTTly0BtgEQ; Mon, 24 Jun 2019 16:45:19 +1000 (AEST)
Received: from cba01.dek-tpc.internal (cba01.dek-tpc.internal [172.16.83.49])
        by mail.dektech.com.au (Postfix) with ESMTP id 1024A45888;
        Mon, 24 Jun 2019 16:45:19 +1000 (AEST)
Received: by cba01.dek-tpc.internal (Postfix, from userid 1014)
        id 0E9AE1812EC; Mon, 24 Jun 2019 16:45:19 +1000 (AEST)
From:   john.rutherford@dektech.com.au
To:     netdev@vger.kernel.org
Cc:     John Rutherford <john.rutherford@dektech.com.au>
Subject: [net-next] tipc: fix missing indentation in source code
Date:   Mon, 24 Jun 2019 16:45:16 +1000
Message-Id: <20190624064516.22652-1-john.rutherford@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix misalignment of policy statement in netlink.c due to automatic
spatch code transformation.

Fixes: 3b0f31f2b8c9 ("genetlink: make policy common to family")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>
---
 net/tipc/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index 99bd166..d6165ad 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -261,7 +261,7 @@ struct genl_family tipc_genl_family __ro_after_init = {
 	.version	= TIPC_GENL_V2_VERSION,
 	.hdrsize	= 0,
 	.maxattr	= TIPC_NLA_MAX,
-	.policy = tipc_nl_policy,
+	.policy		= tipc_nl_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
 	.ops		= tipc_genl_v2_ops,
-- 
2.11.0

