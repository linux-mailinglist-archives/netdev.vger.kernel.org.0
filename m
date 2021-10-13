Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20BD42BD31
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhJMKk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:40:27 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57281 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229836AbhJMKkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:40:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E0695C0197;
        Wed, 13 Oct 2021 06:38:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 13 Oct 2021 06:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/1clM0yMMLV0AIpKTPKSohsiteIXHGgCwf8FuSqJ02c=; b=elLTCEZE
        hrY4ZwbnFjGBEM3MEgVg86bMzhOB0s69cje7QvUpi43AnVChQsCptO/+cRSSpGMm
        zj4+9dyMmGXoB+pcLEuGZATqJ4dI2UfZuwAyzQNhARtunyezi7uyCrXg63z4vVg6
        zXWzjlrenlT2+6JK1xGfOTwEE3kNSFA6tkZooAvUpoTF88Vb8zc4wnSdrB4kMMG/
        yR8YatCIBg0Jkp2822DolhuomJOcVaROYZ63/B26tSNrxY74LXPV73+ovB2DLgUi
        Gje96mPdGCatsizG11wZJFIHVSzx6yZ7n2ZhLZMEJvNwBamjGPDxspsQ8M9knUgV
        +lM33DwWIKk2nw==
X-ME-Sender: <xms:HrdmYeCmNAluxIZnR1ofLJfVkblaGn-JLr_aag77hwBy0jiQ-OkDPA>
    <xme:HrdmYYhpzpcH2VQy4_c-IaBRtsvKZ-cu6nmY8AGpPrzypsY64mJJ_wuI3gZdOHS39
    5Y_G19XxPxZZoM>
X-ME-Received: <xmr:HrdmYRl3c0bLFGBh6nUeRSPetbczLpbKiD-pPVBMa-Jk9mkJ3oAaLTvOwWDkd2qJM4a-uXqkKQtXICivFW5Lv9DM2asaHqLvdMFTLPRxLRA0rQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:HrdmYcyXGXovf4iI36BV45Xak4n7_fUEbj_r4lQR64Yh7l_75JMmrw>
    <xmx:HrdmYTSumg_e-EUVCO2grsJ5wIZ8JsL5rYSYhLcpFyxdtoqhLOy9iw>
    <xmx:HrdmYXaANc5-jHUHYC5nCBDaH4UuZggldsuFFipGXMiTXVejWbItAg>
    <xmx:HrdmYROLWKpgXP50R-9prcQhMi82tVEBKxLU3Y-l4ADVcYNqx_Ch6g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Oct 2021 06:38:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/5] mlxsw: reg: Rename MLXSW_REG_PPCNT_TC_CONG_TC to _CNT
Date:   Wed, 13 Oct 2021 13:37:45 +0300
Message-Id: <20211013103748.492531-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013103748.492531-1-idosch@idosch.org>
References: <20211013103748.492531-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The name does not make sense as it is. Clearly there is a typo and the
suffix should have been _CNT, like the other enumerators. Fix accordingly.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 62b2df8a0715..2f8c0c6d66e0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4951,7 +4951,7 @@ enum mlxsw_reg_ppcnt_grp {
 	MLXSW_REG_PPCNT_DISCARD_CNT = 0x6,
 	MLXSW_REG_PPCNT_PRIO_CNT = 0x10,
 	MLXSW_REG_PPCNT_TC_CNT = 0x11,
-	MLXSW_REG_PPCNT_TC_CONG_TC = 0x13,
+	MLXSW_REG_PPCNT_TC_CONG_CNT = 0x13,
 };
 
 /* reg_ppcnt_grp
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3c9844f2aa1d..67529e9537a6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -824,7 +824,7 @@ mlxsw_sp_port_get_hw_xstats(struct net_device *dev,
 
 	for (i = 0; i < TC_MAX_QUEUE; i++) {
 		err = mlxsw_sp_port_get_stats_raw(dev,
-						  MLXSW_REG_PPCNT_TC_CONG_TC,
+						  MLXSW_REG_PPCNT_TC_CONG_CNT,
 						  i, ppcnt_pl);
 		if (!err)
 			xstats->wred_drop[i] =
-- 
2.31.1

