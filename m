Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E12B3A818F
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhFON7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:59:54 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7277 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhFON7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:59:42 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G48rz6rklz1BMcb;
        Tue, 15 Jun 2021 21:52:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 21:57:35 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/6] net: pci200syn: add some required spaces
Date:   Tue, 15 Jun 2021 21:54:21 +0800
Message-ID: <1623765263-36775-5-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
References: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add spaces required after that close brace '}'.
Add spaces required before the open parenthesis '('.
Add spaces required after that ','.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/pci200syn.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index cee3d65..ac4a599 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -56,7 +56,7 @@ typedef struct {
 	u32 cs_base[4];		/* 3C-48h : Chip Select Base Addrs */
 	u32 intr_ctrl_stat;	/* 4Ch : Interrupt Control/Status */
 	u32 init_ctrl;		/* 50h : EEPROM ctrl, Init Ctrl, etc */
-}plx9052;
+} plx9052;
 
 typedef struct port_s {
 	struct napi_struct napi;
@@ -72,7 +72,7 @@ typedef struct port_s {
 	u16 txlast;
 	u8 rxs, txs, tmc;	/* SCA registers */
 	u8 chan;		/* physical port # - 0 or 1 */
-}port_t;
+} port_t;
 
 typedef struct card_s {
 	u8 __iomem *rambase;	/* buffer memory base (virtual) */
@@ -84,7 +84,7 @@ typedef struct card_s {
 	u8 irq;			/* interrupt request level */
 
 	port_t ports[2];
-}card_t;
+} card_t;
 
 #define get_port(card, port)	     (&card->ports[port])
 #define sca_flush(card)		     (sca_in(IER0, card))
@@ -117,7 +117,7 @@ static void pci200_set_iface(port_t *port)
 
 	sca_out(EXS_TES1, (port->chan ? MSCI1_OFFSET : MSCI0_OFFSET) + EXS,
 		port->card);
-	switch(port->settings.clock_type) {
+	switch (port->settings.clock_type) {
 	case CLOCK_INT:
 		rxs |= CLK_BRG; /* BRG output */
 		txs |= CLK_PIN_OUT | CLK_TX_RXCLK; /* RX clock */
@@ -184,7 +184,7 @@ static int pci200_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
-	switch(ifr->ifr_settings.type) {
+	switch (ifr->ifr_settings.type) {
 	case IF_GET_IFACE:
 		ifr->ifr_settings.type = IF_IFACE_V35;
 		if (ifr->ifr_settings.size < size) {
@@ -301,13 +301,13 @@ static int pci200_pci_init_one(struct pci_dev *pdev,
 		return -EFAULT;
 	}
 
-	plxphys = pci_resource_start(pdev,0) & PCI_BASE_ADDRESS_MEM_MASK;
+	plxphys = pci_resource_start(pdev, 0) & PCI_BASE_ADDRESS_MEM_MASK;
 	card->plxbase = ioremap(plxphys, PCI200SYN_PLX_SIZE);
 
-	scaphys = pci_resource_start(pdev,2) & PCI_BASE_ADDRESS_MEM_MASK;
+	scaphys = pci_resource_start(pdev, 2) & PCI_BASE_ADDRESS_MEM_MASK;
 	card->scabase = ioremap(scaphys, PCI200SYN_SCA_SIZE);
 
-	ramphys = pci_resource_start(pdev,3) & PCI_BASE_ADDRESS_MEM_MASK;
+	ramphys = pci_resource_start(pdev, 3) & PCI_BASE_ADDRESS_MEM_MASK;
 	card->rambase = pci_ioremap_bar(pdev, 3);
 
 	if (!card->plxbase || !card->scabase || !card->rambase) {
-- 
2.8.1

