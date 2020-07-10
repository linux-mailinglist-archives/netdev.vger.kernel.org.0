Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C953C21B763
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgGJN6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:37 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:38005 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726832AbgGJN6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6DABD58058A;
        Fri, 10 Jul 2020 09:58:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=V99AkssyUfTMO/32s6GAy48cqgcqeeUq/6za1QuWhWs=; b=gEs0U88a
        q9B3ti2JKCbfoU49k/XMaB6Rc33B9rcYdKPjHho5HvDoluYYwHTv23zqIzN66jnh
        WpOW/ERabwHDqxfxe/5NQaCQVsvitYX/Dv8Sz993MzfrxAgNEVuZRK4EIqWvlRlx
        B59BHWpjyNuJ/BNbACM5iYLsuPZN/lNkWwu+NXho8hYk+2O1wubnyreNYjztpWhA
        xRXUa1ImJ2GoQkFokDM1MbT3Mrx0iWUYZiBiMhcVdQsJJKOMhxs4vQpp8pdmfqQe
        Mwz241J6WG6YqGgEwTB3d6+ouJPsXeRFa6KUcKqes0Db3SZrYYI1BWEutBMhWB00
        FhbAp96tKcHWkw==
X-ME-Sender: <xms:CnQIX5giBlT7-3SkENkoJZ4vVzK1xup3ATWeV74DSrkxspiGLoj95Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CnQIX-Bmx0Ug3Vc8tnwzo2P238x2YUoj3h8m5CsPTL5sB3dygpm_Gg>
    <xmx:CnQIX5FlNOq0Ubx5tFhLxgcmztGoyofw0n5m4wGqp6ktWWzXCirDyg>
    <xmx:CnQIX-TwHnCguQRtmrCtT3rbpGb4mFIdpckQQzNQ5oO-aq_HID1Eww>
    <xmx:CnQIX459RY8umiB3dC5ldZ9VhoZbn3iCm86AnNtBmBWH92hTF7PDmw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id C90F83280063;
        Fri, 10 Jul 2020 09:58:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/13] mlxsw: spectrum_matchall: Publish matchall data structures
Date:   Fri, 10 Jul 2020 16:57:03 +0300
Message-Id: <20200710135706.601409-11-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

A following patch introduces offloading of filters attached to blocks bound
to the RED tail_drop qevent. The only classifier that mlxsw will permit in
this role is matchall. mlxsw currently offloads matchall filters used with
clsact qdisc. The data structures used for that offload will come handy for
the qevent offload as well. Publish them in spectrum.h.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 24 +++++++++++++++++++
 .../mellanox/mlxsw/spectrum_matchall.c        | 23 ------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index ab54790d2955..51047b1aa23a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -960,6 +960,30 @@ extern const struct mlxsw_afk_ops mlxsw_sp1_afk_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 
 /* spectrum_matchall.c */
+enum mlxsw_sp_mall_action_type {
+	MLXSW_SP_MALL_ACTION_TYPE_MIRROR,
+	MLXSW_SP_MALL_ACTION_TYPE_SAMPLE,
+	MLXSW_SP_MALL_ACTION_TYPE_TRAP,
+};
+
+struct mlxsw_sp_mall_mirror_entry {
+	const struct net_device *to_dev;
+	int span_id;
+};
+
+struct mlxsw_sp_mall_entry {
+	struct list_head list;
+	unsigned long cookie;
+	unsigned int priority;
+	enum mlxsw_sp_mall_action_type type;
+	bool ingress;
+	union {
+		struct mlxsw_sp_mall_mirror_entry mirror;
+		struct mlxsw_sp_port_sample sample;
+	};
+	struct rcu_head rcu;
+};
+
 int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_flow_block *block,
 			  struct tc_cls_matchall_offload *f);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index f1a44a8eda55..195e28ab8e65 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -10,29 +10,6 @@
 #include "spectrum_span.h"
 #include "reg.h"
 
-enum mlxsw_sp_mall_action_type {
-	MLXSW_SP_MALL_ACTION_TYPE_MIRROR,
-	MLXSW_SP_MALL_ACTION_TYPE_SAMPLE,
-};
-
-struct mlxsw_sp_mall_mirror_entry {
-	const struct net_device *to_dev;
-	int span_id;
-};
-
-struct mlxsw_sp_mall_entry {
-	struct list_head list;
-	unsigned long cookie;
-	unsigned int priority;
-	enum mlxsw_sp_mall_action_type type;
-	bool ingress;
-	union {
-		struct mlxsw_sp_mall_mirror_entry mirror;
-		struct mlxsw_sp_port_sample sample;
-	};
-	struct rcu_head rcu;
-};
-
 static struct mlxsw_sp_mall_entry *
 mlxsw_sp_mall_entry_find(struct mlxsw_sp_flow_block *block, unsigned long cookie)
 {
-- 
2.26.2

