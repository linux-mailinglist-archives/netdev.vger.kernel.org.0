Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3947137D
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbfGWH6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:58:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53609 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730810AbfGWH63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 03:58:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D78521FA9;
        Tue, 23 Jul 2019 03:58:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Jul 2019 03:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=2tVTNCcMLZ2oMmlMUBZMs7thCLii0Szq273tgq8Cxok=; b=rgO6NcvW
        1RxkgkjIFKrVzcDkhmK1PAEJsB/I1fBA7VCp1oCGNhtYqNNILXuSivbwYw9QeTEm
        CaT3rOPd47a8YP7upsD15RL31D0tcqaOTqeRcD8IVTciWdgura0d//8cdKNSPl+J
        4By4jjtomXKoWg5NH0EGN+gYO9cKYFrlGuJguKZW1ZadilrpCh1u5iyafgWVCHC/
        EEs6QO3BuqgXvT3ibPq2GexX4a+2kBOupAONGvJhL5Q1o/wtPqe9BD2YLXtRl3Cz
        Q0DUi29Aw5FIfSFjHBkBkm7kDmfXjJSyZtV18pGqNRh05VhkVhNm3A2WK2G3JvUZ
        jynlamGuHvI+Uw==
X-ME-Sender: <xms:JL42XUfGGfHRSuQSYsCD1ujuEH9mp9pUPYBAdHyeX0-klKqm-jPf_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeejgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:JL42XSJMvqT9BfLYbufU90LG_6vIn0FDLZfoklVrnSOqXqqwvf6ZgA>
    <xmx:JL42XYkTVmY8Ph3fezIMr1f7BRyddycM7CmHg7hrlbbGNaVNf0e2_g>
    <xmx:JL42XVUXT-ilpQ7_Ya-_v1_9CXL-csW5OM_GDbZ5croQ3RO-T3viAg>
    <xmx:Jb42XZOMDqLP1onLTehm5O4xCeuz-l5H0Z3qPt37LePftB9QbLvJTQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A679D380084;
        Tue, 23 Jul 2019 03:58:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] mlxsw: spectrum: Expose KVD size for Spectrum-2
Date:   Tue, 23 Jul 2019 10:57:41 +0300
Message-Id: <20190723075742.29029-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723075742.29029-1-idosch@idosch.org>
References: <20190723075742.29029-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Unlike Spectrum-1, the KVD (Key-value database) of Spectrum-2 is not
partitioned, so only expose the entire KVD size. This enables users to
query the total size of the KVD.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 22 ++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 650638152bbc..7e8a54068d92 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5026,6 +5026,26 @@ static int mlxsw_sp1_resources_kvd_register(struct mlxsw_core *mlxsw_core)
 	return 0;
 }
 
+static int mlxsw_sp2_resources_kvd_register(struct mlxsw_core *mlxsw_core)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	struct devlink_resource_size_params kvd_size_params;
+	u32 kvd_size;
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, KVD_SIZE))
+		return -EIO;
+
+	kvd_size = MLXSW_CORE_RES_GET(mlxsw_core, KVD_SIZE);
+	devlink_resource_size_params_init(&kvd_size_params, kvd_size, kvd_size,
+					  MLXSW_SP_KVD_GRANULARITY,
+					  DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	return devlink_resource_register(devlink, MLXSW_SP_RESOURCE_NAME_KVD,
+					 kvd_size, MLXSW_SP_RESOURCE_KVD,
+					 DEVLINK_RESOURCE_ID_PARENT_TOP,
+					 &kvd_size_params);
+}
+
 static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 {
 	return mlxsw_sp1_resources_kvd_register(mlxsw_core);
@@ -5033,7 +5053,7 @@ static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 
 static int mlxsw_sp2_resources_register(struct mlxsw_core *mlxsw_core)
 {
-	return 0;
+	return mlxsw_sp2_resources_kvd_register(mlxsw_core);
 }
 
 static int mlxsw_sp_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
-- 
2.21.0

