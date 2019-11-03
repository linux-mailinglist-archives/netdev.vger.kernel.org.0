Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24324ED29A
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 09:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfKCIgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 03:36:36 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47377 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727558AbfKCIgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 03:36:35 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ACA8020E72;
        Sun,  3 Nov 2019 03:36:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 03 Nov 2019 03:36:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Dc9fieABN5BNUNCiAiHjdnoQG/NRuHEXpbcX7zh2j+M=; b=JJfK7pXk
        ordxH4kE5EHzYStz9uc6u/bINLKjpS7E5DJIhlunPWw4BrpxQKj87xxO3U2BMeED
        LTFI/X3OTpae4tq9fhkoyxW7WIMneXHZVbgLXwa/MqPEGRqaPbFSUzrW3wTTbIzA
        A+9JqnvmeCuO6v4m5O2YuFlwzCeuhLnC12z90TZyXr25+CJAR6Tz+nMbPcd4/vJW
        AwEGUlP0/oPxpso3FOMRnhkPuxq7TTNPPn5OGczYsP5yyrHiyxV7Pp2GwQz5DHV1
        rA8xllf66Tb61kw3TCptKumWCGW07of6cLQpyn8A2xjUpBI4cP0GeC4/NhcHO9C6
        jlKQusF+8icUAQ==
X-ME-Sender: <xms:kpG-XQ95oJQjJaZSg4Wp4DrFj-fu3RjoBZeJJMQvJFKuO7M_CX7zDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddutddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:kpG-XeEY1piCrIt5-HKOBtOs7o-z9Ljl3xlx_6B1jXlQTAHEu5zAqA>
    <xmx:kpG-XWOkG5YsSbIO2YznD-1__ZoGyxCu9YuQMCWnI42Vrvh7uRg6NA>
    <xmx:kpG-XQeDzMfbNYRCFZ9gRm6Dt3GPR6Hvm_1H8Jtj9VzE290JpMVbDw>
    <xmx:kpG-Xdb2eSCOvjLj_3ChGw-Q8i8CtiLNY_TapGhSGFAkqDDI1bfFlQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 536FD3060060;
        Sun,  3 Nov 2019 03:36:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/6] mlxsw: spectrum: Enable EMAD string TLV
Date:   Sun,  3 Nov 2019 10:35:54 +0200
Message-Id: <20191103083554.6317-7-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191103083554.6317-1-idosch@idosch.org>
References: <20191103083554.6317-1-idosch@idosch.org>
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
index ea4cc2aa99e0..5f250b4cc662 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4897,6 +4897,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	if (err)
 		return err;
 
+	mlxsw_core_emad_string_tlv_enable(mlxsw_core);
+
 	err = mlxsw_sp_base_mac_get(mlxsw_sp);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to get base mac\n");
-- 
2.21.0

