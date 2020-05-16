Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708301D648E
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgEPWnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:43:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43561 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbgEPWnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:43:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 268025C007B;
        Sat, 16 May 2020 18:43:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 16 May 2020 18:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=slMxEITuyF0bS7jZilQdLGY0+ndyRri0UtYU38CjxUE=; b=IHFMcv2g
        WsUUopdR/JfJc4vrjaE9vn22jAelnzuXAp1H21b1raq9HDr5aLaY/EsBbn0mSTSJ
        NSC5HaHiwmp8kN1ajPwKa5UUcyOIszv8HBkATYV9qJx6HvMyRYPPevr2bzNQyFAX
        y1KTc+z7ny2bPCMOJj7xAw89IJnAcSUUcpYiiISf3B0jhHFEbzpXpJOfpSkO1GvM
        kPMPUvQKgjFepj2+hWppdB+qyV+72kA9C5feD+WAFawL4Dh9o5awUA3lEvwM22hz
        K63y+UlI30FYCFau+JNT0zoeB8uvWFCfVF8I7Wg5InU++qlNJfrgPNavzivxI35h
        opniTt3ZemkUmw==
X-ME-Sender: <xms:mGzAXqvObBcqNrf5PQNONgF4lOFaRjrjIsqqbYEQNr-ttRbmz-wDFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtuddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:mGzAXve8m9IkyyjHwQvOs9FkpbQWEf9sq88I5rji12qPmBgRidby7w>
    <xmx:mGzAXly3KfX1PZn5bG7ygmepMVLd5oLjTfXwUIfG2Z5VSJyPCCZgrQ>
    <xmx:mGzAXlMmM_N60mNRGjYdUlUXloQRPKHgL1FO-dl4ph6RdbgpOXbFBw>
    <xmx:mGzAXgmJu1BzuAV2BoCk_bmtY3rrCvRVVHANSQHQLmE4IHOeyKMYUA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF00A30663A3;
        Sat, 16 May 2020 18:43:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/6] mlxsw: spectrum_trap: Move struct definition out of header file
Date:   Sun, 17 May 2020 01:43:05 +0300
Message-Id: <20200516224310.877237-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516224310.877237-1-idosch@idosch.org>
References: <20200516224310.877237-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

'struct mlxsw_sp_trap_policer_item' is only used in one file, so move it
there.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index fbf714d027d8..634e695b89fa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -12,6 +12,12 @@
 #include "spectrum.h"
 #include "spectrum_trap.h"
 
+struct mlxsw_sp_trap_policer_item {
+	u16 hw_id;
+	u32 id;
+	struct list_head list; /* Member of policer_item_list */
+};
+
 /* All driver-specific traps must be documented in
  * Documentation/networking/devlink/mlxsw.rst
  */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index 8c54897ba173..8a11a2b973f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -15,10 +15,4 @@ struct mlxsw_sp_trap {
 	unsigned long policers_usage[]; /* Usage bitmap */
 };
 
-struct mlxsw_sp_trap_policer_item {
-	u16 hw_id;
-	u32 id;
-	struct list_head list; /* Member of policer_item_list */
-};
-
 #endif
-- 
2.26.2

