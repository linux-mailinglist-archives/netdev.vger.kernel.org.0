Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF82E993D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 10:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfJ3JfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 05:35:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52549 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbfJ3JfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 05:35:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CEDFE21A7B;
        Wed, 30 Oct 2019 05:35:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Oct 2019 05:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Wzk4n39A1qkwO+y5TomPTuH7SbW3bz2Z6z4SkpVuzw0=; b=dP8dZHGf
        A8vPpyxWoMb2O8FK4SHKyTkPNOdLXRJTkibu5pt1+VT3zKlvXpp5BkMc0iKemiXM
        aHmjVBd35L/1V7JdpjXPecBZ/slf35Tx7oHSho5QJkadFqyMa7OtZLLvoU0YKRmT
        j20y5RUHhp3f+vr9iMa5wssh6nnH0pRKuyI7XUzXYbSglVJzDyHwgwzZ/feyge4P
        i06+QsD71alCOxjAtv3hyITSjsilLcNtkn8AuaLnwJZYPAGiZOIUt9Feqv9mTUet
        2dqe3/VZ5OureBcjZM7tfe7ClVxdOU+u7JN/XK/njyXtCxoHMFUf66u+DLt5IAFd
        qcOB3dFDBeJJxg==
X-ME-Sender: <xms:Slm5XfqUmKQWKXEAuzeimKX0l4LPIe2BDq9k264_IoP4k8Qgm1ql2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:Slm5XUgmRMNaIXcdd46IQrZ8A_NJhP0rQ_LNkj-ZTKyuhOpeo1ju3A>
    <xmx:Slm5XWZIL-rvTjBt2kDszIvNiTpuFh6FH-a9pgJT_FYh3MI37gvTgQ>
    <xmx:Slm5XUm1NDPbwCJTSbh8g4JthvG60w5y6LfoiEsaH_ppNScAYX7YBw>
    <xmx:Slm5XbQwTQX2IqslHHELi0Pl5FJKHPqy7KTsQ--Vx-cLvem5E5c7LA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA660306005B;
        Wed, 30 Oct 2019 05:35:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 3/4] mlxsw: Bump firmware version to 13.2000.2308
Date:   Wed, 30 Oct 2019 11:34:50 +0200
Message-Id: <20191030093451.26325-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030093451.26325-1-idosch@idosch.org>
References: <20191030093451.26325-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The version adds support for querying port module type. It will be used
by a followup patch set from Jiri to make port split code more generic.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1275d21e8fbd..8a797fad2d56 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -48,7 +48,7 @@
 
 #define MLXSW_SP1_FWREV_MAJOR 13
 #define MLXSW_SP1_FWREV_MINOR 2000
-#define MLXSW_SP1_FWREV_SUBMINOR 1886
+#define MLXSW_SP1_FWREV_SUBMINOR 2308
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
-- 
2.21.0

