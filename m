Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D6D3A8185
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFON7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:59:43 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4919 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhFON7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:59:41 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G48v64CNyz704R;
        Tue, 15 Jun 2021 21:54:26 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 21:57:35 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/6] net: pci200syn: add blank line after declarations
Date:   Tue, 15 Jun 2021 21:54:19 +0800
Message-ID: <1623765263-36775-3-git-send-email-lipeng321@huawei.com>
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

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/pci200syn.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index 1667dfd..a7eac90 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -92,6 +92,7 @@ typedef struct card_s {
 static inline void new_memcpy_toio(char __iomem *dest, char *src, int length)
 {
 	int len;
+
 	do {
 		len = length > 256 ? 256 : length;
 		memcpy_toio(dest, src, len);
@@ -148,8 +149,8 @@ static void pci200_set_iface(port_t *port)
 static int pci200_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
-
 	int result = hdlc_open(dev);
+
 	if (result)
 		return result;
 
@@ -366,6 +367,7 @@ static int pci200_pci_init_one(struct pci_dev *pdev,
 		port_t *port = &card->ports[i];
 		struct net_device *dev = port->netdev;
 		hdlc_device *hdlc = dev_to_hdlc(dev);
+
 		port->chan = i;
 
 		spin_lock_init(&port->lock);
-- 
2.8.1

