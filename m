Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD007333AFA
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhCJLD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:03:57 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59061 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232696AbhCJLDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:03:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5229B5C013F;
        Wed, 10 Mar 2021 06:03:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 06:03:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=bzPVxcd+axrfgsSZ4OrOTHLoq4ER9X3Td5zLx9V2u70=; b=KsM+hWns
        OAZybqVVytDcSkzcNTjDmrC/yv8+KgGaOjrBHUz+UqdRpzYZRI9exkwg5kZj8Xke
        0R5rcskIFlvW6+pYxjTcDYpefWn3U/nFF89BXUHYITbAL5yHjxy/YZ9DukA6hi+d
        FYmZkZPcoiFqHPJhYnP08kIC1twQFU2daOuxxF/VUMG5cr+rqUUxwOwFjMtPo7MA
        S8JoEh8cmzeKz21CfpRzYGPVk3H9C4SAQ5ItGPqwLEhWETQyetCIS24idEGkQIPk
        6tnLILz3ks7Ew8+QcPQU3TTNpg9ZmQ33ci8PMgbIS+9QipTgCk7o32DuaTqGMDjW
        UrCxyoghd5gHcQ==
X-ME-Sender: <xms:iKdIYF_J6AxKDbwssaAmalGpR02qUyN4z0YKBhEzqaJ1YekiMQCVrA>
    <xme:iKdIYJszk_FB0fhruMw71IHP4zugfRouozup5J_8N41dLfhevkQCia0gA44b2g7_x
    YQKccFzdhn5CJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:iKdIYDCTThBev_5F-GY7AJxsMh_DaPbUl-4gnM-GvAGBSfsbyGjmlg>
    <xmx:iKdIYJc31R5hhXGb1Z8UflsTMd_FzZcXNb-w6RD7ah0s22rririuPw>
    <xmx:iKdIYKMZMh6c0O5R4FBncboT_zJLe24v0EwWOjHRpYkoVEDTMgr-ig>
    <xmx:iKdIYB3FmU7Tc3GphTmq63aaHa0DFCWZm8dI_X53HFhQF8BQWJA6mA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B6BB1080059;
        Wed, 10 Mar 2021 06:03:34 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/6] mlxsw: reg: Fix comment about slot_index field in PMAOS register
Date:   Wed, 10 Mar 2021 13:02:16 +0200
Message-Id: <20210310110220.2534350-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310110220.2534350-1-idosch@idosch.org>
References: <20210310110220.2534350-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The comment did not include the register name.
Add `pmaos` to align the comment with other comments.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c4adc7f740d3..afd42907092f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5637,7 +5637,7 @@ static inline void mlxsw_reg_pspa_pack(char *payload, u8 swid, u8 local_port)
 
 MLXSW_REG_DEFINE(pmaos, MLXSW_REG_PMAOS_ID, MLXSW_REG_PMAOS_LEN);
 
-/* reg_slot_index
+/* reg_pmaos_slot_index
  * Slot index.
  * Access: Index
  */
-- 
2.29.2

