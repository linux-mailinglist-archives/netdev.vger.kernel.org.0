Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EFF5BB7DB
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 12:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiIQKjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 06:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIQKjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 06:39:32 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A8DC2D;
        Sat, 17 Sep 2022 03:39:30 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MV6lf5rvlz14QRw;
        Sat, 17 Sep 2022 18:35:26 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 18:39:28 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 18:39:27 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>
CC:     <huangdaode@huawei.com>, <liyangyang20@huawei.com>,
        <xuhaoyue1@hisilicon.com>, <huangjunxian6@hisilicon.com>,
        <linuxarm@huawei.com>, <liangwenpeng@huawei.com>
Subject: [PATCH net-next 1/7] net: ll_temac: fix the format of block comments
Date:   Sat, 17 Sep 2022 18:38:37 +0800
Message-ID: <20220917103843.526877-2-xuhaoyue1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
References: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huangjunxian <huangjunxian6@hisilicon.com>

Cleaning some static warnings of block comments.

Signed-off-by: huangjunxian <huangjunxian6@hisilicon.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h      | 181 ++++++++++----------
 drivers/net/ethernet/xilinx/ll_temac_main.c |   6 +-
 drivers/net/ethernet/xilinx/ll_temac_mdio.c |   6 +-
 3 files changed, 103 insertions(+), 90 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index c6395c406418..6668d1b760d8 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -21,36 +21,45 @@
 /*  Configuration options */
 
 /*  Accept all incoming packets.
- *  This option defaults to disabled (cleared) */
+ *  This option defaults to disabled (cleared)
+ */
 #define XTE_OPTION_PROMISC                      (1 << 0)
 /*  Jumbo frame support for Tx & Rx.
- *  This option defaults to disabled (cleared) */
+ *  This option defaults to disabled (cleared)
+ */
 #define XTE_OPTION_JUMBO                        (1 << 1)
 /*  VLAN Rx & Tx frame support.
- *  This option defaults to disabled (cleared) */
+ *  This option defaults to disabled (cleared)
+ */
 #define XTE_OPTION_VLAN                         (1 << 2)
 /*  Enable recognition of flow control frames on Rx
- *  This option defaults to enabled (set) */
+ *  This option defaults to enabled (set)
+ */
 #define XTE_OPTION_FLOW_CONTROL                 (1 << 4)
 /*  Strip FCS and PAD from incoming frames.
  *  Note: PAD from VLAN frames is not stripped.
- *  This option defaults to disabled (set) */
+ *  This option defaults to disabled (set)
+ */
 #define XTE_OPTION_FCS_STRIP                    (1 << 5)
 /*  Generate FCS field and add PAD automatically for outgoing frames.
- *  This option defaults to enabled (set) */
+ *  This option defaults to enabled (set)
+ */
 #define XTE_OPTION_FCS_INSERT                   (1 << 6)
 /*  Enable Length/Type error checking for incoming frames. When this option is
-set, the MAC will filter frames that have a mismatched type/length field
-and if XTE_OPTION_REPORT_RXERR is set, the user is notified when these
-types of frames are encountered. When this option is cleared, the MAC will
-allow these types of frames to be received.
-This option defaults to enabled (set) */
+ *  set, the MAC will filter frames that have a mismatched type/length field
+ *  and if XTE_OPTION_REPORT_RXERR is set, the user is notified when these
+ *  types of frames are encountered. When this option is cleared, the MAC will
+ *  allow these types of frames to be received.
+ *  This option defaults to enabled (set)
+ */
 #define XTE_OPTION_LENTYPE_ERR                  (1 << 7)
 /*  Enable the transmitter.
- *  This option defaults to enabled (set) */
+ *  This option defaults to enabled (set)
+ */
 #define XTE_OPTION_TXEN                         (1 << 11)
 /*  Enable the receiver
-*   This option defaults to enabled (set) */
+ *  This option defaults to enabled (set)
+ */
 #define XTE_OPTION_RXEN                         (1 << 12)
 
 /*  Default options set when device is initialized or reset */
@@ -68,18 +77,18 @@ This option defaults to enabled (set) */
 #define TX_TAILDESC_PTR     0x04            /* rw */
 #define TX_CHNL_CTRL        0x05            /* rw */
 /*
- 0:7      24:31       IRQTimeout
- 8:15     16:23       IRQCount
- 16:20    11:15       Reserved
- 21       10          0
- 22       9           UseIntOnEnd
- 23       8           LdIRQCnt
- 24       7           IRQEn
- 25:28    3:6         Reserved
- 29       2           IrqErrEn
- 30       1           IrqDlyEn
- 31       0           IrqCoalEn
-*/
+ *  0:7      24:31       IRQTimeout
+ *  8:15     16:23       IRQCount
+ *  16:20    11:15       Reserved
+ *  21       10          0
+ *  22       9           UseIntOnEnd
+ *  23       8           LdIRQCnt
+ *  24       7           IRQEn
+ *  25:28    3:6         Reserved
+ *  29       2           IrqErrEn
+ *  30       1           IrqDlyEn
+ *  31       0           IrqCoalEn
+ */
 #define CHNL_CTRL_IRQ_IOE       (1 << 9)
 #define CHNL_CTRL_IRQ_EN        (1 << 7)
 #define CHNL_CTRL_IRQ_ERR_EN    (1 << 2)
@@ -87,35 +96,35 @@ This option defaults to enabled (set) */
 #define CHNL_CTRL_IRQ_COAL_EN   (1 << 0)
 #define TX_IRQ_REG          0x06            /* rw */
 /*
-  0:7      24:31       DltTmrValue
- 8:15     16:23       ClscCntrValue
- 16:17    14:15       Reserved
- 18:21    10:13       ClscCnt
- 22:23    8:9         DlyCnt
- 24:28    3::7        Reserved
- 29       2           ErrIrq
- 30       1           DlyIrq
- 31       0           CoalIrq
+ *  0:7      24:31       DltTmrValue
+ *  8:15     16:23       ClscCntrValue
+ *  16:17    14:15       Reserved
+ *  18:21    10:13       ClscCnt
+ *  22:23    8:9         DlyCnt
+ *  24:28    3::7        Reserved
+ *  29       2           ErrIrq
+ *  30       1           DlyIrq
+ *  31       0           CoalIrq
  */
 #define TX_CHNL_STS         0x07            /* r */
 /*
-   0:9      22:31   Reserved
- 10       21      TailPErr
- 11       20      CmpErr
- 12       19      AddrErr
- 13       18      NxtPErr
- 14       17      CurPErr
- 15       16      BsyWr
- 16:23    8:15    Reserved
- 24       7       Error
- 25       6       IOE
- 26       5       SOE
- 27       4       Cmplt
- 28       3       SOP
- 29       2       EOP
- 30       1       EngBusy
- 31       0       Reserved
-*/
+ *  0:9      22:31   Reserved
+ *  10       21      TailPErr
+ *  11       20      CmpErr
+ *  12       19      AddrErr
+ *  13       18      NxtPErr
+ *  14       17      CurPErr
+ *  15       16      BsyWr
+ *  16:23    8:15    Reserved
+ *  24       7       Error
+ *  25       6       IOE
+ *  26       5       SOE
+ *  27       4       Cmplt
+ *  28       3       SOP
+ *  29       2       EOP
+ *  30       1       EngBusy
+ *  31       0       Reserved
+ */
 
 #define RX_NXTDESC_PTR      0x08            /* r */
 #define RX_CURBUF_ADDR      0x09            /* r */
@@ -124,17 +133,17 @@ This option defaults to enabled (set) */
 #define RX_TAILDESC_PTR     0x0c            /* rw */
 #define RX_CHNL_CTRL        0x0d            /* rw */
 /*
- 0:7      24:31       IRQTimeout
- 8:15     16:23       IRQCount
- 16:20    11:15       Reserved
- 21       10          0
- 22       9           UseIntOnEnd
- 23       8           LdIRQCnt
- 24       7           IRQEn
- 25:28    3:6         Reserved
- 29       2           IrqErrEn
- 30       1           IrqDlyEn
- 31       0           IrqCoalEn
+ *  0:7      24:31       IRQTimeout
+ *  8:15     16:23       IRQCount
+ *  16:20    11:15       Reserved
+ *  21       10          0
+ *  22       9           UseIntOnEnd
+ *  23       8           LdIRQCnt
+ *  24       7           IRQEn
+ *  25:28    3:6         Reserved
+ *  29       2           IrqErrEn
+ *  30       1           IrqDlyEn
+ *  31       0           IrqCoalEn
  */
 #define RX_IRQ_REG          0x0e            /* rw */
 #define IRQ_COAL        (1 << 0)
@@ -142,13 +151,13 @@ This option defaults to enabled (set) */
 #define IRQ_ERR         (1 << 2)
 #define IRQ_DMAERR      (1 << 7)            /* this is not documented ??? */
 /*
- 0:7      24:31       DltTmrValue
- 8:15     16:23       ClscCntrValue
- 16:17    14:15       Reserved
- 18:21    10:13       ClscCnt
- 22:23    8:9         DlyCnt
- 24:28    3::7        Reserved
-*/
+ *  0:7      24:31       DltTmrValue
+ *  8:15     16:23       ClscCntrValue
+ *  16:17    14:15       Reserved
+ *  18:21    10:13       ClscCnt
+ *  22:23    8:9         DlyCnt
+ *  24:28    3::7        Reserved
+ */
 #define RX_CHNL_STS         0x0f        /* r */
 #define CHNL_STS_ENGBUSY    (1 << 1)
 #define CHNL_STS_EOP        (1 << 2)
@@ -165,23 +174,23 @@ This option defaults to enabled (set) */
 #define CHNL_STS_CMPERR     (1 << 20)
 #define CHNL_STS_TAILERR    (1 << 21)
 /*
- 0:9      22:31   Reserved
- 10       21      TailPErr
- 11       20      CmpErr
- 12       19      AddrErr
- 13       18      NxtPErr
- 14       17      CurPErr
- 15       16      BsyWr
- 16:23    8:15    Reserved
- 24       7       Error
- 25       6       IOE
- 26       5       SOE
- 27       4       Cmplt
- 28       3       SOP
- 29       2       EOP
- 30       1       EngBusy
- 31       0       Reserved
-*/
+ *  0:9      22:31   Reserved
+ *  10       21      TailPErr
+ *  11       20      CmpErr
+ *  12       19      AddrErr
+ *  13       18      NxtPErr
+ *  14       17      CurPErr
+ *  15       16      BsyWr
+ *  16:23    8:15    Reserved
+ *  24       7       Error
+ *  25       6       IOE
+ *  26       5       SOE
+ *  27       4       Cmplt
+ *  28       3       SOP
+ *  29       2       EOP
+ *  30       1       EngBusy
+ *  31       0       Reserved
+ */
 
 #define DMA_CONTROL_REG             0x10            /* rw */
 #define DMA_CONTROL_RST                 (1 << 0)
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 3f6b9dfca095..1dfbd85b848d 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -430,7 +430,8 @@ static void temac_do_set_mac_address(struct net_device *ndev)
 				    (ndev->dev_addr[2] << 16) |
 				    (ndev->dev_addr[3] << 24));
 	/* There are reserved bits in EUAW1
-	 * so don't affect them Set MAC bits [47:32] in EUAW1 */
+	 * so don't affect them Set MAC bits [47:32] in EUAW1
+	 */
 	temac_indirect_out32_locked(lp, XTE_UAW1_OFFSET,
 				    (ndev->dev_addr[4] & 0x000000ff) |
 				    (ndev->dev_addr[5] << 8));
@@ -691,7 +692,8 @@ static void temac_device_reset(struct net_device *ndev)
 	spin_unlock_irqrestore(lp->indirect_lock, flags);
 
 	/* Sync default options with HW
-	 * but leave receiver and transmitter disabled.  */
+	 * but leave receiver and transmitter disabled.
+	 */
 	temac_setoptions(ndev,
 			 lp->options & ~(XTE_OPTION_TXEN | XTE_OPTION_RXEN));
 
diff --git a/drivers/net/ethernet/xilinx/ll_temac_mdio.c b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
index 6fd2dea4e60f..2371c072b53f 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_mdio.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
@@ -29,7 +29,8 @@ static int temac_mdio_read(struct mii_bus *bus, int phy_id, int reg)
 
 	/* Write the PHY address to the MIIM Access Initiator register.
 	 * When the transfer completes, the PHY register value will appear
-	 * in the LSW0 register */
+	 * in the LSW0 register
+	 */
 	spin_lock_irqsave(lp->indirect_lock, flags);
 	temac_iow(lp, XTE_LSW0_OFFSET, (phy_id << 5) | reg);
 	rc = temac_indirect_in32_locked(lp, XTE_MIIMAI_OFFSET);
@@ -88,7 +89,8 @@ int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 	}
 
 	/* Enable the MDIO bus by asserting the enable bit and writing
-	 * in the clock config */
+	 * in the clock config
+	 */
 	temac_indirect_out32(lp, XTE_MC_OFFSET, 1 << 6 | clk_div);
 
 	bus = devm_mdiobus_alloc(&pdev->dev);
-- 
2.30.0

