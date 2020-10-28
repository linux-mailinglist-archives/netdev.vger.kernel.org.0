Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03E429DBB5
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390744AbgJ2ANG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50720 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390147AbgJ2ANF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZkU-003u31-9U; Wed, 28 Oct 2020 01:55:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: appletalk: fix kerneldoc warnings
Date:   Wed, 28 Oct 2020 01:55:27 +0100
Message-Id: <20201028005527.930388-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/appletalk/aarp.c:68: warning: Function parameter or member 'dev' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'expires_at' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'hwaddr' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'last_sent' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'next' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'packet_queue' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'status' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'target_addr' not described in 'aarp_entry'
net/appletalk/aarp.c:68: warning: Function parameter or member 'xmit_count' not described in 'aarp_entry'
net/appletalk/ddp.c:1422: warning: Function parameter or member 'dev' not described in 'atalk_rcv'
net/appletalk/ddp.c:1422: warning: Function parameter or member 'orig_dev' not described in 'atalk_rcv'
net/appletalk/ddp.c:1422: warning: Function parameter or member 'pt' not described in 'atalk_rcv'
net/appletalk/ddp.c:1422: warning: Function parameter or member 'skb' not described in 'atalk_rcv'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/appletalk/aarp.c | 18 +++++++++---------
 net/appletalk/ddp.c  |  7 ++++---
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/appletalk/aarp.c b/net/appletalk/aarp.c
index 45f584171de7..be18af481d7d 100644
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -44,15 +44,15 @@ int sysctl_aarp_resolve_time = AARP_RESOLVE_TIME;
 /* Lists of aarp entries */
 /**
  *	struct aarp_entry - AARP entry
- *	@last_sent - Last time we xmitted the aarp request
- *	@packet_queue - Queue of frames wait for resolution
- *	@status - Used for proxy AARP
- *	expires_at - Entry expiry time
- *	target_addr - DDP Address
- *	dev - Device to use
- *	hwaddr - Physical i/f address of target/router
- *	xmit_count - When this hits 10 we give up
- *	next - Next entry in chain
+ *	@last_sent: Last time we xmitted the aarp request
+ *	@packet_queue: Queue of frames wait for resolution
+ *	@status: Used for proxy AARP
+ *	@expires_at: Entry expiry time
+ *	@target_addr: DDP Address
+ *	@dev:  Device to use
+ *	@hwaddr:  Physical i/f address of target/router
+ *	@xmit_count:  When this hits 10 we give up
+ *	@next: Next entry in chain
  */
 struct aarp_entry {
 	/* These first two are only used for unresolved entries */
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 1d48708c5a2e..ca1a0d07a087 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1407,9 +1407,10 @@ static int atalk_route_packet(struct sk_buff *skb, struct net_device *dev,
 
 /**
  *	atalk_rcv - Receive a packet (in skb) from device dev
- *	@skb - packet received
- *	@dev - network device where the packet comes from
- *	@pt - packet type
+ *	@skb: packet received
+ *	@dev: network device where the packet comes from
+ *	@pt: packet type
+ *	@orig_dev: the original receive net device
  *
  *	Receive a packet (in skb) from device dev. This has come from the SNAP
  *	decoder, and on entry skb->transport_header is the DDP header, skb->len
-- 
2.28.0

