Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325323DF342
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbhHCQwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:52:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:29091 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237415AbhHCQwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:52:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="235676235"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="235676235"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:52:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="511398979"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Aug 2021 09:51:51 -0700
Received: from alobakin-mobl.ger.corp.intel.com (mszymcza-mobl.ger.corp.intel.com [10.213.25.231])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173Gpg77004325;
        Tue, 3 Aug 2021 17:51:46 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH ethtool-next 1/5] sync UAPI header copies
Date:   Tue,  3 Aug 2021 18:51:36 +0200
Message-Id: <20210803165140.172-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165140.172-1-alexandr.lobakin@intel.com>
References: <20210803165140.172-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ commit e1d9a90a9bfd ("net: ethernet: rmnet: Support for ingress MAPv5 checksum offload")
+ commit b6e5d27e32ef ("net: ethernet: rmnet: Add support for MAPv5 egress packets")
+ commit d409989b59ad ("netlink: simplify NLMSG_DATA with NLMSG_HDRLEN")
+ commit 00e77ed8e64d ("rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME")
+ commit 2d8ea148e553 ("net: fix mistake path for netdev_features_strings")
+ commit 913d026fbfaf ("ethtool: Document correct attribute type")
+ commit d463126e23f1 ("net: sock: extend SO_TIMESTAMPING for PHC binding")
+ commit c156174a6707 ("ethtool: add a new command for getting PHC virtual clocks")
+ commit 583be982d934 ("mctp: Add device handling and netlink interface")
+ commit 3a755cd8b7c6 ("bonding: add new option lacp_active")
+ commit 44eee6116fda ("ethtool, stats: introduce standard XDP statistics")

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 uapi/linux/ethtool.h         |  6 +++--
 uapi/linux/ethtool_netlink.h | 51 +++++++++++++++++++++++++++++++++++-
 uapi/linux/if_link.h         | 20 ++++++++++++++
 uapi/linux/net_tstamp.h      | 17 ++++++++++--
 uapi/linux/netlink.h         |  5 ++--
 5 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index c6ec1111ffa3..898bce1b08b0 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -231,7 +231,7 @@ enum tunable_id {
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
-	 * tunable_strings[] in net/core/ethtool.c
+	 * tunable_strings[] in net/ethtool/common.c
 	 */
 	__ETHTOOL_TUNABLE_COUNT,
 };
@@ -295,7 +295,7 @@ enum phy_tunable_id {
 	ETHTOOL_PHY_EDPD,
 	/*
 	 * Add your fresh new phy tunable attribute above and remember to update
-	 * phy_tunable_strings[] in net/core/ethtool.c
+	 * phy_tunable_strings[] in net/ethtool/common.c
 	 */
 	__ETHTOOL_PHY_TUNABLE_COUNT,
 };
@@ -672,6 +672,7 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_STATS_ETH_MAC: names of IEEE 802.3 MAC statistics
  * @ETH_SS_STATS_ETH_CTRL: names of IEEE 802.3 MAC Control statistics
  * @ETH_SS_STATS_RMON: names of RMON statistics
+ * @ETH_SS_STATS_XDP: names of XDP statistics
  *
  * @ETH_SS_COUNT: number of defined string sets
  */
@@ -697,6 +698,7 @@ enum ethtool_stringset {
 	ETH_SS_STATS_ETH_MAC,
 	ETH_SS_STATS_ETH_CTRL,
 	ETH_SS_STATS_RMON,
+	ETH_SS_STATS_XDP,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 4653c4c79972..acb1e93084ac 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -46,6 +46,7 @@ enum {
 	ETHTOOL_MSG_FEC_SET,
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
 	ETHTOOL_MSG_STATS_GET,
+	ETHTOOL_MSG_PHC_VCLOCKS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -88,6 +89,7 @@ enum {
 	ETHTOOL_MSG_FEC_NTF,
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 	ETHTOOL_MSG_STATS_GET_REPLY,
+	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -440,6 +442,19 @@ enum {
 	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
 };
 
+/* PHC VCLOCKS */
+
+enum {
+	ETHTOOL_A_PHC_VCLOCKS_UNSPEC,
+	ETHTOOL_A_PHC_VCLOCKS_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_PHC_VCLOCKS_NUM,			/* u32 */
+	ETHTOOL_A_PHC_VCLOCKS_INDEX,			/* array, s32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PHC_VCLOCKS_CNT,
+	ETHTOOL_A_PHC_VCLOCKS_MAX = (__ETHTOOL_A_PHC_VCLOCKS_CNT - 1)
+};
+
 /* CABLE TEST */
 
 enum {
@@ -675,7 +690,7 @@ enum {
 	ETHTOOL_A_MODULE_EEPROM_PAGE,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_BANK,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,		/* u8 */
-	ETHTOOL_A_MODULE_EEPROM_DATA,			/* nested */
+	ETHTOOL_A_MODULE_EEPROM_DATA,			/* binary */
 
 	__ETHTOOL_A_MODULE_EEPROM_CNT,
 	ETHTOOL_A_MODULE_EEPROM_MAX = (__ETHTOOL_A_MODULE_EEPROM_CNT - 1)
@@ -701,6 +716,7 @@ enum {
 	ETHTOOL_STATS_ETH_MAC,
 	ETHTOOL_STATS_ETH_CTRL,
 	ETHTOOL_STATS_RMON,
+	ETHTOOL_STATS_XDP,
 
 	/* add new constants above here */
 	__ETHTOOL_STATS_CNT
@@ -722,6 +738,8 @@ enum {
 	ETHTOOL_A_STATS_GRP_HIST_BKT_HI,	/* u32 */
 	ETHTOOL_A_STATS_GRP_HIST_VAL,		/* u64 */
 
+	ETHTOOL_A_STATS_GRP_STAT_BLOCK,		/* nest */
+
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_GRP_CNT,
 	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_CNT - 1)
@@ -816,6 +834,37 @@ enum {
 	ETHTOOL_A_STATS_RMON_MAX = (__ETHTOOL_A_STATS_RMON_CNT - 1)
 };
 
+enum {
+	/* Number of frames passed to bpf_prog_run_xdp() */
+	ETHTOOL_A_STATS_XDP_PACKETS,
+	/* Number o general XDP errors if driver counts them together */
+	ETHTOOL_A_STATS_XDP_ERRORS,
+	/* Number of %XDP_ABORTED returns */
+	ETHTOOL_A_STATS_XDP_ABORTED,
+	/* Number of %XDP_DROP returns */
+	ETHTOOL_A_STATS_XDP_DROP,
+	/* Number of returns of unallowed values (i.e. not XDP_*) */
+	ETHTOOL_A_STATS_XDP_INVALID,
+	/* Number of %XDP_PASS returns */
+	ETHTOOL_A_STATS_XDP_PASS,
+	/* Number of successfully performed %XDP_REDIRECT requests */
+	ETHTOOL_A_STATS_XDP_REDIRECT,
+	/* Number of failed %XDP_REDIRECT requests */
+	ETHTOOL_A_STATS_XDP_REDIRECT_ERRORS,
+	/* Number of successfully performed %XDP_TX requests */
+	ETHTOOL_A_STATS_XDP_TX,
+	/* Number of failed %XDP_TX requests */
+	ETHTOOL_A_STATS_XDP_TX_ERRORS,
+	/* Number of xdp_frames successfully transmitted via .ndo_xdp_xmit() */
+	ETHTOOL_A_STATS_XDP_XMIT,
+	/* Number of frames dropped from .ndo_xdp_xmit() */
+	ETHTOOL_A_STATS_XDP_XMIT_DROPS,
+
+	/* Add new constants above here */
+	__ETHTOOL_A_STATS_XDP_CNT,
+	ETHTOOL_A_STATS_XDP_MAX = (__ETHTOOL_A_STATS_XDP_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index 0e81707a9637..fb2ecf403a16 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -341,6 +341,13 @@ enum {
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
 	IFLA_PROTO_DOWN_REASON,
+
+	/* device (sysfs) name as parent, used instead
+	 * of IFLA_LINK where there's no parent netdev
+	 */
+	IFLA_PARENT_DEV_NAME,
+	IFLA_PARENT_DEV_BUS_NAME,
+
 	__IFLA_MAX
 };
 
@@ -846,6 +853,7 @@ enum {
 	IFLA_BOND_AD_ACTOR_SYSTEM,
 	IFLA_BOND_TLB_DYNAMIC_LB,
 	IFLA_BOND_PEER_NOTIF_DELAY,
+	IFLA_BOND_AD_LACP_ACTIVE,
 	__IFLA_BOND_MAX,
 };
 
@@ -1234,6 +1242,8 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
+#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
+#define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
 
 enum {
 	IFLA_RMNET_UNSPEC,
@@ -1249,4 +1259,14 @@ struct ifla_rmnet_flags {
 	__u32	mask;
 };
 
+/* MCTP section */
+
+enum {
+	IFLA_MCTP_UNSPEC,
+	IFLA_MCTP_NET,
+	__IFLA_MCTP_MAX,
+};
+
+#define IFLA_MCTP_MAX (__IFLA_MCTP_MAX - 1)
+
 #endif /* _LINUX_IF_LINK_H */
diff --git a/uapi/linux/net_tstamp.h b/uapi/linux/net_tstamp.h
index 7ed0b3d1c00a..fcc61c73a666 100644
--- a/uapi/linux/net_tstamp.h
+++ b/uapi/linux/net_tstamp.h
@@ -13,7 +13,7 @@
 #include <linux/types.h>
 #include <linux/socket.h>   /* for SO_TIMESTAMPING */
 
-/* SO_TIMESTAMPING gets an integer bit field comprised of these values */
+/* SO_TIMESTAMPING flags */
 enum {
 	SOF_TIMESTAMPING_TX_HARDWARE = (1<<0),
 	SOF_TIMESTAMPING_TX_SOFTWARE = (1<<1),
@@ -30,8 +30,9 @@ enum {
 	SOF_TIMESTAMPING_OPT_STATS = (1<<12),
 	SOF_TIMESTAMPING_OPT_PKTINFO = (1<<13),
 	SOF_TIMESTAMPING_OPT_TX_SWHW = (1<<14),
+	SOF_TIMESTAMPING_BIND_PHC = (1 << 15),
 
-	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_OPT_TX_SWHW,
+	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_BIND_PHC,
 	SOF_TIMESTAMPING_MASK = (SOF_TIMESTAMPING_LAST - 1) |
 				 SOF_TIMESTAMPING_LAST
 };
@@ -46,6 +47,18 @@ enum {
 					 SOF_TIMESTAMPING_TX_SCHED | \
 					 SOF_TIMESTAMPING_TX_ACK)
 
+/**
+ * struct so_timestamping - SO_TIMESTAMPING parameter
+ *
+ * @flags:	SO_TIMESTAMPING flags
+ * @bind_phc:	Index of PTP virtual clock bound to sock. This is available
+ *		if flag SOF_TIMESTAMPING_BIND_PHC is set.
+ */
+struct so_timestamping {
+	int flags;
+	int bind_phc;
+};
+
 /**
  * struct hwtstamp_config - %SIOCGHWTSTAMP and %SIOCSHWTSTAMP parameter
  *
diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
index 5024c5435749..e83e2e300130 100644
--- a/uapi/linux/netlink.h
+++ b/uapi/linux/netlink.h
@@ -91,9 +91,10 @@ struct nlmsghdr {
 #define NLMSG_HDRLEN	 ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
 #define NLMSG_LENGTH(len) ((len) + NLMSG_HDRLEN)
 #define NLMSG_SPACE(len) NLMSG_ALIGN(NLMSG_LENGTH(len))
-#define NLMSG_DATA(nlh)  ((void*)(((char*)nlh) + NLMSG_LENGTH(0)))
+#define NLMSG_DATA(nlh)  ((void *)(((char *)nlh) + NLMSG_HDRLEN))
 #define NLMSG_NEXT(nlh,len)	 ((len) -= NLMSG_ALIGN((nlh)->nlmsg_len), \
-				  (struct nlmsghdr*)(((char*)(nlh)) + NLMSG_ALIGN((nlh)->nlmsg_len)))
+				  (struct nlmsghdr *)(((char *)(nlh)) + \
+				  NLMSG_ALIGN((nlh)->nlmsg_len)))
 #define NLMSG_OK(nlh,len) ((len) >= (int)sizeof(struct nlmsghdr) && \
 			   (nlh)->nlmsg_len >= sizeof(struct nlmsghdr) && \
 			   (nlh)->nlmsg_len <= (len))
-- 
2.31.1

