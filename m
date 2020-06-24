Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B157D206EDD
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390374AbgFXIUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:20:25 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:38301 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390368AbgFXIUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:20:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 380CC58051A;
        Wed, 24 Jun 2020 04:20:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 24 Jun 2020 04:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=2jzBQKIAvH1EiUtUjcHrwI52+J4IBRqhm577ffhml6I=; b=paiYsbOD
        m1Zacf4qfJ/kpZAYcVLl5Mbz48Xwf4kpwwZxQ6rPTUTGl/skV2KPPkeC2HAuVas4
        v5KPDQ4/xOYtiE8D8Wa1giikz3QM4k3kLELHiDgmLqYdQz6h8g81OuSnf+ITeSPS
        POibii0KKJ/Wo4lkWcnnAOfHRGVWyZRki2zb1j7T++gSj8v8S2bgw2QfpalFkLwO
        F6T0jhoAuFgsb34J79CtBd5KcEAstz43QQ1X8YTmzYyeyllb1ram9lHfQia7Ov7E
        ornajlK4gCTyf5VnPqvuewwoXL9waA7/ISoAApMrYkZ4TQ31VxZuKtWG7k0fiKo8
        Lq+2ZLPnuWQxlw==
X-ME-Sender: <xms:wwzzXu6UVh-KIFX1uxqD9jwLi_VQi5e_hhovb9K19jA8e8h_804Gxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wwzzXn5ZCRl9g4HjUGufZLEo-IGVDRRD1TQMnNjkXwcIpMPXWKkFFA>
    <xmx:wwzzXtem6sruZNDv60DC7VT02mhwM-v7xwfcTI-IOtx7mNTkhOlQHA>
    <xmx:wwzzXrKf5bxZjoDBZPRJ3IQH73SmZh-NoSbjtazl5OP1INKgnXa7lg>
    <xmx:wwzzXh_z_MvaDD7Bh3ENku5oQuRNCAPSYpl7f--vbx4LXkmovRWGAg>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 014133067626;
        Wed, 24 Jun 2020 04:20:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/10] mlxsw: spectrum_dcb: Rename mlxsw_sp_port_headroom_set()
Date:   Wed, 24 Jun 2020 11:19:14 +0300
Message-Id: <20200624081923.89483-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624081923.89483-1-idosch@idosch.org>
References: <20200624081923.89483-1-idosch@idosch.org>
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

