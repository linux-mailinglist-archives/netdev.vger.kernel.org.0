Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B082B1F92
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgKMQHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:07:00 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47961 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgKMQG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CD3195C0153;
        Fri, 13 Nov 2020 11:06:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=uRMMFJkMI1teWhT1RdmzlGuUZ9TaHLP179Mn3QHg5EI=; b=f/eDYBBa
        fFPsaM/QgOokmlUm05wyvKvrUpzIYERwUragcaFS28ndLw1E7QE1P7vwlkPFAKBc
        b7mfUVVgQ/8NYxanI7m7XdOsQjbjvNYEDewcyYeBim8qWSNKKpYnQJaRzAkk6L9/
        2uRwljbnMWb391maSBdN/iz00/zSpycDv2wC9Ey9mkme7L3nzd71EIjugLbM0x8G
        rRgL5YE8q4ZhVHJ8Kjd89mdWHvWJd0m8dTyKzTKDDuoyzOHn1MoPiH5W8c3zcl8z
        Dwr9o99Hyp+miqTDNdLOwyAlyKp23SYANuibNlLwwaycb1UpKRlevop2s3NCj7NB
        8nODUjJG55U8Cw==
X-ME-Sender: <xms:Ia-uX6awljS7BfenWOSLgVYwM_aS3ncV69L_Uv8TnnYVRzMi1r6mDA>
    <xme:Ia-uX9Z23Nu4VH-ic7LC-U9Na8Y0h7eBIEtHE4Qasrek-ixg_p2JuW01j2ef8loRU
    KHUoRKrpH15iGI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Ia-uX081S8iEngjHiiW1xvkNLK9JlCQoH0lgfNit5F8eBUlFuBMQPw>
    <xmx:Ia-uX8oYosW8A8VMA2ynZMOg3oXJbUPIw7US4_lEpUuYZ7Imny5Kyw>
    <xmx:Ia-uX1rOxQqxDFnRfR9wvC3aeQGF56yNMNUaN6V6MAkNYDIEuq71Bw>
    <xmx:Ia-uX8Uq9fooiQjiI6mhjOIyYA0JCe39BaKZDEXSi5ODWHoR9cebkA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id C48A9328005D;
        Fri, 13 Nov 2020 11:06:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/15] mlxsw: spectrum_router: Remove unused argument from mlxsw_sp_nexthop6_type_init()
Date:   Fri, 13 Nov 2020 18:05:56 +0200
Message-Id: <20201113160559.22148-13-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Remove it as it is unused.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 77be06b703bc..49b7b9294684 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5352,7 +5352,6 @@ static bool mlxsw_sp_nexthop6_ipip_type(const struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_nexthop6_type_init(struct mlxsw_sp *mlxsw_sp,
-				       struct mlxsw_sp_nexthop_group *nh_grp,
 				       struct mlxsw_sp_nexthop *nh,
 				       const struct net_device *dev)
 {
@@ -5415,7 +5414,7 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	nh->ifindex = dev->ifindex;
 
-	return mlxsw_sp_nexthop6_type_init(mlxsw_sp, nh_grp, nh, dev);
+	return mlxsw_sp_nexthop6_type_init(mlxsw_sp, nh, dev);
 }
 
 static void mlxsw_sp_nexthop6_fini(struct mlxsw_sp *mlxsw_sp,
-- 
2.28.0

