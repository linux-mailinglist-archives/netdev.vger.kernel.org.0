Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE5421CC15
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgGLXP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728525AbgGLXPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBu-004mRG-UE; Mon, 13 Jul 2020 01:15:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: [PATCH net-next 20/20] net: x25: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:16 +0200
Message-Id: <20200712231516.1139335-21-andrew@lunn.ch>
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

Cc: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/x25/x25_link.c  | 2 +-
 net/x25/x25_route.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index 7d02532aad0d..fdae054b7dc1 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -270,7 +270,7 @@ void x25_link_device_up(struct net_device *dev)
 
 /**
  *	__x25_remove_neigh - remove neighbour from x25_neigh_list
- *	@nb - neigh to remove
+ *	@nb: - neigh to remove
  *
  *	Remove neighbour from x25_neigh_list. If it was there.
  *	Caller must hold x25_neigh_list_lock.
diff --git a/net/x25/x25_route.c b/net/x25/x25_route.c
index b8e94d58d0f1..00e46c9a5280 100644
--- a/net/x25/x25_route.c
+++ b/net/x25/x25_route.c
@@ -142,7 +142,7 @@ struct net_device *x25_dev_get(char *devname)
 
 /**
  * 	x25_get_route -	Find a route given an X.25 address.
- * 	@addr - address to find a route for
+ *	@addr: - address to find a route for
  *
  * 	Find a route given an X.25 address.
  */
-- 
2.27.0.rc2

