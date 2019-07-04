Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C979A5F33E
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfGDHJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:09:02 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41825 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727326AbfGDHJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:09:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E5A6221F4C;
        Thu,  4 Jul 2019 03:09:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 03:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=f3VLpPuvViUpwGMzu2BiYz2BO7a7Z7WQyvXl24Igdhw=; b=RI7KaEIR
        V3rLHbBYSmUkUcLkWd80oSm3+2TPUS2a5BlcwPVKub8+e3IFUoxYouHnk75l7Vj2
        kajiBLJCo/onG2eP/NgDABGF0SB0VvoCuifSYyGCaKtYJA6YFurNW1hs+eb/uw4q
        ttL4UAbbJibG8SYxMeWaw4/hMVmk//Z/QSp7L8yQnbfmCFuzaxkpprdJkX/2rgmr
        JcQOk3O1lJeKtKxxkWsTLnEhy3lyKLWTakIJyTDba5FYoyu76UCYe4rh6cwQcBKK
        KX6ZWsNIgZHMK1enKDSw+SS4VXDb01zdKO7blbgvDu9w0TRYgHIYNRxiOD1aYKxd
        xzrT6e7Eh4lotA==
X-ME-Sender: <xms:DKYdXYAjdmrakpTn9QbprnaXjmf7U-D4PD_j6uerjA6jiYX3sM5RaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedugdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:DKYdXewSV9Oq2XT09Iw-htfp6PcWjr3gTULZ5P-UlvvDcoqn0Jxemw>
    <xmx:DKYdXWkDThJlCiYE6tNt66OF-k2oNwgkfSV9HiFf8YizQiFqKpIAjA>
    <xmx:DKYdXTHTEiSD-zYZHvVSB4BqLuJHT8gR6YPrJvhad325zsu-03B-ng>
    <xmx:DKYdXTqT5KHH74AYKM29CKKBwYPPSHD6V9eOZ_7zcp2tq9FBAi-b3w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 40650380084;
        Thu,  4 Jul 2019 03:08:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/8] mlxsw: spectrum: Add note about the PTP shaper
Date:   Thu,  4 Jul 2019 10:07:34 +0300
Message-Id: <20190704070740.302-3-idosch@idosch.org>
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

Add note about disabling the PTP shaper when calling to
mlxsw_sp_port_ets_maxrate_set().

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 755b14b82c8f..67133ba53015 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3457,8 +3457,9 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_port *mlxsw_sp_port)
 			return err;
 	}
 
-	/* Make sure the max shaper is disabled in all hierarchies that
-	 * support it.
+	/* Make sure the max shaper is disabled in all hierarchies that support
+	 * it. Note that this disables ptps (PTP shaper), but that is intended
+	 * for the initial configuration.
 	 */
 	err = mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
 					    MLXSW_REG_QEEC_HIERARCY_PORT, 0, 0,
-- 
2.20.1

