Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB932466BC
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgHQM4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:56:24 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:41669 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726727AbgHQM4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:56:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 3BADB3D0;
        Mon, 17 Aug 2020 08:56:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wNn/eF13653gJJUdUuai1FYV6CHqG5Zo6ntSzgEbWSQ=; b=H6YV//oa
        75TLRmQf/9yojjm43RVy3/KaTD53fydTsdcclBKQnPsXqNbnMbJPqyJdf7b0bw2E
        ANzBu2WKU6QIs9AT1WZpBkxVorI33Hmjzucp7YfOQp71cTkwMewyIgO4aAh3NXGs
        Fd7JO4Iy3JEIUYdyDQnRKKRV0rZ/MsXxqElHkmZGT72vm4ICTqjYAxLEByeBSU4P
        EaRNaY9k3ZqZSHZzH7FiBdCh/7B9hjFaSP4A5IV6o+BubpFVrf6uqkqhiHax8URd
        SaLi83O/+yatynxlXmEoVjoyYcDHGYAso21AgpxKR5yX3F0n7rSUeEPgPO6VQiuU
        ohbrjJAqWIbEhg==
X-ME-Sender: <xms:dX46X_20DJBVB61zaBhzPvzqacXOkhwL1IyFfjuB6miWm0Xi4vtj7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudekvddrieefrdegvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:dX46X-F5Nkfe5ZSjFldlmFhWptSYWZXtuJE7aYazZfAUEct07vkWrQ>
    <xmx:dX46X_5ifrSFWgtmViQ6OhZ_tgAnBikQ3drDioOKlvfeNnee379d3w>
    <xmx:dX46X03GyzE48ACHPegYfTxm7Puc-VqpQmspZv5vnyI_hXd5jZhEVw>
    <xmx:dX46X-G-k8m9teUH9g7gvHJxaqpcsbmvtlYEmCGBzSRHPALzdmdtdbDyfN0>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E2FD328005A;
        Mon, 17 Aug 2020 08:56:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH iproute2-next 1/2] Update kernel headers
Date:   Mon, 17 Aug 2020 15:55:40 +0300
Message-Id: <20200817125541.193590-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817125541.193590-1-idosch@idosch.org>
References: <20200817125541.193590-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/devlink.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b7f23faae901..65563df8b0b6 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -122,6 +122,11 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_POLICER_NEW,
 	DEVLINK_CMD_TRAP_POLICER_DEL,
 
+	DEVLINK_CMD_METRIC_GET,		/* can dump */
+	DEVLINK_CMD_METRIC_SET,
+	DEVLINK_CMD_METRIC_NEW,
+	DEVLINK_CMD_METRIC_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -272,6 +277,14 @@ enum {
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
 };
 
+/**
+ * enum devlink_metric_type - Metric type.
+ * @DEVLINK_METRIC_TYPE_COUNTER: Counter. Monotonically increasing.
+ */
+enum devlink_metric_type {
+	DEVLINK_METRIC_TYPE_COUNTER,
+};
+
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	DEVLINK_ATTR_UNSPEC,
@@ -458,6 +471,12 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_METRIC_NAME,		/* string */
+	/* enum devlink_metric_type */
+	DEVLINK_ATTR_METRIC_TYPE,		/* u8 */
+	DEVLINK_ATTR_METRIC_COUNTER_VALUE,	/* u64 */
+	DEVLINK_ATTR_METRIC_GROUP,		/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.26.2

