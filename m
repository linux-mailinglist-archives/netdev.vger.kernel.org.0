Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A3213003C
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgADCuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:50:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:64694 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbgADCt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757895"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Bruce Allan <bruce.w.allan@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 16/16] ice: Add device ids for E822 devices
Date:   Fri,  3 Jan 2020 18:49:53 -0800
Message-Id: <20200104024953.2336731-17-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Add support for E822 devices

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devids.h | 18 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_main.c   |  9 +++++++++
 drivers/net/ethernet/intel/ice/ice_nvm.c    | 12 ++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index f8d5c661d0ba..ce63017c56c7 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -11,5 +11,23 @@
 #define ICE_DEV_ID_E810C_QSFP		0x1592
 /* Intel(R) Ethernet Controller E810-C for SFP */
 #define ICE_DEV_ID_E810C_SFP		0x1593
+/* Intel(R) Ethernet Connection E822-C for backplane */
+#define ICE_DEV_ID_E822C_BACKPLANE	0x1890
+/* Intel(R) Ethernet Connection E822-C for QSFP */
+#define ICE_DEV_ID_E822C_QSFP		0x1891
+/* Intel(R) Ethernet Connection E822-C for SFP */
+#define ICE_DEV_ID_E822C_SFP		0x1892
+/* Intel(R) Ethernet Connection E822-C/X557-AT 10GBASE-T */
+#define ICE_DEV_ID_E822C_10G_BASE_T	0x1893
+/* Intel(R) Ethernet Connection E822-C 1GbE */
+#define ICE_DEV_ID_E822C_SGMII		0x1894
+/* Intel(R) Ethernet Connection E822-X for backplane */
+#define ICE_DEV_ID_E822X_BACKPLANE	0x1897
+/* Intel(R) Ethernet Connection E822-L for SFP */
+#define ICE_DEV_ID_E822L_SFP		0x1898
+/* Intel(R) Ethernet Connection E822-L/X557-AT 10GBASE-T */
+#define ICE_DEV_ID_E822L_10G_BASE_T	0x1899
+/* Intel(R) Ethernet Connection E822-L 1GbE */
+#define ICE_DEV_ID_E822L_SGMII		0x189A
 
 #endif /* _ICE_DEVIDS_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2c9350fcbb59..bf539483e25e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3572,6 +3572,15 @@ static const struct pci_device_id ice_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_BACKPLANE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_QSFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_SFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_BACKPLANE), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_QSFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_SFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_10G_BASE_T), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_SGMII), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822X_BACKPLANE), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_SFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_10G_BASE_T), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822L_SGMII), 0 },
 	/* required last entry */
 	{ 0, }
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 57c73f613f32..7525ac50742e 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -289,6 +289,18 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 
 	nvm->eetrack = (eetrack_hi << 16) | eetrack_lo;
 
+	/* the following devices do not have boot_cfg_tlv yet */
+	if (hw->device_id == ICE_DEV_ID_E822C_BACKPLANE ||
+	    hw->device_id == ICE_DEV_ID_E822C_QSFP ||
+	    hw->device_id == ICE_DEV_ID_E822C_10G_BASE_T ||
+	    hw->device_id == ICE_DEV_ID_E822C_SGMII ||
+	    hw->device_id == ICE_DEV_ID_E822C_SFP ||
+	    hw->device_id == ICE_DEV_ID_E822X_BACKPLANE ||
+	    hw->device_id == ICE_DEV_ID_E822L_SFP ||
+	    hw->device_id == ICE_DEV_ID_E822L_10G_BASE_T ||
+	    hw->device_id == ICE_DEV_ID_E822L_SGMII)
+		return status;
+
 	status = ice_get_pfa_module_tlv(hw, &boot_cfg_tlv, &boot_cfg_tlv_len,
 					ICE_SR_BOOT_CFG_PTR);
 	if (status) {
-- 
2.24.1

