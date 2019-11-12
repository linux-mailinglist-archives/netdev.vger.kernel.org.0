Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF386F88BB
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfKLGtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:49:33 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60745 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbfKLGtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:49:33 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 84711220F4;
        Tue, 12 Nov 2019 01:49:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 12 Nov 2019 01:49:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Hvl5T280L543cVtumFgK4WrNpjjW8IgwrfRoth8Nudg=; b=iPxopF8i
        yG2BtJH3TNlADwU6oTb+dMZBauxXTnctagCa0ymNYNNANLxKA4oMUPibShEdAX9O
        KSU9CUEeuQcGTF/tlVqj9SmhoLE/ZI080D8M0aWdMcT+Prv3P/cvjdtM9l5nF1hS
        fOOFVDl+OPCgMiKRDjnEBCWVVoS9mSNvibD0jj/cViTmgpPc0+GV0Lc9SoW+Oovz
        QYORm/h+Dg/bG9gbbu3hcg2Lf3HGCpKdW4iv54hIygUue4gpZz8HNV38+TzBb7pO
        AiwoDBZUb6UwyalIAzeY6PAEbeM3BHisAQHzjZ9nIOIzqpbDBTLTPsyUHl/2gKqr
        9+CIclBTuu/v/w==
X-ME-Sender: <xms:_FXKXRhuJXSKph6Ja5QYe3ETdxWENjnUFaegodXAahxR6cRrdDogSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvkedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:_FXKXeOAayXiPdPShkn-Up21HMK9ROO0u2DtL1Ydx9YOxs1IwLXhCw>
    <xmx:_FXKXcqUULnmZ7RD2YPfy3V-CuwEmTTMCiXjwwjeqd-zvwRYquvtQA>
    <xmx:_FXKXQ5crQVh0BtAXf3Jzxcad1GxcQo40XcHn5pjlNiQ6S7wphLRnA>
    <xmx:_FXKXe5o5okzU9H0INk7yQp83qeT691VBnYpPRBc3K-ZWR4KkoGNAA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E70EB80065;
        Tue, 12 Nov 2019 01:49:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 2/7] mlxsw: emad: Remove deprecated EMAD TLVs
Date:   Tue, 12 Nov 2019 08:48:25 +0200
Message-Id: <20191112064830.27002-3-idosch@idosch.org>
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

Remove deprecated EMAD TLVs.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/emad.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/emad.h b/drivers/net/ethernet/mellanox/mlxsw/emad.h
index a33b896f4bb8..5d7c78419fa7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/emad.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/emad.h
@@ -19,10 +19,7 @@
 enum {
 	MLXSW_EMAD_TLV_TYPE_END,
 	MLXSW_EMAD_TLV_TYPE_OP,
-	MLXSW_EMAD_TLV_TYPE_DR,
-	MLXSW_EMAD_TLV_TYPE_REG,
-	MLXSW_EMAD_TLV_TYPE_USERDATA,
-	MLXSW_EMAD_TLV_TYPE_OOBETH,
+	MLXSW_EMAD_TLV_TYPE_REG = 0x3,
 };
 
 /* OP TLV */
-- 
2.21.0

