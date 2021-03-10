Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D285333AFB
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhCJLD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:03:58 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59075 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232704AbhCJLDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:03:39 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CD9A35C0101;
        Wed, 10 Mar 2021 06:03:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 06:03:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=i2HmI1uhAvqeBRx54/cSWIoFFTKjsFA2jmw2iGZbh/w=; b=dw+CDsvl
        ww+llL8EUEuM8JP4ivFUyBdXY5oAT/JRhd+jL6f5sagdMJZO9M9V6AF5dX14jSW3
        27v0DKv/TK1IifG+PNqVUm7236YxqafjDMEcL7GV1bcfoYatqNrYiE36UZzaYGcL
        IJYEqarowDM3c8oejcT9r0v1B5wkuu6tkDEo4w6SxqCTtbt0P5f3eVU/jiGvH2YP
        N7gXTCJ3H6iH3LVtG6bDnOHbdcoNizcsCb+K9w43K63h4R7WsDkldrdbtdN/E3Dk
        k1FPp50VS8Zm0de3XwLb0EglMSMK4XqOtt5uOmexWl5XTtsQx0DXqayPIs9622HB
        SsHKqW9ZbYnc0Q==
X-ME-Sender: <xms:iqdIYDsFtVXYeodYerQUzkCbDB_NPp6hPCsWlQD-jUkcaIuF_HPbxQ>
    <xme:iqdIYEdYIGXF01quSB-gYDkuXeSGDuB7Pj9p6BeA5UV56a6Ss7lJOEU0W0cG2t-9V
    lcvJSu3I_8za9o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:iqdIYGy46Qi82QAaOdyekc1JtnmrTIJXW03o9FILYD6qogcMmrAtHg>
    <xmx:iqdIYCP6p7cAo7buGy1hqc03AHCSS3RMXcG8ge07qF9P4K2PW5LhTQ>
    <xmx:iqdIYD-3yEt6oTXK1C6k5JqjIC9KkYAwBMraWheQgM1HzMGYB2qkFg>
    <xmx:iqdIYOnBovvhHAt7WnXCR0CFy7c0HjaP6VlbJyqWDszVKHZOwy0s6g>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 988C81080064;
        Wed, 10 Mar 2021 06:03:36 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: spectrum: Bump minimum FW version to xx.2008.2406
Date:   Wed, 10 Mar 2021 13:02:17 +0200
Message-Id: <20210310110220.2534350-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310110220.2534350-1-idosch@idosch.org>
References: <20210310110220.2534350-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The indicated version fixes the following two issues:

- MIRROR_SAMPLER_ACTION.mirror_probability_rate inverted. This has
  implication for per-flow sampling.

- When adjacency is replaced-if-inactive (RATR.opcode=3), bad parameter
  was reported when replacing an active entry. This breaks offload of
  resilient next-hop groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5d2b965f934f..dbf95e52b341 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -45,7 +45,7 @@
 
 #define MLXSW_SP1_FWREV_MAJOR 13
 #define MLXSW_SP1_FWREV_MINOR 2008
-#define MLXSW_SP1_FWREV_SUBMINOR 2018
+#define MLXSW_SP1_FWREV_SUBMINOR 2406
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
@@ -62,7 +62,7 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 
 #define MLXSW_SP2_FWREV_MAJOR 29
 #define MLXSW_SP2_FWREV_MINOR 2008
-#define MLXSW_SP2_FWREV_SUBMINOR 2018
+#define MLXSW_SP2_FWREV_SUBMINOR 2406
 
 static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	.major = MLXSW_SP2_FWREV_MAJOR,
@@ -77,7 +77,7 @@ static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 
 #define MLXSW_SP3_FWREV_MAJOR 30
 #define MLXSW_SP3_FWREV_MINOR 2008
-#define MLXSW_SP3_FWREV_SUBMINOR 2018
+#define MLXSW_SP3_FWREV_SUBMINOR 2406
 
 static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
 	.major = MLXSW_SP3_FWREV_MAJOR,
-- 
2.29.2

