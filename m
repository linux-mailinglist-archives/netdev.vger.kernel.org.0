Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C0E38BB55
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 03:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhEUBMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:12:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3451 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbhEUBMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:12:39 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FmT4q5SPVzBvPh;
        Fri, 21 May 2021 09:08:27 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/6] net: wan: fix the code style issue about trailing statements
Date:   Fri, 21 May 2021 09:08:14 +0800
Message-ID: <1621559297-9651-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
References: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
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
 drivers/net/wan/hd64572.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wan/hd64572.c b/drivers/net/wan/hd64572.c
index e51d94d62e07..aa69bcaba633 100644
--- a/drivers/net/wan/hd64572.c
+++ b/drivers/net/wan/hd64572.c
@@ -426,22 +426,40 @@ static void sca_open(struct net_device *dev)
 	u8 md0, md2;
 
 	switch (port->encoding) {
-	case ENCODING_NRZ:	md2 = MD2_NRZ;		break;
-	case ENCODING_NRZI:	md2 = MD2_NRZI;		break;
-	case ENCODING_FM_MARK:	md2 = MD2_FM_MARK;	break;
-	case ENCODING_FM_SPACE:	md2 = MD2_FM_SPACE;	break;
-	default:		md2 = MD2_MANCHESTER;
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
 
 	switch (port->parity) {
-	case PARITY_CRC16_PR0:	     md0 = MD0_HDLC | MD0_CRC_16_0;  break;
-	case PARITY_CRC16_PR1:	     md0 = MD0_HDLC | MD0_CRC_16;    break;
-	case PARITY_CRC32_PR1_CCITT: md0 = MD0_HDLC | MD0_CRC_ITU32; break;
-	case PARITY_CRC16_PR1_CCITT: md0 = MD0_HDLC | MD0_CRC_ITU;   break;
-	default:		     md0 = MD0_HDLC | MD0_CRC_NONE;
+	case PARITY_CRC16_PR0:
+		md0 = MD0_HDLC | MD0_CRC_16_0;
+		break;
+	case PARITY_CRC16_PR1:
+		md0 = MD0_HDLC | MD0_CRC_16;
+		break;
+	case PARITY_CRC32_PR1_CCITT:
+		md0 = MD0_HDLC | MD0_CRC_ITU32;
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

