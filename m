Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD92F65A4
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKJCow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbfKJCos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7ACF215EA;
        Sun, 10 Nov 2019 02:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353887;
        bh=YUdWJefQqbJCfgysInUFfykhGjVrzLCnQMM6zBJYnkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vxhm1GP9BfqhIBPvV1WvFlw0B4k5wW2RadfUv2SIIKmBmUCwKMQERhAqdbTpuI4k1
         0xHgC3Ik8FKG/jkNBaWjJ6k9MG0lXXetLjz2m5XZY+Clmqylgld5A/6aKveu0lRLpK
         w6GDzp7Qu+99AP2acQoZrZ4UILbWzYpBOokHikAA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erel Geron <erelx.geron@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 161/191] iwlwifi: fix non_shared_ant for 22000 devices
Date:   Sat,  9 Nov 2019 21:39:43 -0500
Message-Id: <20191110024013.29782-161-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erel Geron <erelx.geron@intel.com>

[ Upstream commit a40287727d9b737e183959fd31a4e0c55f312853 ]

The non-shared antenna was wrong for 22000 device series.
Fix it to ANT_B for correct antenna preference by coex in MVM driver.

Fixes: e34d975e40ff ("iwlwifi: Add a000 HW family support")
Signed-off-by: Erel Geron <erelx.geron@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index b4347806a59ed..a0de61aa0feff 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -143,7 +143,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.ucode_api_min = IWL_22000_UCODE_API_MIN,			\
 	.led_mode = IWL_LED_RF_STATE,					\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_22000,		\
-	.non_shared_ant = ANT_A,					\
+	.non_shared_ant = ANT_B,					\
 	.dccm_offset = IWL_22000_DCCM_OFFSET,				\
 	.dccm_len = IWL_22000_DCCM_LEN,					\
 	.dccm2_offset = IWL_22000_DCCM2_OFFSET,				\
-- 
2.20.1

