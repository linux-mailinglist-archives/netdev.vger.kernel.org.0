Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E227625D963
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgIDNPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:15:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40260 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730010AbgIDNPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 09:15:25 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 521B7D1ABC89FC3C3E6C;
        Fri,  4 Sep 2020 21:15:22 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 4 Sep 2020
 21:15:19 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <gustavoars@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] can: peak_canfd: Remove unused macros
Date:   Fri, 4 Sep 2020 21:12:47 +0800
Message-ID: <20200904131247.23021-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CANFD_CLK_SEL_DIV_MASK and CANFD_OPTIONS_SET are
never used after they were introduced. Remove them.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/can/peak_canfd/peak_pciefd_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/peak_canfd/peak_pciefd_main.c b/drivers/net/can/peak_canfd/peak_pciefd_main.c
index 9469d4421afe..5f0f39d2fa28 100644
--- a/drivers/net/can/peak_canfd/peak_pciefd_main.c
+++ b/drivers/net/can/peak_canfd/peak_pciefd_main.c
@@ -83,7 +83,6 @@ MODULE_LICENSE("GPL v2");
 #define CANFD_MISC_TS_RST		0x00000001	/* timestamp cnt rst */
 
 /* CAN-FD channel Clock SELector Source & DIVider */
-#define CANFD_CLK_SEL_DIV_MASK		0x00000007
 #define CANFD_CLK_SEL_DIV_60MHZ		0x00000000	/* SRC=240MHz only */
 #define CANFD_CLK_SEL_DIV_40MHZ		0x00000001	/* SRC=240MHz only */
 #define CANFD_CLK_SEL_DIV_30MHZ		0x00000002	/* SRC=240MHz only */
@@ -116,8 +115,6 @@ MODULE_LICENSE("GPL v2");
 #define CANFD_CTL_IRQ_CL_DEF	16	/* Rx msg max nb per IRQ in Rx DMA */
 #define CANFD_CTL_IRQ_TL_DEF	10	/* Time before IRQ if < CL (x100 µs) */
 
-#define CANFD_OPTIONS_SET	(CANFD_OPTION_ERROR | CANFD_OPTION_BUSLOAD)
-
 /* Tx anticipation window (link logical address should be aligned on 2K
  * boundary)
  */
-- 
2.17.1

