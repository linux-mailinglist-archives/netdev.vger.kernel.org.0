Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815663E43E0
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhHIKXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:23:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36693 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234646AbhHIKXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:23:43 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id B70145C00E2;
        Mon,  9 Aug 2021 06:23:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 09 Aug 2021 06:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oBZ/4QYSS5TWxc8jl7AUYDJt7K5+51mskC1yjtTLWmE=; b=wmVvb6fx
        GWZ39EddvbOaUoW3hadI8MFx8x2bYd2tWOYIwecgGgQZ+aJH4hZvAUnZ4Ee5o5gU
        nGmM9ETA66D+r8wZnkReoSNuR7or5Mt+ZDCTMiC56Bu65fdT0jsASv7jGyUU4ikQ
        +uQ80gBaE7U2Ut7Dyjad/7sK8fOcap9TGUcTMSnoLFdqO49zXp2GhKx/8ngoizsp
        0JuSpQBrBO1yYwBSmS/BTS8rJmwXvXkYUO/IGuVkIuxdXhkL695hjJFxRwrH1FYp
        3ham1TNsZHr8/8nxzWKPR+8CRQ9RkHufKKY7d+/atruESmqN5PuE/a+RPZwRaApN
        NyEBpngIjAOLFA==
X-ME-Sender: <xms:GQIRYc8TmkTtT8-J1f6o5AKqVuJl1wbedEAOvsX4iJAEt_6YAhdOZg>
    <xme:GQIRYUuFMLAWTzDYXPP2lRsYpSmsh7-GnkmBfN7-SYE-oL4ELzNwLpmhyJsT7GB6g
    BfNucWecj-ovKE>
X-ME-Received: <xmr:GQIRYSB77n6_zPiW8i7LBm0YUpPFLj8viYbmZ3-1NBDKiGhOZkftljZkhUhsEReLUn3nJOlHT69G7GhSIZsUGQdSz88spIY66VzTmHlLSG-CGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedvnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:GQIRYceYjNTDWR8MfzAqspBGy8rVzjqno56OEDNJJoAIHYmyyNGRsg>
    <xmx:GQIRYROb13ZHJupodiAdwcRBZpYkF0rUS8uBbeFja4MoePPHhbrL6g>
    <xmx:GQIRYWm1ij-xnD5RDE8yIftsEVybZFSSrYGictIRZ7v1MJh9ZxT0zw>
    <xmx:GgIRYdAKgOTc2auBMIkIPOQUV10dxxitduJ0bUaTjMwUIT7ULiGiyA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:23:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 1/6] Update UAPI header copies
Date:   Mon,  9 Aug 2021 13:22:51 +0300
Message-Id: <20210809102256.720119-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102256.720119-1-idosch@idosch.org>
References: <20210809102256.720119-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Update to kernel commit XXX.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 uapi/linux/ethtool.h         |  4 ++--
 uapi/linux/ethtool_netlink.h | 35 ++++++++++++++++++++++++++++++++++-
 uapi/linux/if_link.h         | 19 +++++++++++++++++++
 uapi/linux/net_tstamp.h      | 17 +++++++++++++++--
 uapi/linux/netlink.h         |  5 +++--
 5 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index c6ec1111ffa3..f40b00d94276 100644
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
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 4653c4c79972..32eabb5773d0 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -46,6 +46,10 @@ enum {
 	ETHTOOL_MSG_FEC_SET,
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
 	ETHTOOL_MSG_STATS_GET,
+	ETHTOOL_MSG_PHC_VCLOCKS_GET,
+	ETHTOOL_MSG_MODULE_GET,
+	ETHTOOL_MSG_MODULE_SET,
+	ETHTOOL_MSG_MODULE_RESET_ACT,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -88,6 +92,10 @@ enum {
 	ETHTOOL_MSG_FEC_NTF,
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 	ETHTOOL_MSG_STATS_GET_REPLY,
+	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
+	ETHTOOL_MSG_MODULE_GET_REPLY,
+	ETHTOOL_MSG_MODULE_NTF,
+	ETHTOOL_MSG_MODULE_RESET_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -440,6 +448,19 @@ enum {
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
@@ -675,7 +696,7 @@ enum {
 	ETHTOOL_A_MODULE_EEPROM_PAGE,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_BANK,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,		/* u8 */
-	ETHTOOL_A_MODULE_EEPROM_DATA,			/* nested */
+	ETHTOOL_A_MODULE_EEPROM_DATA,			/* binary */
 
 	__ETHTOOL_A_MODULE_EEPROM_CNT,
 	ETHTOOL_A_MODULE_EEPROM_MAX = (__ETHTOOL_A_MODULE_EEPROM_CNT - 1)
@@ -816,6 +837,18 @@ enum {
 	ETHTOOL_A_STATS_RMON_MAX = (__ETHTOOL_A_STATS_RMON_CNT - 1)
 };
 
+/* MODULE */
+
+enum {
+	ETHTOOL_A_MODULE_UNSPEC,
+	ETHTOOL_A_MODULE_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_MODULE_LOW_POWER_ENABLED,	/* u8 */
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
index 0e81707a9637..62512efc4f73 100644
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
 
@@ -1234,6 +1241,8 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
+#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
+#define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
 
 enum {
 	IFLA_RMNET_UNSPEC,
@@ -1249,4 +1258,14 @@ struct ifla_rmnet_flags {
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

