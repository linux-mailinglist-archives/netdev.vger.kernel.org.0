Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892843F5446
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhHXAyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233536AbhHXAyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97AF7613AD;
        Tue, 24 Aug 2021 00:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766441;
        bh=8uGhlzw8itBNSqnqsC9IrVharzy9ChGrbnsD8NU3DQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urdxF2d2Rrilwg8fMEl0nGnhH+8qyluNbyQWmUXq5MLVS6pVcRANFgiahxtZ0huuN
         9eWWkBmDqTvxyfb+Lu3nZUmCYiHPq0EwPxIdpHqpgDStjObw1s5Go7Y2UXL42NRcEy
         f+f3RXvCoD9cavwFGiB37InL7mnBix+XavPrfcTOC5z/qllREFVMfHWtd55rjKw++p
         qJhSsyuJgah6lOtEUK2SiVfM382bc0xuWWZV0/tq6I+0aYYJXWWWEAasgaaSQ2LDro
         Uge+okqCcTt39hniaDdUrmqmvE7sV2qZzdteM95XygnANpmTVdsUEC1D/kvKSz2WY2
         a9YDMwIC8Q8Zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yaara Baruch <yaara.baruch@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 03/26] iwlwifi: add new so-jf devices
Date:   Mon, 23 Aug 2021 20:53:33 -0400
Message-Id: <20210824005356.630888-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yaara Baruch <yaara.baruch@intel.com>

[ Upstream commit 891332f697e14bfb2002f56e21d9bbd4800a7098 ]

Add new so-jf devices to the driver.

Signed-off-by: Yaara Baruch <yaara.baruch@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210719144523.1c9a59fd2760.If5aef1942007828210f0f2c4a17985f63050bb45@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 36 ++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index cd204a9ec87d..9f11a1d5d034 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1142,7 +1142,41 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
 		      IWL_CFG_RF_TYPE_GF, IWL_CFG_ANY,
 		      IWL_CFG_160, IWL_CFG_ANY, IWL_CFG_NO_CDB,
-		      iwlax211_2ax_cfg_so_gf_a0, iwl_ax211_name)
+		      iwlax211_2ax_cfg_so_gf_a0, iwl_ax211_name),
+
+/* So with JF2 */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_name),
+
+/* So with JF */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_name)
 
 #endif /* CONFIG_IWLMVM */
 };
-- 
2.30.2

