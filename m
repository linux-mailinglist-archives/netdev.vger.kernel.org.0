Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2E846B75D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhLGJiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:38:24 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33263 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234207AbhLGJiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:38:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 074D35C0224;
        Tue,  7 Dec 2021 04:34:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Dec 2021 04:34:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/zYyJhw6Q7vBhmjk2Vze+I9/bC6/DMyiqPz0Pyt+J3s=; b=lQriYPp4
        s4T5mj4V+eHbZq/5IqvQIOKIcPMPh0tfKfvEeHPPr0PeMiFoJMZ6TJZ6VC40BL4E
        F8olBvhnk9+8enxZPQxUwkRugUis5RRlUpdavZ7+GDCWwFYEKANoNSLU8j8Tl8wO
        zNioLtmSHuKadUR/vIDHJr4jKDqQyI6sYERJDUM1jhQe0QxmLWrR+WtFvPtn1yXW
        5KXC+gLao2YMbrVmZNr0vZTBpjxWzK8vg76SthcpJ2RSIO6P+Bp1JwiQkUxqohr/
        /pCaNL+CpS3ak0pzn9icX8bQljKN07gUCijQtvMs10lUAeFjsJuXCgf9wB7aPmme
        V6R/p21iGAlNvA==
X-ME-Sender: <xms:sSqvYbO2WB_RfD5QdMpgza9qOM7GaKlzgLTmU9xtNk7mN3DMkJLoiA>
    <xme:sSqvYV-45PuK4WWCJcZ5s8ey-D22_tb3dYOtrJcXx3Oyhtn9kxg9mJS2sReafx_RX
    XQeVBrkF-zqPQI>
X-ME-Received: <xmr:sSqvYaQy_A5-0kKPQY8eORkzaq1rJUKuH4p4zLcjhjHzGbVMJF4Da0gRl1bf9vw2cFq2obfB70-FE32EXrdqLnR84a2_MyCrOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrjeehgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:sSqvYftT9CJGMsdRSM7q0AYq4ZpotAtfRmz_ulW0LPi857cGvTN8dw>
    <xmx:sSqvYTcII7cTHoSTkF6b5gGDRcHsHG5vsIW0sxE2cXBD6DDcQf25Aw>
    <xmx:sSqvYb2F5jjsqO6Iw3VfOFndbOhlkupmDkLwcrTZEsWsoceKEg0rWw>
    <xmx:siqvYUpFXHNJ25u0FzNmKu5dWtE54QRsHVIwsYJtO39i3cdKBEUX3w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Dec 2021 04:34:40 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 1/3] Update UAPI header copies
Date:   Tue,  7 Dec 2021 11:33:57 +0200
Message-Id: <20211207093359.69974-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211207093359.69974-1-idosch@idosch.org>
References: <20211207093359.69974-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Update to kernel commit 1c5526968e27.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 uapi/linux/ethtool.h         | 30 ++++++++++++++++++++++++++++++
 uapi/linux/ethtool_netlink.h | 22 +++++++++++++++++++++-
 uapi/linux/if_link.h         |  1 +
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index a7f549aab845..85548f96e2e2 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -229,6 +229,7 @@ enum tunable_id {
 	ETHTOOL_RX_COPYBREAK,
 	ETHTOOL_TX_COPYBREAK,
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
+	ETHTOOL_TX_COPYBREAK_BUF_SIZE,
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
 	 * tunable_strings[] in net/ethtool/common.c
@@ -601,6 +602,7 @@ enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
 	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
 	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+	ETHTOOL_LINK_EXT_STATE_MODULE,
 };
 
 /* More information in addition to ETHTOOL_LINK_EXT_STATE_AUTONEG. */
@@ -647,6 +649,11 @@ enum ethtool_link_ext_substate_cable_issue {
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
 };
 
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_MODULE. */
+enum ethtool_link_ext_substate_module {
+	ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY = 1,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
@@ -704,6 +711,29 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_module_power_mode_policy - plug-in module power mode policy
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO: Module is transitioned by the host
+ *	to high power mode when the first port using it is put administratively
+ *	up and to low power mode when the last port using it is put
+ *	administratively down.
+ */
+enum ethtool_module_power_mode_policy {
+	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH = 1,
+	ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO,
+};
+
+/**
+ * enum ethtool_module_power_mode - plug-in module power mode
+ * @ETHTOOL_MODULE_POWER_MODE_LOW: Module is in low power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_HIGH: Module is in high power mode.
+ */
+enum ethtool_module_power_mode {
+	ETHTOOL_MODULE_POWER_MODE_LOW = 1,
+	ETHTOOL_MODULE_POWER_MODE_HIGH,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 5665d6432172..d8b19cf98003 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -47,6 +47,8 @@ enum {
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
 	ETHTOOL_MSG_STATS_GET,
 	ETHTOOL_MSG_PHC_VCLOCKS_GET,
+	ETHTOOL_MSG_MODULE_GET,
+	ETHTOOL_MSG_MODULE_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -90,6 +92,8 @@ enum {
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 	ETHTOOL_MSG_STATS_GET_REPLY,
 	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
+	ETHTOOL_MSG_MODULE_GET_REPLY,
+	ETHTOOL_MSG_MODULE_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -325,6 +329,7 @@ enum {
 	ETHTOOL_A_RINGS_RX_MINI,			/* u32 */
 	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
 	ETHTOOL_A_RINGS_TX,				/* u32 */
+	ETHTOOL_A_RINGS_RX_BUF_LEN,                     /* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
@@ -407,7 +412,9 @@ enum {
 	ETHTOOL_A_PAUSE_STAT_TX_FRAMES,
 	ETHTOOL_A_PAUSE_STAT_RX_FRAMES,
 
-	/* add new constants above here */
+	/* add new constants above here
+	 * adjust ETHTOOL_PAUSE_STAT_CNT if adding non-stats!
+	 */
 	__ETHTOOL_A_PAUSE_STAT_CNT,
 	ETHTOOL_A_PAUSE_STAT_MAX = (__ETHTOOL_A_PAUSE_STAT_CNT - 1)
 };
@@ -833,6 +840,19 @@ enum {
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
index 1d4ed60bc779..9ed264d556f8 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -856,6 +856,7 @@ enum {
 	IFLA_BOND_TLB_DYNAMIC_LB,
 	IFLA_BOND_PEER_NOTIF_DELAY,
 	IFLA_BOND_AD_LACP_ACTIVE,
+	IFLA_BOND_MISSED_MAX,
 	__IFLA_BOND_MAX,
 };
 
-- 
2.31.1

