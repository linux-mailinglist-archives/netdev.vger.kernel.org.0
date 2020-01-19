Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F89141DE9
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgASNBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:38 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40265 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727254AbgASNBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3DD6B21A4B;
        Sun, 19 Jan 2020 08:01:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=eEEFIo9aB2CPzeK1vvbAjKYn6oCVRhFgQFaHqwT3l7g=; b=kP+aIpCF
        wWHVQvXsG8D4e4jDn3v27w5QxkuvbbW3IIbu9qD/oIQL0C34W8b/hbTf2oQXL9l7
        iWOwU9Z35oNfpztr4tRhi642cxGaq1vNJzpQGXATxOgBd+BVTKXrajAkopG4r2Rp
        cU2f87WUeVOLd37HyP/ce9lJBpPghm+6lS5OWntnWd0iu33PxTlKvFcBAg1nB1lG
        SrDvgbWl3oDGRAcBDBlZSPpn49X9QWdyvdfOMLSN4cCQDMsuy6TrctBxHs9rPJc9
        hqhm0FtixAiC9j9tJRfk1coOPWmqj6JCx6GKaK8PZtTQKsyXKK/f1rdjv9GkSKgS
        Fp5/Vo7XjpWoiQ==
X-ME-Sender: <xms:MFMkXhF07XaqlUBFbL0SuRl7bZYaAP2NBhtpdsvIoVwf5nmYFlsyNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgephe
X-ME-Proxy: <xmx:MFMkXhHCOQ_j5X7sCP2ljL7Ax94sjSBrASrYNuNcvt45iDaIe_QtxQ>
    <xmx:MFMkXiC3QRJMMYE3U3-aY87QFTG41cioASs8MMW7PIyyv6CaQDJueQ>
    <xmx:MFMkXt0RSv7cTBhRI3pgjF2BshxOr7cR2N7bEk_LGk0O8sH4C6vADQ>
    <xmx:MFMkXsNNSP8IO3f3tlZTWLYz57MD2pnfHo98v_DplPtxY8NY2z29hw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E494D8005A;
        Sun, 19 Jan 2020 08:01:34 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/15] mlxsw: spectrum_trap: Reorder cases according to enum order
Date:   Sun, 19 Jan 2020 15:00:53 +0200
Message-Id: <20200119130100.3179857-9-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Move L3_DROPS case to appear after L2_DROPS case.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 8706821f5851..5ae60eb11a2d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -333,8 +333,8 @@ mlxsw_sp_trap_group_policer_init(struct mlxsw_sp *mlxsw_sp,
 	u32 rate;
 
 	switch (group->id) {
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS:/* fall through */
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS:
+	case DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS: /* fall through */
+	case DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS:
 		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
 		ir_units = MLXSW_REG_QPCR_IR_UNITS_M;
 		is_bytes = false;
-- 
2.24.1

