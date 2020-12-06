Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBE62D01A0
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgLFIYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:24:47 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:57873 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgLFIYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 03:24:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id BE4A7C5C;
        Sun,  6 Dec 2020 03:23:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Dec 2020 03:23:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=EcxJeEocIilW+KANAVW5ZU5SWK4zTVFbe3thPscQWCQ=; b=bKaQwv8i
        syStTOYpXQr0trCzT+ggb+fhp3M/JesNvBeZPjCUAewwxJwiXpbooYgFmifhokew
        lh77M/AUxpoomyeHr1RLNeTzkubRSsHXKNXwvfzAUTpFR0xpVTG7VMJuNyWP/b5H
        7nbhDTTvhEyH0gqxuOegDBtO38jddT70wSEpgcLtioB9XsrmvdqCrxkduFJY+Rs9
        syP4br9i3I7VSzeVunGhBNB4JIQJiI3b9Y+o01xTj5EIaT98b9a/nTIiYm7hjpds
        faY0Kypt3enbDiAwww7ZaWBQr6GKUvzM6UoogKGAcX2QK9STkfAbKUm/x+0GUbh+
        nbC7eiliAdumMw==
X-ME-Sender: <xms:5JTMX3pyYsEIA3pbm-3me_rSXA_fHVyEDhPIYcS2qHWciMa5cK_WSQ>
    <xme:5JTMXxp2MmY9TGGsWwDqgE_4-qK1KXJIMV6qAk73C1HYF2twUZMvrMB9Wd91gwkd8
    rEbCkM15HgyORI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddv
    feegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5JTMX0P97zyxHYFtJoHxkUMCAZtLe8popvfBVCj0VpoODiWzM12uPA>
    <xmx:5JTMX65zYGjEIgd4_SuZrmAkvLd0GUqxqZPClXw12k5RbYwJb2EauA>
    <xmx:5JTMX25Zq93jl_ByigZ3oRDh75_ZbuR2IMq0LSz8F3FNU0yGHunPZQ>
    <xmx:5JTMX8lGsgvQPEGSSuSEX-hyXdTG4TA4Gw5j_ozdzkXnTFBd3jGyYQ>
Received: from shredder.lan (igld-84-229-154-234.inter.net.il [84.229.154.234])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16169108005B;
        Sun,  6 Dec 2020 03:22:58 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/7] mlxsw: spectrum: Bump minimum FW version to xx.2008.2018
Date:   Sun,  6 Dec 2020 10:22:26 +0200
Message-Id: <20201206082227.1857042-7-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201206082227.1857042-1-idosch@idosch.org>
References: <20201206082227.1857042-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The indicated version fixes an issue whereby the MOMTE register would by
default enable mirroring of ECN-marked traffic from all traffic classes,
once the ECN mirroring was configured. This fix is necessary for offload
of RED "ecn_mark" qevent.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 65e8407f4646..963eb0b1d9dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -45,7 +45,7 @@
 
 #define MLXSW_SP1_FWREV_MAJOR 13
 #define MLXSW_SP1_FWREV_MINOR 2008
-#define MLXSW_SP1_FWREV_SUBMINOR 1310
+#define MLXSW_SP1_FWREV_SUBMINOR 2018
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
@@ -62,7 +62,7 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 
 #define MLXSW_SP2_FWREV_MAJOR 29
 #define MLXSW_SP2_FWREV_MINOR 2008
-#define MLXSW_SP2_FWREV_SUBMINOR 1310
+#define MLXSW_SP2_FWREV_SUBMINOR 2018
 
 static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	.major = MLXSW_SP2_FWREV_MAJOR,
@@ -77,7 +77,7 @@ static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 
 #define MLXSW_SP3_FWREV_MAJOR 30
 #define MLXSW_SP3_FWREV_MINOR 2008
-#define MLXSW_SP3_FWREV_SUBMINOR 1310
+#define MLXSW_SP3_FWREV_SUBMINOR 2018
 
 static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
 	.major = MLXSW_SP3_FWREV_MAJOR,
-- 
2.28.0

