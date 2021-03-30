Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0861A34E1B4
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhC3HEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:04:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15040 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhC3HDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:03:54 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F8gMv6W42zPmlg;
        Tue, 30 Mar 2021 15:01:15 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 15:03:42 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/4] net: ipa: remove repeated words
Date:   Tue, 30 Mar 2021 15:04:06 +0800
Message-ID: <1617087846-14270-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617087846-14270-1-git-send-email-tanhuazhong@huawei.com>
References: <1617087846-14270-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Remove repeated words "that" and "the".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ipa/ipa_endpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 38e83cd..dd24179 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -809,7 +809,7 @@ static u32 hol_block_timer_val(struct ipa *ipa, u32 microseconds)
 	 * The best precision is achieved when the base value is as
 	 * large as possible.  Find the highest set bit in the tick
 	 * count, and extract the number of bits in the base field
-	 * such that that high bit is included.
+	 * such that high bit is included.
 	 */
 	high = fls(ticks);		/* 1..32 */
 	width = HWEIGHT32(BASE_VALUE_FMASK);
@@ -1448,7 +1448,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 	if (ret)
 		goto out_suspend_again;
 
-	/* Finally, reset and reconfigure the channel again (re-enabling the
+	/* Finally, reset and reconfigure the channel again (re-enabling
 	 * the doorbell engine if appropriate).  Sleep for 1 millisecond to
 	 * complete the channel reset sequence.  Finish by suspending the
 	 * channel again (if necessary).
-- 
2.7.4

