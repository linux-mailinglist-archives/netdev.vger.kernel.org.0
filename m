Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330642B40DD
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgKPKTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:19:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbgKPKSb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 05:18:31 -0500
Received: from mail.kernel.org (ip5f5ad5de.dynamic.kabel-deutschland.de [95.90.213.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2A323A32;
        Mon, 16 Nov 2020 10:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605521908;
        bh=JVIjR5UYWMem/PlP0sHePqFteQ12l6ecd/TnghhKzxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYoeVXh9Eb0IUyC7557m3+9NYHf6B4ACyemqKhg11R7Gu6GCqzjbyymURW1K4xdQH
         sVAVUOIh/5QNiw3TxbB/iIhtQJvaZvtq0QeW0pJl9IgBOEGyjCS3ksuWFOY9nMz3x0
         0p0dSRyDdLXlimLMFmLQKuA7vXBJynKRlUWWIcpQ=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kebab-00FwDs-Sb; Mon, 16 Nov 2020 11:18:25 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Anna Schumaker <anna.schumaker@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Linux Doc Mailing List" <linux-doc@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Guillaume Nault <gnault@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 02/27] net: datagram: fix some kernel-doc markups
Date:   Mon, 16 Nov 2020 11:17:58 +0100
Message-Id: <7a16cca43a8fc1b2491c9848c1cb72804692afda.1605521731.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605521731.git.mchehab+huawei@kernel.org>
References: <cover.1605521731.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some identifiers have different names between their prototypes
and the kernel-doc markup.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 net/core/datagram.c   | 2 +-
 net/core/dev.c        | 4 ++--
 net/core/skbuff.c     | 2 +-
 net/ethernet/eth.c    | 6 +++---
 net/sunrpc/rpc_pipe.c | 3 ++-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 9fcaa544f11a..81809fa735a7 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -692,41 +692,41 @@ EXPORT_SYMBOL(__zerocopy_sg_from_iter);
  *	@from: the source to copy from
  *
  *	The function will first copy up to headlen, and then pin the userspace
  *	pages and build frags through them.
  *
  *	Returns 0, -EFAULT or -EMSGSIZE.
  */
 int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
 {
 	int copy = min_t(int, skb_headlen(skb), iov_iter_count(from));
 
 	/* copy up to skb headlen */
 	if (skb_copy_datagram_from_iter(skb, 0, from, copy))
 		return -EFAULT;
 
 	return __zerocopy_sg_from_iter(NULL, skb, from, ~0U);
 }
 EXPORT_SYMBOL(zerocopy_sg_from_iter);
 
 /**
- *	skb_copy_and_csum_datagram_iter - Copy datagram to an iovec iterator
+ *	skb_copy_and_csum_datagram - Copy datagram to an iovec iterator
  *          and update a checksum.
  *	@skb: buffer to copy
  *	@offset: offset in the buffer to start copying from
  *	@to: iovec iterator to copy to
  *	@len: amount of data to copy from buffer to iovec
  *      @csump: checksum pointer
  */
 static int skb_copy_and_csum_datagram(const struct sk_buff *skb, int offset,
 				      struct iov_iter *to, int len,
 				      __wsum *csump)
 {
 	return __skb_datagram_iter(skb, offset, to, len, true,
 			csum_and_copy_to_iter, csump);
 }
 
 /**
  *	skb_copy_and_csum_datagram_msg - Copy and checksum skb to user iovec.
  *	@skb: skbuff
  *	@hlen: hardware length
  *	@msg: destination
diff --git a/net/core/dev.c b/net/core/dev.c
index 60d325bda0d7..4bfdcd6b20e8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6902,41 +6902,41 @@ static int ____netdev_has_upper_dev(struct net_device *upper_dev,
  *
  * Find out if a device is linked to specified upper device and return true
  * in case it is. Note that this checks only immediate upper device,
  * not through a complete stack of devices. The caller must hold the RTNL lock.
  */
 bool netdev_has_upper_dev(struct net_device *dev,
 			  struct net_device *upper_dev)
 {
 	struct netdev_nested_priv priv = {
 		.data = (void *)upper_dev,
 	};
 
 	ASSERT_RTNL();
 
 	return netdev_walk_all_upper_dev_rcu(dev, ____netdev_has_upper_dev,
 					     &priv);
 }
 EXPORT_SYMBOL(netdev_has_upper_dev);
 
 /**
- * netdev_has_upper_dev_all - Check if device is linked to an upper device
+ * netdev_has_upper_dev_all_rcu - Check if device is linked to an upper device
  * @dev: device
  * @upper_dev: upper device to check
  *
  * Find out if a device is linked to specified upper device and return true
  * in case it is. Note that this checks the entire upper device chain.
  * The caller must hold rcu lock.
  */
 
 bool netdev_has_upper_dev_all_rcu(struct net_device *dev,
 				  struct net_device *upper_dev)
 {
 	struct netdev_nested_priv priv = {
 		.data = (void *)upper_dev,
 	};
 
 	return !!netdev_walk_all_upper_dev_rcu(dev, ____netdev_has_upper_dev,
 					       &priv);
 }
 EXPORT_SYMBOL(netdev_has_upper_dev_all_rcu);
 
@@ -8140,41 +8140,41 @@ void netdev_adjacent_rename_links(struct net_device *dev, char *oldname)
 	}
 }
 
 void *netdev_lower_dev_get_private(struct net_device *dev,
 				   struct net_device *lower_dev)
 {
 	struct netdev_adjacent *lower;
 
 	if (!lower_dev)
 		return NULL;
 	lower = __netdev_find_adj(lower_dev, &dev->adj_list.lower);
 	if (!lower)
 		return NULL;
 
 	return lower->private;
 }
 EXPORT_SYMBOL(netdev_lower_dev_get_private);
 
 
 /**
- * netdev_lower_change - Dispatch event about lower device state change
+ * netdev_lower_state_changed - Dispatch event about lower device state change
  * @lower_dev: device
  * @lower_state_info: state to dispatch
  *
  * Send NETDEV_CHANGELOWERSTATE to netdev notifiers with info.
  * The caller must hold the RTNL lock.
  */
 void netdev_lower_state_changed(struct net_device *lower_dev,
 				void *lower_state_info)
 {
 	struct netdev_notifier_changelowerstate_info changelowerstate_info = {
 		.info.dev = lower_dev,
 	};
 
 	ASSERT_RTNL();
 	changelowerstate_info.lower_state_info = lower_state_info;
 	call_netdevice_notifiers_info(NETDEV_CHANGELOWERSTATE,
 				      &changelowerstate_info.info);
 }
 EXPORT_SYMBOL(netdev_lower_state_changed);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c9a5a3c262c8..ffe3dcc0ebea 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -825,41 +825,41 @@ EXPORT_SYMBOL(skb_tx_error);
 /**
  *	consume_skb - free an skbuff
  *	@skb: buffer to free
  *
  *	Drop a ref to the buffer and free it if the usage count has hit zero
  *	Functions identically to kfree_skb, but kfree_skb assumes that the frame
  *	is being dropped after a failure and notes that
  */
 void consume_skb(struct sk_buff *skb)
 {
 	if (!skb_unref(skb))
 		return;
 
 	trace_consume_skb(skb);
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(consume_skb);
 #endif
 
 /**
- *	consume_stateless_skb - free an skbuff, assuming it is stateless
+ *	__consume_stateless_skb - free an skbuff, assuming it is stateless
  *	@skb: buffer to free
  *
  *	Alike consume_skb(), but this variant assumes that this is the last
  *	skb reference and all the head states have been already dropped
  */
 void __consume_stateless_skb(struct sk_buff *skb)
 {
 	trace_consume_skb(skb);
 	skb_release_data(skb);
 	kfree_skbmem(skb);
 }
 
 void __kfree_skb_flush(void)
 {
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 
 	/* flush skb_cache if containing objects */
 	if (nc->skb_count) {
 		kmem_cache_free_bulk(skbuff_head_cache, nc->skb_count,
 				     nc->skb_cache);
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index dac65180c4ef..4106373180c6 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -255,41 +255,41 @@ int eth_header_cache(const struct neighbour *neigh, struct hh_cache *hh, __be16
 EXPORT_SYMBOL(eth_header_cache);
 
 /**
  * eth_header_cache_update - update cache entry
  * @hh: destination cache entry
  * @dev: network device
  * @haddr: new hardware address
  *
  * Called by Address Resolution module to notify changes in address.
  */
 void eth_header_cache_update(struct hh_cache *hh,
 			     const struct net_device *dev,
 			     const unsigned char *haddr)
 {
 	memcpy(((u8 *) hh->hh_data) + HH_DATA_OFF(sizeof(struct ethhdr)),
 	       haddr, ETH_ALEN);
 }
 EXPORT_SYMBOL(eth_header_cache_update);
 
 /**
- * eth_header_parser_protocol - extract protocol from L2 header
+ * eth_header_parse_protocol - extract protocol from L2 header
  * @skb: packet to extract protocol from
  */
 __be16 eth_header_parse_protocol(const struct sk_buff *skb)
 {
 	const struct ethhdr *eth = eth_hdr(skb);
 
 	return eth->h_proto;
 }
 EXPORT_SYMBOL(eth_header_parse_protocol);
 
 /**
  * eth_prepare_mac_addr_change - prepare for mac change
  * @dev: network device
  * @p: socket address
  */
 int eth_prepare_mac_addr_change(struct net_device *dev, void *p)
 {
 	struct sockaddr *addr = p;
 
 	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev))
@@ -506,42 +506,42 @@ unsigned char * __weak arch_get_platform_mac_address(void)
 
 int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr)
 {
 	const unsigned char *addr = NULL;
 
 	if (dev->of_node)
 		addr = of_get_mac_address(dev->of_node);
 	if (IS_ERR_OR_NULL(addr))
 		addr = arch_get_platform_mac_address();
 
 	if (!addr)
 		return -ENODEV;
 
 	ether_addr_copy(mac_addr, addr);
 
 	return 0;
 }
 EXPORT_SYMBOL(eth_platform_get_mac_address);
 
 /**
- * Obtain the MAC address from an nvmem cell named 'mac-address' associated
- * with given device.
+ * nvmem_get_mac_address - Obtain the MAC address from an nvmem cell named
+ * 'mac-address' associated with given device.
  *
  * @dev:	Device with which the mac-address cell is associated.
  * @addrbuf:	Buffer to which the MAC address will be copied on success.
  *
  * Returns 0 on success or a negative error number on failure.
  */
 int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 {
 	struct nvmem_cell *cell;
 	const void *mac;
 	size_t len;
 
 	cell = nvmem_cell_get(dev, "mac-address");
 	if (IS_ERR(cell))
 		return PTR_ERR(cell);
 
 	mac = nvmem_cell_read(cell, &len);
 	nvmem_cell_put(cell);
 
 	if (IS_ERR(mac))
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index eadc0ede928c..8241f5a4a01c 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -764,41 +764,42 @@ static struct dentry *rpc_mkdir_populate(struct dentry *parent,
 
 static int rpc_rmdir_depopulate(struct dentry *dentry,
 		void (*depopulate)(struct dentry *))
 {
 	struct dentry *parent;
 	struct inode *dir;
 	int error;
 
 	parent = dget_parent(dentry);
 	dir = d_inode(parent);
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 	if (depopulate != NULL)
 		depopulate(dentry);
 	error = __rpc_rmdir(dir, dentry);
 	inode_unlock(dir);
 	dput(parent);
 	return error;
 }
 
 /**
- * rpc_mkpipe - make an rpc_pipefs file for kernel<->userspace communication
+ * rpc_mkpipe_dentry - make an rpc_pipefs file for kernel<->userspace
+ *		       communication
  * @parent: dentry of directory to create new "pipe" in
  * @name: name of pipe
  * @private: private data to associate with the pipe, for the caller's use
  * @pipe: &rpc_pipe containing input parameters
  *
  * Data is made available for userspace to read by calls to
  * rpc_queue_upcall().  The actual reads will result in calls to
  * @ops->upcall, which will be called with the file pointer,
  * message, and userspace buffer to copy to.
  *
  * Writes can come at any time, and do not necessarily have to be
  * responses to upcalls.  They will result in calls to @msg->downcall.
  *
  * The @private argument passed here will be available to all these methods
  * from the file pointer, via RPC_I(file_inode(file))->private.
  */
 struct dentry *rpc_mkpipe_dentry(struct dentry *parent, const char *name,
 				 void *private, struct rpc_pipe *pipe)
 {
 	struct dentry *dentry;
-- 
2.28.0

