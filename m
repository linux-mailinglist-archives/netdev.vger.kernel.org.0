Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB7C34E230
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhC3H2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:28:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14194 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhC3H1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:27:49 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F8gvW1p6nzmcBv;
        Tue, 30 Mar 2021 15:25:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 15:27:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <jesse.brandeburg@intel.com>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andrew@lunn.ch>, <elder@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RESEND net-next 4/4] net: ipa: remove repeated words
Date:   Tue, 30 Mar 2021 15:27:56 +0800
Message-ID: <1617089276-30268-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
References: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
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

