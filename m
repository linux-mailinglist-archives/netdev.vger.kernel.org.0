Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF45F39C678
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFEHF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:05:27 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4314 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFEHFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 03:05:25 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fxr886q40z1BGSn;
        Sat,  5 Jun 2021 14:58:48 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/8] net: hd64570: fix the code style issue about trailing statements
Date:   Sat, 5 Jun 2021 15:00:25 +0800
Message-ID: <1622876429-47278-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
References: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Trailing statements should be on next line.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64570.c | 60 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index 6237da6..f02cce0 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -58,12 +58,18 @@ static inline int sca_intr_status(card_t *card)
 	u8 isr0 = sca_in(ISR0, card);
 	u8 isr1 = sca_in(ISR1, card);
 
-	if (isr1 & 0x03) result |= SCA_INTR_DMAC_RX(0);
-	if (isr1 & 0x0C) result |= SCA_INTR_DMAC_TX(0);
-	if (isr1 & 0x30) result |= SCA_INTR_DMAC_RX(1);
-	if (isr1 & 0xC0) result |= SCA_INTR_DMAC_TX(1);
-	if (isr0 & 0x0F) result |= SCA_INTR_MSCI(0);
-	if (isr0 & 0xF0) result |= SCA_INTR_MSCI(1);
+	if (isr1 & 0x03)
+		result |= SCA_INTR_DMAC_RX(0);
+	if (isr1 & 0x0C)
+		result |= SCA_INTR_DMAC_TX(0);
+	if (isr1 & 0x30)
+		result |= SCA_INTR_DMAC_RX(1);
+	if (isr1 & 0xC0)
+		result |= SCA_INTR_DMAC_TX(1);
+	if (isr0 & 0x0F)
+		result |= SCA_INTR_MSCI(0);
+	if (isr0 & 0xF0)
+		result |= SCA_INTR_MSCI(1);
 
 	if (!(result & SCA_INTR_DMAC_TX(0)))
 		if (sca_in(DSR_TX(0), card) & DSR_EOM)
@@ -447,23 +453,41 @@ static void sca_open(struct net_device *dev)
 	u16 msci = get_msci(port);
 	u8 md0, md2;
 
-	switch(port->encoding) {
-	case ENCODING_NRZ:	md2 = MD2_NRZ;		break;
-	case ENCODING_NRZI:	md2 = MD2_NRZI;		break;
-	case ENCODING_FM_MARK:	md2 = MD2_FM_MARK;	break;
-	case ENCODING_FM_SPACE:	md2 = MD2_FM_SPACE;	break;
-	default:		md2 = MD2_MANCHESTER;
+	switch (port->encoding) {
+	case ENCODING_NRZ:
+		md2 = MD2_NRZ;
+		break;
+	case ENCODING_NRZI:
+		md2 = MD2_NRZI;
+		break;
+	case ENCODING_FM_MARK:
+		md2 = MD2_FM_MARK;
+		break;
+	case ENCODING_FM_SPACE:
+		md2 = MD2_FM_SPACE;
+		break;
+	default:
+		md2 = MD2_MANCHESTER;
 	}
 
 	if (port->settings.loopback)
 		md2 |= MD2_LOOPBACK;
 
-	switch(port->parity) {
-	case PARITY_CRC16_PR0:	     md0 = MD0_HDLC | MD0_CRC_16_0;  break;
-	case PARITY_CRC16_PR1:	     md0 = MD0_HDLC | MD0_CRC_16;    break;
-	case PARITY_CRC16_PR0_CCITT: md0 = MD0_HDLC | MD0_CRC_ITU_0; break;
-	case PARITY_CRC16_PR1_CCITT: md0 = MD0_HDLC | MD0_CRC_ITU;   break;
-	default:		     md0 = MD0_HDLC | MD0_CRC_NONE;
+	switch (port->parity) {
+	case PARITY_CRC16_PR0:
+		md0 = MD0_HDLC | MD0_CRC_16_0;
+		break;
+	case PARITY_CRC16_PR1:
+		md0 = MD0_HDLC | MD0_CRC_16;
+		break;
+	case PARITY_CRC16_PR0_CCITT:
+		md0 = MD0_HDLC | MD0_CRC_ITU_0;
+		break;
+	case PARITY_CRC16_PR1_CCITT:
+		md0 = MD0_HDLC | MD0_CRC_ITU;
+		break;
+	default:
+		md0 = MD0_HDLC | MD0_CRC_NONE;
 	}
 
 	sca_out(CMD_RESET, msci + CMD, card);
-- 
2.8.1

