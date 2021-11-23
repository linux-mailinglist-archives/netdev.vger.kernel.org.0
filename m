Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8785345A8B9
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhKWQo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:44:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:26573 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235906AbhKWQor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:44:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="215086308"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="215086308"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="538312883"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2021 08:41:22 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wi016784;
        Tue, 23 Nov 2021 16:41:19 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 net-next 06/26] mvneta: reformat mvneta_netdev_ops
Date:   Tue, 23 Nov 2021 17:39:35 +0100
Message-Id: <20211123163955.154512-7-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the initializers are aligned with spaces, others with tabs.
Reindent it using tabs only.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 80e4b500695e..7c30417a0464 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4949,18 +4949,18 @@ static int mvneta_setup_tc(struct net_device *dev, enum tc_setup_type type,
 }

 static const struct net_device_ops mvneta_netdev_ops = {
-	.ndo_open            = mvneta_open,
-	.ndo_stop            = mvneta_stop,
-	.ndo_start_xmit      = mvneta_tx,
-	.ndo_set_rx_mode     = mvneta_set_rx_mode,
-	.ndo_set_mac_address = mvneta_set_mac_addr,
-	.ndo_change_mtu      = mvneta_change_mtu,
-	.ndo_fix_features    = mvneta_fix_features,
-	.ndo_get_stats64     = mvneta_get_stats64,
-	.ndo_eth_ioctl        = mvneta_ioctl,
-	.ndo_bpf	     = mvneta_xdp,
-	.ndo_xdp_xmit        = mvneta_xdp_xmit,
-	.ndo_setup_tc	     = mvneta_setup_tc,
+	.ndo_open		= mvneta_open,
+	.ndo_stop		= mvneta_stop,
+	.ndo_start_xmit		= mvneta_tx,
+	.ndo_set_rx_mode	= mvneta_set_rx_mode,
+	.ndo_set_mac_address	= mvneta_set_mac_addr,
+	.ndo_change_mtu		= mvneta_change_mtu,
+	.ndo_fix_features	= mvneta_fix_features,
+	.ndo_get_stats64	= mvneta_get_stats64,
+	.ndo_eth_ioctl		= mvneta_ioctl,
+	.ndo_bpf		= mvneta_xdp,
+	.ndo_xdp_xmit		= mvneta_xdp_xmit,
+	.ndo_setup_tc		= mvneta_setup_tc,
 };

 static const struct ethtool_ops mvneta_eth_tool_ops = {
--
2.33.1

