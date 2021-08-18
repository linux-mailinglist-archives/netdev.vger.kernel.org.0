Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96A83F0882
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240195AbhHRPyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:54:04 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:32905 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240267AbhHRPyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:54:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9EE40582FDE;
        Wed, 18 Aug 2021 11:53:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 18 Aug 2021 11:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=cXi0XDuwkW+JnPinhpx0F2NUu2Nyf+AHNdbyRcHPibQ=; b=lQNAPMpC
        orkZLPL0zQ+eNKvr0wA6wFatXfNPZign1ftbSTwycsZNCxuqkdl43SC6Hk9vls7i
        nfp0PgWQ4ynqTH9qchC18XF8INPLED8dxH2hj9TzLduhB93I9sgm34w6mPUQu2xB
        zg5rtG4x6XWeCkgN3PsXx/Ul1GrbHagG7Q7RtJJMmuus4LiQeplWp4CEndrX0Cy8
        bB9mVSg0JeyZATduRK6oXR0hIW3Xydgg3U8HF4ADcEIyz6hpj+DJg1qVCAs1V3UW
        Ks+w7cSDa1Vj8Vn3ZN650+IchtoYwPQtmVBsvNn2rzxcNeC6EtznwpfEAY64zxxy
        B5ieZZNgdMFPcQ==
X-ME-Sender: <xms:9iwdYQn5hNrHvAMZs-qxSR01ND_hSFOiZ7is3Afp3iysP5hUJRQUtA>
    <xme:9iwdYf06nizXnyASxlyCXuydGmMDjqTLnYgvLvcHRjlHEqeHyWBTbodAzIxWzbukt
    eCTDjVMz-YZWFY>
X-ME-Received: <xmr:9iwdYerD-uZT1wfwdx8WJuTUmW4E3DHEHbY-YAtAi0hDKVcFanT9qZeiGMqlQxSnYFu6v2HPElxuLNJrK-PDyTcPECbL_Nh_wkyqOvcFYteJHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:9iwdYckSZXEbQWWT1U9IKO6ouvdZnnrX3XjRCWIzeC_PfEQgCQ1pvQ>
    <xmx:9iwdYe1ZefIvHhpJjaWVL7kER453fV6E2LDmrKEQQ86Wkn262R6mxw>
    <xmx:9iwdYTvU2DHAkJh5qCWTC5jo6R7deNhfKrYsBfMVPOIzFNh7ccCX0A>
    <xmx:9ywdYfJ66lghD5ZtxMpiDZXiXete2VSX6hjSPgK6QZKt-Lz9v4hPLw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:53:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v2 1/6] Update UAPI header copies
Date:   Wed, 18 Aug 2021 18:53:01 +0300
Message-Id: <20210818155306.1278356-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155306.1278356-1-idosch@idosch.org>
References: <20210818155306.1278356-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Update to kernel commit XXX.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 uapi/linux/ethtool.h         | 36 ++++++++++++++++++++++++++++++++++--
 uapi/linux/ethtool_netlink.h | 34 +++++++++++++++++++++++++++++++++-
 uapi/linux/if_link.h         | 21 +++++++++++++++++++++
 uapi/linux/net_tstamp.h      | 17 +++++++++++++++--
 uapi/linux/netlink.h         |  5 +++--
 5 files changed, 106 insertions(+), 7 deletions(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index c6ec1111ffa3..0187f87a18d3 100644
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
@@ -601,6 +601,7 @@ enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
 	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
 	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+	ETHTOOL_LINK_EXT_STATE_MODULE,
 };
 
 /* More information in addition to ETHTOOL_LINK_EXT_STATE_AUTONEG. */
@@ -645,6 +646,12 @@ enum ethtool_link_ext_substate_cable_issue {
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
 };
 
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_MODULE. */
+enum ethtool_link_ext_substate_module {
+	ETHTOOL_LINK_EXT_SUBSTATE_MODULE_LOW_POWER_MODE = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
@@ -702,6 +709,31 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_module_power_mode_policy - plug-in module power mode policy
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_LOW: Module is always in low power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP: Module is transitioned by the
+ *	host to high power mode when the first port using it is put
+ *	administratively up and to low power mode when the last port using it
+ *	is put administratively down.
+ */
+enum ethtool_module_power_mode_policy {
+	ETHTOOL_MODULE_POWER_MODE_POLICY_LOW,
+	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH,
+	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP,
+};
+
+/**
+ * enum ethtool_module_power_mode - plug-in module power mode
+ * @ETHTOOL_MODULE_POWER_MODE_LOW: Module is in low power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_HIGH: Module is in high power mode.
+ */
+enum ethtool_module_power_mode {
+	ETHTOOL_MODULE_POWER_MODE_LOW,
+	ETHTOOL_MODULE_POWER_MODE_HIGH,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 4653c4c79972..d706aa03925a 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -46,6 +46,9 @@ enum {
 	ETHTOOL_MSG_FEC_SET,
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
 	ETHTOOL_MSG_STATS_GET,
+	ETHTOOL_MSG_PHC_VCLOCKS_GET,
+	ETHTOOL_MSG_MODULE_GET,
+	ETHTOOL_MSG_MODULE_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -88,6 +91,9 @@ enum {
 	ETHTOOL_MSG_FEC_NTF,
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 	ETHTOOL_MSG_STATS_GET_REPLY,
+	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
+	ETHTOOL_MSG_MODULE_GET_REPLY,
+	ETHTOOL_MSG_MODULE_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -440,6 +446,19 @@ enum {
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
@@ -675,7 +694,7 @@ enum {
 	ETHTOOL_A_MODULE_EEPROM_PAGE,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_BANK,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,		/* u8 */
-	ETHTOOL_A_MODULE_EEPROM_DATA,			/* nested */
+	ETHTOOL_A_MODULE_EEPROM_DATA,			/* binary */
 
 	__ETHTOOL_A_MODULE_EEPROM_CNT,
 	ETHTOOL_A_MODULE_EEPROM_MAX = (__ETHTOOL_A_MODULE_EEPROM_CNT - 1)
@@ -816,6 +835,19 @@ enum {
 	ETHTOOL_A_STATS_RMON_MAX = (__ETHTOOL_A_STATS_RMON_CNT - 1)
 };
 
+/* MODULE */
+
+enum {
+	ETHTOOL_A_MODULE_UNSPEC,
+	ETHTOOL_A_MODULE_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_MODULE_POWER_MODE_POLICY,	/* u8 */
+	ETHTOOL_A_MODULE_POWER_MODE,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MODULE_CNT,
+	ETHTOOL_A_MODULE_MAX = (__ETHTOOL_A_MODULE_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index 0e81707a9637..330a3c1e0035 100644
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
 
@@ -470,6 +477,7 @@ enum {
 	IFLA_BR_MCAST_MLD_VERSION,
 	IFLA_BR_VLAN_STATS_PER_PORT,
 	IFLA_BR_MULTI_BOOLOPT,
+	IFLA_BR_MCAST_QUERIER_STATE,
 	__IFLA_BR_MAX,
 };
 
@@ -846,6 +854,7 @@ enum {
 	IFLA_BOND_AD_ACTOR_SYSTEM,
 	IFLA_BOND_TLB_DYNAMIC_LB,
 	IFLA_BOND_PEER_NOTIF_DELAY,
+	IFLA_BOND_AD_LACP_ACTIVE,
 	__IFLA_BOND_MAX,
 };
 
@@ -1234,6 +1243,8 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
+#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
+#define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
 
 enum {
 	IFLA_RMNET_UNSPEC,
@@ -1249,4 +1260,14 @@ struct ifla_rmnet_flags {
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

