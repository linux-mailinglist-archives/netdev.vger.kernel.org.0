Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FBB2C7A9C
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 19:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgK2Sdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 13:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbgK2Sdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 13:33:44 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A9AC0613D4
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 10:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=akjJuFpo9Ty74PW29g5RWgqiWgvrklVb3KHtflAGnKw=; b=gjGnUyoQqy8gWRXNeaNBgULIiD
        CNVXxGWFJw38SxBqHCCvdvB3tpyIjTQjgXZ38YSomnXUoJtFr8vDcI0s24e3bnHqzQ+QySBEVNpt8
        uUAhAweHOnuQ+lZcigrGMQcLjrGJuh+l6UNqU4MYwzKxqLfjIrHhwrAZems1s6u/jHWV0jrIeX0cB
        B/M/8WjRJPF0UXGKFsexmnhDrs+zuX+NeWLX+sfa5RPC5tWvLtMELmRo24MVzUpr3NETnl6C5huG0
        5KJuBXt+fjwQC/aoUwZvqIRXWylc2GwLdOuchgopQm+DN+X9uSDcvVIzn2fgovFivXobS/ZqDqkks
        C9iDnEFw==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRVN-00011y-Rl; Sun, 29 Nov 2020 18:33:02 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 01/10 net-next v2] net/tipc: fix tipc header files for kernel-doc
Date:   Sun, 29 Nov 2020 10:32:43 -0800
Message-Id: <20201129183251.7049-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201129183251.7049-1-rdunlap@infradead.org>
References: <20201129183251.7049-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix tipc header files for adding to the networking docbook.

Remove some uses of "/**" that were not kernel-doc notation.

Fix some source formatting to eliminate Sphinx warnings.

Add missing struct member and function argument kernel-doc descriptions.

Correct the description of a couple of struct members that were
marked as "(FIXME)".

Documentation/networking/tipc:18: ../net/tipc/name_table.h:65: WARNING: Unexpected indentation.
Documentation/networking/tipc:18: ../net/tipc/name_table.h:66: WARNING: Block quote ends without a blank line; unexpected unindent.

../net/tipc/bearer.h:128: warning: Function parameter or member 'min_win' not described in 'tipc_media'
../net/tipc/bearer.h:128: warning: Function parameter or member 'max_win' not described in 'tipc_media'

../net/tipc/bearer.h:171: warning: Function parameter or member 'min_win' not described in 'tipc_bearer'
../net/tipc/bearer.h:171: warning: Function parameter or member 'max_win' not described in 'tipc_bearer'
../net/tipc/bearer.h:171: warning: Function parameter or member 'disc' not described in 'tipc_bearer'
../net/tipc/bearer.h:171: warning: Function parameter or member 'up' not described in 'tipc_bearer'
../net/tipc/bearer.h:171: warning: Function parameter or member 'refcnt' not described in 'tipc_bearer'

../net/tipc/name_distr.h:68: warning: Function parameter or member 'port' not described in 'distr_item'

../net/tipc/name_table.h:111: warning: Function parameter or member 'services' not described in 'name_table'
../net/tipc/name_table.h:111: warning: Function parameter or member 'cluster_scope_lock' not described in 'name_table'
../net/tipc/name_table.h:111: warning: Function parameter or member 'rc_dests' not described in 'name_table'
../net/tipc/name_table.h:111: warning: Function parameter or member 'snd_nxt' not described in 'name_table'

../net/tipc/subscr.h:67: warning: Function parameter or member 'kref' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'net' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'service_list' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'conid' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'inactive' not described in 'tipc_subscription'
../net/tipc/subscr.h:67: warning: Function parameter or member 'lock' not described in 'tipc_subscription'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
v2: correct (FIXME) descriptions (thanks Ying Xue)
    rebase to current net-next

 net/tipc/bearer.h     |   10 +++++++---
 net/tipc/crypto.h     |    6 +++---
 net/tipc/name_distr.h |    2 +-
 net/tipc/name_table.h |    9 ++++++---
 net/tipc/subscr.h     |   11 +++++++----
 5 files changed, 24 insertions(+), 14 deletions(-)

--- net-next.orig/net/tipc/bearer.h
+++ net-next/net/tipc/bearer.h
@@ -93,7 +93,8 @@ struct tipc_bearer;
  * @raw2addr: convert from raw addr format to media addr format
  * @priority: default link (and bearer) priority
  * @tolerance: default time (in ms) before declaring link failure
- * @window: default window (in packets) before declaring link congestion
+ * @min_win: minimum window (in packets) before declaring link congestion
+ * @max_win: maximum window (in packets) before declaring link congestion
  * @mtu: max packet size bearer can support for media type not dependent on
  * underlying device MTU
  * @type_id: TIPC media identifier
@@ -138,12 +139,15 @@ struct tipc_media {
  * @pt: packet type for bearer
  * @rcu: rcu struct for tipc_bearer
  * @priority: default link priority for bearer
- * @window: default window size for bearer
+ * @min_win: minimum window (in packets) before declaring link congestion
+ * @max_win: maximum window (in packets) before declaring link congestion
  * @tolerance: default link tolerance for bearer
  * @domain: network domain to which links can be established
  * @identity: array index of this bearer within TIPC bearer array
- * @link_req: ptr to (optional) structure making periodic link setup requests
+ * @disc: ptr to link setup request
  * @net_plane: network plane ('A' through 'H') currently associated with bearer
+ * @up: bearer up flag (bit 0)
+ * @refcnt: tipc_bearer reference counter
  *
  * Note: media-specific code is responsible for initialization of the fields
  * indicated below when a bearer is enabled; TIPC's generic bearer code takes
--- net-next.orig/net/tipc/crypto.h
+++ net-next/net/tipc/crypto.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/**
+/*
  * net/tipc/crypto.h: Include file for TIPC crypto
  *
  * Copyright (c) 2019, Ericsson AB
@@ -53,7 +53,7 @@
 #define TIPC_AES_GCM_IV_SIZE		12
 #define TIPC_AES_GCM_TAG_SIZE		16
 
-/**
+/*
  * TIPC crypto modes:
  * - CLUSTER_KEY:
  *	One single key is used for both TX & RX in all nodes in the cluster.
@@ -69,7 +69,7 @@ enum {
 extern int sysctl_tipc_max_tfms __read_mostly;
 extern int sysctl_tipc_key_exchange_enabled __read_mostly;
 
-/**
+/*
  * TIPC encryption message format:
  *
  *     3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
--- net-next.orig/net/tipc/name_distr.h
+++ net-next/net/tipc/name_distr.h
@@ -46,7 +46,7 @@
  * @type: name sequence type
  * @lower: name sequence lower bound
  * @upper: name sequence upper bound
- * @ref: publishing port reference
+ * @port: publishing port reference
  * @key: publication key
  *
  * ===> All fields are stored in network byte order. <===
--- net-next.orig/net/tipc/name_table.h
+++ net-next/net/tipc/name_table.h
@@ -60,8 +60,8 @@ struct tipc_group;
  * @key: publication key, unique across the cluster
  * @id: publication id
  * @binding_node: all publications from the same node which bound this one
- * - Remote publications: in node->publ_list
- *   Used by node/name distr to withdraw publications when node is lost
+ * - Remote publications: in node->publ_list;
+ * Used by node/name distr to withdraw publications when node is lost
  * - Local/node scope publications: in name_table->node_scope list
  * - Local/cluster scope publications: in name_table->cluster_scope list
  * @binding_sock: all publications from the same socket which bound this one
@@ -92,13 +92,16 @@ struct publication {
 
 /**
  * struct name_table - table containing all existing port name publications
- * @seq_hlist: name sequence hash lists
+ * @services: name sequence hash lists
  * @node_scope: all local publications with node scope
  *               - used by name_distr during re-init of name table
  * @cluster_scope: all local publications with cluster scope
  *               - used by name_distr to send bulk updates to new nodes
  *               - used by name_distr during re-init of name table
+ * @cluster_scope_lock: lock for accessing @cluster_scope
  * @local_publ_count: number of publications issued by this node
+ * @rc_dests: destination node counter
+ * @snd_nxt: next sequence number to be used
  */
 struct name_table {
 	struct hlist_head services[TIPC_NAMETBL_SIZE];
--- net-next.orig/net/tipc/subscr.h
+++ net-next/net/tipc/subscr.h
@@ -48,12 +48,15 @@ struct tipc_conn;
 
 /**
  * struct tipc_subscription - TIPC network topology subscription object
- * @subscriber: pointer to its subscriber
- * @seq: name sequence associated with subscription
+ * @kref: reference count for this subscription
+ * @net: network namespace associated with subscription
  * @timer: timer governing subscription duration (optional)
- * @nameseq_list: adjacent subscriptions in name sequence's subscription list
+ * @service_list: adjacent subscriptions in name sequence's subscription list
  * @sub_list: adjacent subscriptions in subscriber's subscription list
  * @evt: template for events generated by subscription
+ * @conid: connection identifier of topology server
+ * @inactive: true if this subscription is inactive
+ * @lock: serialize up/down and timer events
  */
 struct tipc_subscription {
 	struct kref kref;
@@ -64,7 +67,7 @@ struct tipc_subscription {
 	struct tipc_event evt;
 	int conid;
 	bool inactive;
-	spinlock_t lock; /* serialize up/down and timer events */
+	spinlock_t lock;
 };
 
 struct tipc_subscription *tipc_sub_subscribe(struct net *net,
