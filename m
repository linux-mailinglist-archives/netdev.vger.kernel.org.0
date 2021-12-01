Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1788946494F
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347778AbhLAIQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:16:46 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41069 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347864AbhLAIQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EEF6C5C0255;
        Wed,  1 Dec 2021 03:13:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 01 Dec 2021 03:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=aBoYxTOKn9U20QwXUP+JoInxK5FctubJSb50cC8m/5w=; b=LUzJhrKg
        NLnTYA4fO2WEZJIntJYG0MXye2Eo/T9Z1HJ7kr3k56CWCLLSZxq2D9MxdGk3LO7+
        idKSfS7G7KM5fNGBn8V5Zpj8gLVDWrQSqChZfuR3tAKJSHRr/jtYN5FkOyOMNhn7
        CheiGrvx7Op65dLTiM7QKiGl6oSH0vEDV0UxMKD46sa0y9agfZGU2+gDAuS5TGq6
        zkmHipO3cg381B1S9RNRpIM+xTI1crfv4TSEKheqAllpwaOkM78tepGf5FOoT3B4
        OZIW7oM1Vhr6uVuXKE0sNPWYR+P8BWMUseXJHGJGCHudLWHvMGcmzT9R6UTOk6jk
        jkOHSyxqKnqTxw==
X-ME-Sender: <xms:oi6nYVmrCgaUMqp2zANgDjECRZglkOtfZeI30cwk63cyKLPAf_t1dg>
    <xme:oi6nYQ0Hf5TpiyRqxt1E04FdQIlyC_zRdyE-ja7rfSZ54wHcKzr-9ueDBSMw0ulbt
    bjngGghjut-ycQ>
X-ME-Received: <xmr:oi6nYboGyBeZgbEt-HkGkte5fe1fPwkD-Gj8aw-qR6GlA9_zB-Ja-eNQ_zDuYycVoWH7q-720Sy-sHAq_V2gp4bWlKDq6BmUH1dCaj3uFGt1Ew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:oi6nYVllkZrbt-WEvjOEzbtBnqpsBhya9mTMzOGxSlxd7BQMYbHD5A>
    <xmx:oi6nYT3hRUmO1iRSgl8wLLjnd1-2cY98cYOvOMADVLv6Uh4jGPgA7Q>
    <xmx:oi6nYUtRQAYaLR6AQ42132Kn9frU9zbbOwLiv0BDumU8s39z572vew>
    <xmx:oi6nYeTYchMdD_TjiOBRndAhakpn6VvZ69CXGWaMge--vIV71bikjA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:20 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: reg: Remove unused functions
Date:   Wed,  1 Dec 2021 10:12:32 +0200
Message-Id: <20211201081240.3767366-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The functions mlxsw_reg_sfd_uc_unpack() and
mlxsw_reg_sfd_uc_lag_unpack() are not used. Remove them.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 8d420eb8ade2..c67f43437158 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -417,15 +417,6 @@ static inline void mlxsw_reg_sfd_uc_pack(char *payload, int rec_index,
 	mlxsw_reg_sfd_uc_system_port_set(payload, rec_index, local_port);
 }
 
-static inline void mlxsw_reg_sfd_uc_unpack(char *payload, int rec_index,
-					   char *mac, u16 *p_fid_vid,
-					   u8 *p_local_port)
-{
-	mlxsw_reg_sfd_rec_mac_memcpy_from(payload, rec_index, mac);
-	*p_fid_vid = mlxsw_reg_sfd_uc_fid_vid_get(payload, rec_index);
-	*p_local_port = mlxsw_reg_sfd_uc_system_port_get(payload, rec_index);
-}
-
 /* reg_sfd_uc_lag_sub_port
  * LAG sub port.
  * Must be 0 if multichannel VEPA is not enabled.
@@ -478,15 +469,6 @@ mlxsw_reg_sfd_uc_lag_pack(char *payload, int rec_index,
 	mlxsw_reg_sfd_uc_lag_lag_id_set(payload, rec_index, lag_id);
 }
 
-static inline void mlxsw_reg_sfd_uc_lag_unpack(char *payload, int rec_index,
-					       char *mac, u16 *p_vid,
-					       u16 *p_lag_id)
-{
-	mlxsw_reg_sfd_rec_mac_memcpy_from(payload, rec_index, mac);
-	*p_vid = mlxsw_reg_sfd_uc_lag_fid_vid_get(payload, rec_index);
-	*p_lag_id = mlxsw_reg_sfd_uc_lag_lag_id_get(payload, rec_index);
-}
-
 /* reg_sfd_mc_pgi
  *
  * Multicast port group index - index into the port group table.
-- 
2.31.1

