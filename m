Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A1620E091
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389788AbgF2UrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:25 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54545 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389641AbgF2UrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id CDDCD580121;
        Mon, 29 Jun 2020 16:47:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jun 2020 16:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=2jzBQKIAvH1EiUtUjcHrwI52+J4IBRqhm577ffhml6I=; b=YGua8hqS
        OrFcDocYmVi29EI/RopmVh9GSUnowDGXqDqU4ZWRlFjYTpfsACc+ZwCqAd6GdwXy
        hzPlBxweLqyNNa6DAGQAgFOw7EZyjurSAofZMJqdKNkIUBG1RyG3MFObVL0Zu6jx
        rthe0ws5oGKk+qQTjEyhh69TkJX9rdPn/VDrTmqTmJUCMF9MYa/RKGHEACxko4Wl
        k8MI2uF2WPNevXaBd4amHULXVFy95SFjWwrPnErE8IvVyXDU4qkmbiBDS++hANu4
        B7tJhI+pPxjHCZ/Kef/lKIRLhLG/OqSVJXDiINqFaOu/VIWMel2Yj2wcsSKbzFw3
        D7De59lNlW250w==
X-ME-Sender: <xms:WFP6XuCWJa0FcpQ7oMNHnQX6imrlbC2PLJ_2nbeNMmoQ8-0vH01X4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WFP6XoiZBB1zssE1OOlc2ds30AIsnsomCueN0lxXA1JaNZg0WwMcBg>
    <xmx:WFP6Xhnnpe0WcySdlvTbN-FdWHDM3w8-6kW-Anfq7UU4BxRwZtI9Pg>
    <xmx:WFP6XsxHMzv7Cg6XiZ48qwah_M-FWCfgy1DnFQu7DacPc2VBwl_XsA>
    <xmx:WFP6XuHH8PFKriMgIG6HmTf0Me9xL8OjEV4tUAtBgvJonFJ6TWCstQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B3D93280066;
        Mon, 29 Jun 2020 16:47:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 01/10] mlxsw: spectrum_dcb: Rename mlxsw_sp_port_headroom_set()
Date:   Mon, 29 Jun 2020 23:46:12 +0300
Message-Id: <20200629204621.377239-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629204621.377239-1-idosch@idosch.org>
References: <20200629204621.377239-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

mlxsw_sp_port_headroom_set() is defined twice - in spectrum.c and in
spectrum_dcb.c, with different arguments and different implementation
but the name is same.

Rename mlxsw_sp_port_headroom_set() to mlxsw_sp_port_headroom_ets_set()
in order to allow using the second function in several files, and not
only as static function in spectrum.c.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index f8e3d635b9e2..0d3fb2e51ea5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -110,8 +110,8 @@ static int mlxsw_sp_port_pg_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
 }
 
-static int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct ieee_ets *ets)
+static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
+					  struct ieee_ets *ets)
 {
 	bool pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
 	struct ieee_ets *my_ets = mlxsw_sp_port->dcb.ets;
@@ -180,7 +180,7 @@ static int __mlxsw_sp_dcbnl_ieee_setets(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 
 	/* Ingress configuration. */
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, ets);
+	err = mlxsw_sp_port_headroom_ets_set(mlxsw_sp_port, ets);
 	if (err)
 		goto err_port_headroom_set;
 
-- 
2.26.2

