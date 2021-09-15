Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B7940C374
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbhIOKPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:15:05 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41009 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237503AbhIOKPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:15:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AE7225C018D;
        Wed, 15 Sep 2021 06:13:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 15 Sep 2021 06:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=JZuVP1lLHdA8lfPS/LMpJBVAWHAoGWfPVbTqsAa0n0I=; b=rMrK3Uvk
        AlNtLmytemefPS5k/3gOIsRog+ecchfbZ4/PFNkaF7ENfSn5xzDde7eTqqdxXvnX
        36EpQonS48HMtugpKv87fCHZAy/O3ZpXpHE+vnXF8lZOhekFMB/TeaSXaQN758+8
        ugyk352WByUYgRIAN0bt5/tW3NBq7rDxgm7wKtd3yQkbwVT7hP+hMS/DsY87wIZ6
        sLuz/ver514Xk6h1Po43NR78z7yp3S+op3QrW3XzJeTjeb/B9zLUmluWKRtPRFWT
        7nAImRtT5ZElKDn1aTKzSzMbGi7Q+uEyc1u6+wkVFbDS03sF1j957AYPS7K5hOti
        /UnN6aaEboy4Fg==
X-ME-Sender: <xms:VsdBYVpCMhy9Y_TvQE1206VyzTJK1DBnaTajBl5Z-AiMAZdWYcLnfw>
    <xme:VsdBYXo48afXuulXmEzXzs54O7TqR-fHiwuNHKR_dV_d0nuBDiLVH3bsjF2mGg6ra
    8hefAtHnn3H0_4>
X-ME-Received: <xmr:VsdBYSMASw73lOVLW5C7_ty1PtEe7MqQhO7kioOP1RmaRA5_WCeJXhoAYKjNLOVIBUYIAQFemeEvPQ-TpE3cNiZEa4mjBw11-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VsdBYQ7tNTcIVwoVbgFaC2ZNE5b65EG8doNS44EDfx4JuD7NAhoMLA>
    <xmx:VsdBYU5HHN7d49nl_H4J4yIG2v_h9EMDiYmaP0ueSNCvDQzlZzqA_Q>
    <xmx:VsdBYYgM6drMuQcPAQFB8_IOClVj6Q3-ILtHR4MArzxXTM_bqSGJsQ>
    <xmx:VsdBYeQwlUaWrDlicBtlhqbiJsVDc11iFLHez3dKXTVFz_aGuoVfHw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] mlxsw: reg: Add fields to PMAOS register
Date:   Wed, 15 Sep 2021 13:13:12 +0300
Message-Id: <20210915101314.407476-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The Ports Module Administrative and Operational Status (PMAOS) register
configures and retrieves the per-module status. Extend it with fields
required to support various module settings such as reset and power
mode.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 26 +++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 8d87f3cc5711..667856f00728 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5681,6 +5681,14 @@ static inline void mlxsw_reg_pspa_pack(char *payload, u8 swid, u8 local_port)
 
 MLXSW_REG_DEFINE(pmaos, MLXSW_REG_PMAOS_ID, MLXSW_REG_PMAOS_LEN);
 
+/* reg_pmaos_rst
+ * Module reset toggle.
+ * Note: Setting reset while module is plugged-in will result in transition to
+ * "initializing" operational state.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, pmaos, rst, 0x00, 31, 1);
+
 /* reg_pmaos_slot_index
  * Slot index.
  * Access: Index
@@ -5693,6 +5701,24 @@ MLXSW_ITEM32(reg, pmaos, slot_index, 0x00, 24, 4);
  */
 MLXSW_ITEM32(reg, pmaos, module, 0x00, 16, 8);
 
+enum mlxsw_reg_pmaos_admin_status {
+	MLXSW_REG_PMAOS_ADMIN_STATUS_ENABLED = 1,
+	MLXSW_REG_PMAOS_ADMIN_STATUS_DISABLED = 2,
+	/* If the module is active and then unplugged, or experienced an error
+	 * event, the operational status should go to "disabled" and can only
+	 * be enabled upon explicit enable command.
+	 */
+	MLXSW_REG_PMAOS_ADMIN_STATUS_ENABLED_ONCE = 3,
+};
+
+/* reg_pmaos_admin_status
+ * Module administrative state (the desired state of the module).
+ * Note: To disable a module, all ports associated with the port must be
+ * administatively down first.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pmaos, admin_status, 0x00, 8, 4);
+
 /* reg_pmaos_ase
  * Admin state update enable.
  * If this bit is set, admin state will be updated based on admin_state field.
-- 
2.31.1

