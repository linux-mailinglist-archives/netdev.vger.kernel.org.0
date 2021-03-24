Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD1434718A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 07:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhCXGTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 02:19:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14572 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbhCXGTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 02:19:35 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F4yhC5LVdz19GC3;
        Wed, 24 Mar 2021 14:17:31 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Wed, 24 Mar 2021
 14:19:29 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <alex.aring@gmail.com>, <jukka.rissanen@linux.intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-bluetooth@vger.kernel.org>, <linux-wpan@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] 6lowpan: Fix some typos in nhc_udp.c
Date:   Wed, 24 Mar 2021 14:22:24 +0800
Message-ID: <20210324062224.13032-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/Orignal/Original/
s/infered/inferred/

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/6lowpan/nhc_udp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/6lowpan/nhc_udp.c b/net/6lowpan/nhc_udp.c
index 8a3507524f7b..33f17bd8cda7 100644
--- a/net/6lowpan/nhc_udp.c
+++ b/net/6lowpan/nhc_udp.c
@@ -5,7 +5,7 @@
  *	Authors:
  *	Alexander Aring	<aar@pengutronix.de>
  *
- *	Orignal written by:
+ *	Original written by:
  *	Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
  *	Jon Smirl <jonsmirl@gmail.com>
  */
@@ -82,7 +82,7 @@ static int udp_uncompress(struct sk_buff *skb, size_t needed)
 	if (fail)
 		return -EINVAL;
 
-	/* UDP length needs to be infered from the lower layers
+	/* UDP length needs to be inferred from the lower layers
 	 * here, we obtain the hint from the remaining size of the
 	 * frame
 	 */
-- 
2.17.1

