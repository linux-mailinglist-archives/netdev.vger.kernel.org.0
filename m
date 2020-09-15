Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03F526A118
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgIOImF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:42:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42815 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbgIOIlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:41:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F134D5C00EC;
        Tue, 15 Sep 2020 04:41:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 04:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=uk4Vkh6eRSLOK6g7ntLgDxNc7oHFsh50xtlQ8fu+uFI=; b=FP8XiTuB
        7zN8YhzD88qgFN/8yTYcR5amwo+nY1eHKxYh1efRBjNvQP8nMQOW6y79qDjNEtMw
        sCT4G9Q3t/Btz6hLVMqE7iziL4asMAGC9fIl8uU8fxdS27VS8fFQyS44It2jgk9l
        ZZck/b28keRzP/xMrVgsJDA5Px++MG0DXsSpBiqNWz4rYGmutaKoDlij0SBdiPsf
        m1jAEVhSwtU9GTPtS9hfMyy0YiOzG9tsRXblZTTM+RwW0x9yi5n3siGR9xbru479
        ZjzkSw87f5px3dk9KNtaBXA08/Hz2GbwMnFrCg51k7ATeLBNJw8xULlXXiJ8bW/O
        p0yhBG3z6DhxUA==
X-ME-Sender: <xms:T35gXxRW2p_cw3o4Yqf3WPfTelGdcmuv-ANvgTsEUd_N7wC1qtyReg>
    <xme:T35gX6y6sjNZWuTDjLJ6-ZE8teyPPcRUmO_OlOmbHpayX5AJ1ob9TiVTjP6yB-Zxb
    V5A5plO2UNo36k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:T35gX21bwMzoVyyswncbfKWaUcJOctJb4sQaktSLaX6Yhv722Fts0w>
    <xmx:T35gX5BHahNyzEvBv8ADjRXLpc7RMQYsWXt_XUkyQ0fg4-IzSIMwEA>
    <xmx:T35gX6icj9Wo7G4gxTIhkH1GPS8iLs-_dAUk7Clbtg2vRi_OQHKfbA>
    <xmx:T35gX9uW4nJh73n0CZ6pQS8DiNwgrUPumR0syZ4eO-DViOe3cyf3fg>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 462013064674;
        Tue, 15 Sep 2020 04:41:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: reg: Add Monitoring FW Debug Register
Date:   Tue, 15 Sep 2020 11:40:55 +0300
Message-Id: <20200915084058.18555-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915084058.18555-1-idosch@idosch.org>
References: <20200915084058.18555-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Introduce MFDE register that is passed through MFDE trap in case of
fatal FW event.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 79 +++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 485e3e02eb70..f53761114f5a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9880,6 +9880,84 @@ mlxsw_reg_mgpir_unpack(char *payload, u8 *num_of_devices,
 		*num_of_modules = mlxsw_reg_mgpir_num_of_modules_get(payload);
 }
 
+/* MFDE - Monitoring FW Debug Register
+ * -----------------------------------
+ */
+#define MLXSW_REG_MFDE_ID 0x9200
+#define MLXSW_REG_MFDE_LEN 0x18
+
+MLXSW_REG_DEFINE(mfde, MLXSW_REG_MFDE_ID, MLXSW_REG_MFDE_LEN);
+
+/* reg_mfde_irisc_id
+ * Which irisc triggered the event
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, irisc_id, 0x00, 8, 4);
+
+enum mlxsw_reg_mfde_event_id {
+	MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO = 1,
+	/* KVD insertion machine stopped */
+	MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP,
+};
+
+/* reg_mfde_event_id
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, event_id, 0x00, 0, 8);
+
+enum mlxsw_reg_mfde_method {
+	MLXSW_REG_MFDE_METHOD_QUERY,
+	MLXSW_REG_MFDE_METHOD_WRITE,
+};
+
+/* reg_mfde_method
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, method, 0x04, 29, 1);
+
+/* reg_mfde_long_process
+ * Indicates if the command is in long_process mode.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, long_process, 0x04, 28, 1);
+
+enum mlxsw_reg_mfde_command_type {
+	MLXSW_REG_MFDE_COMMAND_TYPE_MAD,
+	MLXSW_REG_MFDE_COMMAND_TYPE_EMAD,
+	MLXSW_REG_MFDE_COMMAND_TYPE_CMDIF,
+};
+
+/* reg_mfde_command_type
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, command_type, 0x04, 24, 2);
+
+/* reg_mfde_reg_attr_id
+ * EMAD - register id, MAD - attibute id
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, reg_attr_id, 0x04, 0, 16);
+
+/* reg_mfde_log_address
+ * crspace address accessed, which resulted in timeout.
+ * Valid in case event_id == MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, log_address, 0x10, 0, 32);
+
+/* reg_mfde_log_id
+ * Which irisc triggered the timeout.
+ * Valid in case event_id == MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, log_id, 0x14, 0, 4);
+
+/* reg_mfde_pipes_mask
+ * Bit per kvh pipe.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, pipes_mask, 0x10, 0, 16);
+
 /* TNGCR - Tunneling NVE General Configuration Register
  * ----------------------------------------------------
  * The TNGCR register is used for setting up the NVE Tunneling configuration.
@@ -10994,6 +11072,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mtpptr),
 	MLXSW_REG(mtptpt),
 	MLXSW_REG(mgpir),
+	MLXSW_REG(mfde),
 	MLXSW_REG(tngcr),
 	MLXSW_REG(tnumt),
 	MLXSW_REG(tnqcr),
-- 
2.26.2

