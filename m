Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7FC21CC14
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgGLXQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:16:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbgGLXPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBu-004mQF-9S; Mon, 13 Jul 2020 01:15:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH net-next 14/20] net: rxrpc: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:10 +0200
Message-Id: <20200712231516.1139335-15-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/rxrpc/af_rxrpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 394189b81849..cd7d0d204c74 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -267,7 +267,7 @@ static int rxrpc_listen(struct socket *sock, int backlog)
  * @gfp: The allocation constraints
  * @notify_rx: Where to send notifications instead of socket queue
  * @upgrade: Request service upgrade for call
- * @intr: The call is interruptible
+ * @interruptibility: The call is interruptible, or can be canceled.
  * @debug_id: The debug ID for tracing to be assigned to the call
  *
  * Allow a kernel service to begin a call on the nominated socket.  This just
-- 
2.27.0.rc2

