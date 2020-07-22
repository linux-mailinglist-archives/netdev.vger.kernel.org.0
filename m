Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59C922A203
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387496AbgGVWMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:12:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39130 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733156AbgGVWMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:12:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MM6NwC027312;
        Wed, 22 Jul 2020 15:12:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=Ssj4J4qySheODq3g8D9MIv3C9Zs4Q9sn3HtKtpEr3Pc=;
 b=OyyvejPfiz52NLhxS51C3ta+UCJWNxNrKUgRzDJ0XoheInoAp+A4MiAViZsRX8e4etb4
 6SC7NU763s4Ee3AEjwZm7UGCjN2n70Lubx2gk/W41gRrOdslMy2SFljpMNAXha9vAwg0
 J9INMhEcIt3IhRxYhqZOSpnaeUa1JXomW0heVMW/YqMK0WJIJf+tjDwZ17JzW8Zo1gDF
 CZELG3b83UXUaJv54/RK6Z/hEubw2XeICvDT60iYOoUCQQ4eCCYQVygbylMNP4PhJitn
 8D6LC8BZBs0kPxYfvN+qb/ty07P9mzWURFPsGSu+PXALGF9etMytIezvqK8zk5mrHmn2 Bg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxentxa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 15:12:35 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:12:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 15:12:34 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id E97F53F7040;
        Wed, 22 Jul 2020 15:12:27 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Doug Ledford" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 13/15] qede: reformat net_device_ops declarations
Date:   Thu, 23 Jul 2020 01:10:43 +0300
Message-ID: <20200722221045.5436-14-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722221045.5436-1-alobakin@marvell.com>
References: <20200722221045.5436-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_16:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct the indentation of net_device_ops declarations for fancier look.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 122 +++++++++----------
 1 file changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index b5a95f165520..92bcdfa27961 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -639,79 +639,79 @@ qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 }
 
 static const struct net_device_ops qede_netdev_ops = {
-	.ndo_open = qede_open,
-	.ndo_stop = qede_close,
-	.ndo_start_xmit = qede_start_xmit,
-	.ndo_select_queue = qede_select_queue,
-	.ndo_set_rx_mode = qede_set_rx_mode,
-	.ndo_set_mac_address = qede_set_mac_addr,
-	.ndo_validate_addr = eth_validate_addr,
-	.ndo_change_mtu = qede_change_mtu,
-	.ndo_do_ioctl = qede_ioctl,
-	.ndo_tx_timeout = qede_tx_timeout,
+	.ndo_open		= qede_open,
+	.ndo_stop		= qede_close,
+	.ndo_start_xmit		= qede_start_xmit,
+	.ndo_select_queue	= qede_select_queue,
+	.ndo_set_rx_mode	= qede_set_rx_mode,
+	.ndo_set_mac_address	= qede_set_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= qede_change_mtu,
+	.ndo_do_ioctl		= qede_ioctl,
+	.ndo_tx_timeout		= qede_tx_timeout,
 #ifdef CONFIG_QED_SRIOV
-	.ndo_set_vf_mac = qede_set_vf_mac,
-	.ndo_set_vf_vlan = qede_set_vf_vlan,
-	.ndo_set_vf_trust = qede_set_vf_trust,
+	.ndo_set_vf_mac		= qede_set_vf_mac,
+	.ndo_set_vf_vlan	= qede_set_vf_vlan,
+	.ndo_set_vf_trust	= qede_set_vf_trust,
 #endif
-	.ndo_vlan_rx_add_vid = qede_vlan_rx_add_vid,
-	.ndo_vlan_rx_kill_vid = qede_vlan_rx_kill_vid,
-	.ndo_fix_features = qede_fix_features,
-	.ndo_set_features = qede_set_features,
-	.ndo_get_stats64 = qede_get_stats64,
+	.ndo_vlan_rx_add_vid	= qede_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid	= qede_vlan_rx_kill_vid,
+	.ndo_fix_features	= qede_fix_features,
+	.ndo_set_features	= qede_set_features,
+	.ndo_get_stats64	= qede_get_stats64,
 #ifdef CONFIG_QED_SRIOV
-	.ndo_set_vf_link_state = qede_set_vf_link_state,
-	.ndo_set_vf_spoofchk = qede_set_vf_spoofchk,
-	.ndo_get_vf_config = qede_get_vf_config,
-	.ndo_set_vf_rate = qede_set_vf_rate,
+	.ndo_set_vf_link_state	= qede_set_vf_link_state,
+	.ndo_set_vf_spoofchk	= qede_set_vf_spoofchk,
+	.ndo_get_vf_config	= qede_get_vf_config,
+	.ndo_set_vf_rate	= qede_set_vf_rate,
 #endif
-	.ndo_udp_tunnel_add = udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del = udp_tunnel_nic_del_port,
-	.ndo_features_check = qede_features_check,
-	.ndo_bpf = qede_xdp,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
+	.ndo_features_check	= qede_features_check,
+	.ndo_bpf		= qede_xdp,
 #ifdef CONFIG_RFS_ACCEL
-	.ndo_rx_flow_steer = qede_rx_flow_steer,
+	.ndo_rx_flow_steer	= qede_rx_flow_steer,
 #endif
-	.ndo_setup_tc = qede_setup_tc_offload,
+	.ndo_setup_tc		= qede_setup_tc_offload,
 };
 
 static const struct net_device_ops qede_netdev_vf_ops = {
-	.ndo_open = qede_open,
-	.ndo_stop = qede_close,
-	.ndo_start_xmit = qede_start_xmit,
-	.ndo_select_queue = qede_select_queue,
-	.ndo_set_rx_mode = qede_set_rx_mode,
-	.ndo_set_mac_address = qede_set_mac_addr,
-	.ndo_validate_addr = eth_validate_addr,
-	.ndo_change_mtu = qede_change_mtu,
-	.ndo_vlan_rx_add_vid = qede_vlan_rx_add_vid,
-	.ndo_vlan_rx_kill_vid = qede_vlan_rx_kill_vid,
-	.ndo_fix_features = qede_fix_features,
-	.ndo_set_features = qede_set_features,
-	.ndo_get_stats64 = qede_get_stats64,
-	.ndo_udp_tunnel_add = udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del = udp_tunnel_nic_del_port,
-	.ndo_features_check = qede_features_check,
+	.ndo_open		= qede_open,
+	.ndo_stop		= qede_close,
+	.ndo_start_xmit		= qede_start_xmit,
+	.ndo_select_queue	= qede_select_queue,
+	.ndo_set_rx_mode	= qede_set_rx_mode,
+	.ndo_set_mac_address	= qede_set_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= qede_change_mtu,
+	.ndo_vlan_rx_add_vid	= qede_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid	= qede_vlan_rx_kill_vid,
+	.ndo_fix_features	= qede_fix_features,
+	.ndo_set_features	= qede_set_features,
+	.ndo_get_stats64	= qede_get_stats64,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
+	.ndo_features_check	= qede_features_check,
 };
 
 static const struct net_device_ops qede_netdev_vf_xdp_ops = {
-	.ndo_open = qede_open,
-	.ndo_stop = qede_close,
-	.ndo_start_xmit = qede_start_xmit,
-	.ndo_select_queue = qede_select_queue,
-	.ndo_set_rx_mode = qede_set_rx_mode,
-	.ndo_set_mac_address = qede_set_mac_addr,
-	.ndo_validate_addr = eth_validate_addr,
-	.ndo_change_mtu = qede_change_mtu,
-	.ndo_vlan_rx_add_vid = qede_vlan_rx_add_vid,
-	.ndo_vlan_rx_kill_vid = qede_vlan_rx_kill_vid,
-	.ndo_fix_features = qede_fix_features,
-	.ndo_set_features = qede_set_features,
-	.ndo_get_stats64 = qede_get_stats64,
-	.ndo_udp_tunnel_add = udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del = udp_tunnel_nic_del_port,
-	.ndo_features_check = qede_features_check,
-	.ndo_bpf = qede_xdp,
+	.ndo_open		= qede_open,
+	.ndo_stop		= qede_close,
+	.ndo_start_xmit		= qede_start_xmit,
+	.ndo_select_queue	= qede_select_queue,
+	.ndo_set_rx_mode	= qede_set_rx_mode,
+	.ndo_set_mac_address	= qede_set_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= qede_change_mtu,
+	.ndo_vlan_rx_add_vid	= qede_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid	= qede_vlan_rx_kill_vid,
+	.ndo_fix_features	= qede_fix_features,
+	.ndo_set_features	= qede_set_features,
+	.ndo_get_stats64	= qede_get_stats64,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
+	.ndo_features_check	= qede_features_check,
+	.ndo_bpf		= qede_xdp,
 };
 
 /* -------------------------------------------------------------------------
-- 
2.25.1

