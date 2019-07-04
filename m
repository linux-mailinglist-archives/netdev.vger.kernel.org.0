Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFAE5F345
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfGDHJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:09:13 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52517 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727413AbfGDHJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:09:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CE05421F14;
        Thu,  4 Jul 2019 03:09:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 03:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=xlk7IfGojOKPJHTA5LRy/LVVcAA7Mg/sqz8SWwTdvQQ=; b=1rIG4IkN
        wzQkNGknebvB/HgDEk0v7C1Dz/XS3fYDaaPyAwgcO7neXPjE7WOId23zNWiUGFBS
        i5dmiMI/rksQ0RyNdancj7MKSqlj8dtLwTBGUlL13j5IJSFteNY9OWH3VXF+Gt1C
        7FLiI6uJBNSOT/WVkVT3yOJPbu0/Iz5qakCOF2cxBzkiRPsnSRv1K4CM7uqwZXYc
        SV0M//PrjjPfGBpv7hwN5l5YpIwjYsr0jh7Ff2vB30iZp2XAS4koRtzjpUp3LSUY
        KxjNZ3YIj7SfD8VpPWZbVsSlnrpt7GGGBwziRHKdYk+OhQ7trlfl4DZhWSj0n4xt
        NcfUJlPsENQ4GQ==
X-ME-Sender: <xms:FqYdXd8IcktnMZOA02NVQex-xw7weMlQ4XsynAmTpOUqRG35p4dqnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedugdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:FqYdXZWj5MSTfMg6C1-sn1DzwcVluqum63lk8otoN7xICFNqw33y4g>
    <xmx:FqYdXWPQSYB-Xr09XUt_hd1IuBWjku1sBmMtp92lLiCA4aEu18w1yA>
    <xmx:FqYdXbwRC4q2jJLYfbppn7MTGly87Ip1JLSN1ymlbhoJjreBUXJ7Zg>
    <xmx:FqYdXVPx89C48sUf8zIqzPGrjARECZA9qA3WE-9C41hjQixhOZYGVQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 29D9E380084;
        Thu,  4 Jul 2019 03:09:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/8] mlxsw: spectrum_ptp: Apply the PTP shaper enable/disable logic
Date:   Thu,  4 Jul 2019 10:07:40 +0300
Message-Id: <20190704070740.302-9-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190704070740.302-1-idosch@idosch.org>
References: <20190704070740.302-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Apply by filling the PTP shaper parameters array.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 0f7c4bd22a45..bd9c2bc2d5d6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -767,6 +767,50 @@ struct mlxsw_sp1_ptp_shaper_params {
 
 static const struct mlxsw_sp1_ptp_shaper_params
 mlxsw_sp1_ptp_shaper_params[] = {
+	{
+		.ethtool_speed		= SPEED_100,
+		.port_speed		= MLXSW_REG_QPSC_PORT_SPEED_100M,
+		.shaper_time_exp	= 4,
+		.shaper_time_mantissa	= 12,
+		.shaper_inc		= 9,
+		.shaper_bs		= 1,
+		.port_to_shaper_credits	= 1,
+		.ing_timestamp_inc	= -313,
+		.egr_timestamp_inc	= 313,
+	},
+	{
+		.ethtool_speed		= SPEED_1000,
+		.port_speed		= MLXSW_REG_QPSC_PORT_SPEED_1G,
+		.shaper_time_exp	= 0,
+		.shaper_time_mantissa	= 12,
+		.shaper_inc		= 6,
+		.shaper_bs		= 0,
+		.port_to_shaper_credits	= 1,
+		.ing_timestamp_inc	= -35,
+		.egr_timestamp_inc	= 35,
+	},
+	{
+		.ethtool_speed		= SPEED_10000,
+		.port_speed		= MLXSW_REG_QPSC_PORT_SPEED_10G,
+		.shaper_time_exp	= 0,
+		.shaper_time_mantissa	= 2,
+		.shaper_inc		= 14,
+		.shaper_bs		= 1,
+		.port_to_shaper_credits	= 1,
+		.ing_timestamp_inc	= -11,
+		.egr_timestamp_inc	= 11,
+	},
+	{
+		.ethtool_speed		= SPEED_25000,
+		.port_speed		= MLXSW_REG_QPSC_PORT_SPEED_25G,
+		.shaper_time_exp	= 0,
+		.shaper_time_mantissa	= 0,
+		.shaper_inc		= 11,
+		.shaper_bs		= 1,
+		.port_to_shaper_credits	= 1,
+		.ing_timestamp_inc	= -14,
+		.egr_timestamp_inc	= 14,
+	},
 };
 
 #define MLXSW_SP1_PTP_SHAPER_PARAMS_LEN ARRAY_SIZE(mlxsw_sp1_ptp_shaper_params)
-- 
2.20.1

