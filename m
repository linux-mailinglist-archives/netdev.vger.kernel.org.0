Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB062D2780
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgLHJZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:25:30 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37377 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728569AbgLHJZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:25:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 000F25C01ED;
        Tue,  8 Dec 2020 04:24:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 08 Dec 2020 04:24:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=vBDRJqwZQ3/mVJcxCOTA3iwjNhgJU+q5svLfrXgD9hM=; b=WICE7MNS
        ypKeDAFBpISpVQ+WHU6H9DDPuTF0LJnhdNGmAGwBUsapuysXTFJ9Oxo4rhDhQRKQ
        JvUkK9KASLp1r236mURQlxO7At58zxQmiBFyFotbVrB+XCZgavRnjee2D1qYUPkQ
        rDv1ufTINrVeO5gRBbA0eMLOoTwVhk2g7+43tGedOj0zvPyf++y8QgChBJDMx8LN
        Oc02BNZZ1uvEe6NFJ6CNG38OX3NERA6jbJ5lHy00KCPwZu3N+l/4PfnoN2fYgoe2
        qvyrsZ+Tlnj5ZS7WvcleoowwXzJiXgivXekncUgtnKaiBk5D2nRd0i4QZobDMh3S
        WhvG7ddKmlDZEQ==
X-ME-Sender: <xms:MEbPX2NCenEvqRnpXAsPWPXf5w1lJvTPdyT6nS0PtvidS7ZSEtXaIA>
    <xme:MEbPX09S7X3a_3BI9Jkiu1uG2e-m3SZEhP3wRFTghb7RKHt6URp70Sdn76fkbkUhi
    EMGPupc70w-Pw4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MEbPX9RdMzD3afxirwglpqbMwjJ0ACR0KGwvsCyHbltXiK217gRh5Q>
    <xmx:MEbPX2vXfkhTbPym1E_dQnsKL_E1H0Sd7GqHsOL0BxVv12aPPA2O6w>
    <xmx:MEbPX-eec3DWFo4e70SF9imonpS810lBlnZDHvMYgl_qbNf8Qsnhmg>
    <xmx:MEbPX96kc7TlVRoux2PeRAtv8SApUsPPe4bzkkE5njU8af8zs0r41w>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 851741080064;
        Tue,  8 Dec 2020 04:23:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/13] mlxsw: spectrum: Publish mlxsw_sp_ethtype_to_sver_type()
Date:   Tue,  8 Dec 2020 11:22:47 +0200
Message-Id: <20201208092253.1996011-8-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Declare mlxsw_sp_ethtype_to_sver_type() in spectrum.h to enable using it
in other files.

It will be used in the next patch to map between EtherType and the
relevant value configured by SVER register.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 963eb0b1d9dd..df8175cd44ab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -384,7 +384,7 @@ int mlxsw_sp_port_vid_learning_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 	return err;
 }
 
-static int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type)
+int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type)
 {
 	switch (ethtype) {
 	case ETH_P_8021Q:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 7e728a8a9fb3..a6956cfc9cb1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -584,6 +584,7 @@ int mlxsw_sp_port_vid_stp_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 int mlxsw_sp_port_vp_mode_set(struct mlxsw_sp_port *mlxsw_sp_port, bool enable);
 int mlxsw_sp_port_vid_learning_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 				   bool learn_enable);
+int mlxsw_sp_ethtype_to_sver_type(u16 ethtype, u8 *p_sver_type);
 int mlxsw_sp_port_pvid_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 vid,
 			   u16 ethtype);
 struct mlxsw_sp_port_vlan *
-- 
2.28.0

