Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734FB56D2C7
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiGKBwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKBwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:52:49 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3378417A82;
        Sun, 10 Jul 2022 18:52:48 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id D70301E80CAB;
        Mon, 11 Jul 2022 09:49:52 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0-v6mupQ4hb7; Mon, 11 Jul 2022 09:49:50 +0800 (CST)
Received: from node1.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 16FEC1E80C82;
        Mon, 11 Jul 2022 09:49:50 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@nfschina.com,
        Li zeming <zeming@nfschina.com>
Subject: [PATCH] rxrpc/conn_event: optimize the string
Date:   Mon, 11 Jul 2022 09:52:27 +0800
Message-Id: <20220711015227.2871-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think the comma in this string can be removed, so that the output
information is more standardized.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 net/rxrpc/conn_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index aab069701398..69b47411ddd0 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -197,7 +197,7 @@ static int rxrpc_abort_connection(struct rxrpc_connection *conn,
 	u32 serial;
 	int ret;
 
-	_enter("%d,,%u,%u", conn->debug_id, error, abort_code);
+	_enter("%d,%u,%u", conn->debug_id, error, abort_code);
 
 	/* generate a connection-level abort */
 	spin_lock_bh(&conn->state_lock);
-- 
2.18.2

