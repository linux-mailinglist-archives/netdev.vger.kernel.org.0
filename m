Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8250D380
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiDXQcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiDXQce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:32:34 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929E79F39D;
        Sun, 24 Apr 2022 09:29:32 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 17AAC30B294B;
        Sun, 24 Apr 2022 18:29:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:date:from
        :from:in-reply-to:message-id:mime-version:references:reply-to
        :subject:subject:to:to; s=felkmail; bh=Ax0KQPwjuExnaEvtd22PQdQnU
        r+CXdcm1/Rj4ihe0y8=; b=gDE7F9u2ikEnMGnudKDqwma7vTNegIffcl0wDMPXG
        01YXRYqTT5IAkfzWpU+mO0UoNQ1p+uFc4dbCJLTka2VtfxgJS2eCPpik6fX+CKBF
        rix02b+s4OZMhTtbeNJhEB1JpWrhDwWH4sjnpy3Zkd+89FX77JcHqHQQLLgzp5gh
        nYv1P8R34I8GcWK0Qeps6DEVIS7ciXAW9JuqiMZgxoxN+9GA2YpqL6ajkjyr3hf0
        Vqy25NXU2We+T+3RCB/alSs0QtwGGcthGsVhedMYPPISOdsVDpLUGEmZJx9L23fW
        +zXrq+wx501WmtkK/QVzyt5Xxtl7eqqTsKJ1KbSAkJvPQ==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 4829F30ADC00;
        Sun, 24 Apr 2022 18:29:30 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23OGTTrY030937;
        Sun, 24 Apr 2022 18:29:29 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23OGTTAY030936;
        Sun, 24 Apr 2022 18:29:29 +0200
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v1 1/4] can: ctucanfd: remove PCI module debug parameters and core debug statements
Date:   Sun, 24 Apr 2022 18:28:08 +0200
Message-Id: <1fd684bcf5ddb0346aad234072f54e976a5210fb.1650816929.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This and remove of inline keyword from the local static functions
should make happy all checks in actual versions of the both checkpatch.pl
and patchwork tools.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c | 33 +++---------------------
 drivers/net/can/ctucanfd/ctucanfd_pci.c  | 22 +++++-----------
 2 files changed, 9 insertions(+), 46 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index 7a4550f60abb..a1f6d37fca11 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -133,13 +133,12 @@ static u32 ctucan_read32_be(struct ctucan_priv *priv,
 	return ioread32be(priv->mem_base + reg);
 }
 
-static inline void ctucan_write32(struct ctucan_priv *priv, enum ctu_can_fd_can_registers reg,
-				  u32 val)
+static void ctucan_write32(struct ctucan_priv *priv, enum ctu_can_fd_can_registers reg, u32 val)
 {
 	priv->write_reg(priv, reg, val);
 }
 
-static inline u32 ctucan_read32(struct ctucan_priv *priv, enum ctu_can_fd_can_registers reg)
+static u32 ctucan_read32(struct ctucan_priv *priv, enum ctu_can_fd_can_registers reg)
 {
 	return priv->read_reg(priv, reg);
 }
@@ -179,8 +178,6 @@ static int ctucan_reset(struct net_device *ndev)
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	int i = 100;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	ctucan_write32(priv, CTUCANFD_MODE, REG_MODE_RST);
 	clear_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags);
 
@@ -266,8 +263,6 @@ static int ctucan_set_bittiming(struct net_device *ndev)
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	struct can_bittiming *bt = &priv->can.bittiming;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	/* Note that bt may be modified here */
 	return ctucan_set_btr(ndev, bt, true);
 }
@@ -283,8 +278,6 @@ static int ctucan_set_data_bittiming(struct net_device *ndev)
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	struct can_bittiming *dbt = &priv->can.data_bittiming;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	/* Note that dbt may be modified here */
 	return ctucan_set_btr(ndev, dbt, false);
 }
@@ -302,8 +295,6 @@ static int ctucan_set_secondary_sample_point(struct net_device *ndev)
 	int ssp_offset = 0;
 	u32 ssp_cfg = 0; /* No SSP by default */
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	if (CTU_CAN_FD_ENABLED(priv)) {
 		netdev_err(ndev, "BUG! Cannot set SSP - CAN is enabled\n");
 		return -EPERM;
@@ -390,8 +381,6 @@ static int ctucan_chip_start(struct net_device *ndev)
 	int err;
 	struct can_ctrlmode mode;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	priv->txb_prio = 0x01234567;
 	priv->txb_head = 0;
 	priv->txb_tail = 0;
@@ -457,8 +446,6 @@ static int ctucan_do_set_mode(struct net_device *ndev, enum can_mode mode)
 {
 	int ret;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	switch (mode) {
 	case CAN_MODE_START:
 		ret = ctucan_reset(ndev);
@@ -486,7 +473,7 @@ static int ctucan_do_set_mode(struct net_device *ndev, enum can_mode mode)
  *
  * Return: Status of TXT buffer
  */
-static inline enum ctucan_txtb_status ctucan_get_tx_status(struct ctucan_priv *priv, u8 buf)
+static enum ctucan_txtb_status ctucan_get_tx_status(struct ctucan_priv *priv, u8 buf)
 {
 	u32 tx_status = ctucan_read32(priv, CTUCANFD_TX_STATUS);
 	enum ctucan_txtb_status status = (tx_status >> (buf * 4)) & 0x7;
@@ -1123,8 +1110,6 @@ static irqreturn_t ctucan_interrupt(int irq, void *dev_id)
 	u32 imask;
 	int irq_loops;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	for (irq_loops = 0; irq_loops < 10000; irq_loops++) {
 		/* Get the interrupt status */
 		isr = ctucan_read32(priv, CTUCANFD_INT_STAT);
@@ -1198,8 +1183,6 @@ static void ctucan_chip_stop(struct net_device *ndev)
 	u32 mask = 0xffffffff;
 	u32 mode;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	/* Disable interrupts and disable CAN */
 	ctucan_write32(priv, CTUCANFD_INT_ENA_CLR, mask);
 	ctucan_write32(priv, CTUCANFD_INT_MASK_SET, mask);
@@ -1222,8 +1205,6 @@ static int ctucan_open(struct net_device *ndev)
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	ret = pm_runtime_get_sync(priv->dev);
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
@@ -1283,8 +1264,6 @@ static int ctucan_close(struct net_device *ndev)
 {
 	struct ctucan_priv *priv = netdev_priv(ndev);
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	netif_stop_queue(ndev);
 	napi_disable(&priv->napi);
 	ctucan_chip_stop(ndev);
@@ -1310,8 +1289,6 @@ static int ctucan_get_berr_counter(const struct net_device *ndev, struct can_ber
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	ret = pm_runtime_get_sync(priv->dev);
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n", __func__, ret);
@@ -1337,8 +1314,6 @@ int ctucan_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct ctucan_priv *priv = netdev_priv(ndev);
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	if (netif_running(ndev)) {
 		netif_stop_queue(ndev);
 		netif_device_detach(ndev);
@@ -1355,8 +1330,6 @@ int ctucan_resume(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct ctucan_priv *priv = netdev_priv(ndev);
 
-	ctucan_netdev_dbg(ndev, "%s\n", __func__);
-
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	if (netif_running(ndev)) {
diff --git a/drivers/net/can/ctucanfd/ctucanfd_pci.c b/drivers/net/can/ctucanfd/ctucanfd_pci.c
index c37a42480533..8f2956a8ae43 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_pci.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_pci.c
@@ -45,14 +45,6 @@
 #define CTUCAN_WITHOUT_CTUCAN_ID  0
 #define CTUCAN_WITH_CTUCAN_ID     1
 
-static bool use_msi = true;
-module_param(use_msi, bool, 0444);
-MODULE_PARM_DESC(use_msi, "PCIe implementation use MSI interrupts. Default: 1 (yes)");
-
-static bool pci_use_second = true;
-module_param(pci_use_second, bool, 0444);
-MODULE_PARM_DESC(pci_use_second, "Use the second CAN core on PCIe card. Default: 1 (yes)");
-
 struct ctucan_pci_board_data {
 	void __iomem *bar0_base;
 	void __iomem *cra_base;
@@ -117,13 +109,11 @@ static int ctucan_pci_probe(struct pci_dev *pdev,
 		goto err_disable_device;
 	}
 
-	if (use_msi) {
-		ret = pci_enable_msi(pdev);
-		if (!ret) {
-			dev_info(dev, "MSI enabled\n");
-			pci_set_master(pdev);
-			msi_ok = 1;
-		}
+	ret = pci_enable_msi(pdev);
+	if (!ret) {
+		dev_info(dev, "MSI enabled\n");
+		pci_set_master(pdev);
+		msi_ok = 1;
 	}
 
 	dev_info(dev, "ctucan BAR0 0x%08llx 0x%08llx\n",
@@ -184,7 +174,7 @@ static int ctucan_pci_probe(struct pci_dev *pdev,
 
 	core_i++;
 
-	while (pci_use_second && (core_i < num_cores)) {
+	while (core_i < num_cores) {
 		addr += 0x4000;
 		ret = ctucan_probe_common(dev, addr, irq, ntxbufs, 100000000,
 					  0, ctucan_pci_set_drvdata);
-- 
2.20.1


