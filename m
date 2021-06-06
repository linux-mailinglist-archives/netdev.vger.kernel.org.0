Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A1939CE21
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 10:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhFFI1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 04:27:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48425 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230173AbhFFI1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 04:27:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0CEBE5C01BB;
        Sun,  6 Jun 2021 04:25:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 06 Jun 2021 04:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=N4IMH2rmMz4BDOpKl3ZRIUT8NeNudePJvQYUl3BMr8A=; b=BQBK6I22
        HvSjj0CLoV0VjZCdgK5y9Ii+AnaDLVgWEvT3+xQyntEuKO/gHZSF7nW2YGILl2GO
        i65qVy3QDjfewiBd9yfw0W8s9Di88nZqt/QBUCP8Ds7fEL5lq0gnJShtrLbpfDEs
        kYk45AXA7mECOzkqigmdKtHm/2O33v8jbP0mYyJOkyhpG6tTbn6NrIoRi+yxtDhx
        dwpTgZLiso6izI32cDG3AWAu1IbBnZwqKEkpc1W4E4/wlYiRmknchEUibsV81YBO
        eh5oR6q6+gARggvePoKRyuCWzUACwFt3iTAGYnDpHZ7U1o65Q6frgrXIaMTTGHhe
        dF+CMGbswFYe7A==
X-ME-Sender: <xms:bIa8YOQPRpdO3YO0x5ji8CxTw-BmgUGkLXweqA6J9zfXYukz92DAuA>
    <xme:bIa8YDy4QQH8C0tYgsPPXbMGAl6CUgxpRBBBAxdVqZGqkc_wpgN72NU6C0pmEre7l
    TifR4JId8_XnOw>
X-ME-Received: <xmr:bIa8YL2xMWvIvUqvEeyjWBheidMneFFbtMX7NSnIaQrr4F1D2gH0c4nvgh-5gxWtrAqqkUuejugx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedthedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:bIa8YKDn904rWGSl5VBeyDnFasDc1gPqhyQU_CbwtFN0uVfdAroYRw>
    <xmx:bIa8YHgja91nj3PaMy0qWIUWSff0CcFxlcioC8AvpRAfCpuoJlTJLw>
    <xmx:bIa8YGqGAswQqoOJjLJHWA8f94hbHBWztLTGvFJEEJfqKi-yPUKiAQ>
    <xmx:bYa8YHcER_auhIoLoYPpEaa-rr4aJTw9Ngm-t9nuPzCDaP4HphNryQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 6 Jun 2021 04:25:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/3] mlxsw: reg: Spectrum-3: Enforce lowest max-shaper burst size of 11
Date:   Sun,  6 Jun 2021 11:24:30 +0300
Message-Id: <20210606082432.1463577-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210606082432.1463577-1-idosch@idosch.org>
References: <20210606082432.1463577-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

A max-shaper is the HW component responsible for delaying egress traffic
above a configured transmission rate. Burst size is the amount of traffic
that is allowed to pass without accounting. The burst size value needs to
be such that it can be expressed as 2^BS * 512 bits, where BS lies in a
certain ASIC-dependent range. mlxsw enforces that this holds before
attempting to configure the shaper.

The assumption for Spectrum-3 was that the lower limit of BS would be 5,
like for Spectrum-1. But as of now, the limit is still 11. Therefore fix
the driver accordingly, so that incorrect values are rejected early with a
proper message.

Fixes: 23effa2479ba ("mlxsw: reg: Add max_shaper_bs to QoS ETS Element Configuration")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 900b4bf5bb5b..2bc5a9003c6d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3907,7 +3907,7 @@ MLXSW_ITEM32(reg, qeec, max_shaper_bs, 0x1C, 0, 6);
 #define MLXSW_REG_QEEC_HIGHEST_SHAPER_BS	25
 #define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1	5
 #define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2	11
-#define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3	5
+#define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3	11
 
 static inline void mlxsw_reg_qeec_pack(char *payload, u8 local_port,
 				       enum mlxsw_reg_qeec_hr hr, u8 index,
-- 
2.31.1

