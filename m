Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B48A3E43CE
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbhHIKWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:22:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45877 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234342AbhHIKWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:22:43 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D05E5C00C9;
        Mon,  9 Aug 2021 06:22:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 09 Aug 2021 06:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=cb55FD5+j/9oBoOflBOsDvA/h/sWtBIJa9rDRvx6Khw=; b=B2E7kA2n
        w82hJ/cmdqNOT04UoCOGIMgC8idvAO2VSujYwoDag0Cb/wfSt/UXIRMs0rC/s8gq
        vBoTPdVshIv0vYd+SLMoWzRbWGl8KYfvlRDkpQ8hSVo6KZImmWFws0If9i0HjEOK
        5QquJSw9FQP6rR25WZ9/mTIJN0Ntu+D5HCyZzzjchK8fU5EV4g2oDKuRlmTeUqVP
        M9YOkg2wqOPqLnO6nVufSEJt+1AonxOf+z+OwpvapmPvx4ht6UtNtLs3bQ12moLd
        PtHduNXrFUE5TCSC2QKlMSjY5+EB+f1TMfZsmyCCerHUIQ4LMZdvRAkiPPTHDma/
        L4Eb2QNRWjsJ7w==
X-ME-Sender: <xms:3gERYa8z6ZbxdTckfiMkuZWL1bUYZ2uTBT-BHiEPwkQ5dsP-AW-M-w>
    <xme:3gERYatXBHUWL7PJ2bzFQUILOA7DsHPzO1WhpDQS0m9lb6cTn95o3D1UxVwy1XSUg
    vE4EoC4Kr6UZ9k>
X-ME-Received: <xmr:3gERYQBOocyNQ4QX0GAuxn1bbV029JBw3s1PB5HfYbiZ96SnK1gGEwIA4vq3kYXT7tBvS32ddRpWPMXHws_CV0bGyOlArRpKwY8bgp9g6N0jrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3gERYSeipTnT0EV3RkTVlSSC7Dby4zVFgfZrbZCuj9SkiuFq1Ygs5Q>
    <xmx:3gERYfPYbOVBz1mEQyFQzFxG32KiUlE0Dxwf28CQfvNzAQJ5iSR5ug>
    <xmx:3gERYclNLbVTY5Qv8dybPu6FmwQiayFiV8MOlQk4IkAqimSAXALrIg>
    <xmx:3wERYbDiVtqrNwmcIcKiuKPZd1Tzts8qBENwwVTujnmf0-4S5nr-1Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:22:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 3/8] mlxsw: reg: Add fields to PMAOS register
Date:   Mon,  9 Aug 2021 13:21:47 +0300
Message-Id: <20210809102152.719961-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102152.719961-1-idosch@idosch.org>
References: <20210809102152.719961-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The Ports Module Administrative and Operational Status (PMAOS) register
configures and retrieves the per-module status. Extend it with fields
required to support various module settings such as reset and low power
mode.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 58 +++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 6fbda6ebd590..b2c55259f333 100644
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
@@ -5693,6 +5701,38 @@ MLXSW_ITEM32(reg, pmaos, slot_index, 0x00, 24, 4);
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
+enum mlxsw_reg_pmaos_oper_status {
+	MLXSW_REG_PMAOS_OPER_STATUS_INITIALIZING,
+	MLXSW_REG_PMAOS_OPER_STATUS_PLUGGED_ENABLED,
+	MLXSW_REG_PMAOS_OPER_STATUS_UNPLUGGED,
+	/* Error code can be read from PMAOS.error_type */
+	MLXSW_REG_PMAOS_OPER_STATUS_PLUGGED_ERROR,
+};
+
+/* reg_pmaos_oper_status
+ * Module state. Reserved while administrative state is disabled.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pmaos, oper_status, 0x00, 0, 4);
+
 /* reg_pmaos_ase
  * Admin state update enable.
  * If this bit is set, admin state will be updated based on admin_state field.
@@ -5709,6 +5749,24 @@ MLXSW_ITEM32(reg, pmaos, ase, 0x04, 31, 1);
  */
 MLXSW_ITEM32(reg, pmaos, ee, 0x04, 30, 1);
 
+enum mlxsw_reg_pmaos_error_type {
+	MLXSW_REG_PMAOS_ERROR_TYPE_POWER_BUDGET_EXCEEDED = 0,
+	/* I2C data or clock shorted */
+	MLXSW_REG_PMAOS_ERROR_TYPE_BUS_STUCK = 2,
+	MLXSW_REG_PMAOS_ERROR_TYPE_BAD_UNSUPPORTED_EEPROM = 3,
+	MLXSW_REG_PMAOS_ERROR_TYPE_UNSUPPORTED_CABLE = 5,
+	MLXSW_REG_PMAOS_ERROR_TYPE_HIGH_TEMP = 6,
+	/* Module / cable is shorted */
+	MLXSW_REG_PMAOS_ERROR_TYPE_BAD_CABLE = 7,
+};
+
+/* reg_pmaos_error_type
+ * Module error details. Only valid when operational status is "plugged with
+ * error".
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pmaos, error_type, 0x04, 8, 4);
+
 enum mlxsw_reg_pmaos_e {
 	MLXSW_REG_PMAOS_E_DO_NOT_GENERATE_EVENT,
 	MLXSW_REG_PMAOS_E_GENERATE_EVENT,
-- 
2.31.1

