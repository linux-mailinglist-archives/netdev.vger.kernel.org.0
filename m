Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E284343A54
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhCVHLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:11:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33569 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhCVHLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:11:32 -0400
Received: from 1.general.alexhung.us.vpn ([10.172.65.254] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <alex.hung@canonical.com>)
        id 1lOEij-0001hC-6j; Mon, 22 Mar 2021 07:11:25 +0000
From:   Alex Hung <alex.hung@canonical.com>
To:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, matti.gottlieb@intel.com,
        ihab.zhaika@intel.com, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        alex.hung@canonical.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] iwlwifi: add new pci id for 6235
Date:   Mon, 22 Mar 2021 01:11:21 -0600
Message-Id: <20210322071121.265584-1-alex.hung@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lspci output:
Network controller [0280]: Intel Corporation Centrino Advanced-N6235
 [8086:088f] (rev 24)
 Subsystem: Intel Corporation Centrino Advanced-N 6235 [8086:526a]

Cc: stable@vger.kernel.org
Signed-off-by: Alex Hung <alex.hung@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index ffaf973..f85fe36 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -200,6 +200,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x088E, 0x446A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x5260, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x526A, iwl6035_2agn_cfg)},
 
 /* 105 Series */
 	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
-- 
2.7.4

