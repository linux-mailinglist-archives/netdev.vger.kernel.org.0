Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F573264079
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgIJIsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:48:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57716 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726847AbgIJIsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 04:48:13 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3ED772AD370DCE52AB3D;
        Thu, 10 Sep 2020 16:48:06 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 16:47:56 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <steffen.klassert@secunet.com>,
        <willemb@google.com>, <mstarovoitov@marvell.com>,
        <kuba@kernel.org>, <mchehab+huawei@kernel.org>,
        <antoine.tenart@bootlin.com>, <edumazet@google.com>,
        <Jason@zx2c4.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Fix broken NETIF_F_CSUM_MASK spell in netdev_features.h
Date:   Thu, 10 Sep 2020 04:46:40 -0400
Message-ID: <20200910084640.55688-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the weird space inside the NETIF_F_CSUM_MASK.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/linux/netdev_features.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2cc3cf80b49a..0b17c4322b09 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -193,7 +193,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 #define NETIF_F_GSO_MASK	(__NETIF_F_BIT(NETIF_F_GSO_LAST + 1) - \
 		__NETIF_F_BIT(NETIF_F_GSO_SHIFT))
 
-/* List of IP checksum features. Note that NETIF_F_ HW_CSUM should not be
+/* List of IP checksum features. Note that NETIF_F_HW_CSUM should not be
  * set in features when NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM are set--
  * this would be contradictory
  */
-- 
2.19.1

