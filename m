Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53AF4F88C0
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfKLGtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:49:42 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46675 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726988AbfKLGtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:49:40 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 41170220E7;
        Tue, 12 Nov 2019 01:49:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 12 Nov 2019 01:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=vMkeugwO1wUVQnifLj7GLcPE5J7z+plNuFKqj8KQz20=; b=km1M8nwb
        9pYvI0Fc90PJLCQ5Iv7t/JP7GKtFSEee0V1MA3iNEOqDyY4u1ooT95fO2d+9gcpZ
        LFKUzdPcAYg4VaVQE87ArO0XC9H90MdmC3HSp+OLDYLCxnnuVq4Xjzy90qkHS4vx
        4SYjnCQDQkVDK+thirw/qSYrlXMChXy1IIv9pCzLdzU03BUmq9V8zv4wi1X1vjJW
        AMMLP71P82ET61TVNEE3Sc6Chx0kEBSdCX5GzzqBsceceaJkYXArUmy0vnc6t60o
        ufumUXFmRFm78hc/YDYyyee2X1RTK2VtrqrJ3JpdtBKVfgxzeR7TWU4tvNL/L3ZQ
        /kbJlMLC97y07g==
X-ME-Sender: <xms:BFbKXZ9OSI-kRXPUkkiF_YlCdVKKCEjTdlu6rwHjfalHjVIA_vpVog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvkedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:BFbKXZjzxgECMm11IhAwIy3mce6lvZwHd5cTSBwHkAdLD8tHI9rf9Q>
    <xmx:BFbKXddrF_xxDzRkTX0w1f0jgf6z9dTG-yTn441WENYRAFK31vcXCA>
    <xmx:BFbKXaIZO9H6IyDoRzg4MzjzRAYFVOna-4ZQynnioDr2i3nZsy6Ltg>
    <xmx:BFbKXVBezq9Tl9lSDLI2OWXi08omwDVBn1TJN4ySWQlcziTED2sN0w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A706F80059;
        Tue, 12 Nov 2019 01:49:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 7/7] mlxsw: spectrum: Enable EMAD string TLV
Date:   Tue, 12 Nov 2019 08:48:30 +0200
Message-Id: <20191112064830.27002-8-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191112064830.27002-1-idosch@idosch.org>
References: <20191112064830.27002-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Make sure to enable EMAD string TLV only after using the required firmware
version.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 471478eb1d86..556dca328bb5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4894,6 +4894,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	if (err)
 		return err;
 
+	mlxsw_core_emad_string_tlv_enable(mlxsw_core);
+
 	err = mlxsw_sp_base_mac_get(mlxsw_sp);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to get base mac\n");
-- 
2.21.0

