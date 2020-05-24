Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD51E037A
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388520AbgEXVvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40973 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388509AbgEXVvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D6985C009F;
        Sun, 24 May 2020 17:51:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=vo1gg7njLk/CgHuRbTkrGztdQill3Zp8Y5h79K1I2OI=; b=tslq9gMK
        10pxN4ZsG9RvobVmrUUrwbEkRRaMGoAdVZWqM9aiLOjKJ6Vnqj6tAFK8yZCyM942
        GjYoTFInh35WzRBHrVaxij5dkvMn91ywAFkexLSwQbG2V8bfc3FTMCRr0HXu/KhI
        cGHo4X7Mq8Pl0XHsM2HgsVhvzxw2w7Idrs/ypTB1npiuA7xs+2P4DLq/iwK27Iw5
        KMVhoKE9n4WE91hRHNVxOcu6uEz4b+qTyP7O5EpC6GLrGaD36A3dFo9MU10nAWqI
        975Topu/K5feD7xz7wRit3c5JnjyECuo+1nwEmT5if+rCMZQj8H11MPxpqxtTb4T
        tOg8FCfyqABM5g==
X-ME-Sender: <xms:a-zKXoggZncUvOov2RJ3uTLTs2rPWXABur11KkfwUU_s7sIKzV0bEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:a-zKXhAmDM1BEdvCnDUEYA7n9YXBF3OHkqPzr7PdHSp5UcQpSjgaSA>
    <xmx:a-zKXgHtfiYh62YR9DEyBUDQd17L21YM5ZUWN0vcL-xSmYkeaIjI-Q>
    <xmx:a-zKXpQ7yQxzqBw3GIkwkv0nMpVDhfjYrU2Wy4V00GHENQdAO3KeyQ>
    <xmx:a-zKXmqlrEX9qGUfDPnDruBq7Es1zSXJsn6jP-vxQ__sR45X7QL8hw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA150306651E;
        Sun, 24 May 2020 17:51:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/11] mlxsw: spectrum: Fix spelling mistake in trap's name
Date:   Mon, 25 May 2020 00:51:07 +0300
Message-Id: <20200524215107.1315526-12-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524215107.1315526-1-idosch@idosch.org>
References: <20200524215107.1315526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Fix incorrect spelling of "advertisement".

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/trap.h     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index d275887bba28..943a24975799 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4080,11 +4080,11 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(IPV6_BGP, TRAP_TO_CPU, BGP, false),
 	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_SOLICITATION, TRAP_TO_CPU, IPV6_ND,
 			  false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_ADVERTISMENT, TRAP_TO_CPU, IPV6_ND,
+	MLXSW_SP_RXL_MARK(L3_IPV6_ROUTER_ADVERTISEMENT, TRAP_TO_CPU, IPV6_ND,
 			  false),
 	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_SOLICITATION, TRAP_TO_CPU,
 			  NEIGH_DISCOVERY, false),
-	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_ADVERTISMENT, TRAP_TO_CPU,
+	MLXSW_SP_RXL_MARK(L3_IPV6_NEIGHBOR_ADVERTISEMENT, TRAP_TO_CPU,
 			  NEIGH_DISCOVERY, false),
 	MLXSW_SP_RXL_MARK(L3_IPV6_REDIRECTION, TRAP_TO_CPU, IPV6_ND, false),
 	MLXSW_SP_RXL_MARK(IPV6_MC_LINK_LOCAL_DEST, TRAP_TO_CPU, ROUTER_EXP,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index fac05433c488..1b89472a0908 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -55,9 +55,9 @@ enum {
 	MLXSW_TRAP_ID_IPV4_BGP = 0x88,
 	MLXSW_TRAP_ID_IPV6_BGP = 0x89,
 	MLXSW_TRAP_ID_L3_IPV6_ROUTER_SOLICITATION = 0x8A,
-	MLXSW_TRAP_ID_L3_IPV6_ROUTER_ADVERTISMENT = 0x8B,
+	MLXSW_TRAP_ID_L3_IPV6_ROUTER_ADVERTISEMENT = 0x8B,
 	MLXSW_TRAP_ID_L3_IPV6_NEIGHBOR_SOLICITATION = 0x8C,
-	MLXSW_TRAP_ID_L3_IPV6_NEIGHBOR_ADVERTISMENT = 0x8D,
+	MLXSW_TRAP_ID_L3_IPV6_NEIGHBOR_ADVERTISEMENT = 0x8D,
 	MLXSW_TRAP_ID_L3_IPV6_REDIRECTION = 0x8E,
 	MLXSW_TRAP_ID_IPV4_DHCP = 0x8F,
 	MLXSW_TRAP_ID_HOST_MISS_IPV4 = 0x90,
-- 
2.26.2

