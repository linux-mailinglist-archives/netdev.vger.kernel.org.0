Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8A821B1B3
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 10:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgGJIwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 04:52:14 -0400
Received: from mail.loongson.cn ([114.242.206.163]:34540 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbgGJIwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 04:52:13 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9CxGdQpLAhfS0kBAA--.1768S2;
        Fri, 10 Jul 2020 16:51:54 +0800 (CST)
From:   Zhi Li <lizhi01@loongson.cn>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lixuefeng@loongson.cn, chenhc@lemote.com, jiaxun.yang@flygoat.com,
        yangtiezhu@loongson.cn, Hongbin Li <lihongbin@loongson.cn>
Subject: [PATCH] stmmac: pci: Add support for LS7A bridge chip
Date:   Fri, 10 Jul 2020 16:51:50 +0800
Message-Id: <1594371110-7580-1-git-send-email-lizhi01@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9CxGdQpLAhfS0kBAA--.1768S2
X-Coremail-Antispam: 1UD129KBjvJXoW7urWfKw1UCF43tr1fAw4DXFb_yoW8urW5p3
        y3Aas2grs3JF1xAws8Jw4DZFy5Ja9xKrWDG3y7tw1fWFWqk3yaqFySqFW5AFy7JrWkWw13
        Xw4UCr4UuF4DC3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26F4j6r
        4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
        0VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8ZwCF04k20xvY0x0EwI
        xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU18wI3UUUUU==
X-CM-SenderInfo: xol2xxqqr6z05rqj20fqof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add gmac platform data to support LS7A bridge chip.

Co-developed-by: Hongbin Li <lihongbin@loongson.cn>
Signed-off-by: Hongbin Li <lihongbin@loongson.cn>
Signed-off-by: Zhi Li <lizhi01@loongson.cn>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 272cb47..dab2a40 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -138,6 +138,24 @@ static const struct stmmac_pci_info snps_gmac5_pci_info = {
 	.setup = snps_gmac5_default_data,
 };
 
+static int loongson_default_data(struct pci_dev *pdev, struct plat_stmmacenent_data *plat)
+{
+	common_default_data(plat);
+
+	plat->bus_id = pci_dev_id(pdev);
+	plat->phy_addr = 0;
+	plat->interface = PHY_INTERFACE_MODE_GMII;
+
+	plat->dma_cfg->pbl = 32;
+	plat->dma_cfg->pblx8 = true;
+
+	return 0;
+}
+
+static struct stmmac_pci_info loongson_pci_info = {
+	.setup = loongson_default_data;
+};
+
 /**
  * stmmac_pci_probe
  *
@@ -204,6 +222,8 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 	res.addr = pcim_iomap_table(pdev)[i];
 	res.wol_irq = pdev->irq;
 	res.irq = pdev->irq;
+	if (pdev->vendor == PCI_VENDOR_ID_LOONGSON)
+		res.lpi_irq = pdev->irq + 1;
 
 	return stmmac_dvr_probe(&pdev->dev, plat, &res);
 }
@@ -273,11 +293,13 @@ static SIMPLE_DEV_PM_OPS(stmmac_pm_ops, stmmac_pci_suspend, stmmac_pci_resume);
 
 #define PCI_DEVICE_ID_STMMAC_STMMAC		0x1108
 #define PCI_DEVICE_ID_SYNOPSYS_GMAC5_ID		0x7102
+#define PCI_DEVICE_ID_LOONGSON_GMAC		0x7a03
 
 static const struct pci_device_id stmmac_id_table[] = {
 	{ PCI_DEVICE_DATA(STMMAC, STMMAC, &stmmac_pci_info) },
 	{ PCI_DEVICE_DATA(STMICRO, MAC, &stmmac_pci_info) },
 	{ PCI_DEVICE_DATA(SYNOPSYS, GMAC5_ID, &snps_gmac5_pci_info) },
+	{ PCI_DEVICE_DATA(LOONGSON, GMAC, &loongson_pci_info) },
 	{}
 };
 
-- 
2.1.0

