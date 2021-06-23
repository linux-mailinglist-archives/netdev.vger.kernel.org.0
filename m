Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044393B156B
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFWILS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:11:18 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:49091 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229920AbhFWILR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 04:11:17 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5BD4B5806DF;
        Wed, 23 Jun 2021 04:09:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 23 Jun 2021 04:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=nl6SxJ3e5/Ck7LpuGtsE0EIHigi6UsamjCJE7klyVEU=; b=b4FFpe2c
        dC5phcDNkELZMX9UxWGx8gAGz5JsQH1wLJXNx7braBo6qCE3SsP13OG0t+0X8Q2v
        caA5W7fjkvMrjhj6ERdbaOzCCbvLpvRq3chan+Bu75Yqwd/r2RWAIvEM0xBEqKNP
        kYALzuN7RkvHKVao3vpH9XTkPxu6lowHiH2AW1gGKm8mJk6Zgd8Qa5FdhcA+enFt
        40RqUN6mLVVSaPfsuZGnpZiiHBHsyTLgCUYfsac7Q4LN4w5rOjic+SOgWVvzI8m2
        WFyUANjFgo7PAySEAFCDQGWTNxtScuEV/x32NaKKCbEgMimA8JrlyuEyzAMmPi58
        wb1g18IBpIrbEg==
X-ME-Sender: <xms:HOzSYDv48FIeO9mai3yDZFFWMB5SCFA88xXLmH6agTaHR-q7g3TiYA>
    <xme:HOzSYEfP-BefANdgOk_9R6mJFPlnq8-oYe6isDqIoSU_D_idiauvtWfd5T2hKWZ2a
    b-Gc7w2DN8QPBE>
X-ME-Received: <xmr:HOzSYGxj_l0T7Jdcfd_JuC1_ZHpqtcGCyhL9UxPAL8vecL1xfwpxSardpJzVfa-5ajqNVwLBNS4pwJjKVl6fX0RAFICZ7ZI8pujla-crRk23LQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegfedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:HOzSYCPJFifMjPFqP9d9Wo5K-b29KdlaMuOJB0s2LJXAGteBPCGFuQ>
    <xmx:HOzSYD_a8B_OSiZmyZNJtQV3V3I2eOxs9K74sOKfGsKn3usgzECkVw>
    <xmx:HOzSYCUjnFLV2ts1C05Tb9eJr_c2PuPI5B2JxGRKlOfE-j72Dw2G_A>
    <xmx:HOzSYPT-_J5fO9mTbDBZSGsND42MRht_qAQpJvJ7LhW5i2yQOxXBZA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 04:08:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 1/2] Update UAPI header copies
Date:   Wed, 23 Jun 2021 11:08:24 +0300
Message-Id: <20210623080825.2612270-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210623080825.2612270-1-idosch@idosch.org>
References: <20210623080825.2612270-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Update to kernel commit XXX.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 uapi/linux/ethtool.h         | 4 ++--
 uapi/linux/ethtool_netlink.h | 4 +++-
 uapi/linux/if_link.h         | 9 +++++++++
 uapi/linux/netlink.h         | 5 +++--
 4 files changed, 17 insertions(+), 5 deletions(-)

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
index 4653c4c79972..35737343b8ca 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -46,6 +46,7 @@ enum {
 	ETHTOOL_MSG_FEC_SET,
 	ETHTOOL_MSG_MODULE_EEPROM_GET,
 	ETHTOOL_MSG_STATS_GET,
+	ETHTOOL_MSG_MODULE_EEPROM_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -88,6 +89,7 @@ enum {
 	ETHTOOL_MSG_FEC_NTF,
 	ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY,
 	ETHTOOL_MSG_STATS_GET_REPLY,
+	ETHTOOL_MSG_MODULE_EEPROM_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -675,7 +677,7 @@ enum {
 	ETHTOOL_A_MODULE_EEPROM_PAGE,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_BANK,			/* u8 */
 	ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,		/* u8 */
-	ETHTOOL_A_MODULE_EEPROM_DATA,			/* nested */
+	ETHTOOL_A_MODULE_EEPROM_DATA,			/* binary */
 
 	__ETHTOOL_A_MODULE_EEPROM_CNT,
 	ETHTOOL_A_MODULE_EEPROM_MAX = (__ETHTOOL_A_MODULE_EEPROM_CNT - 1)
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index 0e81707a9637..5195ed93eff4 100644
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

