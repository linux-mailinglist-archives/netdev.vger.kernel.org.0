Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E04B2D7C69
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389451AbgLKRHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:07:43 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42753 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405239AbgLKRGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:06:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id BA210B0E;
        Fri, 11 Dec 2020 12:05:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Dec 2020 12:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=HWY0p3OJKNVUIb/JUoSXQGS7oqvB/Y1kPFZyDj6+HC0=; b=otN9b1jO
        tJwJxFnKkeZLB6joFgZXyyP+gm2beV0XbzG6zZrZQxy+kr9q4FeSpYvcKiw6xigD
        eDYptBo5hZMXfD+NiR6Z0DQICCWnf3e4H3vOk9TGsdN4fsYEk7iE9CKmODLjiWFr
        WW9agpY62R7ajDn0YzXqd34YNebhCh9oFndP0pxlBvv9DqXTsjk2cmXizSRM9G4X
        wCXloJXu4QsvmrjUqyZBIs4zvgNlshcs7Mx9o0Sc+tbxb/oEAfqIcBMepHn4oPn2
        HCCBdaF10TgANDDSVC9DivMEFpR4vUko/e5iguVyzQQ3qaO7mEipIDlCm2jPvqVg
        MZl1LfvMSuQsoA==
X-ME-Sender: <xms:yqbTXxGtC69JWZbUk0c-qhVSVO-NJeuF1OCOKJlRDQ3SRgMqddYU8Q>
    <xme:yqbTX2USGJc5qZC4aEuEzuBNACys-pbQeHVWdaF_1rgSyPvkbg7ThEqVsauOm-fPF
    c1Wx5vPZkhqQLU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yqbTXzLrQngB_0Pcz6wRUlWP1deRCtMZY4XWblOxE_dsBnLAquPOjA>
    <xmx:yqbTX3F8yMYp6SwlJWeUWEw2AY0TNv9n-1kxT2MTdyDW3WpPawx9ag>
    <xmx:yqbTX3VGmrWGZcVhRLaTjsUZVgnjYLsyIorY808PF8pNzEUQ6I7hOg>
    <xmx:yqbTX0jNWdFSHBtTgpAsdCAVYSryx1RnxPPCSJY-QPyuTFqI96uw1g>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F1641080068;
        Fri, 11 Dec 2020 12:05:12 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/15] mlxsw: reg: Add Router XLT Enable Register
Date:   Fri, 11 Dec 2020 19:04:00 +0200
Message-Id: <20201211170413.2269479-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The RXLTE enables XLT (eXtended Lookup Table) LPM lookups if a capable
XM is present on the system.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 44 +++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e7979edadf4c..ebde4fc860e2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8469,6 +8469,49 @@ mlxsw_reg_rmft2_ipv6_pack(char *payload, bool v, u16 offset, u16 virtual_router,
 	mlxsw_reg_rmft2_sip6_mask_memcpy_to(payload, (void *)&sip6_mask);
 }
 
+/* RXLTE - Router XLT Enable Register
+ * ----------------------------------
+ * The RXLTE enables XLT (eXtended Lookup Table) LPM lookups if a capable
+ * XM is present on the system.
+ */
+
+#define MLXSW_REG_RXLTE_ID 0x8050
+#define MLXSW_REG_RXLTE_LEN 0x0C
+
+MLXSW_REG_DEFINE(rxlte, MLXSW_REG_RXLTE_ID, MLXSW_REG_RXLTE_LEN);
+
+/* reg_rxlte_virtual_router
+ * Virtual router ID associated with the router interface.
+ * Range is 0..cap_max_virtual_routers-1
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rxlte, virtual_router, 0x00, 0, 16);
+
+enum mlxsw_reg_rxlte_protocol {
+	MLXSW_REG_RXLTE_PROTOCOL_IPV4,
+	MLXSW_REG_RXLTE_PROTOCOL_IPV6,
+};
+
+/* reg_rxlte_protocol
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rxlte, protocol, 0x04, 0, 4);
+
+/* reg_rxlte_lpm_xlt_en
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, rxlte, lpm_xlt_en, 0x08, 0, 1);
+
+static inline void mlxsw_reg_rxlte_pack(char *payload, u16 virtual_router,
+					enum mlxsw_reg_rxlte_protocol protocol,
+					bool lpm_xlt_en)
+{
+	MLXSW_REG_ZERO(rxlte, payload);
+	mlxsw_reg_rxlte_virtual_router_set(payload, virtual_router);
+	mlxsw_reg_rxlte_protocol_set(payload, protocol);
+	mlxsw_reg_rxlte_lpm_xlt_en_set(payload, lpm_xlt_en);
+}
+
 /* Note that XMDR and XRALXX register positions violate the rule of ordering
  * register definitions by the ID. However, XRALXX pack helpers are
  * using RALXX pack helpers, RALXX registers have higher IDs.
@@ -11754,6 +11797,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rigr2),
 	MLXSW_REG(recr2),
 	MLXSW_REG(rmft2),
+	MLXSW_REG(rxlte),
 	MLXSW_REG(xmdr),
 	MLXSW_REG(xralta),
 	MLXSW_REG(xralst),
-- 
2.29.2

