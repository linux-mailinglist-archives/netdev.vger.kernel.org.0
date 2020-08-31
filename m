Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF3425807C
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgHaSMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:12:53 -0400
Received: from inva021.nxp.com ([92.121.34.21]:39708 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbgHaSMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 14:12:51 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 31AF92008E6;
        Mon, 31 Aug 2020 20:12:48 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 24A2320062B;
        Mon, 31 Aug 2020 20:12:48 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EC7BC20304;
        Mon, 31 Aug 2020 20:12:47 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/3] dpaa2-eth: add a dpaa2_eth_ prefix to all functions in dpaa2-ethtool.c
Date:   Mon, 31 Aug 2020 21:12:38 +0300
Message-Id: <20200831181240.21527-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831181240.21527-1-ioana.ciornei@nxp.com>
References: <20200831181240.21527-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some static functions in the dpaa2-eth driver don't have the dpaa2_eth_
prefix and this is becoming an inconvenience when looking at, for
example, a perf top output and trying to determine easily which entries
are dpaa2-eth related. Ammend this by adding the prefix to all the
functions.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 89 ++++++++++---------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 8356f1fbbee1..26bd99b76765 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -316,8 +316,8 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 		dpaa2_mac_get_ethtool_stats(priv->mac, data + i);
 }
 
-static int prep_eth_rule(struct ethhdr *eth_value, struct ethhdr *eth_mask,
-			 void *key, void *mask, u64 *fields)
+static int dpaa2_eth_prep_eth_rule(struct ethhdr *eth_value, struct ethhdr *eth_mask,
+				   void *key, void *mask, u64 *fields)
 {
 	int off;
 
@@ -345,9 +345,9 @@ static int prep_eth_rule(struct ethhdr *eth_value, struct ethhdr *eth_mask,
 	return 0;
 }
 
-static int prep_uip_rule(struct ethtool_usrip4_spec *uip_value,
-			 struct ethtool_usrip4_spec *uip_mask,
-			 void *key, void *mask, u64 *fields)
+static int dpaa2_eth_prep_uip_rule(struct ethtool_usrip4_spec *uip_value,
+				   struct ethtool_usrip4_spec *uip_mask,
+				   void *key, void *mask, u64 *fields)
 {
 	int off;
 	u32 tmp_value, tmp_mask;
@@ -400,9 +400,9 @@ static int prep_uip_rule(struct ethtool_usrip4_spec *uip_value,
 	return 0;
 }
 
-static int prep_l4_rule(struct ethtool_tcpip4_spec *l4_value,
-			struct ethtool_tcpip4_spec *l4_mask,
-			void *key, void *mask, u8 l4_proto, u64 *fields)
+static int dpaa2_eth_prep_l4_rule(struct ethtool_tcpip4_spec *l4_value,
+				  struct ethtool_tcpip4_spec *l4_mask,
+				  void *key, void *mask, u8 l4_proto, u64 *fields)
 {
 	int off;
 
@@ -451,9 +451,9 @@ static int prep_l4_rule(struct ethtool_tcpip4_spec *l4_value,
 	return 0;
 }
 
-static int prep_ext_rule(struct ethtool_flow_ext *ext_value,
-			 struct ethtool_flow_ext *ext_mask,
-			 void *key, void *mask, u64 *fields)
+static int dpaa2_eth_prep_ext_rule(struct ethtool_flow_ext *ext_value,
+				   struct ethtool_flow_ext *ext_mask,
+				   void *key, void *mask, u64 *fields)
 {
 	int off;
 
@@ -470,9 +470,9 @@ static int prep_ext_rule(struct ethtool_flow_ext *ext_value,
 	return 0;
 }
 
-static int prep_mac_ext_rule(struct ethtool_flow_ext *ext_value,
-			     struct ethtool_flow_ext *ext_mask,
-			     void *key, void *mask, u64 *fields)
+static int dpaa2_eth_prep_mac_ext_rule(struct ethtool_flow_ext *ext_value,
+				       struct ethtool_flow_ext *ext_mask,
+				       void *key, void *mask, u64 *fields)
 {
 	int off;
 
@@ -486,32 +486,32 @@ static int prep_mac_ext_rule(struct ethtool_flow_ext *ext_value,
 	return 0;
 }
 
-static int prep_cls_rule(struct ethtool_rx_flow_spec *fs, void *key, void *mask,
-			 u64 *fields)
+static int dpaa2_eth_prep_cls_rule(struct ethtool_rx_flow_spec *fs, void *key,
+				   void *mask, u64 *fields)
 {
 	int err;
 
 	switch (fs->flow_type & 0xFF) {
 	case ETHER_FLOW:
-		err = prep_eth_rule(&fs->h_u.ether_spec, &fs->m_u.ether_spec,
-				    key, mask, fields);
+		err = dpaa2_eth_prep_eth_rule(&fs->h_u.ether_spec, &fs->m_u.ether_spec,
+					      key, mask, fields);
 		break;
 	case IP_USER_FLOW:
-		err = prep_uip_rule(&fs->h_u.usr_ip4_spec,
-				    &fs->m_u.usr_ip4_spec, key, mask, fields);
+		err = dpaa2_eth_prep_uip_rule(&fs->h_u.usr_ip4_spec,
+					      &fs->m_u.usr_ip4_spec, key, mask, fields);
 		break;
 	case TCP_V4_FLOW:
-		err = prep_l4_rule(&fs->h_u.tcp_ip4_spec, &fs->m_u.tcp_ip4_spec,
-				   key, mask, IPPROTO_TCP, fields);
+		err = dpaa2_eth_prep_l4_rule(&fs->h_u.tcp_ip4_spec, &fs->m_u.tcp_ip4_spec,
+					     key, mask, IPPROTO_TCP, fields);
 		break;
 	case UDP_V4_FLOW:
-		err = prep_l4_rule(&fs->h_u.udp_ip4_spec, &fs->m_u.udp_ip4_spec,
-				   key, mask, IPPROTO_UDP, fields);
+		err = dpaa2_eth_prep_l4_rule(&fs->h_u.udp_ip4_spec, &fs->m_u.udp_ip4_spec,
+					     key, mask, IPPROTO_UDP, fields);
 		break;
 	case SCTP_V4_FLOW:
-		err = prep_l4_rule(&fs->h_u.sctp_ip4_spec,
-				   &fs->m_u.sctp_ip4_spec, key, mask,
-				   IPPROTO_SCTP, fields);
+		err = dpaa2_eth_prep_l4_rule(&fs->h_u.sctp_ip4_spec,
+					     &fs->m_u.sctp_ip4_spec, key, mask,
+					     IPPROTO_SCTP, fields);
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -521,14 +521,14 @@ static int prep_cls_rule(struct ethtool_rx_flow_spec *fs, void *key, void *mask,
 		return err;
 
 	if (fs->flow_type & FLOW_EXT) {
-		err = prep_ext_rule(&fs->h_ext, &fs->m_ext, key, mask, fields);
+		err = dpaa2_eth_prep_ext_rule(&fs->h_ext, &fs->m_ext, key, mask, fields);
 		if (err)
 			return err;
 	}
 
 	if (fs->flow_type & FLOW_MAC_EXT) {
-		err = prep_mac_ext_rule(&fs->h_ext, &fs->m_ext, key, mask,
-					fields);
+		err = dpaa2_eth_prep_mac_ext_rule(&fs->h_ext, &fs->m_ext, key,
+						  mask, fields);
 		if (err)
 			return err;
 	}
@@ -536,9 +536,9 @@ static int prep_cls_rule(struct ethtool_rx_flow_spec *fs, void *key, void *mask,
 	return 0;
 }
 
-static int do_cls_rule(struct net_device *net_dev,
-		       struct ethtool_rx_flow_spec *fs,
-		       bool add)
+static int dpaa2_eth_do_cls_rule(struct net_device *net_dev,
+				 struct ethtool_rx_flow_spec *fs,
+				 bool add)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct device *dev = net_dev->dev.parent;
@@ -561,7 +561,7 @@ static int do_cls_rule(struct net_device *net_dev,
 		return -ENOMEM;
 
 	/* Fill the key and mask memory areas */
-	err = prep_cls_rule(fs, key_buf, key_buf + rule_cfg.key_size, &fields);
+	err = dpaa2_eth_prep_cls_rule(fs, key_buf, key_buf + rule_cfg.key_size, &fields);
 	if (err)
 		goto free_mem;
 
@@ -629,7 +629,7 @@ static int do_cls_rule(struct net_device *net_dev,
 	return err;
 }
 
-static int num_rules(struct dpaa2_eth_priv *priv)
+static int dpaa2_eth_num_cls_rules(struct dpaa2_eth_priv *priv)
 {
 	int i, rules = 0;
 
@@ -640,9 +640,9 @@ static int num_rules(struct dpaa2_eth_priv *priv)
 	return rules;
 }
 
-static int update_cls_rule(struct net_device *net_dev,
-			   struct ethtool_rx_flow_spec *new_fs,
-			   unsigned int location)
+static int dpaa2_eth_update_cls_rule(struct net_device *net_dev,
+				     struct ethtool_rx_flow_spec *new_fs,
+				     unsigned int location)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct dpaa2_eth_cls_rule *rule;
@@ -658,13 +658,14 @@ static int update_cls_rule(struct net_device *net_dev,
 
 	/* If a rule is present at the specified location, delete it. */
 	if (rule->in_use) {
-		err = do_cls_rule(net_dev, &rule->fs, false);
+		err = dpaa2_eth_do_cls_rule(net_dev, &rule->fs, false);
 		if (err)
 			return err;
 
 		rule->in_use = 0;
 
-		if (!dpaa2_eth_fs_mask_enabled(priv) && !num_rules(priv))
+		if (!dpaa2_eth_fs_mask_enabled(priv) &&
+		    !dpaa2_eth_num_cls_rules(priv))
 			priv->rx_cls_fields = 0;
 	}
 
@@ -672,7 +673,7 @@ static int update_cls_rule(struct net_device *net_dev,
 	if (!new_fs)
 		return err;
 
-	err = do_cls_rule(net_dev, new_fs, true);
+	err = dpaa2_eth_do_cls_rule(net_dev, new_fs, true);
 	if (err)
 		return err;
 
@@ -702,7 +703,7 @@ static int dpaa2_eth_get_rxnfc(struct net_device *net_dev,
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
 		rxnfc->rule_cnt = 0;
-		rxnfc->rule_cnt = num_rules(priv);
+		rxnfc->rule_cnt = dpaa2_eth_num_cls_rules(priv);
 		rxnfc->data = max_rules;
 		break;
 	case ETHTOOL_GRXCLSRULE:
@@ -744,10 +745,10 @@ static int dpaa2_eth_set_rxnfc(struct net_device *net_dev,
 		err = dpaa2_eth_set_hash(net_dev, rxnfc->data);
 		break;
 	case ETHTOOL_SRXCLSRLINS:
-		err = update_cls_rule(net_dev, &rxnfc->fs, rxnfc->fs.location);
+		err = dpaa2_eth_update_cls_rule(net_dev, &rxnfc->fs, rxnfc->fs.location);
 		break;
 	case ETHTOOL_SRXCLSRLDEL:
-		err = update_cls_rule(net_dev, NULL, rxnfc->fs.location);
+		err = dpaa2_eth_update_cls_rule(net_dev, NULL, rxnfc->fs.location);
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
2.25.1

