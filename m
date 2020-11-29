Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777942C7AA3
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 19:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgK2SeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 13:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbgK2SeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 13:34:17 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2B0C061A47
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 10:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wG+ojVJqTfEMZgI+SF6i++W9llYtgd5uH9cuBwA+Aas=; b=Gm2yLcqTGCL2Uu83NBYnHz6meb
        PRQ5VZfmfNkfujO6HQF5Tesnmr0DcMVZN1DcsZu1nf/uX8gZvyNoC4YGsGZ2/tBdDL6M/et0wJbof
        78w4FZD+rfHtq6njHQOy3nfQjTAAXnHuzU+sLD0YVXWWYMOiXgf0c1obvjatwsfsEco1AEvWL8j89
        YMAzBLenh1zftlewsJh14mTROSIktsimvZf0YB2fyYIVum3YiJNuhThT3cdI4G2PdhWNrUGIvK8iv
        jlc6ls+h3I555CnHK+HeJIgczhOoZDw5yfoBm/U6GfJDKCPlF2+FShBGw+0q7Gw9kjw9h0N1yY15m
        FyTJDFsw==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRVW-00011y-Bx; Sun, 29 Nov 2020 18:33:11 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 06/10 net-next v2] net/tipc: fix name_table.c kernel-doc
Date:   Sun, 29 Nov 2020 10:32:46 -0800
Message-Id: <20201129183251.7049-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201129183251.7049-1-rdunlap@infradead.org>
References: <20201129183251.7049-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix name_table.c kernel-doc warnings in preparation for adding to the
networking docbook.

../net/tipc/name_table.c:115: warning: Function parameter or member 'start' not described in 'service_range_foreach_match'
../net/tipc/name_table.c:115: warning: Function parameter or member 'end' not described in 'service_range_foreach_match'
../net/tipc/name_table.c:127: warning: Function parameter or member 'start' not described in 'service_range_match_first'
../net/tipc/name_table.c:127: warning: Function parameter or member 'end' not described in 'service_range_match_first'
../net/tipc/name_table.c:176: warning: Function parameter or member 'start' not described in 'service_range_match_next'
../net/tipc/name_table.c:176: warning: Function parameter or member 'end' not described in 'service_range_match_next'
../net/tipc/name_table.c:225: warning: Function parameter or member 'type' not described in 'tipc_publ_create'
../net/tipc/name_table.c:225: warning: Function parameter or member 'lower' not described in 'tipc_publ_create'
../net/tipc/name_table.c:225: warning: Function parameter or member 'upper' not described in 'tipc_publ_create'
../net/tipc/name_table.c:225: warning: Function parameter or member 'scope' not described in 'tipc_publ_create'
../net/tipc/name_table.c:225: warning: Function parameter or member 'node' not described in 'tipc_publ_create'
../net/tipc/name_table.c:225: warning: Function parameter or member 'port' not described in 'tipc_publ_create'
../net/tipc/name_table.c:225: warning: Function parameter or member 'key' not described in 'tipc_publ_create'
../net/tipc/name_table.c:252: warning: Function parameter or member 'type' not described in 'tipc_service_create'
../net/tipc/name_table.c:252: warning: Function parameter or member 'hd' not described in 'tipc_service_create'
../net/tipc/name_table.c:367: warning: Function parameter or member 'sr' not described in 'tipc_service_remove_publ'
../net/tipc/name_table.c:367: warning: Function parameter or member 'node' not described in 'tipc_service_remove_publ'
../net/tipc/name_table.c:367: warning: Function parameter or member 'key' not described in 'tipc_service_remove_publ'
../net/tipc/name_table.c:383: warning: Function parameter or member 'pa' not described in 'publication_after'
../net/tipc/name_table.c:383: warning: Function parameter or member 'pb' not described in 'publication_after'
../net/tipc/name_table.c:401: warning: Function parameter or member 'service' not described in 'tipc_service_subscribe'
../net/tipc/name_table.c:401: warning: Function parameter or member 'sub' not described in 'tipc_service_subscribe'
../net/tipc/name_table.c:546: warning: Function parameter or member 'net' not described in 'tipc_nametbl_translate'
../net/tipc/name_table.c:546: warning: Function parameter or member 'type' not described in 'tipc_nametbl_translate'
../net/tipc/name_table.c:546: warning: Function parameter or member 'instance' not described in 'tipc_nametbl_translate'
../net/tipc/name_table.c:546: warning: Function parameter or member 'dnode' not described in 'tipc_nametbl_translate'
../net/tipc/name_table.c:762: warning: Function parameter or member 'net' not described in 'tipc_nametbl_withdraw'
../net/tipc/name_table.c:762: warning: Function parameter or member 'type' not described in 'tipc_nametbl_withdraw'
../net/tipc/name_table.c:762: warning: Function parameter or member 'lower' not described in 'tipc_nametbl_withdraw'
../net/tipc/name_table.c:762: warning: Function parameter or member 'upper' not described in 'tipc_nametbl_withdraw'
../net/tipc/name_table.c:762: warning: Function parameter or member 'key' not described in 'tipc_nametbl_withdraw'
../net/tipc/name_table.c:796: warning: Function parameter or member 'sub' not described in 'tipc_nametbl_subscribe'
../net/tipc/name_table.c:826: warning: Function parameter or member 'sub' not described in 'tipc_nametbl_unsubscribe'
../net/tipc/name_table.c:876: warning: Function parameter or member 'net' not described in 'tipc_service_delete'
../net/tipc/name_table.c:876: warning: Function parameter or member 'sc' not described in 'tipc_service_delete'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
v2: rebase to current net-next

 net/tipc/name_table.c |   42 +++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

--- net-next.orig/net/tipc/name_table.c
+++ net-next/net/tipc/name_table.c
@@ -104,7 +104,8 @@ RB_DECLARE_CALLBACKS_MAX(static, sr_call
  *                               range match
  * @sr: the service range pointer as a loop cursor
  * @sc: the pointer to tipc service which holds the service range rbtree
- * @start, end: the range (end >= start) for matching
+ * @start: beginning of the search range (end >= start) for matching
+ * @end: end of the search range (end >= start) for matching
  */
 #define service_range_foreach_match(sr, sc, start, end)			\
 	for (sr = service_range_match_first((sc)->ranges.rb_node,	\
@@ -118,7 +119,8 @@ RB_DECLARE_CALLBACKS_MAX(static, sr_call
 /**
  * service_range_match_first - find first service range matching a range
  * @n: the root node of service range rbtree for searching
- * @start, end: the range (end >= start) for matching
+ * @start: beginning of the search range (end >= start) for matching
+ * @end: end of the search range (end >= start) for matching
  *
  * Return: the leftmost service range node in the rbtree that overlaps the
  * specific range if any. Otherwise, returns NULL.
@@ -167,7 +169,8 @@ static struct service_range *service_ran
 /**
  * service_range_match_next - find next service range matching a range
  * @n: a node in service range rbtree from which the searching starts
- * @start, end: the range (end >= start) for matching
+ * @start: beginning of the search range (end >= start) for matching
+ * @end: end of the search range (end >= start) for matching
  *
  * Return: the next service range node to the given node in the rbtree that
  * overlaps the specific range if any. Otherwise, returns NULL.
@@ -219,6 +222,13 @@ static int hash(int x)
 
 /**
  * tipc_publ_create - create a publication structure
+ * @type: name sequence type
+ * @lower: name sequence lower bound
+ * @upper: name sequence upper bound
+ * @scope: publication scope
+ * @node: network address of publishing socket
+ * @port: publishing port
+ * @key: publication key
  */
 static struct publication *tipc_publ_create(u32 type, u32 lower, u32 upper,
 					    u32 scope, u32 node, u32 port,
@@ -246,6 +256,8 @@ static struct publication *tipc_publ_cre
 
 /**
  * tipc_service_create - create a service structure for the specified 'type'
+ * @type: service type
+ * @hd: name_table services list
  *
  * Allocates a single range structure and sets it to all 0's.
  */
@@ -362,6 +374,9 @@ err:
 
 /**
  * tipc_service_remove_publ - remove a publication from a service
+ * @sr: service_range to remove publication from
+ * @node: target node
+ * @key: target publication key
  */
 static struct publication *tipc_service_remove_publ(struct service_range *sr,
 						    u32 node, u32 key)
@@ -378,7 +393,7 @@ static struct publication *tipc_service_
 	return NULL;
 }
 
-/**
+/*
  * Code reused: time_after32() for the same purpose
  */
 #define publication_after(pa, pb) time_after32((pa)->id, (pb)->id)
@@ -396,6 +411,8 @@ static int tipc_publ_sort(void *priv, st
  * tipc_service_subscribe - attach a subscription, and optionally
  * issue the prescribed number of events if there is any service
  * range overlapping with the requested range
+ * @service: the tipc_service to attach the @sub to
+ * @sub: the subscription to attach
  */
 static void tipc_service_subscribe(struct tipc_service *service,
 				   struct tipc_subscription *sub)
@@ -529,8 +546,10 @@ exit:
 
 /**
  * tipc_nametbl_translate - perform service instance to socket translation
- *
- * On entry, 'dnode' is the search domain used during translation.
+ * @net: network namespace
+ * @type: message type
+ * @instance: message instance
+ * @dnode: the search domain used during translation
  *
  * On exit:
  * - if translation is deferred to another node, leave 'dnode' unchanged and
@@ -757,6 +776,11 @@ exit:
 
 /**
  * tipc_nametbl_withdraw - withdraw a service binding
+ * @net: network namespace
+ * @type: service type
+ * @lower: service range lower bound
+ * @upper: service range upper bound
+ * @key: target publication key
  */
 int tipc_nametbl_withdraw(struct net *net, u32 type, u32 lower,
 			  u32 upper, u32 key)
@@ -792,6 +816,7 @@ int tipc_nametbl_withdraw(struct net *ne
 
 /**
  * tipc_nametbl_subscribe - add a subscription object to the name table
+ * @sub: subscription to add
  */
 bool tipc_nametbl_subscribe(struct tipc_subscription *sub)
 {
@@ -822,6 +847,7 @@ bool tipc_nametbl_subscribe(struct tipc_
 
 /**
  * tipc_nametbl_unsubscribe - remove a subscription object from name table
+ * @sub: subscription to remove
  */
 void tipc_nametbl_unsubscribe(struct tipc_subscription *sub)
 {
@@ -871,7 +897,9 @@ int tipc_nametbl_init(struct net *net)
 }
 
 /**
- *  tipc_service_delete - purge all publications for a service and delete it
+ * tipc_service_delete - purge all publications for a service and delete it
+ * @net: the associated network namespace
+ * @sc: tipc_service to delete
  */
 static void tipc_service_delete(struct net *net, struct tipc_service *sc)
 {
