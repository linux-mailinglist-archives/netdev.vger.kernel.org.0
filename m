Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BDF298A26
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769227AbgJZKOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1768387AbgJZJro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 05:47:44 -0400
Received: from mail.kernel.org (ip5f5ad5a1.dynamic.kabel-deutschland.de [95.90.213.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEDC02087C;
        Mon, 26 Oct 2020 09:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603705663;
        bh=kZEeYcZI3W9smR89Evx7xmR6MBrCXpfe2JhxTnfEpfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1C6ZvuQvdGgw57lYmPQcZQ2LNdgRRVZV534pCf87iNQhUnFIB4yxOd+QnrsQrBUQH
         deg4XKzJMCI8BfXmdjiQmIBZ6Rzp5ZcJsqpWI384HzSaNuMR2tGRwWffooWD3prUp1
         YJ7AToqeixr/Qci/1Bu65uyzL2cMfbJLBcfMy21U=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kWz6J-0030t3-Mk; Mon, 26 Oct 2020 10:47:39 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Guillaume Nault <gnault@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH RESEND 2/3] net: datagram: fix some kernel-doc markups
Date:   Mon, 26 Oct 2020 10:47:37 +0100
Message-Id: <c8850a0e48e2b873cdced4a580dc4c599728a273.1603705472.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603705472.git.mchehab+huawei@kernel.org>
References: <cover.1603705472.git.mchehab+huawei@kernel.org>
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
@@ -709,7 +709,7 @@ int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
 EXPORT_SYMBOL(zerocopy_sg_from_iter);
 
 /**
- *	skb_copy_and_csum_datagram_iter - Copy datagram to an iovec iterator
+ *	skb_copy_and_csum_datagram - Copy datagram to an iovec iterator
  *          and update a checksum.
  *	@skb: buffer to copy
  *	@offset: offset in the buffer to start copying from
diff --git a/net/core/dev.c b/net/core/dev.c
index 751e5264fd49..75c879f8ab3f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6915,7 +6915,7 @@ bool netdev_has_upper_dev(struct net_device *dev,
 EXPORT_SYMBOL(netdev_has_upper_dev);
 
 /**
- * netdev_has_upper_dev_all - Check if device is linked to an upper device
+ * netdev_has_upper_dev_all_rcu - Check if device is linked to an upper device
  * @dev: device
  * @upper_dev: upper device to check
  *
@@ -8153,7 +8153,7 @@ EXPORT_SYMBOL(netdev_lower_dev_get_private);
 
 
 /**
- * netdev_lower_change - Dispatch event about lower device state change
+ * netdev_lower_state_changed - Dispatch event about lower device state change
  * @lower_dev: device
  * @lower_state_info: state to dispatch
  *
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1ba8f0163744..49da6b259444 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -837,7 +837,7 @@ EXPORT_SYMBOL(consume_skb);
 #endif
 
 /**
- *	consume_stateless_skb - free an skbuff, assuming it is stateless
+ *	__consume_stateless_skb - free an skbuff, assuming it is stateless
  *	@skb: buffer to free
  *
  *	Alike consume_skb(), but this variant assumes that this is the last
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index dac65180c4ef..4106373180c6 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -272,7 +272,7 @@ void eth_header_cache_update(struct hh_cache *hh,
 EXPORT_SYMBOL(eth_header_cache_update);
 
 /**
- * eth_header_parser_protocol - extract protocol from L2 header
+ * eth_header_parse_protocol - extract protocol from L2 header
  * @skb: packet to extract protocol from
  */
 __be16 eth_header_parse_protocol(const struct sk_buff *skb)
@@ -523,8 +523,8 @@ int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr)
 EXPORT_SYMBOL(eth_platform_get_mac_address);
 
 /**
- * Obtain the MAC address from an nvmem cell named 'mac-address' associated
- * with given device.
+ * nvmem_get_mac_address - Obtain the MAC address from an nvmem cell named
+ * 'mac-address' associated with given device.
  *
  * @dev:	Device with which the mac-address cell is associated.
  * @addrbuf:	Buffer to which the MAC address will be copied on success.
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index eadc0ede928c..8241f5a4a01c 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -781,7 +781,8 @@ static int rpc_rmdir_depopulate(struct dentry *dentry,
 }
 
 /**
- * rpc_mkpipe - make an rpc_pipefs file for kernel<->userspace communication
+ * rpc_mkpipe_dentry - make an rpc_pipefs file for kernel<->userspace
+ *		       communication
  * @parent: dentry of directory to create new "pipe" in
  * @name: name of pipe
  * @private: private data to associate with the pipe, for the caller's use
-- 
2.26.2

