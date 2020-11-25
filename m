Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CBC2C3806
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgKYEUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgKYEUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:20:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477C6C0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=hYL4RY2LJ4M+gP0ddrsWAI7/bLSiu3Gaqg3YTS9smUM=; b=TbeqyVjT4ZAmM9+ERErRTmufpA
        U9WhJVE2Uh1giFVOPsFoDNFYLzeC8GgTZaWQPH+sNDIpVgdEpHc00pKKBo1wV+1l9aU4anlP/aj3y
        /kU0gHfbSbx94Kfb+URLafL/AleUigt36f9Bkm8ILFEiUsAV+40ywI+6nlcmyXTaTjubKcYx7NZ/K
        wdQMT0W+x2xtIYZSs1SqLfVOq8qgdKy09kTjnOem48fvXdWwTdPgjzezEWwENIqivWXPkuS0Uyj0G
        6HbtWXzLMTlHSxiGrR8MDE+wua9lX+i6AF7w/t77h8uFQbqWhhGDdsR16JKNqUS/+K8Q4xZNa6211
        pE/jjH0Q==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khmIR-0000SB-Bm; Wed, 25 Nov 2020 04:20:48 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 07/10 net-next] net/tipc: fix node.c kernel-doc
Date:   Tue, 24 Nov 2020 20:20:23 -0800
Message-Id: <20201125042026.25374-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix node.c kernel-doc warnings in preparation for adding to the
networking docbook.

../net/tipc/node.c:141: warning: Function parameter or member 'kref' not described in 'tipc_node'
../net/tipc/node.c:141: warning: Function parameter or member 'bc_entry' not described in 'tipc_node'
../net/tipc/node.c:141: warning: Function parameter or member 'failover_sent' not described in 'tipc_node'
../net/tipc/node.c:141: warning: Function parameter or member 'peer_id' not described in 'tipc_node'
../net/tipc/node.c:141: warning: Function parameter or member 'peer_id_string' not described in 'tipc_node'
../net/tipc/node.c:141: warning: Function parameter or member 'conn_sks' not described in 'tipc_node'
../net/tipc/node.c:141: warning: Function parameter or member 'keepalive_intv' not described in 'tipc_node'
../net/tipc/node.c:141: warning: Function parameter or member 'timer' not described in 'tipc_node'
../net/tipc/node.c:141: warning: Function parameter or member 'peer_net' not described in 'tipc_node'
../net/tipc/node.c:141: warning: Function parameter or member 'peer_hash_mix' not described in 'tipc_node'
../net/tipc/node.c:273: warning: Function parameter or member '__n' not described in 'tipc_node_crypto_rx'
../net/tipc/node.c:822: warning: Function parameter or member 'n' not described in '__tipc_node_link_up'
../net/tipc/node.c:822: warning: Function parameter or member 'bearer_id' not described in '__tipc_node_link_up'
../net/tipc/node.c:822: warning: Function parameter or member 'xmitq' not described in '__tipc_node_link_up'
../net/tipc/node.c:888: warning: Function parameter or member 'n' not described in 'tipc_node_link_up'
../net/tipc/node.c:888: warning: Function parameter or member 'bearer_id' not described in 'tipc_node_link_up'
../net/tipc/node.c:888: warning: Function parameter or member 'xmitq' not described in 'tipc_node_link_up'
../net/tipc/node.c:948: warning: Function parameter or member 'n' not described in '__tipc_node_link_down'
../net/tipc/node.c:948: warning: Function parameter or member 'bearer_id' not described in '__tipc_node_link_down'
../net/tipc/node.c:948: warning: Function parameter or member 'xmitq' not described in '__tipc_node_link_down'
../net/tipc/node.c:948: warning: Function parameter or member 'maddr' not described in '__tipc_node_link_down'
../net/tipc/node.c:1537: warning: Function parameter or member 'net' not described in 'tipc_node_get_linkname'
../net/tipc/node.c:1537: warning: Function parameter or member 'len' not described in 'tipc_node_get_linkname'
../net/tipc/node.c:1891: warning: Function parameter or member 'n' not described in 'tipc_node_check_state'
../net/tipc/node.c:1891: warning: Function parameter or member 'xmitq' not described in 'tipc_node_check_state'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/tipc/node.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- linux-next-20201102.orig/net/tipc/node.c
+++ linux-next-20201102/net/tipc/node.c
@@ -82,7 +82,7 @@ struct tipc_bclink_entry {
 /**
  * struct tipc_node - TIPC node structure
  * @addr: network address of node
- * @ref: reference counter to node object
+ * @kref: reference counter to node object
  * @lock: rwlock governing access to structure
  * @net: the applicable net namespace
  * @hash: links to adjacent nodes in unsorted hash chain
@@ -90,9 +90,11 @@ struct tipc_bclink_entry {
  * @namedq: pointer to name table input queue with name table messages
  * @active_links: bearer ids of active links, used as index into links[] array
  * @links: array containing references to all links to node
+ * @bc_entry: broadcast link entry
  * @action_flags: bit mask of different types of node actions
  * @state: connectivity state vs peer node
  * @preliminary: a preliminary node or not
+ * @failover_sent: failover sent or not
  * @sync_point: sequence number where synch/failover is finished
  * @list: links to adjacent nodes in sorted list of cluster's nodes
  * @working_links: number of working links to node (both active and standby)
@@ -100,9 +102,16 @@ struct tipc_bclink_entry {
  * @capabilities: bitmap, indicating peer node's functional capabilities
  * @signature: node instance identifier
  * @link_id: local and remote bearer ids of changing link, if any
+ * @peer_id: 128-bit ID of peer
+ * @peer_id_string: ID string of peer
  * @publ_list: list of publications
+ * @conn_sks: list of connections (FIXME)
+ * @timer: node's keepalive timer
+ * @keepalive_intv: keepalive interval in milliseconds
  * @rcu: rcu struct for tipc_node
  * @delete_at: indicates the time for deleting a down node
+ * @peer_net: peer's net namespace
+ * @peer_hash_mix: hash for this peer (FIXME)
  * @crypto_rx: RX crypto handler
  */
 struct tipc_node {
@@ -267,6 +276,7 @@ char *tipc_node_get_id_str(struct tipc_n
 #ifdef CONFIG_TIPC_CRYPTO
 /**
  * tipc_node_crypto_rx - Retrieve crypto RX handle from node
+ * @__n: target tipc_node
  * Note: node ref counter must be held first!
  */
 struct tipc_crypto *tipc_node_crypto_rx(struct tipc_node *__n)
@@ -814,6 +824,9 @@ static void tipc_node_timeout(struct tim
 
 /**
  * __tipc_node_link_up - handle addition of link
+ * @n: target tipc_node
+ * @bearer_id: id of the bearer
+ * @xmitq: queue for messages to be xmited on
  * Node lock must be held by caller
  * Link becomes active (alone or shared) or standby, depending on its priority.
  */
@@ -880,6 +893,9 @@ static void __tipc_node_link_up(struct t
 
 /**
  * tipc_node_link_up - handle addition of link
+ * @n: target tipc_node
+ * @bearer_id: id of the bearer
+ * @xmitq: queue for messages to be xmited on
  *
  * Link becomes active (alone or shared) or standby, depending on its priority.
  */
@@ -941,6 +957,10 @@ static void tipc_node_link_failover(stru
 
 /**
  * __tipc_node_link_down - handle loss of link
+ * @n: target tipc_node
+ * @bearer_id: id of the bearer
+ * @xmitq: queue for messages to be xmited on
+ * @maddr: output media address of the bearer
  */
 static void __tipc_node_link_down(struct tipc_node *n, int *bearer_id,
 				  struct sk_buff_head *xmitq,
@@ -1526,9 +1546,11 @@ static void node_lost_contact(struct tip
 /**
  * tipc_node_get_linkname - get the name of a link
  *
+ * @net: the applicable net namespace
  * @bearer_id: id of the bearer
  * @addr: peer node address
  * @linkname: link name output buffer
+ * @len: size of @linkname output buffer
  *
  * Returns 0 on success
  */
@@ -1882,8 +1904,10 @@ static void tipc_node_bc_rcv(struct net
 
 /**
  * tipc_node_check_state - check and if necessary update node state
+ * @n: target tipc_node
  * @skb: TIPC packet
  * @bearer_id: identity of bearer delivering the packet
+ * @xmitq: queue for messages to be xmited on
  * Returns true if state and msg are ok, otherwise false
  */
 static bool tipc_node_check_state(struct tipc_node *n, struct sk_buff *skb,
