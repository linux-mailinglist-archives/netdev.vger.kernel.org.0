Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A58A15B993
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 07:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgBMG2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 01:28:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgBMG2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 01:28:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=imUadqXK6KZduy7EQz0jew6CIMoTo0QlYmpTK9PKja4=; b=ujxZDvrbgYSGdCsXxgCsxxgdoj
        wz/bEFcyqlXsU4SrV1BrTEpve+OiWgvUDwEF1BqJvIpRbX4QQ4m2VQx+jaGwYXEeHhAY/pZ2BfRSy
        Xg7M7eshzwiCR7rnE7kaTX220a90QTElK/0O3McDdh5PXsUOgUE7mefBCLDcsyCcVi43zJPILC7s5
        C4GCeonrSjMD0z1dGZjnrM4jUFBu2D0aAwjDlEQ+vCuNo1te5MZ887oTItvD3C4Jxm8NMk8c4tGvx
        tOZyUemGNdbNAhSOx7i5Y4ZLOSdy6kuXjXEp57c+rN32YKUMGdXLkDrPefuyJYwxFU83wzHpzzv1O
        b//x46AA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j27z3-0003cT-Re; Thu, 13 Feb 2020 06:28:21 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] netdevice.h: fix all kernel-doc and Sphinx warnings
Message-ID: <eb81cbe5-c91b-4105-5a45-ddd0747ace76@infradead.org>
Date:   Wed, 12 Feb 2020 22:28:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Eliminate all kernel-doc and Sphinx warnings in
<linux/netdevice.h>.  Fixes these warnings:

../include/linux/netdevice.h:2100: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'tlsdev_ops' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'xdp_prog' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'gro_flush_timeout' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'xdp_bulkq' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'xps_cpus_map' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'xps_rxqs_map' not described in 'net_device'
../include/linux/netdevice.h:2100: warning: Function parameter or member 'qdisc_hash' not described in 'net_device'
../include/linux/netdevice.h:3552: WARNING: Inline emphasis start-string without end-string.
../include/linux/netdevice.h:3552: WARNING: Inline emphasis start-string without end-string.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 include/linux/netdevice.h |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- lnx-56-rc1.orig/include/linux/netdevice.h
+++ lnx-56-rc1/include/linux/netdevice.h
@@ -1616,6 +1616,7 @@ enum netdev_priv_flags {
  *				and drivers will need to set them appropriately.
  *
  *	@mpls_features:	Mask of features inheritable by MPLS
+ *	@gso_partial_features: value(s) from NETIF_F_GSO\*
  *
  *	@ifindex:	interface index
  *	@group:		The group the device belongs to
@@ -1640,8 +1641,11 @@ enum netdev_priv_flags {
  *	@netdev_ops:	Includes several pointers to callbacks,
  *			if one wants to override the ndo_*() functions
  *	@ethtool_ops:	Management operations
+ *	@l3mdev_ops:	Layer 3 master device operations
  *	@ndisc_ops:	Includes callbacks for different IPv6 neighbour
  *			discovery handling. Necessary for e.g. 6LoWPAN.
+ *	@xfrmdev_ops:	Transformation offload operations
+ *	@tlsdev_ops:	Transport Layer Security offload operations
  *	@header_ops:	Includes callbacks for creating,parsing,caching,etc
  *			of Layer 2 headers.
  *
@@ -1680,6 +1684,7 @@ enum netdev_priv_flags {
  * 	@dev_port:		Used to differentiate devices that share
  * 				the same function
  *	@addr_list_lock:	XXX: need comments on this one
+ *	@name_assign_type:	network interface name assignment type
  *	@uc_promisc:		Counter that indicates promiscuous mode
  *				has been enabled due to the need to listen to
  *				additional unicast addresses in a device that
@@ -1702,6 +1707,9 @@ enum netdev_priv_flags {
  *	@ip6_ptr:	IPv6 specific data
  *	@ax25_ptr:	AX.25 specific data
  *	@ieee80211_ptr:	IEEE 802.11 specific data, assign before registering
+ *	@ieee802154_ptr: IEEE 802.15.4 low-rate Wireless Personal Area Network
+ *			 device struct
+ *	@mpls_ptr:	mpls_dev struct pointer
  *
  *	@dev_addr:	Hw address (before bcast,
  *			because most packets are unicast)
@@ -1710,6 +1718,8 @@ enum netdev_priv_flags {
  *	@num_rx_queues:		Number of RX queues
  *				allocated at register_netdev() time
  *	@real_num_rx_queues: 	Number of RX queues currently active in device
+ *	@xdp_prog:		XDP sockets filter program pointer
+ *	@gro_flush_timeout:	timeout for GRO layer in NAPI
  *
  *	@rx_handler:		handler for received packets
  *	@rx_handler_data: 	XXX: need comments on this one
@@ -1731,10 +1741,14 @@ enum netdev_priv_flags {
  *	@qdisc:			Root qdisc from userspace point of view
  *	@tx_queue_len:		Max frames per queue allowed
  *	@tx_global_lock: 	XXX: need comments on this one
+ *	@xdp_bulkq:		XDP device bulk queue
+ *	@xps_cpus_map:		all CPUs map for XPS device
+ *	@xps_rxqs_map:		all RXQs map for XPS device
  *
  *	@xps_maps:	XXX: need comments on this one
  *	@miniq_egress:		clsact qdisc specific data for
  *				egress processing
+ *	@qdisc_hash:		qdisc hash table
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
  *	@watchdog_timer:	List of timers
@@ -3548,7 +3562,7 @@ static inline unsigned int netif_attrmas
 }
 
 /**
- *	netif_attrmask_next_and - get the next CPU/Rx queue in *src1p & *src2p
+ *	netif_attrmask_next_and - get the next CPU/Rx queue in \*src1p & \*src2p
  *	@n: CPU/Rx queue index
  *	@src1p: the first CPUs/Rx queues mask pointer
  *	@src2p: the second CPUs/Rx queues mask pointer


