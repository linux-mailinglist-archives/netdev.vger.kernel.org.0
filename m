Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B624464951
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347856AbhLAIQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:16:48 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37055 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344139AbhLAIQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:44 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B0D8E5C01E1;
        Wed,  1 Dec 2021 03:13:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 01 Dec 2021 03:13:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=c+J6l1Z5bWJvmi5r+1/campL4SjuaTeU5RB5BapYfJ0=; b=YoFWE3ZW
        xqO64CR88maLXXqYoG8Tlzsgq+O8UeNF+ACFs9QsGBWzP4ObIQNtWl1sWnDORdad
        QQW8pI1BRvZzplfd9HWMZ/2qONweP9UswpuEtBwGvZSP4dPOgM9Qaulugk81In8y
        KhPA9cFt2glBmRO6RAgPJLFF2Y13QM77sgjTS9JqBWWznsGQYihnFOp3/T1VluYa
        WLOx5tATdj33y9cjuMuc0E6nJccNZE4pPIjeFKj9Dg9BL8mjWot0/yodT4sBapvM
        e38xDJWiZdsfFJnIIihgnoePBmgDgd1f3Sb0D3wr79iEcuFOJRJ1iRnwiLAn8/QW
        S2n27FzRjyFbvA==
X-ME-Sender: <xms:oC6nYV5s8MQIwr7VMRWJ3wlwbf6L3lzZNMH-lYC5HKb9PRqZnsLxAw>
    <xme:oC6nYS60WI4s17V1GMEHOUB5031SIrVCAa9hsPhiGY7-GJnsnj0a1dKZ8LgbLcI_r
    47YgwZbpJphquE>
X-ME-Received: <xmr:oC6nYcdjbkOWqtogslH5NAG95rClwZ1HJIDt1yBUoEi1Q9mETREyRTeaVTTwgvUAJ45GSxRNf2DFQmMiv8KOGwoRZDF6ooJjQEko7049tYY-Nw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:oC6nYeKx_LXKb_DR-BkbAfUjx5_dfO-1xavhwVfH3fAxN3majsvClg>
    <xmx:oC6nYZKNBLnA4wdgPrimGjSVUek_zGYq2eQ3k-gM7Bg--NPIRJNhZg>
    <xmx:oC6nYXwPoH3q8wtrHB3JZpMQGBqzzcspVBBq5pwfhu7NyGFDSV7J0w>
    <xmx:oC6nYWE4vcyNESsM40pwVI1YrLqzenJ9E83RsQBqtMbTG4Or6NF53w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:18 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: spectrum: Bump minimum FW version to xx.2010.1006
Date:   Wed,  1 Dec 2021 10:12:31 +0200
Message-Id: <20211201081240.3767366-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add latest verified version of Nvidia Spectrum-family switch firmware,
for Spectrum (13.2010.1006), Spectrum-2 (29.2010.1006) and
Spectrum-3 (30.2010.1006).

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f1ed7660b0b5..08ae099de147 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -46,8 +46,8 @@
 #include "spectrum_trap.h"
 
 #define MLXSW_SP1_FWREV_MAJOR 13
-#define MLXSW_SP1_FWREV_MINOR 2008
-#define MLXSW_SP1_FWREV_SUBMINOR 3326
+#define MLXSW_SP1_FWREV_MINOR 2010
+#define MLXSW_SP1_FWREV_SUBMINOR 1006
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
@@ -63,8 +63,8 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 	"." __stringify(MLXSW_SP1_FWREV_SUBMINOR) ".mfa2"
 
 #define MLXSW_SP2_FWREV_MAJOR 29
-#define MLXSW_SP2_FWREV_MINOR 2008
-#define MLXSW_SP2_FWREV_SUBMINOR 3326
+#define MLXSW_SP2_FWREV_MINOR 2010
+#define MLXSW_SP2_FWREV_SUBMINOR 1006
 
 static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	.major = MLXSW_SP2_FWREV_MAJOR,
@@ -78,8 +78,8 @@ static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	"." __stringify(MLXSW_SP2_FWREV_SUBMINOR) ".mfa2"
 
 #define MLXSW_SP3_FWREV_MAJOR 30
-#define MLXSW_SP3_FWREV_MINOR 2008
-#define MLXSW_SP3_FWREV_SUBMINOR 3326
+#define MLXSW_SP3_FWREV_MINOR 2010
+#define MLXSW_SP3_FWREV_SUBMINOR 1006
 
 static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
 	.major = MLXSW_SP3_FWREV_MAJOR,
-- 
2.31.1

