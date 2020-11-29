Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB712C7A9E
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 19:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgK2Sds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 13:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2Sdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 13:33:47 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA12C0617A7
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 10:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BE0T32hQE5D3C24m6QmN/AP67JfFBFApfhjYGYp2Kg4=; b=hyGn2tSyU9tX9FndVjG4k/KnR+
        oA11C6zukBS5wrqAHrApFFxA7EAHNXFnjJQlT6Dkxn/6mG5U0gveewQbSLkyB+EGcDNY91dQZTrKV
        LpcU/1N/DGWBaPxK9BWAXfT17oGMbSplSnu7G1+uaxjoWe+uLtpRj9x9Ma0hvJPOgC9fwg/vf6CU/
        OD6irMiHlDfciNvtpRAG+jRHzEKv47hNjVMJZT+l4eLDkylDuvPiMU6lxhjr+J2iZXMg4ODyLzytW
        9e1f3+qrGqVc/q/R7lX/KRYCK5oK57SgCjrrCocN2FgYyY2iWyhlWMOGQlH24s25LlI2eGwZXZMJ5
        LU+I3ewg==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRVQ-00011y-M0; Sun, 29 Nov 2020 18:33:05 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 04/10 net-next v2] net/tipc: fix link.c kernel-doc
Date:   Sun, 29 Nov 2020 10:32:44 -0800
Message-Id: <20201129183251.7049-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201129183251.7049-1-rdunlap@infradead.org>
References: <20201129183251.7049-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix link.c kernel-doc warnings in preparation for adding to the
networking docbook.

../net/tipc/link.c:200: warning: Function parameter or member 'session' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'snd_nxt_state' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'rcv_nxt_state' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'in_session' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'active' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'if_name' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'rst_cnt' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'drop_point' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'failover_reasm_skb' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'failover_deferdq' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'transmq' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'backlog' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'snd_nxt' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'rcv_unacked' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'deferdq' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'window' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'min_win' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'ssthresh' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'max_win' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'cong_acks' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'checkpoint' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'reasm_tnlmsg' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'last_gap' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'last_ga' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'bc_rcvlink' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'bc_sndlink' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'nack_state' not described in 'tipc_link'
../net/tipc/link.c:200: warning: Function parameter or member 'bc_peer_is_up' not described in 'tipc_link'
../net/tipc/link.c:473: warning: Function parameter or member 'self' not described in 'tipc_link_create'
../net/tipc/link.c:473: warning: Function parameter or member 'peer_id' not described in 'tipc_link_create'
../net/tipc/link.c:473: warning: Excess function parameter 'ownnode' description in 'tipc_link_create'
../net/tipc/link.c:544: warning: Function parameter or member 'ownnode' not described in 'tipc_link_bc_create'
../net/tipc/link.c:544: warning: Function parameter or member 'peer' not described in 'tipc_link_bc_create'
../net/tipc/link.c:544: warning: Function parameter or member 'peer_id' not described in 'tipc_link_bc_create'
../net/tipc/link.c:544: warning: Function parameter or member 'peer_caps' not described in 'tipc_link_bc_create'
../net/tipc/link.c:544: warning: Function parameter or member 'bc_sndlink' not described in 'tipc_link_bc_create'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
v2: rebase to current net-next

 net/tipc/link.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

--- net-next.orig/net/tipc/link.c
+++ net-next/net/tipc/link.c
@@ -120,6 +120,34 @@ struct tipc_stats {
  * @reasm_buf: head of partially reassembled inbound message fragments
  * @bc_rcvr: marks that this is a broadcast receiver link
  * @stats: collects statistics regarding link activity
+ * @session: session to be used by link
+ * @snd_nxt_state: next send seq number
+ * @rcv_nxt_state: next rcv seq number
+ * @in_session: have received ACTIVATE_MSG from peer
+ * @active: link is active
+ * @if_name: associated interface name
+ * @rst_cnt: link reset counter
+ * @drop_point: seq number for failover handling (FIXME)
+ * @failover_reasm_skb: saved failover msg ptr (FIXME)
+ * @failover_deferdq: deferred message queue for failover processing (FIXME)
+ * @transmq: the link's transmit queue
+ * @backlog: link's backlog by priority (importance)
+ * @snd_nxt: next sequence number to be used
+ * @rcv_unacked: # messages read by user, but not yet acked back to peer
+ * @deferdq: deferred receive queue
+ * @window: sliding window size for congestion handling
+ * @min_win: minimal send window to be used by link
+ * @ssthresh: slow start threshold for congestion handling
+ * @max_win: maximal send window to be used by link
+ * @cong_acks: congestion acks for congestion avoidance (FIXME)
+ * @checkpoint: seq number for congestion window size handling
+ * @reasm_tnlmsg: fragmentation/reassembly area for tunnel protocol message
+ * @last_gap: last gap ack blocks for bcast (FIXME)
+ * @last_ga: ptr to gap ack blocks
+ * @bc_rcvlink: the peer specific link used for broadcast reception
+ * @bc_sndlink: the namespace global link used for broadcast sending
+ * @nack_state: bcast nack state
+ * @bc_peer_is_up: peer has acked the bcast init msg
  */
 struct tipc_link {
 	u32 addr;
@@ -450,7 +478,6 @@ u32 tipc_link_state(struct tipc_link *l)
  * @min_win: minimal send window to be used by link
  * @max_win: maximal send window to be used by link
  * @session: session to be used by link
- * @ownnode: identity of own node
  * @peer: node id of peer node
  * @peer_caps: bitmap describing peer node capabilities
  * @bc_sndlink: the namespace global link used for broadcast sending
@@ -458,6 +485,8 @@ u32 tipc_link_state(struct tipc_link *l)
  * @inputq: queue to put messages ready for delivery
  * @namedq: queue to put binding table update messages ready for delivery
  * @link: return value, pointer to put the created link
+ * @self: local unicast link id
+ * @peer_id: 128-bit ID of peer
  *
  * Returns true if link was created, otherwise false
  */
@@ -532,6 +561,11 @@ bool tipc_link_create(struct net *net, c
  * @inputq: queue to put messages ready for delivery
  * @namedq: queue to put binding table update messages ready for delivery
  * @link: return value, pointer to put the created link
+ * @ownnode: identity of own node
+ * @peer: node id of peer node
+ * @peer_id: 128-bit ID of peer
+ * @peer_caps: bitmap describing peer node capabilities
+ * @bc_sndlink: the namespace global link used for broadcast sending
  *
  * Returns true if link was created, otherwise false
  */
@@ -2376,7 +2410,7 @@ int tipc_link_bc_sync_rcv(struct tipc_li
 	if (!msg_peer_node_is_up(hdr))
 		return rc;
 
-	/* Open when peer ackowledges our bcast init msg (pkt #1) */
+	/* Open when peer acknowledges our bcast init msg (pkt #1) */
 	if (msg_ack(hdr))
 		l->bc_peer_is_up = true;
 
