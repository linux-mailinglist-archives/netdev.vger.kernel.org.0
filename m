Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30A12C3807
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgKYEU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgKYEU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:20:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C283BC0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=fpuGcjpJT5ot/DwwaOOdJTR/ZTA7EyB6sOvrdprALuU=; b=pB3IinQZLcPuBUc6EXpvletJUx
        +3dwBjG/3j4vubrzpCn6A3QGOiwZc7CPOu8VJpAO8DVKA1CZNtlII1yd1dxOeX96OQfzVUemhExrb
        n2qTTAhvNqdfDaQ9ePWDtekV2AXrxbHj8oRmrWC8mvCaPCGc6nekFVcbKM3wu4j5QDIMcTmKuJlPY
        U6JMuAqGFhg1IUInaKvYUZ0z/NWLJ5z7CoWHCFPQ9O7OW1ETiWXuNwV/R5xBS1Zm7Q98z+pMVpm5X
        1mA8oXfQmAb8lE4Dw7agHstH01QnwoCgIxu8/sTG46svFIaQCwHNZKM6E0dGjk6fJEvJWbmeDAFOJ
        xXemBeYQ==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khmIU-0000SB-2i; Wed, 25 Nov 2020 04:20:51 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 09/10 net-next] net/tipc: fix all function Return: notation
Date:   Tue, 24 Nov 2020 20:20:24 -0800
Message-Id: <20201125042026.25374-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix Return: kernel-doc notation in all net/tipc/ source files.
Also keep ReST list notation intact for output formatting.
Fix a few typos in comments.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/tipc/bearer.c     |    2 -
 net/tipc/crypto.c     |   38 +++++++++++++-------------
 net/tipc/discover.c   |    2 -
 net/tipc/link.c       |    8 ++---
 net/tipc/msg.c        |   19 +++++++------
 net/tipc/name_distr.c |    2 -
 net/tipc/node.c       |    6 ++--
 net/tipc/socket.c     |   57 +++++++++++++++++++---------------------
 net/tipc/subscr.c     |    2 -
 9 files changed, 68 insertions(+), 68 deletions(-)

--- linux-next-20201102.orig/net/tipc/bearer.c
+++ linux-next-20201102/net/tipc/bearer.c
@@ -132,7 +132,7 @@ int tipc_media_addr_printf(char *buf, in
  * @name: ptr to bearer name string
  * @name_parts: ptr to area for bearer name components (or NULL if not needed)
  *
- * Returns 1 if bearer name is valid, otherwise 0.
+ * Return: 1 if bearer name is valid, otherwise 0.
  */
 static int bearer_name_validate(const char *name,
 				struct tipc_bearer_names *name_parts)
--- linux-next-20201102.orig/net/tipc/crypto.c
+++ linux-next-20201102/net/tipc/crypto.c
@@ -721,9 +721,9 @@ static void *tipc_aead_mem_alloc(struct
  * @__dnode: TIPC dest node if "known"
  *
  * Return:
- * 0                   : if the encryption has completed
- * -EINPROGRESS/-EBUSY : if a callback will be performed
- * < 0                 : the encryption has failed
+ * * 0                   : if the encryption has completed
+ * * -EINPROGRESS/-EBUSY : if a callback will be performed
+ * * < 0                 : the encryption has failed
  */
 static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 			     struct tipc_bearer *b,
@@ -877,9 +877,9 @@ static void tipc_aead_encrypt_done(struc
  * @b: TIPC bearer where the message has been received
  *
  * Return:
- * 0                   : if the decryption has completed
- * -EINPROGRESS/-EBUSY : if a callback will be performed
- * < 0                 : the decryption has failed
+ * * 0                   : if the decryption has completed
+ * * -EINPROGRESS/-EBUSY : if a callback will be performed
+ * * < 0                 : the decryption has failed
  */
 static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 			     struct sk_buff *skb, struct tipc_bearer *b)
@@ -1008,7 +1008,7 @@ static inline int tipc_ehdr_size(struct
  * tipc_ehdr_validate - Validate an encryption message
  * @skb: the message buffer
  *
- * Returns "true" if this is a valid encryption message, otherwise "false"
+ * Return: "true" if this is a valid encryption message, otherwise "false"
  */
 bool tipc_ehdr_validate(struct sk_buff *skb)
 {
@@ -1681,12 +1681,12 @@ static inline void tipc_crypto_clone_msg
  * Otherwise, the skb is freed!
  *
  * Return:
- * 0                   : the encryption has succeeded (or no encryption)
- * -EINPROGRESS/-EBUSY : the encryption is ongoing, a callback will be made
- * -ENOKEK             : the encryption has failed due to no key
- * -EKEYREVOKED        : the encryption has failed due to key revoked
- * -ENOMEM             : the encryption has failed due to no memory
- * < 0                 : the encryption has failed due to other reasons
+ * * 0                   : the encryption has succeeded (or no encryption)
+ * * -EINPROGRESS/-EBUSY : the encryption is ongoing, a callback will be made
+ * * -ENOKEK             : the encryption has failed due to no key
+ * * -EKEYREVOKED        : the encryption has failed due to key revoked
+ * * -ENOMEM             : the encryption has failed due to no memory
+ * * < 0                 : the encryption has failed due to other reasons
  */
 int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
 		     struct tipc_bearer *b, struct tipc_media_addr *dst,
@@ -1806,12 +1806,12 @@ exit:
  * cluster key(s) can be taken for decryption (- recursive).
  *
  * Return:
- * 0                   : the decryption has successfully completed
- * -EINPROGRESS/-EBUSY : the decryption is ongoing, a callback will be made
- * -ENOKEY             : the decryption has failed due to no key
- * -EBADMSG            : the decryption has failed due to bad message
- * -ENOMEM             : the decryption has failed due to no memory
- * < 0                 : the decryption has failed due to other reasons
+ * * 0                   : the decryption has successfully completed
+ * * -EINPROGRESS/-EBUSY : the decryption is ongoing, a callback will be made
+ * * -ENOKEY             : the decryption has failed due to no key
+ * * -EBADMSG            : the decryption has failed due to bad message
+ * * -ENOMEM             : the decryption has failed due to no memory
+ * * < 0                 : the decryption has failed due to other reasons
  */
 int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 		    struct sk_buff **skb, struct tipc_bearer *b)
--- linux-next-20201102.orig/net/tipc/discover.c
+++ linux-next-20201102/net/tipc/discover.c
@@ -342,7 +342,7 @@ exit:
  * @dest: destination address for request messages
  * @skb: pointer to created frame
  *
- * Returns 0 if successful, otherwise -errno.
+ * Return: 0 if successful, otherwise -errno.
  */
 int tipc_disc_create(struct net *net, struct tipc_bearer *b,
 		     struct tipc_media_addr *dest, struct sk_buff **skb)
--- linux-next-20201102.orig/net/tipc/link.c
+++ linux-next-20201102/net/tipc/link.c
@@ -488,7 +488,7 @@ u32 tipc_link_state(struct tipc_link *l)
  * @self: local unicast link id
  * @peer_id: 128-bit ID of peer
  *
- * Returns true if link was created, otherwise false
+ * Return: true if link was created, otherwise false
  */
 bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
 		      int tolerance, char net_plane, u32 mtu, int priority,
@@ -567,7 +567,7 @@ bool tipc_link_create(struct net *net, c
  * @peer_caps: bitmap describing peer node capabilities
  * @bc_sndlink: the namespace global link used for broadcast sending
  *
- * Returns true if link was created, otherwise false
+ * Return: true if link was created, otherwise false
  */
 bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer, u8 *peer_id,
 			 int mtu, u32 min_win, u32 max_win, u16 peer_caps,
@@ -822,7 +822,7 @@ static void link_profile_stats(struct ti
  * tipc_link_too_silent - check if link is "too silent"
  * @l: tipc link to be checked
  *
- * Returns true if the link 'silent_intv_cnt' is about to reach the
+ * Return: true if the link 'silent_intv_cnt' is about to reach the
  * 'abort_limit' value, otherwise false
  */
 bool tipc_link_too_silent(struct tipc_link *l)
@@ -1024,8 +1024,8 @@ void tipc_link_reset(struct tipc_link *l
  * @xmitq: returned list of packets to be sent by caller
  *
  * Consumes the buffer chain.
- * Returns 0 if success, or errno: -ELINKCONG, -EMSGSIZE or -ENOBUFS
  * Messages at TIPC_SYSTEM_IMPORTANCE are always accepted
+ * Return: 0 if success, or errno: -ELINKCONG, -EMSGSIZE or -ENOBUFS
  */
 int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		   struct sk_buff_head *xmitq)
--- linux-next-20201102.orig/net/tipc/msg.c
+++ linux-next-20201102/net/tipc/msg.c
@@ -60,7 +60,7 @@ static unsigned int align(unsigned int i
  * @size: message size (including TIPC header)
  * @gfp: memory allocation flags
  *
- * Returns a new buffer with data pointers set to the specified size.
+ * Return: a new buffer with data pointers set to the specified size.
  *
  * NOTE:
  * Headroom is reserved to allow prepending of a data link header.
@@ -209,8 +209,9 @@ err:
  * @m: the data to be appended
  * @mss: max allowable size of buffer
  * @dlen: size of data to be appended
- * @txq: queue to appand to
- * Returns the number og 1k blocks appended or errno value
+ * @txq: queue to append to
+ *
+ * Return: the number of 1k blocks appended or errno value
  */
 int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
 		    int mss, struct sk_buff_head *txq)
@@ -314,7 +315,7 @@ bool tipc_msg_validate(struct sk_buff **
  * @pktmax: max size of a fragment incl. the header
  * @frags: returned fragment skb list
  *
- * Returns 0 if the fragmentation is successful, otherwise: -EINVAL
+ * Return: 0 if the fragmentation is successful, otherwise: -EINVAL
  * or -ENOMEM
  */
 int tipc_msg_fragment(struct sk_buff *skb, const struct tipc_msg *hdr,
@@ -377,7 +378,7 @@ error:
  * Note that the recursive call we are making here is safe, since it can
  * logically go only one further level down.
  *
- * Returns message data size or errno: -ENOMEM, -EFAULT
+ * Return: message data size or errno: -ENOMEM, -EFAULT
  */
 int tipc_msg_build(struct tipc_msg *mhdr, struct msghdr *m, int offset,
 		   int dsz, int pktmax, struct sk_buff_head *list)
@@ -488,7 +489,7 @@ error:
  * @msg: message to be appended
  * @max: max allowable size for the bundle buffer
  *
- * Returns "true" if bundling has been performed, otherwise "false"
+ * Return: "true" if bundling has been performed, otherwise "false"
  */
 static bool tipc_msg_bundle(struct sk_buff *bskb, struct tipc_msg *msg,
 			    u32 max)
@@ -585,7 +586,7 @@ bundle:
  *  @pos: position in outer message of msg to be extracted.
  *  Returns position of next msg.
  *  Consumes outer buffer when last packet extracted
- *  Returns true when there is an extracted buffer, otherwise false
+ *  Return: true when there is an extracted buffer, otherwise false
  */
 bool tipc_msg_extract(struct sk_buff *skb, struct sk_buff **iskb, int *pos)
 {
@@ -629,7 +630,7 @@ none:
  * @skb:  buffer containing message to be reversed; will be consumed
  * @err:  error code to be set in message, if any
  * Replaces consumed buffer with new one when successful
- * Returns true if success, otherwise false
+ * Return: true if success, otherwise false
  */
 bool tipc_msg_reverse(u32 own_node,  struct sk_buff **skb, int err)
 {
@@ -705,7 +706,7 @@ bool tipc_msg_skb_clone(struct sk_buff_h
  * @skb: the buffer containing the message.
  * @err: error code to be used by caller if lookup fails
  * Does not consume buffer
- * Returns true if a destination is found, false otherwise
+ * Return: true if a destination is found, false otherwise
  */
 bool tipc_msg_lookup_dest(struct net *net, struct sk_buff *skb, int *err)
 {
--- linux-next-20201102.orig/net/tipc/name_distr.c
+++ linux-next-20201102/net/tipc/name_distr.c
@@ -287,7 +287,7 @@ void tipc_publ_notify(struct net *net, s
  * @dtype: name distributor message type
  *
  * tipc_nametbl_lock must be held.
- * Returns the publication item if successful, otherwise NULL.
+ * Return: the publication item if successful, otherwise NULL.
  */
 static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 				u32 node, u32 dtype)
--- linux-next-20201102.orig/net/tipc/node.c
+++ linux-next-20201102/net/tipc/node.c
@@ -1552,7 +1552,7 @@ static void node_lost_contact(struct tip
  * @linkname: link name output buffer
  * @len: size of @linkname output buffer
  *
- * Returns 0 on success
+ * Return: 0 on success
  */
 int tipc_node_get_linkname(struct net *net, u32 bearer_id, u32 addr,
 			   char *linkname, size_t len)
@@ -1671,7 +1671,7 @@ static void tipc_lxc_xmit(struct net *pe
  * @dnode: address of destination node
  * @selector: a number used for deterministic link selection
  * Consumes the buffer chain.
- * Returns 0 if success, otherwise: -ELINKCONG,-EHOSTUNREACH,-EMSGSIZE,-ENOBUF
+ * Return: 0 if success, otherwise: -ELINKCONG,-EHOSTUNREACH,-EMSGSIZE,-ENOBUF
  */
 int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 		   u32 dnode, int selector)
@@ -1908,7 +1908,7 @@ static void tipc_node_bc_rcv(struct net
  * @skb: TIPC packet
  * @bearer_id: identity of bearer delivering the packet
  * @xmitq: queue for messages to be xmited on
- * Returns true if state and msg are ok, otherwise false
+ * Return: true if state and msg are ok, otherwise false
  */
 static bool tipc_node_check_state(struct tipc_node *n, struct sk_buff *skb,
 				  int bearer_id, struct sk_buff_head *xmitq)
--- linux-next-20201102.orig/net/tipc/socket.c
+++ linux-next-20201102/net/tipc/socket.c
@@ -457,7 +457,7 @@ static int tipc_sk_sock_err(struct socke
  * This routine creates additional data structures used by the TIPC socket,
  * initializes them, and links them together.
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  */
 static int tipc_sk_create(struct net *net, struct socket *sock,
 			  int protocol, int kern)
@@ -622,7 +622,7 @@ static void __tipc_shutdown(struct socke
  * are returned or discarded according to the "destination droppable" setting
  * specified for the message by the sender.
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  */
 static int tipc_release(struct socket *sock)
 {
@@ -669,7 +669,7 @@ static int tipc_release(struct socket *s
  * a negative scope value unbinds the specified name.  Specifying no name
  * (i.e. a socket address length of 0) unbinds all names from the socket.
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  *
  * NOTE: This routine doesn't need to take the socket lock since it doesn't
  *       access any non-constant socket information.
@@ -737,7 +737,7 @@ static int tipc_bind(struct socket *sock
  * @uaddr: area for returned socket address
  * @peer: 0 = own ID, 1 = current peer ID, 2 = current/former peer ID
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  *
  * NOTE: This routine doesn't need to take the socket lock since it only
  *       accesses socket information that is unchanging (or which changes in
@@ -776,7 +776,7 @@ static int tipc_getname(struct socket *s
  * @sock: socket for which to calculate the poll bits
  * @wait: ???
  *
- * Returns pollmask value
+ * Return: pollmask value
  *
  * COMMENTARY:
  * It appears that the usual socket locking mechanisms are not useful here
@@ -838,7 +838,7 @@ static __poll_t tipc_poll(struct file *f
  * @timeout: timeout to wait for wakeup
  *
  * Called from function tipc_sendmsg(), which has done all sanity checks
- * Returns the number of bytes sent on success, or errno
+ * Return: the number of bytes sent on success, or errno
  */
 static int tipc_sendmcast(struct  socket *sock, struct tipc_name_seq *seq,
 			  struct msghdr *msg, size_t dlen, long timeout)
@@ -954,7 +954,7 @@ static int tipc_send_group_msg(struct ne
  * @timeout: timeout to wait for wakeup
  *
  * Called from function tipc_sendmsg(), which has done all sanity checks
- * Returns the number of bytes sent on success, or errno
+ * Return: the number of bytes sent on success, or errno
  */
 static int tipc_send_group_unicast(struct socket *sock, struct msghdr *m,
 				   int dlen, long timeout)
@@ -998,7 +998,7 @@ static int tipc_send_group_unicast(struc
  * @timeout: timeout to wait for wakeup
  *
  * Called from function tipc_sendmsg(), which has done all sanity checks
- * Returns the number of bytes sent on success, or errno
+ * Return: the number of bytes sent on success, or errno
  */
 static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
 				   int dlen, long timeout)
@@ -1083,7 +1083,7 @@ static int tipc_send_group_anycast(struc
  * @timeout: timeout to wait for wakeup
  *
  * Called from function tipc_sendmsg(), which has done all sanity checks
- * Returns the number of bytes sent on success, or errno
+ * Return: the number of bytes sent on success, or errno
  */
 static int tipc_send_group_bcast(struct socket *sock, struct msghdr *m,
 				 int dlen, long timeout)
@@ -1157,7 +1157,7 @@ static int tipc_send_group_bcast(struct
  * @timeout: timeout to wait for wakeup
  *
  * Called from function tipc_sendmsg(), which has done all sanity checks
- * Returns the number of bytes sent on success, or errno
+ * Return: the number of bytes sent on success, or errno
  */
 static int tipc_send_group_mcast(struct socket *sock, struct msghdr *m,
 				 int dlen, long timeout)
@@ -1403,7 +1403,7 @@ exit:
  * and for 'SYN' messages on SOCK_SEQPACKET and SOCK_STREAM connections.
  * (Note: 'SYN+' is prohibited on SOCK_STREAM.)
  *
- * Returns the number of bytes sent on success, or errno otherwise
+ * Return: the number of bytes sent on success, or errno otherwise
  */
 static int tipc_sendmsg(struct socket *sock,
 			struct msghdr *m, size_t dsz)
@@ -1548,7 +1548,7 @@ static int __tipc_sendmsg(struct socket
  *
  * Used for SOCK_STREAM data.
  *
- * Returns the number of bytes sent on success (or partial success),
+ * Return: the number of bytes sent on success (or partial success),
  * or errno if no data sent
  */
 static int tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dsz)
@@ -1656,7 +1656,7 @@ static int __tipc_sendstream(struct sock
  *
  * Used for SOCK_SEQPACKET messages.
  *
- * Returns the number of bytes sent on success, or errno otherwise
+ * Return: the number of bytes sent on success, or errno otherwise
  */
 static int tipc_send_packet(struct socket *sock, struct msghdr *m, size_t dsz)
 {
@@ -1741,7 +1741,7 @@ static void tipc_sk_set_orig_addr(struct
  *
  * Note: Ancillary data is not captured if not requested by receiver.
  *
- * Returns 0 if successful, otherwise errno
+ * Return: 0 if successful, otherwise errno
  */
 static int tipc_sk_anc_data_recv(struct msghdr *m, struct sk_buff *skb,
 				 struct tipc_sock *tsk)
@@ -1899,7 +1899,7 @@ static int tipc_wait_for_rcvmsg(struct s
  * Used for SOCK_DGRAM, SOCK_RDM, and SOCK_SEQPACKET messages.
  * If the complete message doesn't fit in user area, truncate it.
  *
- * Returns size of returned message data, errno otherwise
+ * Return: size of returned message data, errno otherwise
  */
 static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 			size_t buflen,	int flags)
@@ -2008,7 +2008,7 @@ exit:
  * Used for SOCK_STREAM messages only.  If not enough data is available
  * will optionally wait for more; never truncates data.
  *
- * Returns size of returned message data, errno otherwise
+ * Return: size of returned message data, errno otherwise
  */
 static int tipc_recvstream(struct socket *sock, struct msghdr *m,
 			   size_t buflen, int flags)
@@ -2186,7 +2186,7 @@ static void tipc_sk_proto_rcv(struct soc
  * @tsk: TIPC socket
  * @skb: pointer to message buffer.
  * @xmitq: for Nagle ACK if any
- * Returns true if message should be added to receive queue, false otherwise
+ * Return: true if message should be added to receive queue, false otherwise
  */
 static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
 				   struct sk_buff_head *xmitq)
@@ -2300,7 +2300,7 @@ static bool tipc_sk_filter_connect(struc
  * TIPC_HIGH_IMPORTANCE      (8 MB)
  * TIPC_CRITICAL_IMPORTANCE  (16 MB)
  *
- * Returns overload limit according to corresponding message importance
+ * Return: overload limit according to corresponding message importance
  */
 static unsigned int rcvbuf_limit(struct sock *sk, struct sk_buff *skb)
 {
@@ -2329,7 +2329,6 @@ static unsigned int rcvbuf_limit(struct
  * disconnect indication for a connected socket.
  *
  * Called with socket lock already taken
- *
  */
 static void tipc_sk_filter_rcv(struct sock *sk, struct sk_buff *skb,
 			       struct sk_buff_head *xmitq)
@@ -2565,7 +2564,7 @@ static bool tipc_sockaddr_is_sane(struct
  * @destlen: size of socket address data structure
  * @flags: file-related flags associated with socket
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  */
 static int tipc_connect(struct socket *sock, struct sockaddr *dest,
 			int destlen, int flags)
@@ -2658,7 +2657,7 @@ exit:
  * @sock: socket structure
  * @len: (unused)
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  */
 static int tipc_listen(struct socket *sock, int len)
 {
@@ -2712,7 +2711,7 @@ static int tipc_wait_for_accept(struct s
  * @flags: file-related flags associated with socket
  * @kern: caused by kernel or by userspace?
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  */
 static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 		       bool kern)
@@ -2791,7 +2790,7 @@ exit:
  *
  * Terminates connection (if necessary), then purges socket's receive queue.
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  */
 static int tipc_shutdown(struct socket *sock, int how)
 {
@@ -3134,7 +3133,7 @@ static int tipc_sk_leave(struct tipc_soc
  * For stream sockets only, accepts and ignores all IPPROTO_TCP options
  * (to ease compatibility).
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  */
 static int tipc_setsockopt(struct socket *sock, int lvl, int opt,
 			   sockptr_t ov, unsigned int ol)
@@ -3228,7 +3227,7 @@ static int tipc_setsockopt(struct socket
  * For stream sockets only, returns 0 length result for all IPPROTO_TCP options
  * (to ease compatibility).
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  */
 static int tipc_getsockopt(struct socket *sock, int lvl, int opt,
 			   char __user *ov, int __user *ol)
@@ -3432,7 +3431,7 @@ static struct proto tipc_proto = {
 /**
  * tipc_socket_init - initialize TIPC socket interface
  *
- * Returns 0 on success, errno otherwise
+ * Return: 0 on success, errno otherwise
  */
 int tipc_socket_init(void)
 {
@@ -3835,7 +3834,7 @@ int tipc_nl_publ_dump(struct sk_buff *sk
  * @sysctl_tipc_sk_filter is used as the socket tuple for filtering:
  * (portid, sock type, name type, name lower, name upper)
  *
- * Returns true if the socket meets the socket tuple data
+ * Return: true if the socket meets the socket tuple data
  * (value 0 = 'any') or when there is no tuple set (all = 0),
  * otherwise false
  */
@@ -3900,7 +3899,7 @@ u32 tipc_sock_get_portid(struct sock *sk
  * @sk: tipc sk to be checked
  * @skb: tipc msg to be checked
  *
- * Returns true if the socket rx queue allocation is > 90%, otherwise false
+ * Return: true if the socket rx queue allocation is > 90%, otherwise false
  */
 
 bool tipc_sk_overlimit1(struct sock *sk, struct sk_buff *skb)
@@ -3918,7 +3917,7 @@ bool tipc_sk_overlimit1(struct sock *sk,
  * @sk: tipc sk to be checked
  * @skb: tipc msg to be checked
  *
- * Returns true if the socket rx queue allocation is > 90%, otherwise false
+ * Return: true if the socket rx queue allocation is > 90%, otherwise false
  */
 
 bool tipc_sk_overlimit2(struct sock *sk, struct sk_buff *skb)
--- linux-next-20201102.orig/net/tipc/subscr.c
+++ linux-next-20201102/net/tipc/subscr.c
@@ -60,7 +60,7 @@ static void tipc_sub_send_event(struct t
  * @found_lower: lower value to test
  * @found_upper: upper value to test
  *
- * Returns 1 if there is overlap, otherwise 0.
+ * Return: 1 if there is overlap, otherwise 0.
  */
 int tipc_sub_check_overlap(struct tipc_name_seq *seq, u32 found_lower,
 			   u32 found_upper)
