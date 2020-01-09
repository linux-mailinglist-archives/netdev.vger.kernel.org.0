Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A73E13610D
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgAIT1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:27:42 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39981 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729872AbgAIT1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:27:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E7E5421FBA;
        Thu,  9 Jan 2020 14:27:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 09 Jan 2020 14:27:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=UfBKAJUj1DJ8kXAWzftsCLNOuLyKqCg/Pdd5QSNuOzM=; b=mHMOe/fL
        GGxfb1EVX18fTFYCFosITWZmmhyTDe0tOQ2971dTB+bKOHpEpFq6gsv/WmTV7MLw
        op2P9ek7k72WFmL/OIW/w/m1Wgbtxm6dpxOu0bsbGljjVnwVeWySEjo2aUz44oAN
        ODYXYBhkai2mPoDAAbXbSMpCJzP2NHq/eAeQDXkB3Wls26uvgw8fDcbSh2i/34Dv
        1rNG3Podiy9cnjzVCWqYU62KPlP4SBNluGWj5kQCuMOlApLyMu5CtbdsgUM9K9QJ
        dzpxfhvsf/goO+Tqee5thqugjexdDPfaZMRFIwYbGXnGuLER13HIKcXYWT/1o626
        rJ6YEZhgD34Jbw==
X-ME-Sender: <xms:rH4XXhfTazkzU3n4nqBKQci_tWXaOrqR9ro337qV_mxSwGfuUpDFJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiuddgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:rH4XXsmBQzT5YFBeMXi-OKPCG_1DVGy0Fn6a26SjPNpsb677pV9gdg>
    <xmx:rH4XXmjNhq_yu9uhAZXU6rvq2ztUwZK8wFcyzY_fSC_mkVYAQvTyUw>
    <xmx:rH4XXupnmwYNRG_Ecuk7bIQCUhb-W-Z6Ft02r8ax5opeT-Yx6ODOYw>
    <xmx:rH4XXs80EEvH9F4CEhuWF6aIbYQXGIvMnU4IryMbm3Ia70lVlOLdcw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6A2A30600A8;
        Thu,  9 Jan 2020 14:27:39 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] mlxsw: spectrum: Update firmware version to xx.2000.2714
Date:   Thu,  9 Jan 2020 21:27:21 +0200
Message-Id: <20200109192722.297496-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109192722.297496-1-idosch@idosch.org>
References: <20200109192722.297496-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The version adds support for 2x50 Gb/s port split option on SN3800
systems.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 431c3765b545..38d16042e7a8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -49,7 +49,7 @@
 
 #define MLXSW_SP1_FWREV_MAJOR 13
 #define MLXSW_SP1_FWREV_MINOR 2000
-#define MLXSW_SP1_FWREV_SUBMINOR 2308
+#define MLXSW_SP1_FWREV_SUBMINOR 2714
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
@@ -66,7 +66,7 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 
 #define MLXSW_SP2_FWREV_MAJOR 29
 #define MLXSW_SP2_FWREV_MINOR 2000
-#define MLXSW_SP2_FWREV_SUBMINOR 2308
+#define MLXSW_SP2_FWREV_SUBMINOR 2714
 
 static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	.major = MLXSW_SP2_FWREV_MAJOR,
-- 
2.24.1

