Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B5BA7083
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbfICQYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbfICQYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 12:24:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D9F2343A;
        Tue,  3 Sep 2019 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527882;
        bh=Nduea2QbyJ3v27nt6zo8M+Qqeb3vl3dkgX4cjqkMiE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuUOhGvBZVMCZc52X6hUPha9RaNg4Gp4QYOyrrY/sP2NzZehRfBQ10Hm8LJ20+YYq
         bDMaqyQW8Lr9BugjNTeeX8wQQZh2szwSOzgqnjcIGeunRPoJvTA/xwEe9eUJCzSMPl
         FBJy4GdHf9tx4m/sVgL6EAdLDuCEuoOIwuXj//dk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 05/23] iwlwifi: add new cards for 22000 and change wrong structs
Date:   Tue,  3 Sep 2019 12:24:06 -0400
Message-Id: <20190903162424.6877-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

add few PCI ID'S for 22000 and chainge few cards structs names

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  36 ++++++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 122 +++++++++---------
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   5 +-
 4 files changed, 103 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 650ca46efc48f..e40fa12212b75 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -265,6 +265,42 @@ const struct iwl_cfg iwl_ax101_cfg_quz_hr = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
+const struct iwl_cfg iwl_ax201_cfg_quz_hr = {
+		.name = "Intel(R) Wi-Fi 6 AX201 160MHz",
+		.fw_name_pre = IWL_QUZ_A_HR_B_FW_PRE,
+		IWL_DEVICE_22500,
+		/*
+         * This device doesn't support receiving BlockAck with a large bitmap
+         * so we need to restrict the size of transmitted aggregation to the
+         * HT size; mac80211 would otherwise pick the HE max (256) by default.
+         */
+		.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
+const struct iwl_cfg iwl_ax1650s_cfg_quz_hr = {
+		.name = "Killer(R) Wi-Fi 6 AX1650s 160MHz Wireless Network Adapter (201D2W)",
+		.fw_name_pre = IWL_QUZ_A_HR_B_FW_PRE,
+		IWL_DEVICE_22500,
+		/*
+         * This device doesn't support receiving BlockAck with a large bitmap
+         * so we need to restrict the size of transmitted aggregation to the
+         * HT size; mac80211 would otherwise pick the HE max (256) by default.
+         */
+		.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
+const struct iwl_cfg iwl_ax1650i_cfg_quz_hr = {
+		.name = "Killer(R) Wi-Fi 6 AX1650i 160MHz Wireless Network Adapter (201NGW)",
+		.fw_name_pre = IWL_QUZ_A_HR_B_FW_PRE,
+		IWL_DEVICE_22500,
+		/*
+         * This device doesn't support receiving BlockAck with a large bitmap
+         * so we need to restrict the size of transmitted aggregation to the
+         * HT size; mac80211 would otherwise pick the HE max (256) by default.
+         */
+		.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
 const struct iwl_cfg iwl_ax200_cfg_cc = {
 	.name = "Intel(R) Wi-Fi 6 AX200 160MHz",
 	.fw_name_pre = IWL_CC_A_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 29aaf649c13c3..dbe6437249f07 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -563,6 +563,9 @@ extern const struct iwl_cfg iwl_ax101_cfg_quz_hr;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
 extern const struct iwl_cfg iwl_ax200_cfg_cc;
 extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
+extern const struct iwl_cfg iwl_ax201_cfg_quz_hr;
+extern const struct iwl_cfg iwl_ax1650i_cfg_quz_hr;
+extern const struct iwl_cfg iwl_ax1650s_cfg_quz_hr;
 extern const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650i_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650x_2ax_cfg;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 2f3ee5769fdd3..02af9073793af 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -517,8 +517,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x02F0, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0040, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -527,7 +525,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x02F0, 0x0234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0238, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x023C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -545,8 +542,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x06F0, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0040, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -555,7 +550,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x06F0, 0x0234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0238, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x023C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -621,7 +615,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x0034, iwl9560_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x0038, iwl9560_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x003C, iwl9560_2ac_160_cfg)},
-	{IWL_PCI_DEVICE(0x2720, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -630,7 +623,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x0234, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x0238, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x023C, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2720, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -708,7 +700,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x34F0, 0x0034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0038, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x003C, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0060, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0064, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x00A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
@@ -717,7 +708,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x34F0, 0x0234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0238, iwl9560_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x023C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0260, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0264, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x02A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
@@ -764,7 +754,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x43F0, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -773,7 +762,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x43F0, 0x0234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0238, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x023C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -833,7 +821,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA0F0, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -842,7 +829,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA0F0, 0x0234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0238, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x023C, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -890,69 +876,80 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x0030, iwl9560_2ac_cfg_qnj_jf_b0)},
 
 /* 22000 Series */
-	{IWL_PCI_DEVICE(0x02F0, 0x0070, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0074, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0078, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x007C, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0310, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0x02F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0x02F0, 0x2074, iwl_ax201_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x4070, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0070, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0074, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0078, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x007C, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0310, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0x06F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0x06F0, 0x2074, iwl_ax201_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x4070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0070, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0074, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0078, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x007C, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0244, iwl_ax101_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0310, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x1651, iwl_ax1650s_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x1652, iwl_ax1650i_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x2074, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x4070, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x4244, iwl_ax101_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0070, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0074, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0078, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x007C, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0244, iwl_ax101_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0310, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x1651, iwl_ax1650s_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x1652, iwl_ax1650i_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x2074, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x4070, iwl_ax201_cfg_quz_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x4244, iwl_ax101_cfg_quz_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0040, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0070, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x2720, 0x0074, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x007C, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0044, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0070, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0074, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x007C, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0090, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x2720, 0x0310, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwl22000_2ac_cfg_hr_cdb)},
+	{IWL_PCI_DEVICE(0x2720, 0x0244, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0310, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x2720, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x2720, 0x2074, iwl_ax201_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x4070, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0074, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x007C, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x4070, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x4244, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0044, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0074, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x007C, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0244, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x2074, iwl_ax201_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x4070, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0040, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0070, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0074, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0078, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x007C, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x4070, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x4244, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0044, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0070, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0074, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0078, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x007C, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x43F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x43F0, 0x2074, iwl_ax201_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x4070, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0040, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0070, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0074, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0078, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x007C, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x00B0, iwl_ax101_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x4070, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x4244, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0044, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0070, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0074, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0078, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x007C, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0244, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl_ax201_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x2074, iwl_ax201_cfg_qu_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x4070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x4070, iwl_ax201_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x4244, iwl_ax101_cfg_qu_hr)},
 
 	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl_ax200_cfg_cc)},
 	{IWL_PCI_DEVICE(0x2723, 0x0084, iwl_ax200_cfg_cc)},
@@ -974,6 +971,9 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x7A70, 0x0310, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7A70, 0x0510, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7A70, 0x0A10, iwlax211_2ax_cfg_so_gf_a0)},
+	{IWL_PCI_DEVICE(0x7AF0, 0x0310, iwlax211_2ax_cfg_so_gf_a0)},
+	{IWL_PCI_DEVICE(0x7AF0, 0x0510, iwlax211_2ax_cfg_so_gf_a0)},
+	{IWL_PCI_DEVICE(0x7AF0, 0x0A10, iwlax211_2ax_cfg_so_gf_a0)},
 
 #endif /* CONFIG_IWLMVM */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 51a3f77474e66..38ab24d962446 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3601,8 +3601,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
 		   ((trans->cfg != &iwl_ax200_cfg_cc &&
-		    trans->cfg != &killer1650x_2ax_cfg &&
-		    trans->cfg != &killer1650w_2ax_cfg) ||
+		     trans->cfg != &killer1650x_2ax_cfg &&
+		     trans->cfg != &killer1650w_2ax_cfg &&
+		     trans->cfg != &iwl_ax201_cfg_quz_hr) ||
 		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0)) {
 		u32 hw_status;
 
-- 
2.20.1

