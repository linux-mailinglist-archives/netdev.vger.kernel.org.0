Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292C016B573
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgBXX16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:27:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2756 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727957AbgBXX16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:27:58 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ONRh2c031525
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 15:27:56 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ycbpnuw3k-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 15:27:56 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 24 Feb 2020 15:27:52 -0800
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 2D69A15F14D55; Mon, 24 Feb 2020 15:27:49 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <davidm@devvm1828.vll1.facebook.com>, <netdev@vger.kernel.org>,
        <michael.chan@broadcom.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH] bnxt_en: add newline to netdev_*() format strings
Date:   Mon, 24 Feb 2020 15:27:49 -0800
Message-ID: <20200224232749.2307582-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_12:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 clxscore=1034 impostorscore=0 malwarescore=0 suspectscore=2
 lowpriorityscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002240175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing newlines to netdev_* format strings so the lines
aren't buffered by the printk subsystem.

Nitpicked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  4 +-
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 10 ++--
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  | 48 +++++++++----------
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 10 ++--
 5 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fd6e0e48cd51..f9a8151f092c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11252,7 +11252,7 @@ static void bnxt_cfg_ntp_filters(struct bnxt *bp)
 		}
 	}
 	if (test_and_clear_bit(BNXT_HWRM_PF_UNLOAD_SP_EVENT, &bp->sp_event))
-		netdev_info(bp->dev, "Receive PF driver unload event!");
+		netdev_info(bp->dev, "Receive PF driver unload event!\n");
 }
 
 #else
@@ -11759,7 +11759,7 @@ static int bnxt_pcie_dsn_get(struct bnxt *bp, u8 dsn[])
 	u32 dw;
 
 	if (!pos) {
-		netdev_info(bp->dev, "Unable do read adapter's DSN");
+		netdev_info(bp->dev, "Unable do read adapter's DSN\n");
 		return -EOPNOTSUPP;
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index eec0168330b7..d3c93ccee86a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -641,14 +641,14 @@ static int bnxt_dl_params_register(struct bnxt *bp)
 	rc = devlink_params_register(bp->dl, bnxt_dl_params,
 				     ARRAY_SIZE(bnxt_dl_params));
 	if (rc) {
-		netdev_warn(bp->dev, "devlink_params_register failed. rc=%d",
+		netdev_warn(bp->dev, "devlink_params_register failed. rc=%d\n",
 			    rc);
 		return rc;
 	}
 	rc = devlink_port_params_register(&bp->dl_port, bnxt_dl_port_params,
 					  ARRAY_SIZE(bnxt_dl_port_params));
 	if (rc) {
-		netdev_err(bp->dev, "devlink_port_params_register failed");
+		netdev_err(bp->dev, "devlink_port_params_register failed\n");
 		devlink_params_unregister(bp->dl, bnxt_dl_params,
 					  ARRAY_SIZE(bnxt_dl_params));
 		return rc;
@@ -679,7 +679,7 @@ int bnxt_dl_register(struct bnxt *bp)
 	else
 		dl = devlink_alloc(&bnxt_vf_dl_ops, sizeof(struct bnxt_dl));
 	if (!dl) {
-		netdev_warn(bp->dev, "devlink_alloc failed");
+		netdev_warn(bp->dev, "devlink_alloc failed\n");
 		return -ENOMEM;
 	}
 
@@ -692,7 +692,7 @@ int bnxt_dl_register(struct bnxt *bp)
 
 	rc = devlink_register(dl, &bp->pdev->dev);
 	if (rc) {
-		netdev_warn(bp->dev, "devlink_register failed. rc=%d", rc);
+		netdev_warn(bp->dev, "devlink_register failed. rc=%d\n", rc);
 		goto err_dl_free;
 	}
 
@@ -704,7 +704,7 @@ int bnxt_dl_register(struct bnxt *bp)
 			       sizeof(bp->dsn));
 	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
 	if (rc) {
-		netdev_err(bp->dev, "devlink_port_register failed");
+		netdev_err(bp->dev, "devlink_port_register failed\n");
 		goto err_dl_unreg;
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6171fa8b3677..e8fc1671c581 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2028,7 +2028,7 @@ int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
 	}
 
 	if (fw->size > item_len) {
-		netdev_err(dev, "PKG insufficient update area in nvram: %lu",
+		netdev_err(dev, "PKG insufficient update area in nvram: %lu\n",
 			   (unsigned long)fw->size);
 		rc = -EFBIG;
 	} else {
@@ -3338,7 +3338,7 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 	kfree(coredump.data);
 	*dump_len += sizeof(struct bnxt_coredump_record);
 	if (rc == -ENOBUFS)
-		netdev_err(bp->dev, "Firmware returned large coredump buffer");
+		netdev_err(bp->dev, "Firmware returned large coredump buffer\n");
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 0cc6ec51f45f..9bec256b0934 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -50,7 +50,7 @@ static u16 bnxt_flow_get_dst_fid(struct bnxt *pf_bp, struct net_device *dev)
 
 	/* check if dev belongs to the same switch */
 	if (!netdev_port_same_parent_id(pf_bp->dev, dev)) {
-		netdev_info(pf_bp->dev, "dev(ifindex=%d) not on same switch",
+		netdev_info(pf_bp->dev, "dev(ifindex=%d) not on same switch\n",
 			    dev->ifindex);
 		return BNXT_FID_INVALID;
 	}
@@ -70,7 +70,7 @@ static int bnxt_tc_parse_redir(struct bnxt *bp,
 	struct net_device *dev = act->dev;
 
 	if (!dev) {
-		netdev_info(bp->dev, "no dev in mirred action");
+		netdev_info(bp->dev, "no dev in mirred action\n");
 		return -EINVAL;
 	}
 
@@ -106,7 +106,7 @@ static int bnxt_tc_parse_tunnel_set(struct bnxt *bp,
 	const struct ip_tunnel_key *tun_key = &tun_info->key;
 
 	if (ip_tunnel_info_af(tun_info) != AF_INET) {
-		netdev_info(bp->dev, "only IPv4 tunnel-encap is supported");
+		netdev_info(bp->dev, "only IPv4 tunnel-encap is supported\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -295,7 +295,7 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
 	int i, rc;
 
 	if (!flow_action_has_entries(flow_action)) {
-		netdev_info(bp->dev, "no actions");
+		netdev_info(bp->dev, "no actions\n");
 		return -EINVAL;
 	}
 
@@ -370,7 +370,7 @@ static int bnxt_tc_parse_flow(struct bnxt *bp,
 	/* KEY_CONTROL and KEY_BASIC are needed for forming a meaningful key */
 	if ((dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL)) == 0 ||
 	    (dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_BASIC)) == 0) {
-		netdev_info(bp->dev, "cannot form TC key: used_keys = 0x%x",
+		netdev_info(bp->dev, "cannot form TC key: used_keys = 0x%x\n",
 			    dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
@@ -508,7 +508,7 @@ static int bnxt_hwrm_cfa_flow_free(struct bnxt *bp,
 
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
-		netdev_info(bp->dev, "%s: Error rc=%d", __func__, rc);
+		netdev_info(bp->dev, "%s: Error rc=%d\n", __func__, rc);
 
 	return rc;
 }
@@ -841,7 +841,7 @@ static int hwrm_cfa_decap_filter_alloc(struct bnxt *bp,
 		resp = bnxt_get_hwrm_resp_addr(bp, &req);
 		*decap_filter_handle = resp->decap_filter_id;
 	} else {
-		netdev_info(bp->dev, "%s: Error rc=%d", __func__, rc);
+		netdev_info(bp->dev, "%s: Error rc=%d\n", __func__, rc);
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 
@@ -859,7 +859,7 @@ static int hwrm_cfa_decap_filter_free(struct bnxt *bp,
 
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
-		netdev_info(bp->dev, "%s: Error rc=%d", __func__, rc);
+		netdev_info(bp->dev, "%s: Error rc=%d\n", __func__, rc);
 
 	return rc;
 }
@@ -906,7 +906,7 @@ static int hwrm_cfa_encap_record_alloc(struct bnxt *bp,
 		resp = bnxt_get_hwrm_resp_addr(bp, &req);
 		*encap_record_handle = resp->encap_record_id;
 	} else {
-		netdev_info(bp->dev, "%s: Error rc=%d", __func__, rc);
+		netdev_info(bp->dev, "%s: Error rc=%d\n", __func__, rc);
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 
@@ -924,7 +924,7 @@ static int hwrm_cfa_encap_record_free(struct bnxt *bp,
 
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
-		netdev_info(bp->dev, "%s: Error rc=%d", __func__, rc);
+		netdev_info(bp->dev, "%s: Error rc=%d\n", __func__, rc);
 
 	return rc;
 }
@@ -943,7 +943,7 @@ static int bnxt_tc_put_l2_node(struct bnxt *bp,
 					     tc_info->l2_ht_params);
 		if (rc)
 			netdev_err(bp->dev,
-				   "Error: %s: rhashtable_remove_fast: %d",
+				   "Error: %s: rhashtable_remove_fast: %d\n",
 				   __func__, rc);
 		kfree_rcu(l2_node, rcu);
 	}
@@ -972,7 +972,7 @@ bnxt_tc_get_l2_node(struct bnxt *bp, struct rhashtable *l2_table,
 		if (rc) {
 			kfree_rcu(l2_node, rcu);
 			netdev_err(bp->dev,
-				   "Error: %s: rhashtable_insert_fast: %d",
+				   "Error: %s: rhashtable_insert_fast: %d\n",
 				   __func__, rc);
 			return NULL;
 		}
@@ -1031,7 +1031,7 @@ static bool bnxt_tc_can_offload(struct bnxt *bp, struct bnxt_tc_flow *flow)
 	if ((flow->flags & BNXT_TC_FLOW_FLAGS_PORTS) &&
 	    (flow->l4_key.ip_proto != IPPROTO_TCP &&
 	     flow->l4_key.ip_proto != IPPROTO_UDP)) {
-		netdev_info(bp->dev, "Cannot offload non-TCP/UDP (%d) ports",
+		netdev_info(bp->dev, "Cannot offload non-TCP/UDP (%d) ports\n",
 			    flow->l4_key.ip_proto);
 		return false;
 	}
@@ -1088,7 +1088,7 @@ static int bnxt_tc_put_tunnel_node(struct bnxt *bp,
 		rc =  rhashtable_remove_fast(tunnel_table, &tunnel_node->node,
 					     *ht_params);
 		if (rc) {
-			netdev_err(bp->dev, "rhashtable_remove_fast rc=%d", rc);
+			netdev_err(bp->dev, "rhashtable_remove_fast rc=%d\n", rc);
 			rc = -1;
 		}
 		kfree_rcu(tunnel_node, rcu);
@@ -1129,7 +1129,7 @@ bnxt_tc_get_tunnel_node(struct bnxt *bp, struct rhashtable *tunnel_table,
 	tunnel_node->refcount++;
 	return tunnel_node;
 err:
-	netdev_info(bp->dev, "error rc=%d", rc);
+	netdev_info(bp->dev, "error rc=%d\n", rc);
 	return NULL;
 }
 
@@ -1187,7 +1187,7 @@ static void bnxt_tc_put_decap_l2_node(struct bnxt *bp,
 					     &decap_l2_node->node,
 					     tc_info->decap_l2_ht_params);
 		if (rc)
-			netdev_err(bp->dev, "rhashtable_remove_fast rc=%d", rc);
+			netdev_err(bp->dev, "rhashtable_remove_fast rc=%d\n", rc);
 		kfree_rcu(decap_l2_node, rcu);
 	}
 }
@@ -1227,7 +1227,7 @@ static int bnxt_tc_resolve_tunnel_hdrs(struct bnxt *bp,
 
 	rt = ip_route_output_key(dev_net(real_dst_dev), &flow);
 	if (IS_ERR(rt)) {
-		netdev_info(bp->dev, "no route to %pI4b", &flow.daddr);
+		netdev_info(bp->dev, "no route to %pI4b\n", &flow.daddr);
 		return -EOPNOTSUPP;
 	}
 
@@ -1241,7 +1241,7 @@ static int bnxt_tc_resolve_tunnel_hdrs(struct bnxt *bp,
 
 		if (vlan->real_dev != real_dst_dev) {
 			netdev_info(bp->dev,
-				    "dst_dev(%s) doesn't use PF-if(%s)",
+				    "dst_dev(%s) doesn't use PF-if(%s)\n",
 				    netdev_name(dst_dev),
 				    netdev_name(real_dst_dev));
 			rc = -EOPNOTSUPP;
@@ -1253,7 +1253,7 @@ static int bnxt_tc_resolve_tunnel_hdrs(struct bnxt *bp,
 #endif
 	} else if (dst_dev != real_dst_dev) {
 		netdev_info(bp->dev,
-			    "dst_dev(%s) for %pI4b is not PF-if(%s)",
+			    "dst_dev(%s) for %pI4b is not PF-if(%s)\n",
 			    netdev_name(dst_dev), &flow.daddr,
 			    netdev_name(real_dst_dev));
 		rc = -EOPNOTSUPP;
@@ -1262,7 +1262,7 @@ static int bnxt_tc_resolve_tunnel_hdrs(struct bnxt *bp,
 
 	nbr = dst_neigh_lookup(&rt->dst, &flow.daddr);
 	if (!nbr) {
-		netdev_info(bp->dev, "can't lookup neighbor for %pI4b",
+		netdev_info(bp->dev, "can't lookup neighbor for %pI4b\n",
 			    &flow.daddr);
 		rc = -EOPNOTSUPP;
 		goto put_rt;
@@ -1472,7 +1472,7 @@ static int __bnxt_tc_del_flow(struct bnxt *bp,
 	rc = rhashtable_remove_fast(&tc_info->flow_table, &flow_node->node,
 				    tc_info->flow_ht_params);
 	if (rc)
-		netdev_err(bp->dev, "Error: %s: rhashtable_remove_fast rc=%d",
+		netdev_err(bp->dev, "Error: %s: rhashtable_remove_fast rc=%d\n",
 			   __func__, rc);
 
 	kfree_rcu(flow_node, rcu);
@@ -1587,7 +1587,7 @@ static int bnxt_tc_add_flow(struct bnxt *bp, u16 src_fid,
 free_node:
 	kfree_rcu(new_node, rcu);
 done:
-	netdev_err(bp->dev, "Error: %s: cookie=0x%lx error=%d",
+	netdev_err(bp->dev, "Error: %s: cookie=0x%lx error=%d\n",
 		   __func__, tc_flow_cmd->cookie, rc);
 	return rc;
 }
@@ -1700,7 +1700,7 @@ bnxt_hwrm_cfa_flow_stats_get(struct bnxt *bp, int num_flows,
 						le64_to_cpu(resp_bytes[i]);
 		}
 	} else {
-		netdev_info(bp->dev, "error rc=%d", rc);
+		netdev_info(bp->dev, "error rc=%d\n", rc);
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 
@@ -1970,7 +1970,7 @@ static int bnxt_tc_indr_block_event(struct notifier_block *nb,
 						   bp);
 		if (rc)
 			netdev_info(bp->dev,
-				    "Failed to register indirect blk: dev: %s",
+				    "Failed to register indirect blk: dev: %s\n",
 				    netdev->name);
 		break;
 	case NETDEV_UNREGISTER:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index b010b34cdaf8..6f2faf81c1ae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -43,7 +43,7 @@ static int hwrm_cfa_vfr_alloc(struct bnxt *bp, u16 vf_idx,
 		netdev_dbg(bp->dev, "tx_cfa_action=0x%x, rx_cfa_code=0x%x",
 			   *tx_cfa_action, *rx_cfa_code);
 	} else {
-		netdev_info(bp->dev, "%s error rc=%d", __func__, rc);
+		netdev_info(bp->dev, "%s error rc=%d\n", __func__, rc);
 	}
 
 	mutex_unlock(&bp->hwrm_cmd_lock);
@@ -60,7 +60,7 @@ static int hwrm_cfa_vfr_free(struct bnxt *bp, u16 vf_idx)
 
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
-		netdev_info(bp->dev, "%s error rc=%d", __func__, rc);
+		netdev_info(bp->dev, "%s error rc=%d\n", __func__, rc);
 	return rc;
 }
 
@@ -465,7 +465,7 @@ static int bnxt_vf_reps_create(struct bnxt *bp)
 	return 0;
 
 err:
-	netdev_info(bp->dev, "%s error=%d", __func__, rc);
+	netdev_info(bp->dev, "%s error=%d\n", __func__, rc);
 	kfree(cfa_code_map);
 	__bnxt_vf_reps_destroy(bp);
 	return rc;
@@ -488,7 +488,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 
 	mutex_lock(&bp->sriov_lock);
 	if (bp->eswitch_mode == mode) {
-		netdev_info(bp->dev, "already in %s eswitch mode",
+		netdev_info(bp->dev, "already in %s eswitch mode\n",
 			    mode == DEVLINK_ESWITCH_MODE_LEGACY ?
 			    "legacy" : "switchdev");
 		rc = -EINVAL;
@@ -508,7 +508,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		}
 
 		if (pci_num_vf(bp->pdev) == 0) {
-			netdev_info(bp->dev, "Enable VFs before setting switchdev mode");
+			netdev_info(bp->dev, "Enable VFs before setting switchdev mode\n");
 			rc = -EPERM;
 			goto done;
 		}
-- 
2.17.1

