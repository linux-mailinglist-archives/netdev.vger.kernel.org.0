Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9AF6802D7
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 00:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbjA2XLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 18:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbjA2XLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 18:11:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0FD1ADC3;
        Sun, 29 Jan 2023 15:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sC3a08R/9oD198jwz+AO6kjHuvQGJ469D4hmSHZPHao=; b=MpyP0N+e7co5j8jaeQKGQ47Qvg
        B4AaORQ86mb4jheDxaLM1tDaQRc5W1GAkxwxdyJbrR0ioOdS8URZCF40Fm3snK8zlUlXj6rg/VZkt
        NeLHHGPv2ER0eZwahxLUwneWTzVUTUBcrMUk50oPhqPstL1mdi87mi+hwBqFAqrMBF6rMVBfdQQWD
        xsyjHgUEiM3TAPmD925Wwu/O7vuGdcK1r8yxwDzVfJhSHdvfh1EgyErdB4OQWri3JKEMV/STMauOW
        EZwJwW9eRj/UqxDMwUSKnghT0Ai4GYW8l9bRRvluL99xAkIl7fKyCslcrr1vhgjig1/WfYRdaDi76
        aknUmQQQ==;
Received: from [2601:1c2:d00:6a60::9526] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMGp8-0020M2-Cv; Sun, 29 Jan 2023 23:10:58 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH 4/9] Documentation: networking: correct spelling
Date:   Sun, 29 Jan 2023 15:10:48 -0800
Message-Id: <20230129231053.20863-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct spelling problems for Documentation/networking/ as reported
by codespell.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
---
 .../af_xdp.rst                                                  |    4 ++--
 .../arcnet-hardware.rst                                         |    2 +-
 .../can.rst                                                     |    2 +-
 .../can_ucan_protocol.rst                                       |    2 +-
 .../cdc_mbim.rst                                                |    2 +-
 .../device_drivers/atm/iphase.rst                               |    2 +-
 .../device_drivers/can/ctu/ctucanfd-driver.rst                  |    4 ++--
 .../device_drivers/can/ctu/fsm_txt_buffer_user.svg              |    4 ++--
 .../device_drivers/ethernet/3com/vortex.rst                     |    2 +-
 .../device_drivers/ethernet/aquantia/atlantic.rst               |    6 +++---
 .../device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst |    2 +-
 .../device_drivers/ethernet/marvell/octeontx2.rst               |    2 +-
 .../device_drivers/ethernet/pensando/ionic.rst                  |    2 +-
 .../device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst     |    2 +-
 .../device_drivers/ethernet/ti/cpsw_switchdev.rst               |    2 +-
 .../device_drivers/wwan/iosm.rst                                |    2 +-
 .../devlink/ice.rst                                             |    4 ++--
 .../devlink/netdevsim.rst                                       |    2 +-
 .../devlink/prestera.rst                                        |    2 +-
 .../dsa/configuration.rst                                       |    2 +-
 .../ethtool-netlink.rst                                         |    6 +++---
 .../gtp.rst                                                     |    2 +-
 .../ieee802154.rst                                              |    2 +-
 .../ip-sysctl.rst                                               |    6 +++---
 .../ipvlan.rst                                                  |    2 +-
 .../j1939.rst                                                   |    2 +-
 .../net_failover.rst                                            |    2 +-
 .../netconsole.rst                                              |    2 +-
 .../page_pool.rst                                               |    6 +++---
 .../phonet.rst                                                  |    2 +-
 .../phy.rst                                                     |    2 +-
 .../regulatory.rst                                              |    4 ++--
 .../rxrpc.rst                                                   |    2 +-
 .../snmp_counter.rst                                            |    4 ++--
 .../sysfs-tagging.rst                                           |    2 +-
 35 files changed, 49 insertions(+), 49 deletions(-)

diff -- a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -285,7 +285,7 @@ features are enabled after the hierarchy
 changes are made.
 
 This feature is also dependent on switchdev being enabled in the system.
-It's required bacause devlink-rate requires devlink-port objects to be
+It's required because devlink-rate requires devlink-port objects to be
 present, and those objects are only created in switchdev mode.
 
 If the driver is set to the switchdev mode, it will export internal
@@ -320,7 +320,7 @@ nodes and nodes with children also can't
     * - ``tx_weight``
       - allows for usage of Weighted Fair Queuing arbitration scheme among
         siblings. This arbitration scheme can be used simultaneously with
-        the strict priority. Range 1-200. Only relative values mater for
+        the strict priority. Range 1-200. Only relative values matter for
         arbitration.
 
 ``tx_priority`` and ``tx_weight`` can be used simultaneously. In that case
diff -- a/Documentation/networking/devlink/netdevsim.rst b/Documentation/networking/devlink/netdevsim.rst
--- a/Documentation/networking/devlink/netdevsim.rst
+++ b/Documentation/networking/devlink/netdevsim.rst
@@ -95,5 +95,5 @@ Driver-specific Traps
    * - ``fid_miss``
      - ``exception``
      - When a packet enters the device it is classified to a filtering
-       indentifier (FID) based on the ingress port and VLAN. This trap is used
+       identifier (FID) based on the ingress port and VLAN. This trap is used
        to trap packets for which a FID could not be found
diff -- a/Documentation/networking/devlink/prestera.rst b/Documentation/networking/devlink/prestera.rst
--- a/Documentation/networking/devlink/prestera.rst
+++ b/Documentation/networking/devlink/prestera.rst
@@ -138,4 +138,4 @@ Driver-specific Traps
      - Drops packets with zero (0) IPV4 source address.
    * - ``met_red``
      - ``drop``
-     - Drops non-conforming packets (dropped by Ingress policer, metering drop), e.g. packet rate exceeded configured bandwith.
+     - Drops non-conforming packets (dropped by Ingress policer, metering drop), e.g. packet rate exceeded configured bandwidth.
diff -- a/Documentation/networking/dsa/configuration.rst b/Documentation/networking/dsa/configuration.rst
--- a/Documentation/networking/dsa/configuration.rst
+++ b/Documentation/networking/dsa/configuration.rst
@@ -5,7 +5,7 @@ DSA switch configuration from userspace
 =======================================
 
 The DSA switch configuration is not integrated into the main userspace
-network configuration suites by now and has to be performed manualy.
+network configuration suites by now and has to be performed manually.
 
 .. _dsa-config-showcases:
 
diff -- a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -106,7 +106,7 @@ modifying a bitmap, the former changes t
 value and preserves the rest; the latter sets the bits set in the bitmap and
 clears the rest.
 
-Compact form: nested (bitset) atrribute contents:
+Compact form: nested (bitset) attribute contents:
 
   ============================  ======  ============================
   ``ETHTOOL_A_BITSET_NOMASK``   flag    no mask, only a list
@@ -783,7 +783,7 @@ Kernel response contents:
   ``ETHTOOL_A_FEATURES_ACTIVE``         bitset  diff old vs. new active
   ====================================  ======  ==========================
 
-Request constains only one bitset which can be either value/mask pair (request
+Request contains only one bitset which can be either value/mask pair (request
 to change specific feature bits and leave the rest) or only a value (request
 to set all features to specified set).
 
@@ -1823,7 +1823,7 @@ aPLCATransmitOpportunityTimer. The valid
 When set, the optional ``ETHTOOL_A_PLCA_BURST_CNT`` attribute indicates the
 configured number of extra packets that the node is allowed to send during a
 single transmit opportunity. By default, this attribute is 0, meaning that
-the node can only send a sigle frame per TO. When greater than 0, the PLCA RS
+the node can only send a single frame per TO. When greater than 0, the PLCA RS
 keeps the TO after any transmission, waiting for the MAC to send a new frame
 for up to aPLCABurstTimer BTs. This can only happen a number of times per PLCA
 cycle up to the value of this parameter. After that, the burst is over and the
diff -- a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -50,7 +50,7 @@ ip_no_pmtu_disc - INTEGER
 	Default: FALSE
 
 min_pmtu - INTEGER
-	default 552 - minimum Path MTU. Unless this is changed mannually,
+	default 552 - minimum Path MTU. Unless this is changed manually,
 	each cached pmtu will never be lower than this setting.
 
 ip_forward_use_pmtu - BOOLEAN
@@ -2078,7 +2078,7 @@ skip_notify_on_dev_down - BOOLEAN
 
 nexthop_compat_mode - BOOLEAN
 	New nexthop API provides a means for managing nexthops independent of
-	prefixes. Backwards compatibilty with old route format is enabled by
+	prefixes. Backwards compatibility with old route format is enabled by
 	default which means route dumps and notifications contain the new
 	nexthop attribute but also the full, expanded nexthop definition.
 	Further, updates or deletes of a nexthop configuration generate route
@@ -2811,7 +2811,7 @@ pf_expose - INTEGER
 	can be got via SCTP_GET_PEER_ADDR_INFO sockopt;  When it's enabled,
 	a SCTP_PEER_ADDR_CHANGE event will be sent for a transport becoming
 	SCTP_PF state and a SCTP_PF-state transport info can be got via
-	SCTP_GET_PEER_ADDR_INFO sockopt;  When it's diabled, no
+	SCTP_GET_PEER_ADDR_INFO sockopt;  When it's disabled, no
 	SCTP_PEER_ADDR_CHANGE event will be sent and it returns -EACCES when
 	trying to get a SCTP_PF-state transport info via SCTP_GET_PEER_ADDR_INFO
 	sockopt.
diff -- a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -116,7 +116,7 @@ format, the Group Extension is set in th
   ----------------------------------------
   23 ... 16       15 ... 8
   ==============  ========================
-  F0h ... FFh     GE (Group Extenstion)
+  F0h ... FFh     GE (Group Extension)
   ==============  ========================
 
 On the other hand, when using PDU1 format, the PS-field contains a so-called
diff -- a/Documentation/networking/phonet.rst b/Documentation/networking/phonet.rst
--- a/Documentation/networking/phonet.rst
+++ b/Documentation/networking/phonet.rst
@@ -131,7 +131,7 @@ Phonet resources, as follow::
 Subscription is similarly cancelled using the SIOCPNDELRESOURCE I/O
 control request, or when the socket is closed.
 
-Note that no more than one socket can be subcribed to any given
+Note that no more than one socket can be subscribed to any given
 resource at a time. If not, ioctl() will return EBUSY.
 
 
diff -- a/Documentation/networking/regulatory.rst b/Documentation/networking/regulatory.rst
--- a/Documentation/networking/regulatory.rst
+++ b/Documentation/networking/regulatory.rst
@@ -66,7 +66,7 @@ An example::
   iw reg set CR
 
 This will request the kernel to set the regulatory domain to
-the specificied alpha2. The kernel in turn will then ask userspace
+the specified alpha2. The kernel in turn will then ask userspace
 to provide a regulatory domain for the alpha2 specified by the user
 by sending a uevent.
 
@@ -158,7 +158,7 @@ kmalloc() a structure big enough to hold
 structure and you should then fill it with your data. Finally you simply
 call regulatory_hint() with the regulatory domain structure in it.
 
-Bellow is a simple example, with a regulatory domain cached using the stack.
+Below is a simple example, with a regulatory domain cached using the stack.
 Your implementation may vary (read EEPROM cache instead, for example).
 
 Example cache of some regulatory domain::
diff -- a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -419,7 +419,7 @@ XDP_UMEM_REG setsockopt
 -----------------------
 
 This setsockopt registers a UMEM to a socket. This is the area that
-contain all the buffers that packet can recide in. The call takes a
+contain all the buffers that packet can reside in. The call takes a
 pointer to the beginning of this area and the size of it. Moreover, it
 also has parameter called chunk_size that is the size that the UMEM is
 divided into. It can only be 2K or 4K at the moment. If you have an
@@ -592,7 +592,7 @@ A: When a netdev of a physical NIC is in
    A number of other ways are possible all up to the capabilities of
    the NIC you have.
 
-Q: Can I use the XSKMAP to implement a switch betwen different umems
+Q: Can I use the XSKMAP to implement a switch between different umems
    in copy mode?
 
 A: The short answer is no, that is not supported at the moment. The
diff -- a/Documentation/networking/arcnet-hardware.rst b/Documentation/networking/arcnet-hardware.rst
--- a/Documentation/networking/arcnet-hardware.rst
+++ b/Documentation/networking/arcnet-hardware.rst
@@ -1902,7 +1902,7 @@ of 32 possible I/O Base addresses using
      6    |  10
 
 The I/O address is sum of all switches set to "1". Remember that
-the I/O address space bellow 0x200 is RESERVED for mainboard, so
+the I/O address space below 0x200 is RESERVED for mainboard, so
 switch 1 should be ALWAYS SET TO OFF.
 
 
diff -- a/Documentation/networking/can.rst b/Documentation/networking/can.rst
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -931,7 +931,7 @@ ival1:
 ival2:
 	Throttle the received message rate down to the value of ival2. This
 	is useful to reduce messages for the application when the signal inside the
-	CAN frame is stateless as state changes within the ival2 periode may get
+	CAN frame is stateless as state changes within the ival2 period may get
 	lost.
 
 Broadcast Manager Multiplex Message Receive Filter
diff -- a/Documentation/networking/can_ucan_protocol.rst b/Documentation/networking/can_ucan_protocol.rst
--- a/Documentation/networking/can_ucan_protocol.rst
+++ b/Documentation/networking/can_ucan_protocol.rst
@@ -50,7 +50,7 @@ Setup Packet
 ``wIndex``         USB Interface Index (0 for device commands)
 ``wLength``        * Host to Device - Number of bytes to transmit
                    * Device to Host - Maximum Number of bytes to
-                     receive. If the device send less. Commom ZLP
+                     receive. If the device send less. Common ZLP
                      semantics are used.
 =================  =====================================================
 
diff -- a/Documentation/networking/cdc_mbim.rst b/Documentation/networking/cdc_mbim.rst
--- a/Documentation/networking/cdc_mbim.rst
+++ b/Documentation/networking/cdc_mbim.rst
@@ -93,7 +93,7 @@ MBIM function can be looked up using sys
 USB configuration descriptors
 -----------------------------
 The wMaxControlMessage field of the CDC MBIM functional descriptor
-limits the maximum control message size. The managament application is
+limits the maximum control message size. The management application is
 responsible for negotiating a control message size complying with the
 requirements in section 9.3.1 of [1], taking this descriptor field
 into consideration.
diff -- a/Documentation/networking/gtp.rst b/Documentation/networking/gtp.rst
--- a/Documentation/networking/gtp.rst
+++ b/Documentation/networking/gtp.rst
@@ -162,7 +162,7 @@ Local GTP-U entity and tunnel identifica
 GTP-U uses UDP for transporting PDU's. The receiving UDP port is 2152
 for GTPv1-U and 3386 for GTPv0-U.
 
-There is only one GTP-U entity (and therefor SGSN/GGSN/S-GW/PDN-GW
+There is only one GTP-U entity (and therefore SGSN/GGSN/S-GW/PDN-GW
 instance) per IP address. Tunnel Endpoint Identifier (TEID) are unique
 per GTP-U entity.
 
diff -- a/Documentation/networking/ieee802154.rst b/Documentation/networking/ieee802154.rst
--- a/Documentation/networking/ieee802154.rst
+++ b/Documentation/networking/ieee802154.rst
@@ -70,7 +70,7 @@ Like with WiFi, there are several types
 exports a management (e.g. MLME) and data API.
 2) 'SoftMAC' or just radio. These types of devices are just radio transceivers
 possibly with some kinds of acceleration like automatic CRC computation and
-comparation, automagic ACK handling, address matching, etc.
+comparison, automagic ACK handling, address matching, etc.
 
 Those types of devices require different approach to be hooked into Linux kernel.
 
diff -- a/Documentation/networking/ipvlan.rst b/Documentation/networking/ipvlan.rst
--- a/Documentation/networking/ipvlan.rst
+++ b/Documentation/networking/ipvlan.rst
@@ -61,7 +61,7 @@ e.g.
 IPvlan has two modes of operation - L2 and L3. For a given master device,
 you can select one of these two modes and all slaves on that master will
 operate in the same (selected) mode. The RX mode is almost identical except
-that in L3 mode the slaves wont receive any multicast / broadcast traffic.
+that in L3 mode the slaves won't receive any multicast / broadcast traffic.
 L3 mode is more restrictive since routing is controlled from the other (mostly)
 default namespace.
 
diff -- a/Documentation/networking/netconsole.rst b/Documentation/networking/netconsole.rst
--- a/Documentation/networking/netconsole.rst
+++ b/Documentation/networking/netconsole.rst
@@ -167,7 +167,7 @@ following format which is the same as /d
 
 Non printable characters in <message text> are escaped using "\xff"
 notation. If the message contains optional dictionary, verbatim
-newline is used as the delimeter.
+newline is used as the delimiter.
 
 If a message doesn't fit in certain number of bytes (currently 1000),
 the message is split into multiple fragments by netconsole. These
diff -- a/Documentation/networking/net_failover.rst b/Documentation/networking/net_failover.rst
--- a/Documentation/networking/net_failover.rst
+++ b/Documentation/networking/net_failover.rst
@@ -90,7 +90,7 @@ virtio-net interface, and ens11 is the s
 One point to note here is that some user space network configuration daemons
 like systemd-networkd, ifupdown, etc, do not understand the 'net_failover'
 device; and on the first boot, the VM might end up with both 'failover' device
-and VF accquiring IP addresses (either same or different) from the DHCP server.
+and VF acquiring IP addresses (either same or different) from the DHCP server.
 This will result in lack of connectivity to the VM. So some tweaks might be
 needed to these network configuration daemons to make sure that an IP is
 received only on the 'failover' device.
diff -- a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -11,7 +11,7 @@ Basic use involves replacing alloc_pages
 page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages()
 replacing dev_alloc_pages().
 
-API keeps track of inflight pages, in order to let API user know
+API keeps track of in-flight pages, in order to let API user know
 when it is safe to free a page_pool object.  Thus, API users
 must run page_pool_release_page() when a page is leaving the page_pool or
 call page_pool_put_page() where appropriate in order to maintain correct
@@ -19,7 +19,7 @@ accounting.
 
 API user must call page_pool_put_page() once on a page, as it
 will either recycle the page, or in case of refcnt > 1, it will
-release the DMA mapping and inflight state accounting.
+release the DMA mapping and in-flight state accounting.
 
 Architecture overview
 =====================
@@ -88,7 +88,7 @@ a page will cause no race conditions is
   directly into the pool fast cache.
 
 * page_pool_release_page(): Unmap the page (if mapped) and account for it on
-  inflight counters.
+  in-flight counters.
 
 * page_pool_dev_alloc_pages(): Get a page from the page allocator or page_pool
   caches.
diff -- a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -315,7 +315,7 @@ Some of the interface modes are describe
     only the port id, but also so-called "extensions". The only documented
     extension so-far in the specification is the inclusion of timestamps, for
     PTP-enabled PHYs. This mode isn't compatible with QSGMII, but offers the
-    same capabilities in terms of link speed and negociation.
+    same capabilities in terms of link speed and negotiation.
 
 ``PHY_INTERFACE_MODE_1000BASEKX``
     This is 1000BASE-X as defined by IEEE 802.3 Clause 36 with Clause 73
diff -- a/Documentation/networking/rxrpc.rst b/Documentation/networking/rxrpc.rst
--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -1069,7 +1069,7 @@ The kernel interface functions are as fo
      This value can be used to determine if the remote client has been
      restarted as it shouldn't change otherwise.
 
- (#) Set the maxmimum lifespan on a call::
+ (#) Set the maximum lifespan on a call::
 
 	void rxrpc_kernel_set_max_life(struct socket *sock,
 				       struct rxrpc_call *call,
diff -- a/Documentation/networking/snmp_counter.rst b/Documentation/networking/snmp_counter.rst
--- a/Documentation/networking/snmp_counter.rst
+++ b/Documentation/networking/snmp_counter.rst
@@ -980,7 +980,7 @@ How many reply packets of the SYN cookie
 
 The MSS decoded from the SYN cookie is invalid. When this counter is
 updated, the received packet won't be treated as a SYN cookie and the
-TcpExtSyncookiesRecv counter wont be updated.
+TcpExtSyncookiesRecv counter won't be updated.
 
 Challenge ACK
 =============
@@ -1681,7 +1681,7 @@ RST to nstat-b::
 
   nstatuser@nstat-a:~$ sudo iptables -A INPUT -p tcp --sport 9000 -j DROP
 
-Send 3 SYN repeatly to nstat-b::
+Send 3 SYN repeatedly to nstat-b::
 
   nstatuser@nstat-a:~$ for i in {1..3}; do sudo tcpreplay -i ens3 /tmp/syn_fixcsum.pcap; done
 
diff -- a/Documentation/networking/sysfs-tagging.rst b/Documentation/networking/sysfs-tagging.rst
--- a/Documentation/networking/sysfs-tagging.rst
+++ b/Documentation/networking/sysfs-tagging.rst
@@ -43,6 +43,6 @@ Users of this interface:
 
   - current_ns() which returns current's namespace
   - netlink_ns() which returns a socket's namespace
-  - initial_ns() which returns the initial namesapce
+  - initial_ns() which returns the initial namespace
 
 - call kobj_ns_exit() when an individual tag is no longer valid
diff -- a/Documentation/networking/device_drivers/atm/iphase.rst b/Documentation/networking/device_drivers/atm/iphase.rst
--- a/Documentation/networking/device_drivers/atm/iphase.rst
+++ b/Documentation/networking/device_drivers/atm/iphase.rst
@@ -4,7 +4,7 @@
 ATM (i)Chip IA Linux Driver Source
 ==================================
 
-			      READ ME FISRT
+			      READ ME FIRST
 
 --------------------------------------------------------------------------------
 
diff -- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
@@ -577,7 +577,7 @@ CTU CAN FD IP Core and Driver Developmen
 
   * Linux driver development
   * continuous integration platform architect and GHDL updates
-  * theses `Open-source and Open-hardware CAN FD Protocol Support <https://dspace.cvut.cz/bitstream/handle/10467/80366/F3-DP-2019-Jerabek-Martin-Jerabek-thesis-2019-canfd.pdf>`_
+  * thesis `Open-source and Open-hardware CAN FD Protocol Support <https://dspace.cvut.cz/bitstream/handle/10467/80366/F3-DP-2019-Jerabek-Martin-Jerabek-thesis-2019-canfd.pdf>`_
 
 * Jiri Novak <jnovak@fel.cvut.cz>
 
@@ -603,7 +603,7 @@ CTU CAN FD IP Core and Driver Developmen
 * Jan Charvat
 
  * implemented CTU CAN FD functional model for QEMU which has been integrated into QEMU mainline (`docs/system/devices/can.rst <https://www.qemu.org/docs/master/system/devices/can.html>`_)
- * Bachelor theses Model of CAN FD Communication Controller for QEMU Emulator
+ * Bachelor thesis Model of CAN FD Communication Controller for QEMU Emulator
 
 Notes
 -----
diff -- a/Documentation/networking/device_drivers/can/ctu/fsm_txt_buffer_user.svg b/Documentation/networking/device_drivers/can/ctu/fsm_txt_buffer_user.svg
--- a/Documentation/networking/device_drivers/can/ctu/fsm_txt_buffer_user.svg
+++ b/Documentation/networking/device_drivers/can/ctu/fsm_txt_buffer_user.svg
@@ -129,10 +129,10 @@
    </g>
   </g>
   <text transform="matrix(.264583 0 0 .264583 91.8919 139.964)" x="26.959213" y="9.11724" fill="#2aa1ff" filter="url(#filter1204-6-2-9-1-3-1)" font-size="12px" stroke-width="3.77953" text-align="center" text-anchor="middle" style="line-height:1.1" xml:space="preserve"><tspan x="26.959213" y="9.11724" text-align="center">Set</tspan><tspan x="26.959213" y="22.31724" text-align="center">abort</tspan></text>
-  <text transform="translate(49.0277 104.823)" x="57.620724" y="16.855087" filter="url(#filter1204)" font-size="3.175px" text-align="center" text-anchor="middle" style="line-height:1.1" xml:space="preserve"><tspan x="57.620724" y="16.855087" text-align="center">Transmission</tspan><tspan x="57.620724" y="20.347588" text-align="center">unsuccesfull</tspan></text>
+  <text transform="translate(49.0277 104.823)" x="57.620724" y="16.855087" filter="url(#filter1204)" font-size="3.175px" text-align="center" text-anchor="middle" style="line-height:1.1" xml:space="preserve"><tspan x="57.620724" y="16.855087" text-align="center">Transmission</tspan><tspan x="57.620724" y="20.347588" text-align="center">unsuccessful</tspan></text>
   <g font-size="12px" stroke-width="3.77953" text-anchor="middle">
    <text transform="matrix(.264583 0 0 .264583 68.5988 118.913)" x="38.824219" y="9.1171875" filter="url(#filter1204)" text-align="center" style="line-height:1.1" xml:space="preserve"><tspan x="38.824219" y="9.1171875" text-align="center">Transmission</tspan><tspan x="38.824219" y="22.317188" text-align="center">starts</tspan></text>
-   <text transform="matrix(.264583 0 0 .264583 106.802 130.509)" x="38.824219" y="9.1171875" filter="url(#filter1204)" text-align="center" style="line-height:1.1" xml:space="preserve"><tspan x="38.824219" y="9.1171875" text-align="center">Transmission</tspan><tspan x="38.824219" y="22.317188" text-align="center">succesfull</tspan></text>
+   <text transform="matrix(.264583 0 0 .264583 106.802 130.509)" x="38.824219" y="9.1171875" filter="url(#filter1204)" text-align="center" style="line-height:1.1" xml:space="preserve"><tspan x="38.824219" y="9.1171875" text-align="center">Transmission</tspan><tspan x="38.824219" y="22.317188" text-align="center">successful</tspan></text>
    <text transform="matrix(.264583 0 0 .264583 107.77 145.476)" x="38.824219" y="9.1171875" filter="url(#filter1204)" text-align="center" style="line-height:1.1" xml:space="preserve"><tspan x="38.824219" y="9.1171875" text-align="center">Transmission</tspan><tspan x="38.824219" y="22.317188" text-align="center">sborted</tspan></text>
   </g>
   <g stroke-width="3.77953" text-anchor="middle">
diff -- a/Documentation/networking/device_drivers/wwan/iosm.rst b/Documentation/networking/device_drivers/wwan/iosm.rst
--- a/Documentation/networking/device_drivers/wwan/iosm.rst
+++ b/Documentation/networking/device_drivers/wwan/iosm.rst
@@ -69,7 +69,7 @@ wwan0-X network device
 The IOSM driver exposes IP link interface "wwan0-X" of type "wwan" for IP
 traffic. Iproute network utility is used for creating "wwan0-X" network
 interface and for associating it with MBIM IP session. The Driver supports
-upto 8 IP sessions for simultaneous IP communication.
+up to 8 IP sessions for simultaneous IP communication.
 
 The userspace management application is responsible for creating new IP link
 prior to establishing MBIM IP session where the SessionId is greater than 0.
diff -- a/Documentation/networking/device_drivers/ethernet/3com/vortex.rst b/Documentation/networking/device_drivers/ethernet/3com/vortex.rst
--- a/Documentation/networking/device_drivers/ethernet/3com/vortex.rst
+++ b/Documentation/networking/device_drivers/ethernet/3com/vortex.rst
@@ -254,7 +254,7 @@ Media selection
 A number of the older NICs such as the 3c590 and 3c900 series have
 10base2 and AUI interfaces.
 
-Prior to January, 2001 this driver would autoeselect the 10base2 or AUI
+Prior to January, 2001 this driver would autoselect the 10base2 or AUI
 port if it didn't detect activity on the 10baseT port.  It would then
 get stuck on the 10base2 port and a driver reload was necessary to
 switch back to 10baseT.  This behaviour could not be prevented with a
diff -- a/Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst b/Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst
--- a/Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst
+++ b/Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst
@@ -270,7 +270,7 @@ RX flow rules (ntuple filters)
 
     ethtool -K ethX ntuple <on|off>
 
- When disabling ntuple filters, all the user programed filters are
+ When disabling ntuple filters, all the user programmed filters are
  flushed from the driver cache and hardware. All needed filters must
  be re-added when ntuple is re-enabled.
 
@@ -418,7 +418,7 @@ Default value: 0xFFFF
 0        Disable interrupt throttling.
 1        Enable interrupt throttling and use specified tx and rx rates.
 0xFFFF   Auto throttling mode. Driver will choose the best RX and TX
-	 interrupt throtting settings based on link speed.
+	 interrupt throttling settings based on link speed.
 ======   ==============================================================
 
 aq_itr_tx - TX interrupt throttle rate
@@ -456,7 +456,7 @@ AQ_CFG_RX_PAGEORDER
 
 Default value: 0
 
-RX page order override. Thats a power of 2 number of RX pages allocated for
+RX page order override. That's a power of 2 number of RX pages allocated for
 each descriptor. Received descriptor size is still limited by
 AQ_CFG_RX_FRAME_MAX.
 
diff -- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst
--- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst
+++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst
@@ -11,7 +11,7 @@ Overview
 --------
 
 The DPAA2 MAC / PHY support consists of a set of APIs that help DPAA2 network
-drivers (dpaa2-eth, dpaa2-ethsw) interract with the PHY library.
+drivers (dpaa2-eth, dpaa2-ethsw) interact with the PHY library.
 
 DPAA2 Software Architecture
 ---------------------------
diff -- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
--- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
@@ -127,7 +127,7 @@ Type1:
 Type2:
  - RVU PF0 ie admin function creates these VFs and maps them to loopback block's channels.
  - A set of two VFs (VF0 & VF1, VF2 & VF3 .. so on) works as a pair ie pkts sent out of
-   VF0 will be received by VF1 and viceversa.
+   VF0 will be received by VF1 and vice versa.
  - These VFs can be used by applications or virtual machines to communicate between them
    without sending traffic outside. There is no switch present in HW, hence the support
    for loopback VFs.
diff -- a/Documentation/networking/device_drivers/ethernet/pensando/ionic.rst b/Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
--- a/Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
+++ b/Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
@@ -83,7 +83,7 @@ Configuring the Driver
 MTU
 ---
 
-Jumbo frame support is available with a maximim size of 9194 bytes.
+Jumbo frame support is available with a maximum size of 9194 bytes.
 
 Interrupt coalescing
 --------------------
diff -- a/Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst b/Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst
--- a/Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst
+++ b/Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst
@@ -124,7 +124,7 @@ Multicast flooding
 ==================
 CPU port mcast_flooding is always on
 
-Turning flooding on/off on swithch ports:
+Turning flooding on/off on switch ports:
 bridge link set dev sw0p1 mcast_flood on/off
 
 Access and Trunk port
diff -- a/Documentation/networking/device_drivers/ethernet/ti/cpsw_switchdev.rst b/Documentation/networking/device_drivers/ethernet/ti/cpsw_switchdev.rst
--- a/Documentation/networking/device_drivers/ethernet/ti/cpsw_switchdev.rst
+++ b/Documentation/networking/device_drivers/ethernet/ti/cpsw_switchdev.rst
@@ -174,7 +174,7 @@ Multicast flooding
 ==================
 CPU port mcast_flooding is always on
 
-Turning flooding on/off on swithch ports:
+Turning flooding on/off on switch ports:
 bridge link set dev sw0p1 mcast_flood on/off
 
 Access and Trunk port
