Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEA421CC0B
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgGLXPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbgGLXPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPT-Rj; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH net-next 09/20] net: mac80211: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:05 +0200
Message-Id: <20200712231516.1139335-10-andrew@lunn.ch>
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

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/mac80211/mesh_pathtbl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 117519bf33d6..fe4e853c61f4 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -72,7 +72,6 @@ static void mesh_table_free(struct mesh_table *tbl)
 }
 
 /**
- *
  * mesh_path_assign_nexthop - update mesh path next hop
  *
  * @mpath: mesh path to update
@@ -140,7 +139,6 @@ static void prepare_for_gate(struct sk_buff *skb, char *dst_addr,
 }
 
 /**
- *
  * mesh_path_move_to_queue - Move or copy frames from one mpath queue to another
  *
  * This function is used to transfer or copy frames from an unresolved mpath to
@@ -152,7 +150,7 @@ static void prepare_for_gate(struct sk_buff *skb, char *dst_addr,
  *
  * The gate mpath must be an active mpath with a valid mpath->next_hop.
  *
- * @mpath: An active mpath the frames will be sent to (i.e. the gate)
+ * @gate_mpath: An active mpath the frames will be sent to (i.e. the gate)
  * @from_mpath: The failed mpath
  * @copy: When true, copy all the frames to the new mpath queue.  When false,
  * move them.
-- 
2.27.0.rc2

