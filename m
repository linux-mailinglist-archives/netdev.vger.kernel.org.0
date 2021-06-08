Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647B639F090
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhFHIR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:17:58 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3789 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhFHIRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:45 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fzjc50Y5FzWrHP;
        Tue,  8 Jun 2021 16:11:01 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 07/16] net: farsync: remove trailing whitespaces
Date:   Tue, 8 Jun 2021 16:12:33 +0800
Message-ID: <1623139962-34847-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
References: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes trailing whitespaces.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index f8c7558..7653ff0 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -524,25 +524,25 @@ do {								\
 /*      PCI ID lookup table
  */
 static const struct pci_device_id fst_pci_dev_id[] = {
-	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T2P, PCI_ANY_ID, 
+	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T2P, PCI_ANY_ID,
 	 PCI_ANY_ID, 0, 0, FST_TYPE_T2P},
 
-	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T4P, PCI_ANY_ID, 
+	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T4P, PCI_ANY_ID,
 	 PCI_ANY_ID, 0, 0, FST_TYPE_T4P},
 
-	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T1U, PCI_ANY_ID, 
+	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T1U, PCI_ANY_ID,
 	 PCI_ANY_ID, 0, 0, FST_TYPE_T1U},
 
-	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T2U, PCI_ANY_ID, 
+	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T2U, PCI_ANY_ID,
 	 PCI_ANY_ID, 0, 0, FST_TYPE_T2U},
 
-	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T4U, PCI_ANY_ID, 
+	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T4U, PCI_ANY_ID,
 	 PCI_ANY_ID, 0, 0, FST_TYPE_T4U},
 
-	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_TE1, PCI_ANY_ID, 
+	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_TE1, PCI_ANY_ID,
 	 PCI_ANY_ID, 0, 0, FST_TYPE_TE1},
 
-	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_TE1C, PCI_ANY_ID, 
+	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_TE1C, PCI_ANY_ID,
 	 PCI_ANY_ID, 0, 0, FST_TYPE_TE1},
 	{0,}			/* End */
 };
@@ -551,11 +551,11 @@ MODULE_DEVICE_TABLE(pci, fst_pci_dev_id);
 
 /*      Device Driver Work Queues
  *
- *      So that we don't spend too much time processing events in the 
- *      Interrupt Service routine, we will declare a work queue per Card 
+ *      So that we don't spend too much time processing events in the
+ *      Interrupt Service routine, we will declare a work queue per Card
  *      and make the ISR schedule a task in the queue for later execution.
  *      In the 2.4 Kernel we used to use the immediate queue for BH's
- *      Now that they are gone, tasklets seem to be much better than work 
+ *      Now that they are gone, tasklets seem to be much better than work
  *      queues.
  */
 
@@ -1139,7 +1139,7 @@ fst_recover_rx_error(struct fst_card_info *card, struct fst_port_info *port,
 	pi = port->index;
 	/* Discard buffer descriptors until we see the start of the
 	 * next frame.  Note that for long frames this could be in
-	 * a subsequent interrupt. 
+	 * a subsequent interrupt.
 	 */
 	i = 0;
 	while ((dmabits & (DMA_OWN | RX_STP)) == 0) {
@@ -1436,7 +1436,7 @@ fst_intr(int dummy, void *dev_id)
 
 		/* It is possible to really be running, i.e. we have re-loaded
 		 * a running card
-		 * Clear and reprime the interrupt source 
+		 * Clear and reprime the interrupt source
 		 */
 		fst_clear_intr(card);
 		return IRQ_HANDLED;
@@ -1616,8 +1616,8 @@ set_conf_from_info(struct fst_card_info *card, struct fst_port_info *port,
 	int err;
 	unsigned char my_framing;
 
-	/* Set things according to the user set valid flags 
-	 * Several of the old options have been invalidated/replaced by the 
+	/* Set things according to the user set valid flags
+	 * Several of the old options have been invalidated/replaced by the
 	 * generic hdlc package.
 	 */
 	err = 0;
@@ -1739,7 +1739,7 @@ gather_conf_info(struct fst_card_info *card, struct fst_port_info *port,
 	info->smcFirmwareVersion = FST_RDL(card, smcFirmwareVersion);
 
 	/* The T2U can report cable presence for both A or B
-	 * in bits 0 and 1 of cableStatus.  See which port we are and 
+	 * in bits 0 and 1 of cableStatus.  See which port we are and
 	 * do the mapping.
 	 */
 	if (card->family == FST_FAMILY_TXU) {
-- 
2.8.1

