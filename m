Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D8128D38
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388519AbfEWWdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:19070 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388585AbfEWWdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:37 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Richard Rodriguez <richard.rodriguez@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/15] ice: Format ethtool reported stats
Date:   Thu, 23 May 2019 15:33:35 -0700
Message-Id: <20190523223340.13449-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Rodriguez <richard.rodriguez@intel.com>

Fixes ethtool -S reported stats in ice driver to match
format and nomenclature of the ixgbe driver.

Signed-off-by: Richard Rodriguez <richard.rodriguez@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 108 +++++++++----------
 1 file changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 91e3c451c66c..1214325eb80b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -45,20 +45,20 @@ static int ice_q_stats_len(struct net_device *netdev)
 				 ICE_VSI_STATS_LEN + ice_q_stats_len(n))
 
 static const struct ice_stats ice_gstrings_vsi_stats[] = {
-	ICE_VSI_STAT("tx_unicast", eth_stats.tx_unicast),
 	ICE_VSI_STAT("rx_unicast", eth_stats.rx_unicast),
-	ICE_VSI_STAT("tx_multicast", eth_stats.tx_multicast),
+	ICE_VSI_STAT("tx_unicast", eth_stats.tx_unicast),
 	ICE_VSI_STAT("rx_multicast", eth_stats.rx_multicast),
-	ICE_VSI_STAT("tx_broadcast", eth_stats.tx_broadcast),
+	ICE_VSI_STAT("tx_multicast", eth_stats.tx_multicast),
 	ICE_VSI_STAT("rx_broadcast", eth_stats.rx_broadcast),
-	ICE_VSI_STAT("tx_bytes", eth_stats.tx_bytes),
+	ICE_VSI_STAT("tx_broadcast", eth_stats.tx_broadcast),
 	ICE_VSI_STAT("rx_bytes", eth_stats.rx_bytes),
-	ICE_VSI_STAT("rx_discards", eth_stats.rx_discards),
-	ICE_VSI_STAT("tx_errors", eth_stats.tx_errors),
-	ICE_VSI_STAT("tx_linearize", tx_linearize),
+	ICE_VSI_STAT("tx_bytes", eth_stats.tx_bytes),
+	ICE_VSI_STAT("rx_dropped", eth_stats.rx_discards),
 	ICE_VSI_STAT("rx_unknown_protocol", eth_stats.rx_unknown_protocol),
 	ICE_VSI_STAT("rx_alloc_fail", rx_buf_failed),
 	ICE_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
+	ICE_VSI_STAT("tx_errors", eth_stats.tx_errors),
+	ICE_VSI_STAT("tx_linearize", tx_linearize),
 };
 
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
@@ -71,45 +71,45 @@ static const struct ice_stats ice_gstrings_vsi_stats[] = {
  * is queried on the base PF netdev.
  */
 static const struct ice_stats ice_gstrings_pf_stats[] = {
-	ICE_PF_STAT("port.tx_bytes", stats.eth.tx_bytes),
-	ICE_PF_STAT("port.rx_bytes", stats.eth.rx_bytes),
-	ICE_PF_STAT("port.tx_unicast", stats.eth.tx_unicast),
-	ICE_PF_STAT("port.rx_unicast", stats.eth.rx_unicast),
-	ICE_PF_STAT("port.tx_multicast", stats.eth.tx_multicast),
-	ICE_PF_STAT("port.rx_multicast", stats.eth.rx_multicast),
-	ICE_PF_STAT("port.tx_broadcast", stats.eth.tx_broadcast),
-	ICE_PF_STAT("port.rx_broadcast", stats.eth.rx_broadcast),
-	ICE_PF_STAT("port.tx_errors", stats.eth.tx_errors),
-	ICE_PF_STAT("port.tx_size_64", stats.tx_size_64),
-	ICE_PF_STAT("port.rx_size_64", stats.rx_size_64),
-	ICE_PF_STAT("port.tx_size_127", stats.tx_size_127),
-	ICE_PF_STAT("port.rx_size_127", stats.rx_size_127),
-	ICE_PF_STAT("port.tx_size_255", stats.tx_size_255),
-	ICE_PF_STAT("port.rx_size_255", stats.rx_size_255),
-	ICE_PF_STAT("port.tx_size_511", stats.tx_size_511),
-	ICE_PF_STAT("port.rx_size_511", stats.rx_size_511),
-	ICE_PF_STAT("port.tx_size_1023", stats.tx_size_1023),
-	ICE_PF_STAT("port.rx_size_1023", stats.rx_size_1023),
-	ICE_PF_STAT("port.tx_size_1522", stats.tx_size_1522),
-	ICE_PF_STAT("port.rx_size_1522", stats.rx_size_1522),
-	ICE_PF_STAT("port.tx_size_big", stats.tx_size_big),
-	ICE_PF_STAT("port.rx_size_big", stats.rx_size_big),
-	ICE_PF_STAT("port.link_xon_tx", stats.link_xon_tx),
-	ICE_PF_STAT("port.link_xon_rx", stats.link_xon_rx),
-	ICE_PF_STAT("port.link_xoff_tx", stats.link_xoff_tx),
-	ICE_PF_STAT("port.link_xoff_rx", stats.link_xoff_rx),
-	ICE_PF_STAT("port.tx_dropped_link_down", stats.tx_dropped_link_down),
-	ICE_PF_STAT("port.rx_undersize", stats.rx_undersize),
-	ICE_PF_STAT("port.rx_fragments", stats.rx_fragments),
-	ICE_PF_STAT("port.rx_oversize", stats.rx_oversize),
-	ICE_PF_STAT("port.rx_jabber", stats.rx_jabber),
-	ICE_PF_STAT("port.rx_csum_bad", hw_csum_rx_error),
-	ICE_PF_STAT("port.rx_length_errors", stats.rx_len_errors),
-	ICE_PF_STAT("port.rx_dropped", stats.eth.rx_discards),
-	ICE_PF_STAT("port.rx_crc_errors", stats.crc_errors),
-	ICE_PF_STAT("port.illegal_bytes", stats.illegal_bytes),
-	ICE_PF_STAT("port.mac_local_faults", stats.mac_local_faults),
-	ICE_PF_STAT("port.mac_remote_faults", stats.mac_remote_faults),
+	ICE_PF_STAT("rx_bytes.nic", stats.eth.rx_bytes),
+	ICE_PF_STAT("tx_bytes.nic", stats.eth.tx_bytes),
+	ICE_PF_STAT("rx_unicast.nic", stats.eth.rx_unicast),
+	ICE_PF_STAT("tx_unicast.nic", stats.eth.tx_unicast),
+	ICE_PF_STAT("rx_multicast.nic", stats.eth.rx_multicast),
+	ICE_PF_STAT("tx_multicast.nic", stats.eth.tx_multicast),
+	ICE_PF_STAT("rx_broadcast.nic", stats.eth.rx_broadcast),
+	ICE_PF_STAT("tx_broadcast.nic", stats.eth.tx_broadcast),
+	ICE_PF_STAT("tx_errors.nic", stats.eth.tx_errors),
+	ICE_PF_STAT("rx_size_64.nic", stats.rx_size_64),
+	ICE_PF_STAT("tx_size_64.nic", stats.tx_size_64),
+	ICE_PF_STAT("rx_size_127.nic", stats.rx_size_127),
+	ICE_PF_STAT("tx_size_127.nic", stats.tx_size_127),
+	ICE_PF_STAT("rx_size_255.nic", stats.rx_size_255),
+	ICE_PF_STAT("tx_size_255.nic", stats.tx_size_255),
+	ICE_PF_STAT("rx_size_511.nic", stats.rx_size_511),
+	ICE_PF_STAT("tx_size_511.nic", stats.tx_size_511),
+	ICE_PF_STAT("rx_size_1023.nic", stats.rx_size_1023),
+	ICE_PF_STAT("tx_size_1023.nic", stats.tx_size_1023),
+	ICE_PF_STAT("rx_size_1522.nic", stats.rx_size_1522),
+	ICE_PF_STAT("tx_size_1522.nic", stats.tx_size_1522),
+	ICE_PF_STAT("rx_size_big.nic", stats.rx_size_big),
+	ICE_PF_STAT("tx_size_big.nic", stats.tx_size_big),
+	ICE_PF_STAT("link_xon_rx.nic", stats.link_xon_rx),
+	ICE_PF_STAT("link_xon_tx.nic", stats.link_xon_tx),
+	ICE_PF_STAT("link_xoff_rx.nic", stats.link_xoff_rx),
+	ICE_PF_STAT("link_xoff_tx.nic", stats.link_xoff_tx),
+	ICE_PF_STAT("tx_dropped_link_down.nic", stats.tx_dropped_link_down),
+	ICE_PF_STAT("rx_undersize.nic", stats.rx_undersize),
+	ICE_PF_STAT("rx_fragments.nic", stats.rx_fragments),
+	ICE_PF_STAT("rx_oversize.nic", stats.rx_oversize),
+	ICE_PF_STAT("rx_jabber.nic", stats.rx_jabber),
+	ICE_PF_STAT("rx_csum_bad.nic", hw_csum_rx_error),
+	ICE_PF_STAT("rx_length_errors.nic", stats.rx_len_errors),
+	ICE_PF_STAT("rx_dropped.nic", stats.eth.rx_discards),
+	ICE_PF_STAT("rx_crc_errors.nic", stats.crc_errors),
+	ICE_PF_STAT("illegal_bytes.nic", stats.illegal_bytes),
+	ICE_PF_STAT("mac_local_faults.nic", stats.mac_local_faults),
+	ICE_PF_STAT("mac_remote_faults.nic", stats.mac_remote_faults),
 };
 
 static const u32 ice_regs_dump_list[] = {
@@ -295,17 +295,17 @@ static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 
 		ice_for_each_alloc_txq(vsi, i) {
 			snprintf(p, ETH_GSTRING_LEN,
-				 "tx-queue-%u.tx_packets", i);
+				 "tx_queue_%u_packets", i);
 			p += ETH_GSTRING_LEN;
-			snprintf(p, ETH_GSTRING_LEN, "tx-queue-%u.tx_bytes", i);
+			snprintf(p, ETH_GSTRING_LEN, "tx_queue_%u_bytes", i);
 			p += ETH_GSTRING_LEN;
 		}
 
 		ice_for_each_alloc_rxq(vsi, i) {
 			snprintf(p, ETH_GSTRING_LEN,
-				 "rx-queue-%u.rx_packets", i);
+				 "rx_queue_%u_packets", i);
 			p += ETH_GSTRING_LEN;
-			snprintf(p, ETH_GSTRING_LEN, "rx-queue-%u.rx_bytes", i);
+			snprintf(p, ETH_GSTRING_LEN, "rx_queue_%u_bytes", i);
 			p += ETH_GSTRING_LEN;
 		}
 
@@ -320,18 +320,18 @@ static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 
 		for (i = 0; i < ICE_MAX_USER_PRIORITY; i++) {
 			snprintf(p, ETH_GSTRING_LEN,
-				 "port.tx-priority-%u-xon", i);
+				 "tx_priority_%u_xon.nic", i);
 			p += ETH_GSTRING_LEN;
 			snprintf(p, ETH_GSTRING_LEN,
-				 "port.tx-priority-%u-xoff", i);
+				 "tx_priority_%u_xoff.nic", i);
 			p += ETH_GSTRING_LEN;
 		}
 		for (i = 0; i < ICE_MAX_USER_PRIORITY; i++) {
 			snprintf(p, ETH_GSTRING_LEN,
-				 "port.rx-priority-%u-xon", i);
+				 "rx_priority_%u_xon.nic", i);
 			p += ETH_GSTRING_LEN;
 			snprintf(p, ETH_GSTRING_LEN,
-				 "port.rx-priority-%u-xoff", i);
+				 "rx_priority_%u_xoff.nic", i);
 			p += ETH_GSTRING_LEN;
 		}
 		break;
-- 
2.21.0

