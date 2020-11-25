Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AABC2C3802
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgKYEUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgKYEUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:20:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDB6C0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3jeNkokVsVj7u1u29ntjqFet+7EqMcY34oXvc/FRSUc=; b=Pro1zcEBCtv7JqGwYTYVb+XOo7
        jY7aspQZ6Q9AUXj6Er9Q7wMsln5s19sd92tCrMo06kwQkGMv6XrWou1uDy7Ct8+HFy+jeBR0JKTiG
        nYY7xCLSFtH3thB6jARqkBBMHkvjQHoCLcm2Z5A/q8rhQNu3I3KYfNy3MohvSlwX2swJcrUqbcncV
        NWQFiWYw+lXrEY+n+l8j+ym/NALxjgBUU2EMoFaUeTsKjwxOBLXYxD6lPet53mmM8jm+LHvkwjUes
        W47FE6gF0BxPCG4qZ08ozY8CpYYO9wraFge4omnXmsFq7+rc8rn3eL3qQFIpNTO/rzIaDAANNpWFf
        EeqcTVdw==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khmIH-0000SB-JR; Wed, 25 Nov 2020 04:20:38 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 01/10 net-next] net/tipc: fix tipc header files for kernel-doc
Date:   Tue, 24 Nov 2020 20:20:19 -0800
Message-Id: <20201125042026.25374-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix tipc header files for adding to the networking docbook.

Remove some uses of "/**" that were not kernel-doc notation.

Fix some source formatting to eliminate Sphinx warnings.

Add missing struct member and function argument kernel-doc descriptions.

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
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/tipc/bearer.h     |   10 +++++++---
 net/tipc/crypto.h     |    6 +++---
 net/tipc/name_distr.h |    2 +-
 net/tipc/name_table.h |    9 ++++++---
 net/tipc/subscr.h     |   11 +++++++----
 5 files changed, 24 insertions(+), 14 deletions(-)

--- linux-next-20201102.orig/net/tipc/bearer.h
+++ linux-next-20201102/net/tipc/bearer.h
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
--- linux-next-20201102.orig/net/tipc/crypto.h
+++ linux-next-20201102/net/tipc/crypto.h
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
--- linux-next-20201102.orig/net/tipc/name_distr.h
+++ linux-next-20201102/net/tipc/name_distr.h
@@ -46,7 +46,7 @@
  * @type: name sequence type
  * @lower: name sequence lower bound
  * @upper: name sequence upper bound
- * @ref: publishing port reference
+ * @port: publishing port reference
  * @key: publication key
  *
  * ===> All fields are stored in network byte order. <===
--- linux-next-20201102.orig/net/tipc/name_table.h
+++ linux-next-20201102/net/tipc/name_table.h
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
+ * @rc_dests: broadcast destinations counter (FIXME)
+ * @snd_nxt: next sequence number to be used
  */
 struct name_table {
 	struct hlist_head services[TIPC_NAMETBL_SIZE];
--- linux-next-20201102.orig/net/tipc/subscr.h
+++ linux-next-20201102/net/tipc/subscr.h
@@ -47,12 +47,15 @@ struct tipc_conn;
 
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
+ * @conid: connection ID for this subscription (FIXME)
+ * @inactive: true if this subscription is inactive
+ * @lock: serialize up/down and timer events
  */
 struct tipc_subscription {
 	struct kref kref;
@@ -63,7 +66,7 @@ struct tipc_subscription {
 	struct tipc_event evt;
 	int conid;
 	bool inactive;
-	spinlock_t lock; /* serialize up/down and timer events */
+	spinlock_t lock;
 };
 
 struct tipc_subscription *tipc_sub_subscribe(struct net *net,
