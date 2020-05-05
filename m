Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9111C50B7
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgEEIpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:45:02 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3793 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgEEIpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 04:45:02 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D4F092EA6AF3E865E9F2;
        Tue,  5 May 2020 16:44:56 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 16:44:49 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <tglx@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: microchip: Remove unused inline function is_bits_set
Date:   Tue, 5 May 2020 16:44:21 +0800
Message-ID: <20200505084421.40052-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no callers in-tree.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 1f496fac7033..5bd7fb917b7a 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -17,11 +17,6 @@
 
 #include "encx24j600_hw.h"
 
-static inline bool is_bits_set(int value, int mask)
-{
-	return (value & mask) == mask;
-}
-
 static int encx24j600_switch_bank(struct encx24j600_context *ctx,
 				  int bank)
 {
-- 
2.17.1


