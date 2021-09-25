Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206ED418219
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 14:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245514AbhIYMyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 08:54:09 -0400
Received: from mx24.baidu.com ([111.206.215.185]:44592 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245182AbhIYMyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 08:54:04 -0400
Received: from BC-Mail-Ex32.internal.baidu.com (unknown [172.31.51.26])
        by Forcepoint Email with ESMTPS id 04ECC304F7E3A1E9FE96;
        Sat, 25 Sep 2021 20:52:28 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex32.internal.baidu.com (172.31.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 25 Sep 2021 20:52:27 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 20:52:27 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] net: fddi: skfp: Fix a function name in comments
Date:   Sat, 25 Sep 2021 20:52:08 +0800
Message-ID: <20210925125209.1700-2-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210925125209.1700-1-caihuoqing@baidu.com>
References: <20210925125209.1700-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex01.internal.baidu.com (10.127.64.11) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_map_single() instead of pci_map_single(),
because only dma_map_single() is called here.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/fddi/skfp/skfddi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
index c5cb421f9890..cc5126ea7ef5 100644
--- a/drivers/net/fddi/skfp/skfddi.c
+++ b/drivers/net/fddi/skfp/skfddi.c
@@ -1012,7 +1012,7 @@ static int skfp_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __
  *   is contained in a single physically contiguous buffer
  *   in which the virtual address of the start of packet
  *   (skb->data) can be converted to a physical address
- *   by using pci_map_single().
+ *   by using dma_map_single().
  *
  *   We have an internal queue for packets we can not send 
  *   immediately. Packets in this queue can be given to the 
-- 
2.25.1

