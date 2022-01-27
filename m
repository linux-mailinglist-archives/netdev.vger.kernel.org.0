Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD32649E907
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240561AbiA0RbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:31:05 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:57213 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238232AbiA0RbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:31:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643304664; x=1674840664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F8/6AyDwHbuCM2xmbOtVCusdSb7+rM42lQXfetuf4KQ=;
  b=ipbaIzNVeH6npJQoMfxxRCSywmXqwV5b4PKWuxZT8wxjDBBE30cgTgmw
   5ATTe58zrIoZeRzbV4AmuBD79RaNjSVX9+EstIzextdX+2mIFurBkr9iz
   uj6lUZXW556uM1JxUha1d5lK356on/JnYEZhFRNIqdxRcc/P/1l1KFvVJ
   yM9ANkOIMIWB5PdsZ6ATjP+Fy9IKQtXideKS/U9i3M1EiM74WBpnGBx38
   Kfmpm3/LylKBghTDFi2JETbUNX98/yuO6RvtDctUOpSUCSvtl55k1xBa1
   Mkp1rix5/RFt/Uea0SxzWdj7UnWMP6u0bdwaSH5kPwteB6PNN/QM4ip85
   g==;
IronPort-SDR: pz9BU9mivLsF95UlfUjMhsw4jKuJckBWrJzk6KCXsOg1AWiAt+T6qsMIP531dtR7ltWMPmIwVS
 WdSeVVNvG4zQk9OyitW5IPzjy/8yVeO8znq29AgUMMcJEfUpC5VmDsg5DCozb90YhgviUQkaTb
 9m0XBPSq27f6cPmLvqPq6hvNPqqMK+CCg8CutAJopAnHUF98NIqWGxnv1VEqlKz7JMOfnwiGB3
 g/CWJlEUYRR9HPsLHrGhkrmE6XDz+b74XxoYI3ISdCTFyWpZankMi3ij78u+UXUKsjhcQz9B5+
 +E68rifpe0AGBt3mcyJpfuYg
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="83901346"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 10:31:04 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 10:31:04 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 10:31:02 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 1/5] net: lan743x: Add PCI1A011/PCI1A041 chip driver
Date:   Thu, 27 Jan 2022 23:00:51 +0530
Message-ID: <20220127173055.308918-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
References: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCI1A011/PCI1A041 chip is enhancement of Ethernet LAN743x chip family.

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c |  6 ++++++
 drivers/net/ethernet/microchip/lan743x_main.h | 10 ++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 8c6390d95158..49eeff8757e5 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2758,6 +2758,10 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 	if ((adapter->csr.id_rev & ID_REV_ID_MASK_) == ID_REV_ID_LAN7430_)
 		/* LAN7430 uses internal phy at address 1 */
 		adapter->mdiobus->phy_mask = ~(u32)BIT(1);
+	else if (((adapter->csr.id_rev & ID_REV_ID_MASK_) == ID_REV_ID_PCIA011_) ||
+		 ((adapter->csr.id_rev & ID_REV_ID_MASK_) == ID_REV_ID_PCIA041_))
+		/* PCIA011/PCIA041 uses internal phy at address 1 */
+		adapter->mdiobus->phy_mask = ~(u32)BIT(1);
 
 	/* register mdiobus */
 	ret = mdiobus_register(adapter->mdiobus);
@@ -3056,6 +3060,8 @@ static const struct dev_pm_ops lan743x_pm_ops = {
 static const struct pci_device_id lan743x_pcidev_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SMSC, PCI_DEVICE_ID_SMSC_LAN7430) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SMSC, PCI_DEVICE_ID_SMSC_LAN7431) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_SMSC, PCI_DEVICE_ID_SMSC_PCIA011) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_SMSC, PCI_DEVICE_ID_SMSC_PCIA041) },
 	{ 0, }
 };
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index aaf7aaeaba0c..a9d722f719f9 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -16,8 +16,12 @@
 #define ID_REV_ID_MASK_			(0xFFFF0000)
 #define ID_REV_ID_LAN7430_		(0x74300000)
 #define ID_REV_ID_LAN7431_		(0x74310000)
-#define ID_REV_IS_VALID_CHIP_ID_(id_rev)	\
-	(((id_rev) & 0xFFF00000) == 0x74300000)
+#define ID_REV_ID_PCIA011_		(0xA0110000)	// PCI11010
+#define ID_REV_ID_PCIA041_		(0xA0410000)	// PCI11414
+#define ID_REV_IS_VALID_CHIP_ID_(id_rev)	    \
+	((((id_rev) & 0xFFF00000) == 0x74300000) || \
+	 (((id_rev) & 0xFFF00000) == 0xA0100000) || \
+	 (((id_rev) & 0xFFF00000) == 0xA0400000))
 #define ID_REV_CHIP_REV_MASK_		(0x0000FFFF)
 #define ID_REV_CHIP_REV_A0_		(0x00000000)
 #define ID_REV_CHIP_REV_B0_		(0x00000010)
@@ -559,6 +563,8 @@ struct lan743x_adapter;
 #define PCI_VENDOR_ID_SMSC		PCI_VENDOR_ID_EFAR
 #define PCI_DEVICE_ID_SMSC_LAN7430	(0x7430)
 #define PCI_DEVICE_ID_SMSC_LAN7431	(0x7431)
+#define PCI_DEVICE_ID_SMSC_PCIA011	(0xA011)
+#define PCI_DEVICE_ID_SMSC_PCIA041	(0xA041)
 
 #define PCI_CONFIG_LENGTH		(0x1000)
 
-- 
2.25.1

