Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5DAE3677
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 17:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503107AbfJXPWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 11:22:12 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:58726 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503090AbfJXPWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 11:22:08 -0400
Received: from ramsan ([84.195.182.253])
        by michel.telenet-ops.be with bizsmtp
        id HTN42100f5USYZQ06TN4cn; Thu, 24 Oct 2019 17:22:05 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNew8-00075D-LG; Thu, 24 Oct 2019 17:22:04 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNew8-0007mV-Iv; Thu, 24 Oct 2019 17:22:04 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jiri Kosina <trivial@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] [trivial] net: Fix misspellings of "configure" and "configuration"
Date:   Thu, 24 Oct 2019 17:22:01 +0200
Message-Id: <20191024152201.29868-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix various misspellings of "configuration" and "configure".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - Merge
    [trivial] net/mlx5e: Spelling s/configuraiton/configuration/
    [trivial] qed: Spelling s/configuraiton/configuration/
  - Fix typo in subject,
  - Extend with various other similar misspellings.
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.h                | 4 ++--
 drivers/net/ethernet/qlogic/qed/qed_sriov.h              | 2 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c           | 2 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c               | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h              | 2 +-
 drivers/net/wireless/ti/wlcore/spi.c                     | 2 +-
 include/uapi/linux/dcbnl.h                               | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 633b117eb13e8143..7b672ada63a39733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -175,7 +175,7 @@ static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
  *	@port_buffer: <output> port receive buffer configuration
  *	@change: <output>
  *
- *	Update buffer configuration based on pfc configuraiton and
+ *	Update buffer configuration based on pfc configuration and
  *	priority to buffer mapping.
  *	Buffer's lossy bit is changed to:
  *		lossless if there is at least one PFC enabled priority
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index d473b522afc5137f..9ad568d93ae6501c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -37,14 +37,14 @@
 #include <linux/slab.h>
 #include "qed.h"
 
-/* Fields of IGU PF CONFIGRATION REGISTER */
+/* Fields of IGU PF CONFIGURATION REGISTER */
 #define IGU_PF_CONF_FUNC_EN       (0x1 << 0)    /* function enable        */
 #define IGU_PF_CONF_MSI_MSIX_EN   (0x1 << 1)    /* MSI/MSIX enable        */
 #define IGU_PF_CONF_INT_LINE_EN   (0x1 << 2)    /* INT enable             */
 #define IGU_PF_CONF_ATTN_BIT_EN   (0x1 << 3)    /* attention enable       */
 #define IGU_PF_CONF_SINGLE_ISR_EN (0x1 << 4)    /* single ISR mode enable */
 #define IGU_PF_CONF_SIMD_MODE     (0x1 << 5)    /* simd all ones mode     */
-/* Fields of IGU VF CONFIGRATION REGISTER */
+/* Fields of IGU VF CONFIGURATION REGISTER */
 #define IGU_VF_CONF_FUNC_EN        (0x1 << 0)	/* function enable        */
 #define IGU_VF_CONF_MSI_MSIX_EN    (0x1 << 1)	/* MSI/MSIX enable        */
 #define IGU_VF_CONF_SINGLE_ISR_EN  (0x1 << 4)	/* single ISR mode enable */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.h b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
index 9a8fd79611f24909..368e88565783bb50 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -305,7 +305,7 @@ void qed_iov_bulletin_set_udp_ports(struct qed_hwfn *p_hwfn,
 
 /**
  * @brief Read sriov related information and allocated resources
- *  reads from configuraiton space, shmem, etc.
+ *  reads from configuration space, shmem, etc.
  *
  * @param p_hwfn
  *
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 9a6a9a008714659a..d6cfe4ffbaf3d883 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1298,7 +1298,7 @@ void qede_config_rx_mode(struct net_device *ndev)
 	rx_mode.type = QED_FILTER_TYPE_RX_MODE;
 
 	/* Remove all previous unicast secondary macs and multicast macs
-	 * (configrue / leave the primary mac)
+	 * (configure / leave the primary mac)
 	 */
 	rc = qede_set_ucast_rx_mac(edev, QED_FILTER_XCAST_TYPE_REPLACE,
 				   edev->ndev->dev_addr);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 2fe12b0de5b4f2a4..42f00a2a8c8007d2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -1037,7 +1037,7 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 	}
 
 	/*
-	 * Configire PCIE after Ini init. SERDES values now come from ini file
+	 * Configure PCIE after Ini init. SERDES values now come from ini file
 	 * This enables PCIe low power mode.
 	 */
 	array = power_off ? &ah->iniPcieSerdes :
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 0c12df5582409db3..05c1c77c88a0f738 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -148,7 +148,7 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(struct iwl_trans *trans,
  *
  * Bits 3:0:
  * Define the maximum number of pending read requests.
- * Maximum configration value allowed is 0xC
+ * Maximum configuration value allowed is 0xC
  * Bits 9:8:
  * Define the maximum transfer size. (64 / 128 / 256)
  * Bit 10:
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index d4c09e54fd634d61..18c4d998ce4b92e6 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -186,7 +186,7 @@ static void wl12xx_spi_init(struct device *child)
 
 	spi_sync(to_spi_device(glue->dev), &m);
 
-	/* Restore chip select configration to normal */
+	/* Restore chip select configuration to normal */
 	spi->mode ^= SPI_CS_HIGH;
 	kfree(cmd);
 }
diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
index 69df19aa8e728909..a791a94013a69a61 100644
--- a/include/uapi/linux/dcbnl.h
+++ b/include/uapi/linux/dcbnl.h
@@ -286,7 +286,7 @@ struct dcbmsg {
  * @DCB_CMD_GNUMTCS: get the number of traffic classes currently supported
  * @DCB_CMD_SNUMTCS: set the number of traffic classes
  * @DCB_CMD_GBCN: set backward congestion notification configuration
- * @DCB_CMD_SBCN: get backward congestion notification configration.
+ * @DCB_CMD_SBCN: get backward congestion notification configuration.
  * @DCB_CMD_GAPP: get application protocol configuration
  * @DCB_CMD_SAPP: set application protocol configuration
  * @DCB_CMD_IEEE_SET: set IEEE 802.1Qaz configuration
-- 
2.17.1

