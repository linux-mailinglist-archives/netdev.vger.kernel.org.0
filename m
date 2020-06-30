Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B120F07D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 10:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731480AbgF3I2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 04:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731464AbgF3I14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 04:27:56 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2342C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 01:27:55 -0700 (PDT)
Received: from kero.packetmixer.de (p4fd575ab.dip0.t-ipconnect.de [79.213.117.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id D4F756206B;
        Tue, 30 Jun 2020 10:27:52 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/4] batman-adv: Fix typos and grammar in documentation
Date:   Tue, 30 Jun 2020 10:27:30 +0200
Message-Id: <20200630082731.2397-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200630082731.2397-1-sw@simonwunderlich.de>
References: <20200630082731.2397-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 Documentation/networking/batman-adv.rst |  6 +--
 include/uapi/linux/batadv_packet.h      | 50 ++++++++++++-------------
 include/uapi/linux/batman_adv.h         |  4 +-
 net/batman-adv/bat_iv_ogm.c             |  8 ++--
 net/batman-adv/bat_v_elp.c              | 10 ++---
 net/batman-adv/bat_v_ogm.c              | 14 +++----
 net/batman-adv/bridge_loop_avoidance.c  |  6 +--
 net/batman-adv/distributed-arp-table.c  |  2 +-
 net/batman-adv/fragmentation.c          |  6 +--
 net/batman-adv/hard-interface.c         | 14 +++----
 net/batman-adv/log.h                    |  6 +--
 net/batman-adv/main.c                   |  2 +-
 net/batman-adv/main.h                   |  6 +--
 net/batman-adv/multicast.c              | 21 ++++++-----
 net/batman-adv/netlink.c                |  2 +-
 net/batman-adv/network-coding.c         | 14 +++----
 net/batman-adv/originator.c             |  8 ++--
 net/batman-adv/routing.c                |  4 +-
 net/batman-adv/send.c                   |  4 +-
 net/batman-adv/soft-interface.c         |  2 +-
 net/batman-adv/tp_meter.c               | 12 +++---
 net/batman-adv/translation-table.c      | 10 ++---
 net/batman-adv/tvlv.c                   |  4 +-
 net/batman-adv/types.h                  | 12 +++---
 24 files changed, 114 insertions(+), 113 deletions(-)

diff --git a/Documentation/networking/batman-adv.rst b/Documentation/networking/batman-adv.rst
index 02af49b08635..74821d29a22f 100644
--- a/Documentation/networking/batman-adv.rst
+++ b/Documentation/networking/batman-adv.rst
@@ -73,7 +73,7 @@ lower value. This will make the mesh more responsive to topology changes, but
 will also increase the overhead.
 
 Information about the current state can be accessed via the batadv generic
-netlink family. batctl provides human readable version via its debug tables
+netlink family. batctl provides a human readable version via its debug tables
 subcommands.
 
 
@@ -115,8 +115,8 @@ are prefixed with "batman-adv:" So to see just these messages try::
   $ dmesg | grep batman-adv
 
 When investigating problems with your mesh network, it is sometimes necessary to
-see more detail debug messages. This must be enabled when compiling the
-batman-adv module. When building batman-adv as part of kernel, use "make
+see more detailed debug messages. This must be enabled when compiling the
+batman-adv module. When building batman-adv as part of the kernel, use "make
 menuconfig" and enable the option ``B.A.T.M.A.N. debugging``
 (``CONFIG_BATMAN_ADV_DEBUG=y``).
 
diff --git a/include/uapi/linux/batadv_packet.h b/include/uapi/linux/batadv_packet.h
index 0ae34c85ef9e..9c8604c5b5f6 100644
--- a/include/uapi/linux/batadv_packet.h
+++ b/include/uapi/linux/batadv_packet.h
@@ -72,8 +72,8 @@ enum batadv_subtype {
 
 /**
  * enum batadv_iv_flags - flags used in B.A.T.M.A.N. IV OGM packets
- * @BATADV_NOT_BEST_NEXT_HOP: flag is set when ogm packet is forwarded and was
- *     previously received from someone else than the best neighbor.
+ * @BATADV_NOT_BEST_NEXT_HOP: flag is set when the ogm packet is forwarded and
+ *  was previously received from someone other than the best neighbor.
  * @BATADV_PRIMARIES_FIRST_HOP: flag unused.
  * @BATADV_DIRECTLINK: flag is for the first hop or if rebroadcasted from a
  *     one hop neighbor on the interface where it was originally received.
@@ -195,8 +195,8 @@ struct batadv_bla_claim_dst {
 /**
  * struct batadv_ogm_packet - ogm (routing protocol) packet
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @flags: contains routing relevant flags - see enum batadv_iv_flags
  * @seqno: sequence identification
  * @orig: address of the source node
@@ -247,7 +247,7 @@ struct batadv_ogm2_packet {
 /**
  * struct batadv_elp_packet - elp (neighbor discovery) packet
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
  * @orig: originator mac address
  * @seqno: sequence number
  * @elp_interval: currently used ELP sending interval in ms
@@ -265,15 +265,15 @@ struct batadv_elp_packet {
 /**
  * struct batadv_icmp_header - common members among all the ICMP packets
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @msg_type: ICMP packet type
  * @dst: address of the destination node
  * @orig: address of the source node
  * @uid: local ICMP socket identifier
  * @align: not used - useful for alignment purposes only
  *
- * This structure is used for ICMP packets parsing only and it is never sent
+ * This structure is used for ICMP packet parsing only and it is never sent
  * over the wire. The alignment field at the end is there to ensure that
  * members are padded the same way as they are in real packets.
  */
@@ -291,8 +291,8 @@ struct batadv_icmp_header {
 /**
  * struct batadv_icmp_packet - ICMP packet
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @msg_type: ICMP packet type
  * @dst: address of the destination node
  * @orig: address of the source node
@@ -315,8 +315,8 @@ struct batadv_icmp_packet {
 /**
  * struct batadv_icmp_tp_packet - ICMP TP Meter packet
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @msg_type: ICMP packet type
  * @dst: address of the destination node
  * @orig: address of the source node
@@ -358,8 +358,8 @@ enum batadv_icmp_tp_subtype {
 /**
  * struct batadv_icmp_packet_rr - ICMP RouteRecord packet
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @msg_type: ICMP packet type
  * @dst: address of the destination node
  * @orig: address of the source node
@@ -397,8 +397,8 @@ struct batadv_icmp_packet_rr {
 /**
  * struct batadv_unicast_packet - unicast packet for network payload
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @ttvn: translation table version number
  * @dest: originator destination of the unicast packet
  */
@@ -433,8 +433,8 @@ struct batadv_unicast_4addr_packet {
 /**
  * struct batadv_frag_packet - fragmented packet
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @dest: final destination used when routing fragments
  * @orig: originator of the fragment used when merging the packet
  * @no: fragment number within this sequence
@@ -467,8 +467,8 @@ struct batadv_frag_packet {
 /**
  * struct batadv_bcast_packet - broadcast packet for network payload
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @reserved: reserved byte for alignment
  * @seqno: sequence identification
  * @orig: originator of the broadcast packet
@@ -488,10 +488,10 @@ struct batadv_bcast_packet {
 /**
  * struct batadv_coded_packet - network coded packet
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @first_source: original source of first included packet
- * @first_orig_dest: original destinal of first included packet
+ * @first_orig_dest: original destination of first included packet
  * @first_crc: checksum of first included packet
  * @first_ttvn: tt-version number of first included packet
  * @second_ttl: ttl of second packet
@@ -523,8 +523,8 @@ struct batadv_coded_packet {
 /**
  * struct batadv_unicast_tvlv_packet - generic unicast packet with tvlv payload
  * @packet_type: batman-adv packet type, part of the general header
- * @version: batman-adv protocol version, part of the genereal header
- * @ttl: time to live for this packet, part of the genereal header
+ * @version: batman-adv protocol version, part of the general header
+ * @ttl: time to live for this packet, part of the general header
  * @reserved: reserved field (for packet alignment)
  * @src: address of the source
  * @dst: address of the destination
diff --git a/include/uapi/linux/batman_adv.h b/include/uapi/linux/batman_adv.h
index 617c180ff0c8..8cf2ad11ead9 100644
--- a/include/uapi/linux/batman_adv.h
+++ b/include/uapi/linux/batman_adv.h
@@ -69,7 +69,7 @@ enum batadv_tt_client_flags {
 
 	/**
 	 * @BATADV_TT_CLIENT_TEMP: this global client has been detected to be
-	 * part of the network but no nnode has already announced it
+	 * part of the network but no node has already announced it
 	 */
 	BATADV_TT_CLIENT_TEMP	 = (1 << 11),
 };
@@ -131,7 +131,7 @@ enum batadv_gw_modes {
 	/** @BATADV_GW_MODE_CLIENT: send DHCP requests to gw servers */
 	BATADV_GW_MODE_CLIENT,
 
-	/** @BATADV_GW_MODE_SERVER: announce itself as gatway server */
+	/** @BATADV_GW_MODE_SERVER: announce itself as gateway server */
 	BATADV_GW_MODE_SERVER,
 };
 
diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index e87f19c82e8d..5b3a41983156 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -134,7 +134,7 @@ static u8 batadv_ring_buffer_avg(const u8 lq_recv[])
  *
  * Return: the originator object corresponding to the passed mac address or NULL
  * on failure.
- * If the object does not exists it is created an initialised.
+ * If the object does not exist, it is created and initialised.
  */
 static struct batadv_orig_node *
 batadv_iv_ogm_orig_get(struct batadv_priv *bat_priv, const u8 *addr)
@@ -871,7 +871,7 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
 }
 
 /**
- * batadv_iv_orig_ifinfo_sum() - Get bcast_own sum for originator over iterface
+ * batadv_iv_orig_ifinfo_sum() - Get bcast_own sum for originator over interface
  * @orig_node: originator which reproadcasted the OGMs directly
  * @if_outgoing: interface which transmitted the original OGM and received the
  *  direct rebroadcast
@@ -1554,7 +1554,7 @@ static void batadv_iv_ogm_process_reply(struct batadv_ogm_packet *ogm_packet,
  * batadv_iv_ogm_process() - process an incoming batman iv OGM
  * @skb: the skb containing the OGM
  * @ogm_offset: offset to the OGM which should be processed (for aggregates)
- * @if_incoming: the interface where this packet was receved
+ * @if_incoming: the interface where this packet was received
  */
 static void batadv_iv_ogm_process(const struct sk_buff *skb, int ogm_offset,
 				  struct batadv_hard_iface *if_incoming)
@@ -2288,7 +2288,7 @@ batadv_iv_ogm_neigh_dump_hardif(struct sk_buff *msg, u32 portid, u32 seq,
  * @msg: Netlink message to dump into
  * @cb: Control block containing additional options
  * @bat_priv: The bat priv with all the soft interface information
- * @single_hardif: Limit dump to this hard interfaace
+ * @single_hardif: Limit dump to this hard interface
  */
 static void
 batadv_iv_ogm_neigh_dump(struct sk_buff *msg, struct netlink_callback *cb,
diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 0bdefa35da98..d35aca0e969a 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -60,7 +60,7 @@ static void batadv_v_elp_start_timer(struct batadv_hard_iface *hard_iface)
  * @neigh: the neighbour for which the throughput has to be obtained
  *
  * Return: The throughput towards the given neighbour in multiples of 100kpbs
- *         (a value of '1' equals to 0.1Mbps, '10' equals 1Mbps, etc).
+ *         (a value of '1' equals 0.1Mbps, '10' equals 1Mbps, etc).
  */
 static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 {
@@ -183,8 +183,8 @@ void batadv_v_elp_throughput_metric_update(struct work_struct *work)
  *
  * Sends a predefined number of unicast wifi packets to a given neighbour in
  * order to trigger the throughput estimation on this link by the RC algorithm.
- * Packets are sent only if there there is not enough payload unicast traffic
- * towards this neighbour..
+ * Packets are sent only if there is not enough payload unicast traffic towards
+ * this neighbour..
  *
  * Return: True on success and false in case of error during skb preparation.
  */
@@ -244,7 +244,7 @@ batadv_v_elp_wifi_neigh_probe(struct batadv_hardif_neigh_node *neigh)
  * batadv_v_elp_periodic_work() - ELP periodic task per interface
  * @work: work queue item
  *
- * Emits broadcast ELP message in regular intervals.
+ * Emits broadcast ELP messages in regular intervals.
  */
 static void batadv_v_elp_periodic_work(struct work_struct *work)
 {
@@ -499,7 +499,7 @@ static void batadv_v_elp_neigh_update(struct batadv_priv *bat_priv,
  * @skb: the received packet
  * @if_incoming: the interface this packet was received through
  *
- * Return: NET_RX_SUCCESS and consumes the skb if the packet was peoperly
+ * Return: NET_RX_SUCCESS and consumes the skb if the packet was properly
  * processed or NET_RX_DROP in case of failure.
  */
 int batadv_v_elp_packet_recv(struct sk_buff *skb,
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 18028b9f95f0..0d404f7bcd9f 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -47,9 +47,9 @@
  * @bat_priv: the bat priv with all the soft interface information
  * @addr: the address of the originator
  *
- * Return: the orig_node corresponding to the specified address. If such object
- * does not exist it is allocated here. In case of allocation failure returns
- * NULL.
+ * Return: the orig_node corresponding to the specified address. If such an
+ * object does not exist, it is allocated here. In case of allocation failure
+ * returns NULL.
  */
 struct batadv_orig_node *batadv_v_ogm_orig_get(struct batadv_priv *bat_priv,
 					       const u8 *addr)
@@ -172,7 +172,7 @@ static bool batadv_v_ogm_queue_left(struct sk_buff *skb,
  * batadv_v_ogm_aggr_list_free - free all elements in an aggregation queue
  * @hard_iface: the interface holding the aggregation queue
  *
- * Empties the OGMv2 aggregation queue and frees all the skbs it contained.
+ * Empties the OGMv2 aggregation queue and frees all the skbs it contains.
  *
  * Caller needs to hold the hard_iface->bat_v.aggr_list.lock.
  */
@@ -378,7 +378,7 @@ static void batadv_v_ogm_send(struct work_struct *work)
  * batadv_v_ogm_aggr_work() - OGM queue periodic task per interface
  * @work: work queue item
  *
- * Emits aggregated OGM message in regular intervals.
+ * Emits aggregated OGM messages in regular intervals.
  */
 void batadv_v_ogm_aggr_work(struct work_struct *work)
 {
@@ -399,7 +399,7 @@ void batadv_v_ogm_aggr_work(struct work_struct *work)
  * batadv_v_ogm_iface_enable() - prepare an interface for B.A.T.M.A.N. V
  * @hard_iface: the interface to prepare
  *
- * Takes care of scheduling own OGM sending routine for this interface.
+ * Takes care of scheduling its own OGM sending routine for this interface.
  *
  * Return: 0 on success or a negative error code otherwise
  */
@@ -847,7 +847,7 @@ batadv_v_ogm_aggr_packet(int buff_pos, int packet_len,
  * batadv_v_ogm_process() - process an incoming batman v OGM
  * @skb: the skb containing the OGM
  * @ogm_offset: offset to the OGM which should be processed (for aggregates)
- * @if_incoming: the interface where this packet was receved
+ * @if_incoming: the interface where this packet was received
  */
 static void batadv_v_ogm_process(const struct sk_buff *skb, int ogm_offset,
 				 struct batadv_hard_iface *if_incoming)
diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 41cc87f06b14..91a04ca373dc 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -992,7 +992,7 @@ static bool batadv_handle_claim(struct batadv_priv *bat_priv,
  * @hw_dst: the Hardware destination in the ARP Header
  * @ethhdr: pointer to the Ethernet header of the claim frame
  *
- * checks if it is a claim packet and if its on the same group.
+ * checks if it is a claim packet and if it's on the same group.
  * This function also applies the group ID of the sender
  * if it is in the same mesh.
  *
@@ -1757,7 +1757,7 @@ void batadv_bla_free(struct batadv_priv *bat_priv)
  * @vid: the VLAN ID of the frame
  *
  * Checks if this packet is a loop detect frame which has been sent by us,
- * throw an uevent and log the event if that is the case.
+ * throws an uevent and logs the event if that is the case.
  *
  * Return: true if it is a loop detect frame which is to be dropped, false
  * otherwise.
@@ -1815,7 +1815,7 @@ batadv_bla_loopdetect_check(struct batadv_priv *bat_priv, struct sk_buff *skb,
  *  * we have to race for a claim
  *  * if the frame is allowed on the LAN
  *
- * in these cases, the skb is further handled by this function
+ * In these cases, the skb is further handled by this function
  *
  * Return: true if handled, otherwise it returns false and the caller shall
  * further process the skb.
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index b85da4b7a77b..0e6e53e9b5f3 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -666,7 +666,7 @@ batadv_dat_select_candidates(struct batadv_priv *bat_priv, __be32 ip_dst,
  * @vid: VLAN identifier
  * @packet_subtype: unicast4addr packet subtype to use
  *
- * This function copies the skb with pskb_copy() and is sent as unicast packet
+ * This function copies the skb with pskb_copy() and is sent as a unicast packet
  * to each of the selected candidates.
  *
  * Return: true if the packet is sent to at least one candidate, false
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 7cad97644d05..9fdbe3068153 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -102,8 +102,8 @@ static int batadv_frag_size_limit(void)
  *
  * Caller must hold chain->lock.
  *
- * Return: true if chain is empty and caller can just insert the new fragment
- * without searching for the right position.
+ * Return: true if chain is empty and the caller can just insert the new
+ * fragment without searching for the right position.
  */
 static bool batadv_frag_init_chain(struct batadv_frag_table_entry *chain,
 				   u16 seqno)
@@ -306,7 +306,7 @@ batadv_frag_merge_packets(struct hlist_head *chain)
  * set *skb to merged packet; 2) Packet is buffered: Return true and set *skb
  * to NULL; 3) Error: Return false and free skb.
  *
- * Return: true when packet is merged or buffered, false when skb is not not
+ * Return: true when the packet is merged or buffered, false when skb is not not
  * used.
  */
 bool batadv_frag_skb_buffer(struct sk_buff **skb,
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 3a256af92784..53c27c67cc11 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -138,10 +138,10 @@ static bool batadv_mutual_parents(const struct net_device *dev1,
  * @net_dev: the device to check
  *
  * If the user creates any virtual device on top of a batman-adv interface, it
- * is important to prevent this new interface to be used to create a new mesh
- * network (this behaviour would lead to a batman-over-batman configuration).
- * This function recursively checks all the fathers of the device passed as
- * argument looking for a batman-adv soft interface.
+ * is important to prevent this new interface from being used to create a new
+ * mesh network (this behaviour would lead to a batman-over-batman
+ * configuration). This function recursively checks all the fathers of the
+ * device passed as argument looking for a batman-adv soft interface.
  *
  * Return: true if the device is descendant of a batman-adv mesh interface (or
  * if it is a batman-adv interface itself), false otherwise
@@ -680,8 +680,8 @@ batadv_hardif_deactivate_interface(struct batadv_hard_iface *hard_iface)
  * @slave: the interface enslaved in another master
  * @master: the master from which slave has to be removed
  *
- * Invoke ndo_del_slave on master passing slave as argument. In this way slave
- * is free'd and master can correctly change its internal state.
+ * Invoke ndo_del_slave on master passing slave as argument. In this way the
+ * slave is free'd and the master can correctly change its internal state.
  *
  * Return: 0 on success, a negative value representing the error otherwise
  */
@@ -818,7 +818,7 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
  * @soft_iface: soft interface to check
  *
  * This function is only using RCU for locking - the result can therefore be
- * off when another functions is modifying the list at the same time. The
+ * off when another function is modifying the list at the same time. The
  * caller can use the rtnl_lock to make sure that the count is accurate.
  *
  * Return: number of connected/enslaved hard interfaces
diff --git a/net/batman-adv/log.h b/net/batman-adv/log.h
index f9884dc56cf3..979864c0fa6b 100644
--- a/net/batman-adv/log.h
+++ b/net/batman-adv/log.h
@@ -69,7 +69,7 @@ int batadv_debug_log(struct batadv_priv *bat_priv, const char *fmt, ...)
 __printf(2, 3);
 
 /**
- * _batadv_dbg() - Store debug output with(out) ratelimiting
+ * _batadv_dbg() - Store debug output with(out) rate limiting
  * @type: type of debug message
  * @bat_priv: the bat priv with all the soft interface information
  * @ratelimited: whether output should be rate limited
@@ -95,7 +95,7 @@ static inline void _batadv_dbg(int type __always_unused,
 #endif
 
 /**
- * batadv_dbg() - Store debug output without ratelimiting
+ * batadv_dbg() - Store debug output without rate limiting
  * @type: type of debug message
  * @bat_priv: the bat priv with all the soft interface information
  * @arg: format string and variable arguments
@@ -104,7 +104,7 @@ static inline void _batadv_dbg(int type __always_unused,
 	_batadv_dbg(type, bat_priv, 0, ## arg)
 
 /**
- * batadv_dbg_ratelimited() - Store debug output with ratelimiting
+ * batadv_dbg_ratelimited() - Store debug output with rate limiting
  * @type: type of debug message
  * @bat_priv: the bat priv with all the soft interface information
  * @arg: format string and variable arguments
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index d8a255c85e77..519c08c2cfba 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -666,7 +666,7 @@ unsigned short batadv_get_vid(struct sk_buff *skb, size_t header_len)
  * @vid: the VLAN identifier for which the AP isolation attributed as to be
  *  looked up
  *
- * Return: true if AP isolation is on for the VLAN idenfied by vid, false
+ * Return: true if AP isolation is on for the VLAN identified by vid, false
  * otherwise
  */
 bool batadv_vlan_ap_isola_get(struct batadv_priv *bat_priv, unsigned short vid)
diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 42b8d1e76dea..0393bb9ed3d0 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -308,7 +308,7 @@ static inline bool batadv_has_timed_out(unsigned long timestamp,
  * @y: value to compare @x against
  *
  * It handles overflows/underflows and can correctly check for a predecessor
- * unless the variable sequence number has grown by more then
+ * unless the variable sequence number has grown by more than
  * 2**(bitwidth(x)-1)-1.
  *
  * This means that for a u8 with the maximum value 255, it would think:
@@ -330,11 +330,11 @@ static inline bool batadv_has_timed_out(unsigned long timestamp,
 
 /**
  * batadv_seq_after() - Checks if a sequence number x is a successor of y
- * @x: potential sucessor of @y
+ * @x: potential successor of @y
  * @y: value to compare @x against
  *
  * It handles overflows/underflows and can correctly check for a successor
- * unless the variable sequence number has grown by more then
+ * unless the variable sequence number has grown by more than
  * 2**(bitwidth(x)-1)-1.
  *
  * This means that for a u8 with the maximum value 255, it would think:
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 9ebdc1e864b9..bdc4a1fba1c6 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -510,7 +510,7 @@ batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
  * the given mcast_list. In general, multicast listeners provided by
  * your multicast receiving applications run directly on this node.
  *
- * If there is a bridge interface on top of dev, collects from that one
+ * If there is a bridge interface on top of dev, collect from that one
  * instead. Just like with IP addresses and routes, multicast listeners
  * will(/should) register to the bridge interface instead of an
  * enslaved bat0.
@@ -832,8 +832,8 @@ batadv_mcast_bridge_log(struct batadv_priv *bat_priv,
  * @bat_priv: the bat priv with all the soft interface information
  * @flags: TVLV flags indicating the new multicast state
  *
- * Whenever the multicast TVLV flags this nodes announces change this notifies
- * userspace via the 'mcast' log level.
+ * Whenever the multicast TVLV flags this node announces change, this function
+ * should be used to notify userspace about the change.
  */
 static void batadv_mcast_flags_log(struct batadv_priv *bat_priv, u8 flags)
 {
@@ -1244,7 +1244,7 @@ batadv_mcast_forw_ipv6_node_get(struct batadv_priv *bat_priv)
  * @ethhdr: an ethernet header to determine the protocol family from
  *
  * Return: an orig_node which has the BATADV_MCAST_WANT_ALL_IPV4 or
- * BATADV_MCAST_WANT_ALL_IPV6 flag, depending on the provided ethhdr, set and
+ * BATADV_MCAST_WANT_ALL_IPV6 flag, depending on the provided ethhdr, sets and
  * increases its refcount.
  */
 static struct batadv_orig_node *
@@ -1693,7 +1693,7 @@ batadv_mcast_forw_want_rtr(struct batadv_priv *bat_priv,
 }
 
 /**
- * batadv_mcast_forw_send() - send packet to any detected multicast recpient
+ * batadv_mcast_forw_send() - send packet to any detected multicast recipient
  * @bat_priv: the bat priv with all the soft interface information
  * @skb: the multicast packet to transmit
  * @vid: the vlan identifier
@@ -1742,7 +1742,8 @@ int batadv_mcast_forw_send(struct batadv_priv *bat_priv, struct sk_buff *skb,
  * @mcast_flags: flags indicating the new multicast state
  *
  * If the BATADV_MCAST_WANT_ALL_UNSNOOPABLES flag of this originator,
- * orig, has toggled then this method updates counter and list accordingly.
+ * orig, has toggled then this method updates the counter and the list
+ * accordingly.
  *
  * Caller needs to hold orig->mcast_handler_lock.
  */
@@ -1787,7 +1788,7 @@ static void batadv_mcast_want_unsnoop_update(struct batadv_priv *bat_priv,
  * @mcast_flags: flags indicating the new multicast state
  *
  * If the BATADV_MCAST_WANT_ALL_IPV4 flag of this originator, orig, has
- * toggled then this method updates counter and list accordingly.
+ * toggled then this method updates the counter and the list accordingly.
  *
  * Caller needs to hold orig->mcast_handler_lock.
  */
@@ -1832,7 +1833,7 @@ static void batadv_mcast_want_ipv4_update(struct batadv_priv *bat_priv,
  * @mcast_flags: flags indicating the new multicast state
  *
  * If the BATADV_MCAST_WANT_ALL_IPV6 flag of this originator, orig, has
- * toggled then this method updates counter and list accordingly.
+ * toggled then this method updates the counter and the list accordingly.
  *
  * Caller needs to hold orig->mcast_handler_lock.
  */
@@ -1877,7 +1878,7 @@ static void batadv_mcast_want_ipv6_update(struct batadv_priv *bat_priv,
  * @mcast_flags: flags indicating the new multicast state
  *
  * If the BATADV_MCAST_WANT_NO_RTR4 flag of this originator, orig, has
- * toggled then this method updates counter and list accordingly.
+ * toggled then this method updates the counter and the list accordingly.
  *
  * Caller needs to hold orig->mcast_handler_lock.
  */
@@ -1922,7 +1923,7 @@ static void batadv_mcast_want_rtr4_update(struct batadv_priv *bat_priv,
  * @mcast_flags: flags indicating the new multicast state
  *
  * If the BATADV_MCAST_WANT_NO_RTR6 flag of this originator, orig, has
- * toggled then this method updates counter and list accordingly.
+ * toggled then this method updates the counter and the list accordingly.
  *
  * Caller needs to hold orig->mcast_handler_lock.
  */
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 02ed073f95a9..cfb00dfa468a 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -640,7 +640,7 @@ batadv_netlink_tp_meter_put(struct sk_buff *msg, u32 cookie)
  * @bat_priv: the bat priv with all the soft interface information
  * @dst: destination of tp_meter session
  * @result: reason for tp meter session stop
- * @test_time: total time ot the tp_meter session
+ * @test_time: total time of the tp_meter session
  * @total_bytes: bytes acked to the receiver
  * @cookie: cookie of tp_meter session
  *
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index b0469d15da0e..48d707850f3e 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -134,7 +134,7 @@ static void batadv_nc_tvlv_ogm_handler_v1(struct batadv_priv *bat_priv,
 }
 
 /**
- * batadv_nc_mesh_init() - initialise coding hash table and start house keeping
+ * batadv_nc_mesh_init() - initialise coding hash table and start housekeeping
  * @bat_priv: the bat priv with all the soft interface information
  *
  * Return: 0 on success or negative error number in case of failure
@@ -700,7 +700,7 @@ batadv_nc_process_nc_paths(struct batadv_priv *bat_priv,
 }
 
 /**
- * batadv_nc_worker() - periodic task for house keeping related to network
+ * batadv_nc_worker() - periodic task for housekeeping related to network
  *  coding
  * @work: kernel work struct
  */
@@ -1316,7 +1316,7 @@ batadv_nc_path_search(struct batadv_priv *bat_priv,
 }
 
 /**
- * batadv_nc_skb_src_search() - Loops through the list of neighoring nodes of
+ * batadv_nc_skb_src_search() - Loops through the list of neighboring nodes of
  *  the skb's sender (may be equal to the originator).
  * @bat_priv: the bat priv with all the soft interface information
  * @skb: data skb to forward
@@ -1402,10 +1402,10 @@ static void batadv_nc_skb_store_before_coding(struct batadv_priv *bat_priv,
  * @neigh_node: next hop to forward packet to
  * @ethhdr: pointer to the ethernet header inside the skb
  *
- * Loops through list of neighboring nodes the next hop has a good connection to
- * (receives OGMs with a sufficient quality). We need to find a neighbor of our
- * next hop that potentially sent a packet which our next hop also received
- * (overheard) and has stored for later decoding.
+ * Loops through the list of neighboring nodes the next hop has a good
+ * connection to (receives OGMs with a sufficient quality). We need to find a
+ * neighbor of our next hop that potentially sent a packet which our next hop
+ * also received (overheard) and has stored for later decoding.
  *
  * Return: true if the skb was consumed (encoded packet sent) or false otherwise
  */
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 5b0c2fffc214..805d8969bdfb 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -325,7 +325,7 @@ void batadv_neigh_node_put(struct batadv_neigh_node *neigh_node)
  * @if_outgoing: the interface where the payload packet has been received or
  *  the OGM should be sent to
  *
- * Return: the neighbor which should be router for this orig_node/iface.
+ * Return: the neighbor which should be the router for this orig_node/iface.
  *
  * The object is returned with refcounter increased by 1.
  */
@@ -515,7 +515,7 @@ batadv_neigh_ifinfo_new(struct batadv_neigh_node *neigh,
  * Looks for and possibly returns a neighbour belonging to this originator list
  * which is connected through the provided hard interface.
  *
- * Return: neighbor when found. Othwerwise NULL
+ * Return: neighbor when found. Otherwise NULL
  */
 static struct batadv_neigh_node *
 batadv_neigh_node_get(const struct batadv_orig_node *orig_node,
@@ -620,7 +620,7 @@ batadv_hardif_neigh_get_or_create(struct batadv_hard_iface *hard_iface,
  *
  * Looks for and possibly returns a neighbour belonging to this hard interface.
  *
- * Return: neighbor when found. Othwerwise NULL
+ * Return: neighbor when found. Otherwise NULL
  */
 struct batadv_hardif_neigh_node *
 batadv_hardif_neigh_get(const struct batadv_hard_iface *hard_iface,
@@ -999,7 +999,7 @@ void batadv_originator_free(struct batadv_priv *bat_priv)
  * @bat_priv: the bat priv with all the soft interface information
  * @addr: the mac address of the originator
  *
- * Creates a new originator object and initialise all the generic fields.
+ * Creates a new originator object and initialises all the generic fields.
  * The new object is not added to the originator list.
  *
  * Return: the newly created object or NULL on failure.
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index d343382e9664..27cdf5e4349a 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -449,7 +449,7 @@ int batadv_recv_icmp_packet(struct sk_buff *skb,
  * @skb: packet to check
  * @hdr_size: size of header to pull
  *
- * Check for short header and bad addresses in given packet.
+ * Checks for short header and bad addresses in the given packet.
  *
  * Return: negative value when check fails and 0 otherwise. The negative value
  * depends on the reason: -ENODATA for bad header, -EBADR for broadcast
@@ -1113,7 +1113,7 @@ int batadv_recv_unicast_tvlv(struct sk_buff *skb,
  * @recv_if: interface that the skb is received on
  *
  * This function does one of the three following things: 1) Forward fragment, if
- * the assembled packet will exceed our MTU; 2) Buffer fragment, if we till
+ * the assembled packet will exceed our MTU; 2) Buffer fragment, if we still
  * lack further fragments; 3) Merge fragments, if we have all needed parts.
  *
  * Return: NET_RX_DROP if the skb is not consumed, NET_RX_SUCCESS otherwise.
diff --git a/net/batman-adv/send.c b/net/batman-adv/send.c
index 7f8ade04e08e..d267b94800d6 100644
--- a/net/batman-adv/send.c
+++ b/net/batman-adv/send.c
@@ -605,8 +605,8 @@ bool batadv_forw_packet_steal(struct batadv_forw_packet *forw_packet,
  * given hard_iface. If hard_iface is NULL forwarding packets on all hard
  * interfaces will be claimed.
  *
- * The packets are being moved from the forw_list to the cleanup_list and
- * by that allows already running threads to notice the claiming.
+ * The packets are being moved from the forw_list to the cleanup_list. This
+ * makes it possible for already running threads to notice the claim.
  */
 static void
 batadv_forw_packet_list_steal(struct hlist_head *forw_list,
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index f1f1c86f3419..23833a0ba5e6 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -406,7 +406,7 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
  * @hdr_size: size of already parsed batman-adv header
  * @orig_node: originator from which the batman-adv packet was sent
  *
- * Sends a ethernet frame to the receive path of the local @soft_iface.
+ * Sends an ethernet frame to the receive path of the local @soft_iface.
  * skb->data has still point to the batman-adv header with the size @hdr_size.
  * The caller has to have parsed this header already and made sure that at least
  * @hdr_size bytes are still available for pull in @skb.
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index bd2ac570c42c..db7e3774825b 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -66,7 +66,7 @@
 
 /**
  * BATADV_TP_MAX_RTO - Maximum sender timeout. If the sender RTO gets beyond
- * such amound of milliseconds, the receiver is considered unreachable and the
+ * such amount of milliseconds, the receiver is considered unreachable and the
  * connection is killed
  */
 #define BATADV_TP_MAX_RTO 30000
@@ -108,10 +108,10 @@ static u32 batadv_tp_session_cookie(const u8 session[2], u8 icmp_uid)
  * batadv_tp_cwnd() - compute the new cwnd size
  * @base: base cwnd size value
  * @increment: the value to add to base to get the new size
- * @min: minumim cwnd value (usually MSS)
+ * @min: minimum cwnd value (usually MSS)
  *
- * Return the new cwnd size and ensures it does not exceed the Advertised
- * Receiver Window size. It is wrap around safe.
+ * Return the new cwnd size and ensure it does not exceed the Advertised
+ * Receiver Window size. It is wrapped around safely.
  * For details refer to Section 3.1 of RFC5681
  *
  * Return: new congestion window size in bytes
@@ -254,7 +254,7 @@ static void batadv_tp_batctl_error_notify(enum batadv_tp_meter_reason reason,
  * @dst: the other endpoint MAC address to look for
  *
  * Look for a tp_vars object matching dst as end_point and return it after
- * having incremented the refcounter. Return NULL is not found
+ * having increment the refcounter. Return NULL is not found
  *
  * Return: matching tp_vars or NULL when no tp_vars with @dst was found
  */
@@ -291,7 +291,7 @@ static struct batadv_tp_vars *batadv_tp_list_find(struct batadv_priv *bat_priv,
  * @session: session identifier
  *
  * Look for a tp_vars object matching dst as end_point, session as tp meter
- * session and return it after having incremented the refcounter. Return NULL
+ * session and return it after having increment the refcounter. Return NULL
  * is not found
  *
  * Return: matching tp_vars or NULL when no tp_vars was found
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index a9635c882fe0..98a0aaaf0d50 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -301,7 +301,7 @@ void batadv_tt_global_entry_put(struct batadv_tt_global_entry *tt_global_entry)
  * @vid: VLAN identifier
  *
  * Return: the number of originators advertising the given address/data
- * (excluding ourself).
+ * (excluding our self).
  */
 int batadv_tt_global_hash_count(struct batadv_priv *bat_priv,
 				const u8 *addr, unsigned short vid)
@@ -842,7 +842,7 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
  *  table. In case of success the value is updated with the real amount of
  *  reserved bytes
  * Allocate the needed amount of memory for the entire TT TVLV and write its
- * header made up by one tvlv_tt_data object and a series of tvlv_tt_vlan_data
+ * header made up of one tvlv_tt_data object and a series of tvlv_tt_vlan_data
  * objects, one per active VLAN served by the originator node.
  *
  * Return: the size of the allocated buffer or 0 in case of failure.
@@ -1674,7 +1674,7 @@ batadv_tt_global_orig_entry_add(struct batadv_tt_global_entry *tt_global,
  * the function argument.
  * If a TT local entry exists for this non-mesh client remove it.
  *
- * The caller must hold orig_node refcount.
+ * The caller must hold the orig_node refcount.
  *
  * Return: true if the new entry has been added, false otherwise
  */
@@ -1839,7 +1839,7 @@ static bool batadv_tt_global_add(struct batadv_priv *bat_priv,
  * @bat_priv: the bat priv with all the soft interface information
  * @tt_global_entry: global translation table entry to be analyzed
  *
- * This functon assumes the caller holds rcu_read_lock().
+ * This function assumes the caller holds rcu_read_lock().
  * Return: best originator list entry or NULL on errors.
  */
 static struct batadv_tt_orig_list_entry *
@@ -1887,7 +1887,7 @@ batadv_transtable_best_orig(struct batadv_priv *bat_priv,
  * @tt_global_entry: global translation table entry to be printed
  * @seq: debugfs table seq_file struct
  *
- * This functon assumes the caller holds rcu_read_lock().
+ * This function assumes the caller holds rcu_read_lock().
  */
 static void
 batadv_tt_global_print_entry(struct batadv_priv *bat_priv,
diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index 0963a43ad996..6a23a566cde1 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -353,8 +353,8 @@ u16 batadv_tvlv_container_ogm_append(struct batadv_priv *bat_priv,
  * @tvlv_value: tvlv content
  * @tvlv_value_len: tvlv content length
  *
- * Return: success if handler was not found or the return value of the handler
- * callback.
+ * Return: success if the handler was not found or the return value of the
+ * handler callback.
  */
 static int batadv_tvlv_call_handler(struct batadv_priv *bat_priv,
 				    struct batadv_tvlv_handler *tvlv_handler,
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index d152b8e81f61..cc151e1f23b2 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -455,8 +455,8 @@ struct batadv_orig_node {
 	spinlock_t tt_buff_lock;
 
 	/**
-	 * @tt_lock: prevents from updating the table while reading it. Table
-	 *  update is made up by two operations (data structure update and
+	 * @tt_lock: avoids concurrent read from and write to the table. Table
+	 *  update is made up of two operations (data structure update and
 	 *  metadata -CRC/TTVN-recalculation) and they have to be executed
 	 *  atomically in order to avoid another thread to read the
 	 *  table/metadata between those.
@@ -748,7 +748,7 @@ struct batadv_neigh_ifinfo {
  * struct batadv_bcast_duplist_entry - structure for LAN broadcast suppression
  */
 struct batadv_bcast_duplist_entry {
-	/** @orig: mac address of orig node orginating the broadcast */
+	/** @orig: mac address of orig node originating the broadcast */
 	u8 orig[ETH_ALEN];
 
 	/** @crc: crc32 checksum of broadcast payload */
@@ -1010,7 +1010,7 @@ struct batadv_priv_tt {
 
 	/**
 	 * @commit_lock: prevents from executing a local TT commit while reading
-	 *  the local table. The local TT commit is made up by two operations
+	 *  the local table. The local TT commit is made up of two operations
 	 *  (data structure update and metadata -CRC/TTVN- recalculation) and
 	 *  they have to be executed atomically in order to avoid another thread
 	 *  to read the table/metadata between those.
@@ -1024,7 +1024,7 @@ struct batadv_priv_tt {
 #ifdef CONFIG_BATMAN_ADV_BLA
 
 /**
- * struct batadv_priv_bla - per mesh interface bridge loope avoidance data
+ * struct batadv_priv_bla - per mesh interface bridge loop avoidance data
  */
 struct batadv_priv_bla {
 	/** @num_requests: number of bla requests in flight */
@@ -1718,7 +1718,7 @@ struct batadv_priv {
 	spinlock_t softif_vlan_list_lock;
 
 #ifdef CONFIG_BATMAN_ADV_BLA
-	/** @bla: bridge loope avoidance data */
+	/** @bla: bridge loop avoidance data */
 	struct batadv_priv_bla bla;
 #endif
 
-- 
2.20.1

