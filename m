Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2592C3809
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgKYEVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgKYEVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:21:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC868C0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=QipUbZNRebB5kqxTpNzmNIjt/HkwOH4MpjpSByLWjHM=; b=t6ep8kIxePIRlMfnBb69p87Phx
        i1exmnhajk+N8p4vpc9qO9+IDaxjzN5QjRf4P5FVvTAroV9cuDPvJIlMmHYcAtjWvVLG7jlDF7/wi
        0hg5BEait8Xtl6+0Lk3kSDaNV7c7pUUSmuC4+LJee/HWICoCgNWbB9KMT4wg0+0HC0R7bskFSUCf0
        8kQRy95mNMFtBPt3kb+QiP1j5oWaQvIzULxnQf9hirNs7U6Zo2qxoGZsSF/nphUh/XmEjVKp3NqeJ
        UtNp3R6PSpnkGVdDlNtF8mNHi4J3gdNnBsqYYRI83yXOcHzh9hnXQWgINKj1MOsYcJWHJcDseaGXo
        KJacgjJg==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khmIZ-0000SB-OK; Wed, 25 Nov 2020 04:20:57 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 02/10 net-next] net/tipc: fix various kernel-doc warnings
Date:   Tue, 24 Nov 2020 20:20:26 -0800
Message-Id: <20201125042026.25374-11-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel-doc and Sphinx fixes to eliminate lots of warnings
in preparation for adding to the networking docbook.

../net/tipc/crypto.c:57: warning: cannot understand function prototype: 'enum '
../net/tipc/crypto.c:69: warning: cannot understand function prototype: 'enum '
../net/tipc/crypto.c:130: warning: Function parameter or member 'tfm' not described in 'tipc_tfm'
../net/tipc/crypto.c:130: warning: Function parameter or member 'list' not described in 'tipc_tfm'
../net/tipc/crypto.c:172: warning: Function parameter or member 'stat' not described in 'tipc_crypto_stats'
../net/tipc/crypto.c:232: warning: Function parameter or member 'flags' not described in 'tipc_crypto'
../net/tipc/crypto.c:329: warning: Function parameter or member 'ukey' not described in 'tipc_aead_key_validate'
../net/tipc/crypto.c:329: warning: Function parameter or member 'info' not described in 'tipc_aead_key_validate'
../net/tipc/crypto.c:482: warning: Function parameter or member 'aead' not described in 'tipc_aead_tfm_next'
../net/tipc/trace.c:43: warning: cannot understand function prototype: 'unsigned long sysctl_tipc_sk_filter[5] __read_mostly = '

Documentation/networking/tipc:57: ../net/tipc/msg.c:584: WARNING: Unexpected indentation.
Documentation/networking/tipc:63: ../net/tipc/name_table.c:536: WARNING: Unexpected indentation.
Documentation/networking/tipc:63: ../net/tipc/name_table.c:537: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/networking/tipc:78: ../net/tipc/socket.c:3809: WARNING: Unexpected indentation.
Documentation/networking/tipc:78: ../net/tipc/socket.c:3807: WARNING: Inline strong start-string without end-string.
Documentation/networking/tipc:72: ../net/tipc/node.c:904: WARNING: Unexpected indentation.
Documentation/networking/tipc:39: ../net/tipc/crypto.c:97: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/networking/tipc:39: ../net/tipc/crypto.c:98: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/networking/tipc:39: ../net/tipc/crypto.c:141: WARNING: Inline strong start-string without end-string.

../net/tipc/discover.c:82: warning: Function parameter or member 'skb' not described in 'tipc_disc_init_msg'

../net/tipc/msg.c:69: warning: Function parameter or member 'gfp' not described in 'tipc_buf_acquire'
../net/tipc/msg.c:382: warning: Function parameter or member 'offset' not described in 'tipc_msg_build'
../net/tipc/msg.c:708: warning: Function parameter or member 'net' not described in 'tipc_msg_lookup_dest'

../net/tipc/subscr.c:65: warning: Function parameter or member 'seq' not described in 'tipc_sub_check_overlap'
../net/tipc/subscr.c:65: warning: Function parameter or member 'found_lower' not described in 'tipc_sub_check_overlap'
../net/tipc/subscr.c:65: warning: Function parameter or member 'found_upper' not described in 'tipc_sub_check_overlap'

../net/tipc/udp_media.c:75: warning: Function parameter or member 'proto' not described in 'udp_media_addr'
../net/tipc/udp_media.c:75: warning: Function parameter or member 'port' not described in 'udp_media_addr'
../net/tipc/udp_media.c:75: warning: Function parameter or member 'ipv4' not described in 'udp_media_addr'
../net/tipc/udp_media.c:75: warning: Function parameter or member 'ipv6' not described in 'udp_media_addr'
../net/tipc/udp_media.c:98: warning: Function parameter or member 'rcast' not described in 'udp_bearer'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/tipc/crypto.c     |   17 ++++++++++++-----
 net/tipc/discover.c   |    1 +
 net/tipc/msg.c        |   10 +++++++---
 net/tipc/name_table.c |    4 ++--
 net/tipc/node.c       |    5 +++--
 net/tipc/socket.c     |    4 ++--
 net/tipc/subscr.c     |    6 ++++--
 net/tipc/trace.c      |    2 +-
 net/tipc/udp_media.c  |    8 +++++++-
 9 files changed, 39 insertions(+), 18 deletions(-)

--- linux-next-20201124.orig/net/tipc/crypto.c
+++ linux-next-20201124/net/tipc/crypto.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/**
+/*
  * net/tipc/crypto.c: TIPC crypto for key handling & packet en/decryption
  *
  * Copyright (c) 2019, Ericsson AB
@@ -51,7 +51,7 @@
 
 #define TIPC_REKEYING_INTV_DEF	(60 * 24) /* default: 1 day */
 
-/**
+/*
  * TIPC Key ids
  */
 enum {
@@ -63,7 +63,7 @@ enum {
 	KEY_MAX = KEY_3,
 };
 
-/**
+/*
  * TIPC Crypto statistics
  */
 enum {
@@ -90,7 +90,7 @@ int sysctl_tipc_max_tfms __read_mostly =
 /* Key exchange switch, default: on */
 int sysctl_tipc_key_exchange_enabled __read_mostly = 1;
 
-/**
+/*
  * struct tipc_key - TIPC keys' status indicator
  *
  *         7     6     5     4     3     2     1     0
@@ -123,6 +123,8 @@ struct tipc_key {
 
 /**
  * struct tipc_tfm - TIPC TFM structure to form a list of TFMs
+ * @tfm: cipher handle/key
+ * @list: linked list of TFMs
  */
 struct tipc_tfm {
 	struct crypto_aead *tfm;
@@ -138,7 +140,7 @@ struct tipc_tfm {
  * @salt: the key's SALT value
  * @authsize: authentication tag size (max = 16)
  * @mode: crypto mode is applied to the key
- * @hint[]: a hint for user key
+ * @hint: a hint for user key
  * @rcu: struct rcu_head
  * @key: the aead key
  * @gen: the key's generation
@@ -166,6 +168,7 @@ struct tipc_aead {
 
 /**
  * struct tipc_crypto_stats - TIPC Crypto statistics
+ * @stat: array of crypto statistics
  */
 struct tipc_crypto_stats {
 	unsigned int stat[MAX_STATS];
@@ -194,6 +197,7 @@ struct tipc_crypto_stats {
  * @key_master: flag indicates if master key exists
  * @legacy_user: flag indicates if a peer joins w/o master key (for bwd comp.)
  * @nokey: no key indication
+ * @flags: combined flags field
  * @lock: tipc_key lock
  */
 struct tipc_crypto {
@@ -324,6 +328,8 @@ do {									\
 
 /**
  * tipc_aead_key_validate - Validate a AEAD user key
+ * @ukey: pointer to user key data
+ * @info: netlink info pointer
  */
 int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info)
 {
@@ -477,6 +483,7 @@ static void tipc_aead_users_set(struct t
 
 /**
  * tipc_aead_tfm_next - Move TFM entry to the next one in list and return it
+ * @aead: the AEAD key pointer
  */
 static struct crypto_aead *tipc_aead_tfm_next(struct tipc_aead *aead)
 {
--- linux-next-20201124.orig/net/tipc/trace.c
+++ linux-next-20201124/net/tipc/trace.c
@@ -36,7 +36,7 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
-/**
+/*
  * socket tuples for filtering in socket traces:
  * (portid, sock type, name type, name lower, name upper)
  */
--- linux-next-20201124.orig/net/tipc/msg.c
+++ linux-next-20201124/net/tipc/msg.c
@@ -58,11 +58,13 @@ static unsigned int align(unsigned int i
 /**
  * tipc_buf_acquire - creates a TIPC message buffer
  * @size: message size (including TIPC header)
+ * @gfp: memory allocation flags
  *
  * Returns a new buffer with data pointers set to the specified size.
  *
- * NOTE: Headroom is reserved to allow prepending of a data link header.
- *       There may also be unrequested tailroom present at the buffer's end.
+ * NOTE:
+ * Headroom is reserved to allow prepending of a data link header.
+ * There may also be unrequested tailroom present at the buffer's end.
  */
 struct sk_buff *tipc_buf_acquire(u32 size, gfp_t gfp)
 {
@@ -367,6 +369,7 @@ error:
  * tipc_msg_build - create buffer chain containing specified header and data
  * @mhdr: Message header, to be prepended to data
  * @m: User message
+ * @offset: buffer offset for fragmented messages (FIXME)
  * @dsz: Total length of user data
  * @pktmax: Max packet size that can be used
  * @list: Buffer or chain of buffers to be returned to caller
@@ -580,7 +583,7 @@ bundle:
  *  @skb: buffer to be extracted from.
  *  @iskb: extracted inner buffer, to be returned
  *  @pos: position in outer message of msg to be extracted.
- *        Returns position of next msg
+ *  Returns position of next msg.
  *  Consumes outer buffer when last packet extracted
  *  Returns true when there is an extracted buffer, otherwise false
  */
@@ -698,6 +701,7 @@ bool tipc_msg_skb_clone(struct sk_buff_h
 
 /**
  * tipc_msg_lookup_dest(): try to find new destination for named message
+ * @net: pointer to associated network namespace
  * @skb: the buffer containing the message.
  * @err: error code to be used by caller if lookup fails
  * Does not consume buffer
--- linux-next-20201124.orig/net/tipc/name_table.c
+++ linux-next-20201124/net/tipc/name_table.c
@@ -533,9 +533,9 @@ exit:
  *
  * On exit:
  * - if translation is deferred to another node, leave 'dnode' unchanged and
- *   return 0
+ * return 0
  * - if translation is attempted and succeeds, set 'dnode' to the publishing
- *   node and return the published (non-zero) port number
+ * node and return the published (non-zero) port number
  * - if translation is attempted and fails, set 'dnode' to 0 and return 0
  *
  * Note that for legacy users (node configured with Z.C.N address format) the
--- linux-next-20201124.orig/net/tipc/socket.c
+++ linux-next-20201124/net/tipc/socket.c
@@ -3805,8 +3805,8 @@ int tipc_nl_publ_dump(struct sk_buff *sk
 /**
  * tipc_sk_filtering - check if a socket should be traced
  * @sk: the socket to be examined
- * @sysctl_tipc_sk_filter[]: the socket tuple for filtering,
- *  (portid, sock type, name type, name lower, name upper)
+ * @sysctl_tipc_sk_filter: the socket tuple for filtering:
+ * (portid, sock type, name type, name lower, name upper)
  *
  * Returns true if the socket meets the socket tuple data
  * (value 0 = 'any') or when there is no tuple set (all = 0),
--- linux-next-20201124.orig/net/tipc/node.c
+++ linux-next-20201124/net/tipc/node.c
@@ -900,10 +900,11 @@ static void tipc_node_link_up(struct tip
  *
  * This function is only called in a very special situation where link
  * failover can be already started on peer node but not on this node.
- * This can happen when e.g.
+ * This can happen when e.g.::
+ *
  *	1. Both links <1A-2A>, <1B-2B> down
  *	2. Link endpoint 2A up, but 1A still down (e.g. due to network
- *	   disturbance, wrong session, etc.)
+ *	disturbance, wrong session, etc.)
  *	3. Link <1B-2B> up
  *	4. Link endpoint 2A down (e.g. due to link tolerance timeout)
  *	5. Node 2 starts failover onto link <1B-2B>
--- linux-next-20201124.orig/net/tipc/discover.c
+++ linux-next-20201124/net/tipc/discover.c
@@ -74,6 +74,7 @@ struct tipc_discoverer {
 /**
  * tipc_disc_init_msg - initialize a link setup message
  * @net: the applicable net namespace
+ * @skb: buffer containing message
  * @mtyp: message type (request or response)
  * @b: ptr to bearer issuing message
  */
--- linux-next-20201124.orig/net/tipc/subscr.c
+++ linux-next-20201124/net/tipc/subscr.c
@@ -55,8 +55,10 @@ static void tipc_sub_send_event(struct t
 }
 
 /**
- * tipc_sub_check_overlap - test for subscription overlap with the
- * given values
+ * tipc_sub_check_overlap - test for subscription overlap with the given values
+ * @seq: tipc_name_seq to check
+ * @found_lower: lower value to test
+ * @found_upper: upper value to test
  *
  * Returns 1 if there is overlap, otherwise 0.
  */
--- linux-next-20201124.orig/net/tipc/udp_media.c
+++ linux-next-20201124/net/tipc/udp_media.c
@@ -64,6 +64,11 @@
  *
  * This is the bearer level originating address used in neighbor discovery
  * messages, and all fields should be in network byte order
+ *
+ * @proto: Ethernet protocol in use
+ * @port: port being used
+ * @ipv4: IPv4 address of neighbor
+ * @ipv6: IPv6 address of neighbor
  */
 struct udp_media_addr {
 	__be16	proto;
@@ -88,6 +93,7 @@ struct udp_replicast {
  * @ubsock:	bearer associated socket
  * @ifindex:	local address scope
  * @work:	used to schedule deferred work on a bearer
+ * @rcast:	associated udp_replicast container
  */
 struct udp_bearer {
 	struct tipc_bearer __rcu *bearer;
@@ -772,7 +778,7 @@ static int tipc_udp_enable(struct net *n
 	if (err)
 		goto free;
 
-	/**
+	/*
 	 * The bcast media address port is used for all peers and the ip
 	 * is used if it's a multicast address.
 	 */
