Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619AC516B95
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383650AbiEBIDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383646AbiEBIC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:02:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CF12CE00
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 00:59:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlQxo-0002Y5-3i
        for netdev@vger.kernel.org; Mon, 02 May 2022 09:59:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 509C872E53
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 07:59:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EB5F872E26;
        Mon,  2 May 2022 07:59:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id cb2f3fd7;
        Mon, 2 May 2022 07:59:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 9/9] can: ctucanfd: remove PCI module debug parameters
Date:   Mon,  2 May 2022 09:59:14 +0200
Message-Id: <20220502075914.1905039-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502075914.1905039-1-mkl@pengutronix.de>
References: <20220502075914.1905039-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

This patch removes the PCI module debug parameters, which are not
needed anymore, to make both checkpatch.pl and patchwork happy.

Link: https://lore.kernel.org/all/1fd684bcf5ddb0346aad234072f54e976a5210fb.1650816929.git.pisa@cmp.felk.cvut.cz
Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
[mkl: split into separate patches]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ctucanfd/ctucanfd_pci.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

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
2.35.1


