Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F2E394C0D
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 13:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhE2Lqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 07:46:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2469 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhE2Lq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 07:46:29 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fsfm43Bv4z681J;
        Sat, 29 May 2021 19:41:56 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 19:44:51 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 29
 May 2021 19:44:50 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: hso: Use BIT(x) macro
Date:   Sat, 29 May 2021 19:44:21 +0800
Message-ID: <20210529114421.25480-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BIT(x) improves readability and safety with respect to shifts.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/usb/hso.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 63006838bdcc..2587f8f52226 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -163,13 +163,13 @@ enum rx_ctrl_state{
 #define W_VALUE         (0x0)
 #define W_LENGTH        (0x2)
 
-#define B_OVERRUN       (0x1<<6)
-#define B_PARITY        (0x1<<5)
-#define B_FRAMING       (0x1<<4)
-#define B_RING_SIGNAL   (0x1<<3)
-#define B_BREAK         (0x1<<2)
-#define B_TX_CARRIER    (0x1<<1)
-#define B_RX_CARRIER    (0x1<<0)
+#define B_OVERRUN       BIT(6)
+#define B_PARITY        BIT(5)
+#define B_FRAMING       BIT(4)
+#define B_RING_SIGNAL   BIT(3)
+#define B_BREAK         BIT(2)
+#define B_TX_CARRIER    BIT(1)
+#define B_RX_CARRIER    BIT(0)
 
 struct hso_serial_state_notification {
 	u8 bmRequestType;
-- 
2.17.1

