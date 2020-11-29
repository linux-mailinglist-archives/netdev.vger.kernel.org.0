Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096842C7AA2
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 19:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgK2SeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 13:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbgK2SeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 13:34:17 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ACFC061A04
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 10:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=uh4tIGVRyGOe4ObUdHLfqqu+ug2ELtFEb+zgwkxKvMo=; b=iOocjkAGhvqlIZBYukhwASCb1R
        7C6Yu5iDO+D8/jRLJjqe+tKU9NDFc0Cs1+4wd7leBG7GzfSqD+0/bF2iPxVGzzKDCIOK7quK2xB2i
        lAdGOQjAPqWS3LlInktVe7FSMDFTv3Up7XdKpE7f1WDSfItKWXxAsbXIfWaj2VG4OMGQZ5pcvt/dA
        XNeD9YO7h31IqM/O+9bK9hPXJRA1UjLCZDbryByGelGOz/E7ALu5MDKOL8Oyqcz/iX9AEloUm7NTf
        Uc9fPUCoBEft0PoI+giDv0CO7ABHzA92wP1YwHCfaG0GMW61jmN3gkQ4PWPWnb/heobeMFINV41Vi
        GoGWW3rg==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRVT-00011y-Fx; Sun, 29 Nov 2020 18:33:08 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 05/10 net-next v2] net/tipc: fix name_distr.c kernel-doc
Date:   Sun, 29 Nov 2020 10:32:45 -0800
Message-Id: <20201129183251.7049-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201129183251.7049-1-rdunlap@infradead.org>
References: <20201129183251.7049-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix name_distr.c kernel-doc warnings in preparation for adding to the
networking docbook.

../net/tipc/name_distr.c:55: warning: Function parameter or member 'i' not described in 'publ_to_item'
../net/tipc/name_distr.c:55: warning: Function parameter or member 'p' not described in 'publ_to_item'
../net/tipc/name_distr.c:70: warning: Function parameter or member 'net' not described in 'named_prepare_buf'
../net/tipc/name_distr.c:70: warning: Function parameter or member 'type' not described in 'named_prepare_buf'
../net/tipc/name_distr.c:70: warning: Function parameter or member 'size' not described in 'named_prepare_buf'
../net/tipc/name_distr.c:70: warning: Function parameter or member 'dest' not described in 'named_prepare_buf'
../net/tipc/name_distr.c:88: warning: Function parameter or member 'net' not described in 'tipc_named_publish'
../net/tipc/name_distr.c:88: warning: Function parameter or member 'publ' not described in 'tipc_named_publish'
../net/tipc/name_distr.c:116: warning: Function parameter or member 'net' not described in 'tipc_named_withdraw'
../net/tipc/name_distr.c:116: warning: Function parameter or member 'publ' not described in 'tipc_named_withdraw'
../net/tipc/name_distr.c:147: warning: Function parameter or member 'net' not described in 'named_distribute'
../net/tipc/name_distr.c:147: warning: Function parameter or member 'seqno' not described in 'named_distribute'
../net/tipc/name_distr.c:199: warning: Function parameter or member 'net' not described in 'tipc_named_node_up'
../net/tipc/name_distr.c:199: warning: Function parameter or member 'dnode' not described in 'tipc_named_node_up'
../net/tipc/name_distr.c:199: warning: Function parameter or member 'capabilities' not described in 'tipc_named_node_up'
../net/tipc/name_distr.c:225: warning: Function parameter or member 'net' not described in 'tipc_publ_purge'
../net/tipc/name_distr.c:225: warning: Function parameter or member 'publ' not described in 'tipc_publ_purge'
../net/tipc/name_distr.c:225: warning: Function parameter or member 'addr' not described in 'tipc_publ_purge'
../net/tipc/name_distr.c:272: warning: Function parameter or member 'net' not described in 'tipc_update_nametbl'
../net/tipc/name_distr.c:272: warning: Function parameter or member 'i' not described in 'tipc_update_nametbl'
../net/tipc/name_distr.c:272: warning: Function parameter or member 'node' not described in 'tipc_update_nametbl'
../net/tipc/name_distr.c:272: warning: Function parameter or member 'dtype' not described in 'tipc_update_nametbl'
../net/tipc/name_distr.c:353: warning: Function parameter or member 'net' not described in 'tipc_named_rcv'
../net/tipc/name_distr.c:353: warning: Function parameter or member 'namedq' not described in 'tipc_named_rcv'
../net/tipc/name_distr.c:353: warning: Function parameter or member 'rcv_nxt' not described in 'tipc_named_rcv'
../net/tipc/name_distr.c:353: warning: Function parameter or member 'open' not described in 'tipc_named_rcv'
../net/tipc/name_distr.c:383: warning: Function parameter or member 'net' not described in 'tipc_named_reinit'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
v2: rebase to current net-next

 net/tipc/name_distr.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- net-next.orig/net/tipc/name_distr.c
+++ net-next/net/tipc/name_distr.c
@@ -50,6 +50,8 @@ struct distr_queue_item {
 
 /**
  * publ_to_item - add publication info to a publication message
+ * @p: publication info
+ * @i: location of item in the message
  */
 static void publ_to_item(struct distr_item *i, struct publication *p)
 {
@@ -62,6 +64,10 @@ static void publ_to_item(struct distr_it
 
 /**
  * named_prepare_buf - allocate & initialize a publication message
+ * @net: the associated network namespace
+ * @type: message type
+ * @size: payload size
+ * @dest: destination node
  *
  * The buffer returned is of size INT_H_SIZE + payload size
  */
@@ -83,6 +89,8 @@ static struct sk_buff *named_prepare_buf
 
 /**
  * tipc_named_publish - tell other nodes about a new publication by this node
+ * @net: the associated network namespace
+ * @publ: the new publication
  */
 struct sk_buff *tipc_named_publish(struct net *net, struct publication *publ)
 {
@@ -111,6 +119,8 @@ struct sk_buff *tipc_named_publish(struc
 
 /**
  * tipc_named_withdraw - tell other nodes about a withdrawn publication by this node
+ * @net: the associated network namespace
+ * @publ: the withdrawn publication
  */
 struct sk_buff *tipc_named_withdraw(struct net *net, struct publication *publ)
 {
@@ -138,9 +148,11 @@ struct sk_buff *tipc_named_withdraw(stru
 
 /**
  * named_distribute - prepare name info for bulk distribution to another node
+ * @net: the associated network namespace
  * @list: list of messages (buffers) to be returned from this function
  * @dnode: node to be updated
  * @pls: linked list of publication items to be packed into buffer chain
+ * @seqno: sequence number for this message
  */
 static void named_distribute(struct net *net, struct sk_buff_head *list,
 			     u32 dnode, struct list_head *pls, u16 seqno)
@@ -194,6 +206,9 @@ static void named_distribute(struct net
 
 /**
  * tipc_named_node_up - tell specified node about all publications by this node
+ * @net: the associated network namespace
+ * @dnode: destination node
+ * @capabilities: peer node's capabilities
  */
 void tipc_named_node_up(struct net *net, u32 dnode, u16 capabilities)
 {
@@ -217,6 +232,9 @@ void tipc_named_node_up(struct net *net,
 
 /**
  * tipc_publ_purge - remove publication associated with a failed node
+ * @net: the associated network namespace
+ * @publ: the publication to remove
+ * @addr: failed node's address
  *
  * Invoked for each publication issued by a newly failed node.
  * Removes publication structure from name table & deletes it.
@@ -263,6 +281,10 @@ void tipc_publ_notify(struct net *net, s
 /**
  * tipc_update_nametbl - try to process a nametable update and notify
  *			 subscribers
+ * @net: the associated network namespace
+ * @i: location of item in the message
+ * @node: node address
+ * @dtype: name distributor message type
  *
  * tipc_nametbl_lock must be held.
  * Returns the publication item if successful, otherwise NULL.
@@ -347,6 +369,10 @@ static struct sk_buff *tipc_named_dequeu
 
 /**
  * tipc_named_rcv - process name table update messages sent by another node
+ * @net: the associated network namespace
+ * @namedq: queue to receive from
+ * @rcv_nxt: store last received seqno here
+ * @open: last bulk msg was received (FIXME)
  */
 void tipc_named_rcv(struct net *net, struct sk_buff_head *namedq,
 		    u16 *rcv_nxt, bool *open)
@@ -374,6 +400,7 @@ void tipc_named_rcv(struct net *net, str
 
 /**
  * tipc_named_reinit - re-initialize local publications
+ * @net: the associated network namespace
  *
  * This routine is called whenever TIPC networking is enabled.
  * All name table entries published by this node are updated to reflect
