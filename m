Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2C8423BAF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238144AbhJFKtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:49:22 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37947 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhJFKtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:49:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A681458119B;
        Wed,  6 Oct 2021 06:47:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 06 Oct 2021 06:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=nImdF6j1LgCiDiPmAZ0/Yn9vHkDCY52jGC75qP6Y4XM=; b=Bg735MdS
        2YPh+p7OcPkRH90jOsuttT9qgmQmXSCk8qjiwZzv/JiFbao0ZE5WU66/2C3GPEW3
        Q2wIYCPtI8/DsxsXKbdkxz8kiori/9SfhINfuDfEDUF6vvaSj1diq/kSmqozHF0H
        wvafQair9HzCqLMN3esev3lYkxJYrqm5GiOhXqlTYZEbJZPt30v+Ynf3+S8UQpx5
        jrj/PGVRtMrGcPwp5FoYa9A/XQF6O6+AnK1j7P3iKDkjtyFQGlXOFH3DsiNA5gVe
        rn+DZaPrfJtuWOppWXnjnFgBEJMUlDnNdD68kOm/L7XY1CJv6nu5gqpc0GUTzc+g
        FYL8WeJ2mUubCA==
X-ME-Sender: <xms:wX5dYbfIQaYm7RNURN-ZktMVCX5GwMHTnXap6FtD_i8fXYnjEcCGYg>
    <xme:wX5dYRP8AOd7Ztlo63wjUmOwKr5oC8nYqSFIgUlJZXScbPDHN2yDuneXP1YB2HdoN
    wvM3ZIvPqHa9Co>
X-ME-Received: <xmr:wX5dYUi-yBDqZ74u7Vg8ERk_lh5zcz6mYshkctLn5oDwvMq42GK0o0zAVI4rodiN4GfjpzSpUZpNF9DQpL0iAxIqsnlmTfkJKGgBkO7rtvhmpw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeliedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wX5dYc8gsZ9ZJpkYcxmRU5GOlhfmZU7GRwGK8x1PwHD9V45u6UrH2g>
    <xmx:wX5dYXu2_B4iF6eeQAWaKC3Nfc1bbZPp34BZJcrzuYPdr10CnPqa4Q>
    <xmx:wX5dYbHQ1qFviU27nogF_FLnu153ctxDfaZf9rXdOYc557fDXRBZXQ>
    <xmx:wX5dYdDIw0Tw_uIGm560dk2my2m1SL1Qt7ULd_cS5DEoVQ9zlx6xbQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 6 Oct 2021 06:47:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 2/6] mlxsw: reg: Add Port Module Memory Map Properties register
Date:   Wed,  6 Oct 2021 13:46:43 +0300
Message-Id: <20211006104647.2357115-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006104647.2357115-1-idosch@idosch.org>
References: <20211006104647.2357115-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add the Port Module Memory Map Properties register. It will be used to
set the power mode of a module in subsequent patches.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 50 +++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c5fad3c94fac..bff05a0a2f7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5946,6 +5946,55 @@ static inline void mlxsw_reg_pddr_pack(char *payload, u8 local_port,
 	mlxsw_reg_pddr_page_select_set(payload, page_select);
 }
 
+/* PMMP - Port Module Memory Map Properties Register
+ * -------------------------------------------------
+ * The PMMP register allows to override the module memory map advertisement.
+ * The register can only be set when the module is disabled by PMAOS register.
+ */
+#define MLXSW_REG_PMMP_ID 0x5044
+#define MLXSW_REG_PMMP_LEN 0x2C
+
+MLXSW_REG_DEFINE(pmmp, MLXSW_REG_PMMP_ID, MLXSW_REG_PMMP_LEN);
+
+/* reg_pmmp_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmmp, module, 0x00, 16, 8);
+
+/* reg_pmmp_sticky
+ * When set, will keep eeprom_override values after plug-out event.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, pmmp, sticky, 0x00, 0, 1);
+
+/* reg_pmmp_eeprom_override_mask
+ * Write mask bit (negative polarity).
+ * 0 - Allow write
+ * 1 - Ignore write
+ * On write, indicates which of the bits from eeprom_override field are
+ * updated.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, pmmp, eeprom_override_mask, 0x04, 16, 16);
+
+enum {
+	/* Set module to low power mode */
+	MLXSW_REG_PMMP_EEPROM_OVERRIDE_LOW_POWER_MASK = BIT(8),
+};
+
+/* reg_pmmp_eeprom_override
+ * Override / ignore EEPROM advertisement properties bitmask
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pmmp, eeprom_override, 0x04, 0, 16);
+
+static inline void mlxsw_reg_pmmp_pack(char *payload, u8 module)
+{
+	MLXSW_REG_ZERO(pmmp, payload);
+	mlxsw_reg_pmmp_module_set(payload, module);
+}
+
 /* PLLP - Port Local port to Label Port mapping Register
  * -----------------------------------------------------
  * The PLLP register returns the mapping from Local Port into Label Port.
@@ -12348,6 +12397,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pmtdb),
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
+	MLXSW_REG(pmmp),
 	MLXSW_REG(pllp),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
-- 
2.31.1

