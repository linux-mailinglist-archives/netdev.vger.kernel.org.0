Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F101121CC06
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgGLXPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728454AbgGLXPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPA-GY; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH net-next 01/20] net: 9p: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:14:57 +0200
Message-Id: <20200712231516.1139335-2-andrew@lunn.ch>
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

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/9p/client.c     | 2 +-
 net/9p/trans_rdma.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index fc1f3635e5dd..09f1ec589b80 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -811,7 +811,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
  * @uodata: source for zero copy write
  * @inlen: read buffer size
  * @olen: write buffer size
- * @hdrlen: reader header size, This is the size of response protocol data
+ * @in_hdrlen: reader header size, This is the size of response protocol data
  * @fmt: protocol format string (see protocol.c)
  *
  * Returns request structure (which client must free using p9_tag_remove)
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index b21c3c209815..2885ff9c76f0 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -94,14 +94,15 @@ struct p9_trans_rdma {
 	struct completion cm_done;
 };
 
+struct p9_rdma_req;
+
 /**
- * p9_rdma_context - Keeps track of in-process WR
+ * struct p9_rdma_context - Keeps track of in-process WR
  *
  * @busa: Bus address to unmap when the WR completes
  * @req: Keeps track of requests (send)
  * @rc: Keepts track of replies (receive)
  */
-struct p9_rdma_req;
 struct p9_rdma_context {
 	struct ib_cqe cqe;
 	dma_addr_t busa;
@@ -112,7 +113,7 @@ struct p9_rdma_context {
 };
 
 /**
- * p9_rdma_opts - Collection of mount options
+ * struct p9_rdma_opts - Collection of mount options
  * @port: port of connection
  * @sq_depth: The requested depth of the SQ. This really doesn't need
  * to be any deeper than the number of threads used in the client
-- 
2.27.0.rc2

