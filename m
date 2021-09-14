Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9382140A68F
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbhINGPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:15:45 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52639 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239748AbhINGPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:15:39 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 58FD95C0174;
        Tue, 14 Sep 2021 02:14:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 14 Sep 2021 02:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=dav00pLOzlvpUGwe8yRo4UBW44OSm/Hz/sstp6IT3TU=; b=myZ/Ob6J
        GpsP/Se4JqjmwKOhwYekQ3aU/1MhQUqXFclghE8ipRmFXmNP/GCTEcAoIksUSrJV
        3Yu+AKCqtfH3lTofCdIw2yjGe+1RtPyqQ9Qfutab7GjE5YHGrmMVgzLkGnvoqKeW
        JXkkiZekJ89dhRvd65BZ7MZH0MxN5uZae1qY4slUXuT5nbirP41N/F85+wqrw9Aj
        ecsMW57qx4owgAOBOztlNLRGBlbaQpYc1rzZ4TtgLPvs/Ar4NgWVgPC3xM5iuDBz
        +CcTt4xeJBdqJjdxIpmUPiogTcMW2oY/HMk+wL1RvYsEBEpr7R7NAzl7dhILMHpC
        /3PBCzLc7RrYKw==
X-ME-Sender: <xms:vj1AYRHBvrUfNJ3LkA_eTTVBu2gKeZ0uddkIIuVsLqI6b8Hy3aZPQw>
    <xme:vj1AYWWWT8WrVdtLBbSny_w-ji6dzL6zyk4C9u5cc2XafdujB8JR_Q6tlsP2LW8xG
    eDQETpqKBveJKg>
X-ME-Received: <xmr:vj1AYTIffra51KuZb9KaHKGWzTXQR9Eqy4wnpdyHWJLtf9nX7xGByttKBgQT2rYWzx9auvA9iHgVP-nB0v_oQkOKpYaVminWPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:vj1AYXGgtWajtNoKPyd8XyGeM-E9Y7_e-CdmQ4pmBCu9pp5efOoQfw>
    <xmx:vj1AYXWa6guBoxo6nrToTK95xFQD-4M5hNZ95PKa3bMZ9911eb0F9g>
    <xmx:vj1AYSN-azTsKDTcv4Oxj3XuubUbDNnDF6AwMiwk0X8gO8LtoGMUAg>
    <xmx:vj1AYSRl6mKooJk-hC1ERjBO6d73yrzzY_kO_gPcj8Ue0RBeXfzB4Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 02:14:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: spectrum: Bump minimum FW version to xx.2008.3326
Date:   Tue, 14 Sep 2021 09:13:23 +0300
Message-Id: <20210914061330.226000-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914061330.226000-1-idosch@idosch.org>
References: <20210914061330.226000-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add latest verified version of Nvidia Spectrum-family switch firmware,
for Spectrum (13.2008.3326), Spectrum-2 (29.2008.3326) and Spectrum-3
(30.2008.3326).

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 250c5a24264d..583b09be92e6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -47,7 +47,7 @@
 
 #define MLXSW_SP1_FWREV_MAJOR 13
 #define MLXSW_SP1_FWREV_MINOR 2008
-#define MLXSW_SP1_FWREV_SUBMINOR 2406
+#define MLXSW_SP1_FWREV_SUBMINOR 3326
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
@@ -64,7 +64,7 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 
 #define MLXSW_SP2_FWREV_MAJOR 29
 #define MLXSW_SP2_FWREV_MINOR 2008
-#define MLXSW_SP2_FWREV_SUBMINOR 2406
+#define MLXSW_SP2_FWREV_SUBMINOR 3326
 
 static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	.major = MLXSW_SP2_FWREV_MAJOR,
@@ -79,7 +79,7 @@ static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 
 #define MLXSW_SP3_FWREV_MAJOR 30
 #define MLXSW_SP3_FWREV_MINOR 2008
-#define MLXSW_SP3_FWREV_SUBMINOR 2406
+#define MLXSW_SP3_FWREV_SUBMINOR 3326
 
 static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
 	.major = MLXSW_SP3_FWREV_MAJOR,
-- 
2.31.1

