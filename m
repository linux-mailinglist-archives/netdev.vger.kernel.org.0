Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF828A721
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 13:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgJKLSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 07:18:03 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:24850 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgJKLSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 07:18:02 -0400
X-IronPort-AV: E=Sophos;i="5.77,362,1596492000"; 
   d="scan'208";a="471985690"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES256-SHA256; 11 Oct 2020 13:18:00 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     David Howells <dhowells@redhat.com>
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] rxrpc: use semicolons rather than commas to separate statements
Date:   Sun, 11 Oct 2020 12:34:54 +0200
Message-Id: <1602412498-32025-2-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
References: <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace commas with semicolons.  Commas introduce unnecessary
variability in the code structure and are hard to see.  What is done
is essentially described by the following Coccinelle semantic patch
(http://coccinelle.lip6.fr/):

// <smpl>
@@ expression e1,e2; @@
e1
-,
+;
e2
... when any
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 net/rxrpc/recvmsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index c4684dde1f16..acc4660cfa5b 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -69,7 +69,7 @@ bool __rxrpc_set_call_completion(struct rxrpc_call *call,
 	if (call->state < RXRPC_CALL_COMPLETE) {
 		call->abort_code = abort_code;
 		call->error = error;
-		call->completion = compl,
+		call->completion = compl;
 		call->state = RXRPC_CALL_COMPLETE;
 		trace_rxrpc_call_complete(call);
 		wake_up(&call->waitq);

