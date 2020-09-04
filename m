Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8758C25D957
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgIDNNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:13:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10816 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728588AbgIDNNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 09:13:15 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B0FFDF05AD95A8EF610F;
        Fri,  4 Sep 2020 21:13:03 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 4 Sep 2020
 21:12:58 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] can: kvaser_pciefd: Remove unused macro KVASER_PCIEFD_KCAN_CTRL_EFRAME
Date:   Fri, 4 Sep 2020 21:10:26 +0800
Message-ID: <20200904131026.21817-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KVASER_PCIEFD_KCAN_CTRL_EFRAME is never used after it was introduced.
So better to remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/can/kvaser_pciefd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 6f766918211a..c0b18ff107c7 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -131,7 +131,6 @@ MODULE_DESCRIPTION("CAN driver for Kvaser CAN/PCIe devices");
 
 /* Kvaser KCAN definitions */
 #define KVASER_PCIEFD_KCAN_CTRL_EFLUSH (4 << 29)
-#define KVASER_PCIEFD_KCAN_CTRL_EFRAME (5 << 29)
 
 #define KVASER_PCIEFD_KCAN_CMD_SEQ_SHIFT 16
 /* Request status packet */
-- 
2.17.1

