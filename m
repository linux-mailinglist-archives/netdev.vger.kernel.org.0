Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD21E2A131C
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 03:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgJaCsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 22:48:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:6998 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgJaCsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 22:48:21 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CNNsF1VpBzhdWp;
        Sat, 31 Oct 2020 10:48:17 +0800 (CST)
Received: from localhost (10.174.176.180) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Sat, 31 Oct 2020
 10:48:07 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <dchickles@marvell.com>, <sburla@marvell.com>,
        <fmanlunas@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] liquidio: cn68xx: Remove duplicated include
Date:   Sat, 31 Oct 2020 10:47:44 +0800
Message-ID: <20201031024744.39020-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.176.180]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/cavium/liquidio/cn68xx_device.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c b/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
index 2a6d1cadac9e..30254e4cf70f 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn68xx_device.c
@@ -27,7 +27,6 @@
 #include "cn66xx_device.h"
 #include "cn68xx_device.h"
 #include "cn68xx_regs.h"
-#include "cn68xx_device.h"
 
 static void lio_cn68xx_set_dpi_regs(struct octeon_device *oct)
 {
-- 
2.17.1

