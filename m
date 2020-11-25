Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601702C3808
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgKYEVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgKYEU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:20:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AEEC0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=kbl3usflLvVsbvwBmk1GORUzslG18jOOUBMowWbhqN4=; b=Z2VmU+vfFDV1llfhMayh7kx4aA
        Ju6TFvfuIk+cGca7vbbiUTpla5UzOxvaZyhs1mRqGRGrYVRFGyg1pfzZvnWfR1omROMOs/o501snX
        XLRQUz9n3HZtl9uEaFaQtKMT4ARu21KEjmqtPLfFw0FOKviszRrt95U5cu/GTRgrS9qZo6fesdD2j
        LPvCXnZHgSVxPMqKRKcRmYmr2pFR8m/grnJZLdz3yDgu1WkY6OqwnAfWbEfIROMgIw9BZlItOH+JO
        TeMCSUs8f6ydWVxqNTOKgS8k9+ZKnTQLvLS07kKgmJSuHlysJWlxAP3g67QebXYhZfJAw0IAaLoGP
        gL2Wel/g==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khmIX-0000SB-2T; Wed, 25 Nov 2020 04:20:53 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 08/10 net-next] net/tipc: fix socket.c kernel-doc
Date:   Tue, 24 Nov 2020 20:20:25 -0800
Message-Id: <20201125042026.25374-10-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix socket.c kernel-doc warnings in preparation for adding to the
networking docbook.

Also, for rcvbuf_limit(), use bullet notation so that the lines do
not run together.

../net/tipc/socket.c:130: warning: Function parameter or member 'cong_links' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'probe_unacked' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'snd_win' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'peer_caps' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'rcv_win' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'group' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'oneway' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'nagle_start' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'snd_backlog' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'msg_acc' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'pkt_cnt' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'expect_ack' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'nodelay' not described in 'tipc_sock'
../net/tipc/socket.c:130: warning: Function parameter or member 'group_is_open' not described in 'tipc_sock'
../net/tipc/socket.c:267: warning: Function parameter or member 'sk' not described in 'tsk_advance_rx_queue'
../net/tipc/socket.c:295: warning: Function parameter or member 'sk' not described in 'tsk_rej_rx_queue'
../net/tipc/socket.c:295: warning: Function parameter or member 'error' not described in 'tsk_rej_rx_queue'
../net/tipc/socket.c:894: warning: Function parameter or member 'tsk' not described in 'tipc_send_group_msg'
../net/tipc/socket.c:1187: warning: Function parameter or member 'net' not described in 'tipc_sk_mcast_rcv'
../net/tipc/socket.c:1323: warning: Function parameter or member 'inputq' not described in 'tipc_sk_conn_proto_rcv'
../net/tipc/socket.c:1323: warning: Function parameter or member 'xmitq' not described in 'tipc_sk_conn_proto_rcv'
../net/tipc/socket.c:1885: warning: Function parameter or member 'sock' not described in 'tipc_recvmsg'
../net/tipc/socket.c:1993: warning: Function parameter or member 'sock' not described in 'tipc_recvstream'
../net/tipc/socket.c:2313: warning: Function parameter or member 'xmitq' not described in 'tipc_sk_filter_rcv'
../net/tipc/socket.c:2404: warning: Function parameter or member 'xmitq' not described in 'tipc_sk_enqueue'
../net/tipc/socket.c:2456: warning: Function parameter or member 'net' not described in 'tipc_sk_rcv'
../net/tipc/socket.c:2693: warning: Function parameter or member 'kern' not described in 'tipc_accept'
../net/tipc/socket.c:3816: warning: Excess function parameter 'sysctl_tipc_sk_filter' description in 'tipc_sk_filtering'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/tipc/socket.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

--- linux-next-20201102.orig/net/tipc/socket.c
+++ linux-next-20201102/net/tipc/socket.c
@@ -79,19 +79,32 @@ struct sockaddr_pair {
  * @maxnagle: maximum size of msg which can be subject to nagle
  * @portid: unique port identity in TIPC socket hash table
  * @phdr: preformatted message header used when sending messages
- * #cong_links: list of congested links
+ * @cong_links: list of congested links
  * @publications: list of publications for port
  * @blocking_link: address of the congested link we are currently sleeping on
  * @pub_count: total # of publications port has made during its lifetime
  * @conn_timeout: the time we can wait for an unresponded setup request
+ * @probe_unacked: probe has not received ack yet
  * @dupl_rcvcnt: number of bytes counted twice, in both backlog and rcv queue
  * @cong_link_cnt: number of congested links
  * @snt_unacked: # messages sent by socket, and not yet acked by peer
+ * @snd_win: send window size
+ * @peer_caps: peer capabilities mask
  * @rcv_unacked: # messages read by user, but not yet acked back to peer
+ * @rcv_win: receive window size
  * @peer: 'connected' peer for dgram/rdm
  * @node: hash table node
  * @mc_method: cookie for use between socket and broadcast layer
  * @rcu: rcu struct for tipc_sock
+ * @group: TIPC communications group
+ * @oneway: message count in one direction (FIXME)
+ * @nagle_start: current nagle value
+ * @snd_backlog: send backlog count
+ * @msg_acc: messages accepted; used in managing backlog and nagle
+ * @pkt_cnt: TIPC socket packet count
+ * @expect_ack: whether this TIPC socket is expecting an ack
+ * @nodelay: setsockopt() TIPC_NODELAY setting
+ * @group_is_open: TIPC socket group is fully open (FIXME)
  */
 struct tipc_sock {
 	struct sock sk;
@@ -260,6 +273,7 @@ static void tsk_set_nagle(struct tipc_so
 
 /**
  * tsk_advance_rx_queue - discard first buffer in socket receive queue
+ * @sk: network socket
  *
  * Caller must hold socket lock
  */
@@ -288,6 +302,8 @@ static void tipc_sk_respond(struct sock
 
 /**
  * tsk_rej_rx_queue - reject all buffers in socket receive queue
+ * @sk: network socket
+ * @error: response error code
  *
  * Caller must hold socket lock
  */
@@ -882,6 +898,7 @@ static int tipc_sendmcast(struct  socket
 /**
  * tipc_send_group_msg - send a message to a member in the group
  * @net: network namespace
+ * @tsk: tipc socket
  * @m: message to send
  * @mb: group member
  * @dnode: destination node
@@ -1177,6 +1194,7 @@ static int tipc_send_group_mcast(struct
 
 /**
  * tipc_sk_mcast_rcv - Deliver multicast messages to all destination sockets
+ * @net: the associated network namespace
  * @arrvq: queue with arriving messages, to be cloned after destination lookup
  * @inputq: queue with cloned messages, delivered to socket after dest lookup
  *
@@ -1316,6 +1334,8 @@ static void tipc_sk_push_backlog(struct
  * tipc_sk_conn_proto_rcv - receive a connection mng protocol message
  * @tsk: receiving socket
  * @skb: pointer to message buffer.
+ * @inputq: buffer list containing the buffers
+ * @xmitq: output message area
  */
 static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
 				   struct sk_buff_head *inputq,
@@ -1871,6 +1891,7 @@ static int tipc_wait_for_rcvmsg(struct s
 
 /**
  * tipc_recvmsg - receive packet-oriented message
+ * @sock: network socket
  * @m: descriptor for message info
  * @buflen: length of user buffer area
  * @flags: receive flags
@@ -1979,6 +2000,7 @@ exit:
 
 /**
  * tipc_recvstream - receive stream-oriented data
+ * @sock: network socket
  * @m: descriptor for message info
  * @buflen: total size of user buffer area
  * @flags: receive flags
@@ -2301,6 +2323,7 @@ static unsigned int rcvbuf_limit(struct
  * tipc_sk_filter_rcv - validate incoming message
  * @sk: socket
  * @skb: pointer to message.
+ * @xmitq: output message area (FIXME)
  *
  * Enqueues message on receive queue if acceptable; optionally handles
  * disconnect indication for a connected socket.
@@ -2396,6 +2419,7 @@ static int tipc_sk_backlog_rcv(struct so
  * @inputq: list of incoming buffers with potentially different destinations
  * @sk: socket where the buffers should be enqueued
  * @dport: port number for the socket
+ * @xmitq: output queue
  *
  * Caller must hold socket lock
  */
@@ -2448,6 +2472,7 @@ static void tipc_sk_enqueue(struct sk_bu
 
 /**
  * tipc_sk_rcv - handle a chain of incoming buffers
+ * @net: the associated network namespace
  * @inputq: buffer list containing the buffers
  * Consumes all buffers in list until inputq is empty
  * Note: may be called in multiple threads referring to the same queue
@@ -2685,6 +2710,7 @@ static int tipc_wait_for_accept(struct s
  * @sock: listening socket
  * @new_sock: new socket that is to be connected
  * @flags: file-related flags associated with socket
+ * @kern: caused by kernel or by userspace?
  *
  * Returns 0 on success, errno otherwise
  */
@@ -3805,7 +3831,8 @@ int tipc_nl_publ_dump(struct sk_buff *sk
 /**
  * tipc_sk_filtering - check if a socket should be traced
  * @sk: the socket to be examined
- * @sysctl_tipc_sk_filter: the socket tuple for filtering:
+ *
+ * @sysctl_tipc_sk_filter is used as the socket tuple for filtering:
  * (portid, sock type, name type, name lower, name upper)
  *
  * Returns true if the socket meets the socket tuple data
