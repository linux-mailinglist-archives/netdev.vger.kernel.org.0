Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87022347182
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 07:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhCXGRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 02:17:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14456 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbhCXGQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 02:16:40 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F4ycv4sDjzjMRS;
        Wed, 24 Mar 2021 14:14:39 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Wed, 24 Mar 2021
 14:16:36 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <willemb@google.com>,
        <xie.he.0141@gmail.com>, <john.ogness@linutronix.de>,
        <yonatanlinik@gmail.com>, <gustavoars@kernel.org>,
        <tannerlove@google.com>, <eyal.birger@gmail.com>,
        <orcohen@paloaltonetworks.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net/packet: Fix a typo in af_packet.c
Date:   Wed, 24 Mar 2021 14:19:31 +0800
Message-ID: <20210324061931.11012-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/sequencially/sequentially/

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 6bbc7a448593..fe29fc1b8b9d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2057,7 +2057,7 @@ static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
  * and skb->cb are mangled. It works because (and until) packets
  * falling here are owned by current CPU. Output packets are cloned
  * by dev_queue_xmit_nit(), input packets are processed by net_bh
- * sequencially, so that if we return skb to original state on exit,
+ * sequentially, so that if we return skb to original state on exit,
  * we will not harm anyone.
  */
 
-- 
2.17.1

