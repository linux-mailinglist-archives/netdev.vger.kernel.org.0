Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF84B2C6A8
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfE1MgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:36:21 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42709 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbfE1MgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:36:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9930422AD;
        Tue, 28 May 2019 08:26:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=hVKe1y7pY2FNtBBZnep78orj0qdupd3eQqjN2oWn+FM=; b=a04dRuDy
        0UXA7EolPiie6zax4jrAFf4/hBOq83GLYXqL5MBPJfxWY4BsOh9VWBf03CfOTeY0
        lN7QoXM5lys8pcTlLZwa6TLjuSqtFou+LDcHN3KRFA3MB3Vz88c3Id9MHNd8TKff
        a+sN1C3MkirJFPrKut/WpI7ihyM6+ul7zDeTZV0aXjxJIiLUJg/LjOPh3I2AK9RL
        VKm8dI/lgizvGeSmFng6hZJJsbenhr+aDXGmnLSyqgVhNYppmpxBhfmNvk329jR5
        Bzw33cYudqJh/703MItKEL1srMmfSAAVOVoFMzeTb8Tpz4Jkfz09xPmgBNss1yIU
        N60mFDFpuR2Byg==
X-ME-Sender: <xms:DCntXL5iQQ5Nepc8b1185GiQG7Dd_cXghqz8hLwgEaQ2FWccMWIUSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:DCntXK8eA-4uva1r0MElPDqWlhCSdqjSDd4lBsCN5CHeOvo6OvNpTQ>
    <xmx:DCntXCWmE6R8SwYEzBHtPsiWsXfBuhLa6V4gC3IPs2r1Cmx5ymd1Iw>
    <xmx:DCntXNr2J1KFGTey40Wi2XolhpoGE71rZiyZFu8U2_r30oGHh-9jLw>
    <xmx:DSntXPvWGmOEP5w0GNWirJ4GlQOEabjZd_KE7Ef_0iF-8uJrwyfFYQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF9B380061;
        Tue, 28 May 2019 08:26:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH iproute2-next 1/5] Update kernel headers
Date:   Tue, 28 May 2019 15:26:14 +0300
Message-Id: <20190528122618.30769-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122618.30769-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
 <20190528122618.30769-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Only including this patch so that people could easily apply the series.
I'm aware David takes care of syncing the kernel headers.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/uapi/linux/devlink.h | 68 ++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 3b6a9e6be3ac..bd38d009df0d 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -16,6 +16,7 @@
 #define DEVLINK_GENL_NAME "devlink"
 #define DEVLINK_GENL_VERSION 0x1
 #define DEVLINK_GENL_MCGRP_CONFIG_NAME "config"
+#define DEVLINK_GENL_MCGRP_TRAP_NAME "trap"
 
 enum devlink_command {
 	/* don't change the order or add anything between, this is ABI! */
@@ -105,6 +106,17 @@ enum devlink_command {
 
 	DEVLINK_CMD_FLASH_UPDATE,
 
+	DEVLINK_CMD_TRAP_GET,		/* can dump */
+	DEVLINK_CMD_TRAP_SET,
+	DEVLINK_CMD_TRAP_NEW,
+	DEVLINK_CMD_TRAP_DEL,
+	DEVLINK_CMD_TRAP_REPORT,
+
+	DEVLINK_CMD_TRAP_GROUP_GET,	/* can dump */
+	DEVLINK_CMD_TRAP_GROUP_SET,
+	DEVLINK_CMD_TRAP_GROUP_NEW,
+	DEVLINK_CMD_TRAP_GROUP_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -184,6 +196,47 @@ enum devlink_param_fw_load_policy_value {
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH,
 };
 
+enum {
+	DEVLINK_ATTR_STATS_RX_PACKETS,
+	DEVLINK_ATTR_STATS_RX_BYTES,
+
+	__DEVLINK_ATTR_STATS_MAX,
+	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
+};
+
+/**
+ * enum devlink_trap_action - Packet trap action.
+ * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
+ *                            sent to the CPU.
+ * @DEVLINK_TRAP_ACTION_TRAP: The sole copy of the packet is sent to the CPU.
+ */
+enum devlink_trap_action {
+	DEVLINK_TRAP_ACTION_DROP,
+	DEVLINK_TRAP_ACTION_TRAP,
+};
+
+/**
+ * enum devlink_trap_type - Packet trap type.
+ * @DEVLINK_TRAP_TYPE_DROP: Trap reason is a drop. Trapped packets are only
+ *                          processed by devlink and not injected to the
+ *                          kernel's Rx path.
+ * @DEVLINK_TRAP_TYPE_EXCEPTION: Trap reason is an exception. Packet was not
+ *                               forwarded as intended due to an exception
+ *                               (e.g., missing neighbour entry) and trapped to
+ *                               control plane for resolution. Trapped packets
+ *                               are processed by devlink and injected to
+ *                               the kernel's Rx path.
+ */
+enum devlink_trap_type {
+	DEVLINK_TRAP_TYPE_DROP,
+	DEVLINK_TRAP_TYPE_EXCEPTION,
+};
+
+enum {
+	/* Trap can report input port as metadata */
+	DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT,
+};
+
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	DEVLINK_ATTR_UNSPEC,
@@ -332,6 +385,21 @@ enum devlink_attr {
 	DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME,	/* string */
 	DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,	/* string */
 
+	DEVLINK_ATTR_STATS,				/* nested */
+
+	DEVLINK_ATTR_TRAP_NAME,				/* string */
+	DEVLINK_ATTR_TRAP_REPORT_ENABLED,		/* u8 */
+	/* enum devlink_trap_action */
+	DEVLINK_ATTR_TRAP_ACTION,			/* u8 */
+	/* enum devlink_trap_type */
+	DEVLINK_ATTR_TRAP_TYPE,				/* u8 */
+	DEVLINK_ATTR_TRAP_GENERIC,			/* flag */
+	DEVLINK_ATTR_TRAP_METADATA,			/* nested */
+	DEVLINK_ATTR_TRAP_TIMESTAMP,			/* struct timespec */
+	DEVLINK_ATTR_TRAP_IN_PORT,			/* nested */
+	DEVLINK_ATTR_TRAP_PAYLOAD,			/* binary */
+	DEVLINK_ATTR_TRAP_GROUP_NAME,			/* string */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.20.1

