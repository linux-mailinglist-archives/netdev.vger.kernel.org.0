Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47622D4371
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbgLINjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:39:23 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8738 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732537AbgLINjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:39:21 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CrdQl1hmRzklNb;
        Wed,  9 Dec 2020 21:37:51 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 21:38:24 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michael.jamet@intel.com>,
        <mika.westerberg@linux.intel.com>, <YehezkelShB@gmail.com>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: thunderbolt: convert comma to semicolon
Date:   Wed, 9 Dec 2020 21:38:52 +0800
Message-ID: <20201209133852.1475-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/thunderbolt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 3160443ef3b9..ae83d66195a5 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1241,7 +1241,7 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 	dev->max_mtu = TBNET_MAX_MTU - ETH_HLEN;
 
 	net->handler.uuid = &tbnet_svc_uuid;
-	net->handler.callback = tbnet_handle_packet,
+	net->handler.callback = tbnet_handle_packet;
 	net->handler.data = net;
 	tb_register_protocol_handler(&net->handler);
 
-- 
2.22.0

