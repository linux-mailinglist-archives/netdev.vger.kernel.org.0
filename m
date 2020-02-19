Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446AD16521E
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgBSWHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:07:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:62535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgBSWHB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:07:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824830"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/13] ice: add additional E810 device id
Date:   Wed, 19 Feb 2020 14:06:50 -0800
Message-Id: <20200219220652.2255171-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Add support for device id 0x159b.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devids.h | 2 ++
 drivers/net/ethernet/intel/ice/ice_main.c   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index ce63017c56c7..56952d89ada8 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -11,6 +11,8 @@
 #define ICE_DEV_ID_E810C_QSFP		0x1592
 /* Intel(R) Ethernet Controller E810-C for SFP */
 #define ICE_DEV_ID_E810C_SFP		0x1593
+/* Intel(R) Ethernet Controller E810-XXV for SFP */
+#define ICE_DEV_ID_E810_XXV_SFP		0x159B
 /* Intel(R) Ethernet Connection E822-C for backplane */
 #define ICE_DEV_ID_E822C_BACKPLANE	0x1890
 /* Intel(R) Ethernet Connection E822-C for QSFP */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8de63c84e4d6..1fa4904de7e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3552,6 +3552,7 @@ static const struct pci_device_id ice_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_BACKPLANE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_QSFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_SFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_SFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_BACKPLANE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_QSFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822C_SFP), 0 },
-- 
2.24.1

