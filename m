Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D18813C8C
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfEEBTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:19:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:33074 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbfEEBTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:19:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:14:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="297102543"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2019 18:14:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/12] i40e: add new pci id for X710/XXV710 N3000 cards
Date:   Sat,  4 May 2019 18:13:59 -0700
Message-Id: <20190505011409.6771-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
References: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

New device ids are created to support X710/XXV710 N3000 cards.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 2 ++
 drivers/net/ethernet/intel/i40e/i40e_devids.h | 2 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index e7d500f92a90..8de6e007b4a0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -32,6 +32,8 @@ static i40e_status i40e_set_mac_type(struct i40e_hw *hw)
 		case I40E_DEV_ID_20G_KR2_A:
 		case I40E_DEV_ID_25G_B:
 		case I40E_DEV_ID_25G_SFP28:
+		case I40E_DEV_ID_X710_N3000:
+		case I40E_DEV_ID_XXV710_N3000:
 			hw->mac.type = I40E_MAC_XL710;
 			break;
 		case I40E_DEV_ID_KX_X722:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_devids.h b/drivers/net/ethernet/intel/i40e/i40e_devids.h
index 334b05ff685a..16be4d5286bd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_devids.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_devids.h
@@ -5,6 +5,8 @@
 #define _I40E_DEVIDS_H_
 
 /* Device IDs */
+#define I40E_DEV_ID_X710_N3000		0x0CF8
+#define I40E_DEV_ID_XXV710_N3000	0x0D58
 #define I40E_DEV_ID_SFP_XL710		0x1572
 #define I40E_DEV_ID_QEMU		0x1574
 #define I40E_DEV_ID_KX_B		0x1580
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index fa1b2cfd359e..7d0183c67cff 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -81,6 +81,8 @@ static const struct pci_device_id i40e_pci_tbl[] = {
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_SFP_I_X722), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_20G_KR2), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_20G_KR2_A), 0},
+	{PCI_VDEVICE(INTEL, I40E_DEV_ID_X710_N3000), 0},
+	{PCI_VDEVICE(INTEL, I40E_DEV_ID_XXV710_N3000), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_25G_B), 0},
 	{PCI_VDEVICE(INTEL, I40E_DEV_ID_25G_SFP28), 0},
 	/* required last entry */
-- 
2.20.1

