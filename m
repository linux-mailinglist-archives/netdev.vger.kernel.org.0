Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC70263477
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbgIIRUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:20:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50388 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730412AbgIIRUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 13:20:44 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DA026C71AC4136B1ABFA;
        Wed,  9 Sep 2020 21:23:51 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:23:49 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <bprakash@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: cavium: Fix a bunch of kerneldoc parameter issues
Date:   Wed, 9 Sep 2020 21:21:09 +0800
Message-ID: <20200909132109.71466-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename ptp to ptp_info.

Fix W=1 compile warnings (invalid kerneldoc):

drivers/net/ethernet/cavium/common/cavium_ptp.c:94: warning: Excess function parameter 'ptp' description in 'cavium_ptp_adjfine'
drivers/net/ethernet/cavium/common/cavium_ptp.c:141: warning: Excess function parameter 'ptp' description in 'cavium_ptp_adjtime'
drivers/net/ethernet/cavium/common/cavium_ptp.c:163: warning: Excess function parameter 'ptp' description in 'cavium_ptp_gettime'
drivers/net/ethernet/cavium/common/cavium_ptp.c:185: warning: Excess function parameter 'ptp' description in 'cavium_ptp_settime'
drivers/net/ethernet/cavium/common/cavium_ptp.c:208: warning: Excess function parameter 'ptp' description in 'cavium_ptp_enable'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/cavium/common/cavium_ptp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cavium/common/cavium_ptp.c b/drivers/net/ethernet/cavium/common/cavium_ptp.c
index 81ff9ac73f9a..9fd717b9cf69 100644
--- a/drivers/net/ethernet/cavium/common/cavium_ptp.c
+++ b/drivers/net/ethernet/cavium/common/cavium_ptp.c
@@ -86,7 +86,7 @@ EXPORT_SYMBOL(cavium_ptp_put);
 
 /**
  * cavium_ptp_adjfine() - Adjust ptp frequency
- * @ptp: PTP clock info
+ * @ptp_info: PTP clock info
  * @scaled_ppm: how much to adjust by, in parts per million, but with a
  *              16 bit binary fractional field
  */
@@ -134,7 +134,7 @@ static int cavium_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 
 /**
  * cavium_ptp_adjtime() - Adjust ptp time
- * @ptp:   PTP clock info
+ * @ptp_info:   PTP clock info
  * @delta: how much to adjust by, in nanosecs
  */
 static int cavium_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
@@ -155,7 +155,7 @@ static int cavium_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
 
 /**
  * cavium_ptp_gettime() - Get hardware clock time with adjustment
- * @ptp: PTP clock info
+ * @ptp_info: PTP clock info
  * @ts:  timespec
  */
 static int cavium_ptp_gettime(struct ptp_clock_info *ptp_info,
@@ -177,7 +177,7 @@ static int cavium_ptp_gettime(struct ptp_clock_info *ptp_info,
 
 /**
  * cavium_ptp_settime() - Set hardware clock time. Reset adjustment
- * @ptp: PTP clock info
+ * @ptp_info: PTP clock info
  * @ts:  timespec
  */
 static int cavium_ptp_settime(struct ptp_clock_info *ptp_info,
@@ -199,7 +199,7 @@ static int cavium_ptp_settime(struct ptp_clock_info *ptp_info,
 
 /**
  * cavium_ptp_enable() - Request to enable or disable an ancillary feature.
- * @ptp: PTP clock info
+ * @ptp_info: PTP clock info
  * @rq:  request
  * @on:  is it on
  */
-- 
2.17.1

