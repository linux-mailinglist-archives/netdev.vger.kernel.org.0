Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4E12C3805
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgKYEUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbgKYEUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:20:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E784EC0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=UZXwskei2Q33fTbsJNjHCa9tKzz24PYPq+Ckem2UBE4=; b=opoCG5723cj/85lguZhsrzLzC3
        OTIHUpUe6L9/BowVEmrVbsPT0b5ImB8/OVoaQrU01u2N1M9J5YtV2Rhm/VwxFf7943cbRiVnUd3XQ
        SOFaT5Hk3EHar3NJwwEG7l0h0b0gXbbFpnLPUIal3U2/s8kLtePws9y/3HbB2GChNrW4MxJvOV/FP
        WAjieupK1eHtAQYdIOjh39ji9W9+5dbvP49VndAM/rlwve+YBxEbTd2wuuyFv4Uc2hwmze2pXpYHb
        kVC8L4YIQ/IBNFQKuRURXaZc6m1SAYdimLHKZoNGPpZqQrVAD9Njtdjj29pnaGsT01+ED4Abmc7kn
        Jc8eWgbw==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khmIO-0000SB-Ui; Wed, 25 Nov 2020 04:20:45 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 06/10 net-next] net/tipc: fix name_table.c kernel-doc
Date:   Tue, 24 Nov 2020 20:20:22 -0800
Message-Id: <20201125042026.25374-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
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
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/tipc/name_table.c |   42 +++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

--- linux-next-20201102.orig/net/tipc/name_table.c
+++ linux-next-20201102/net/tipc/name_table.c
@@ -103,7 +103,8 @@ RB_DECLARE_CALLBACKS_MAX(static, sr_call
  *                               range match
  * @sr: the service range pointer as a loop cursor
  * @sc: the pointer to tipc service which holds the service range rbtree
- * @start, end: the range (end >= start) for matching
+ * @start: beginning of the search range (end >= start) for matching
+ * @end: end of the search range (end >= start) for matching
  */
 #define service_range_foreach_match(sr, sc, start, end)			\
 	for (sr = service_range_match_first((sc)->ranges.rb_node,	\
@@ -117,7 +118,8 @@ RB_DECLARE_CALLBACKS_MAX(static, sr_call
 /**
  * service_range_match_first - find first service range matching a range
  * @n: the root node of service range rbtree for searching
- * @start, end: the range (end >= start) for matching
+ * @start: beginning of the search range (end >= start) for matching
+ * @end: end of the search range (end >= start) for matching
  *
  * Return: the leftmost service range node in the rbtree that overlaps the
  * specific range if any. Otherwise, returns NULL.
@@ -166,7 +168,8 @@ static struct service_range *service_ran
 /**
  * service_range_match_next - find next service range matching a range
  * @n: a node in service range rbtree from which the searching starts
- * @start, end: the range (end >= start) for matching
+ * @start: beginning of the search range (end >= start) for matching
+ * @end: end of the search range (end >= start) for matching
  *
  * Return: the next service range node to the given node in the rbtree that
  * overlaps the specific range if any. Otherwise, returns NULL.
@@ -218,6 +221,13 @@ static int hash(int x)
 
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
@@ -245,6 +255,8 @@ static struct publication *tipc_publ_cre
 
 /**
  * tipc_service_create - create a service structure for the specified 'type'
+ * @type: service type
+ * @hd: name_table services list
  *
  * Allocates a single range structure and sets it to all 0's.
  */
@@ -361,6 +373,9 @@ err:
 
 /**
  * tipc_service_remove_publ - remove a publication from a service
+ * @sr: service_range to remove publication from
+ * @node: target node
+ * @key: target publication key
  */
 static struct publication *tipc_service_remove_publ(struct service_range *sr,
 						    u32 node, u32 key)
@@ -377,7 +392,7 @@ static struct publication *tipc_service_
 	return NULL;
 }
 
-/**
+/*
  * Code reused: time_after32() for the same purpose
  */
 #define publication_after(pa, pb) time_after32((pa)->id, (pb)->id)
@@ -395,6 +410,8 @@ static int tipc_publ_sort(void *priv, st
  * tipc_service_subscribe - attach a subscription, and optionally
  * issue the prescribed number of events if there is any service
  * range overlapping with the requested range
+ * @service: the tipc_service to attach the @sub to
+ * @sub: the subscription to attach
  */
 static void tipc_service_subscribe(struct tipc_service *service,
 				   struct tipc_subscription *sub)
@@ -528,8 +545,10 @@ exit:
 
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
@@ -756,6 +775,11 @@ exit:
 
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
@@ -791,6 +815,7 @@ int tipc_nametbl_withdraw(struct net *ne
 
 /**
  * tipc_nametbl_subscribe - add a subscription object to the name table
+ * @sub: subscription to add
  */
 bool tipc_nametbl_subscribe(struct tipc_subscription *sub)
 {
@@ -821,6 +846,7 @@ bool tipc_nametbl_subscribe(struct tipc_
 
 /**
  * tipc_nametbl_unsubscribe - remove a subscription object from name table
+ * @sub: subscription to remove
  */
 void tipc_nametbl_unsubscribe(struct tipc_subscription *sub)
 {
@@ -870,7 +896,9 @@ int tipc_nametbl_init(struct net *net)
 }
 
 /**
- *  tipc_service_delete - purge all publications for a service and delete it
+ * tipc_service_delete - purge all publications for a service and delete it
+ * @net: the associated network namespace
+ * @sc: tipc_service to delete
  */
 static void tipc_service_delete(struct net *net, struct tipc_service *sc)
 {
