Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE90464531
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346327AbhLADAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 22:00:42 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:35110 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1346324AbhLADAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 22:00:42 -0500
X-UUID: 20eedf528da8464482d2d31b868615a4-20211201
X-UUID: 20eedf528da8464482d2d31b868615a4-20211201
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <xiayu.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 435790683; Wed, 01 Dec 2021 10:57:19 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 1 Dec 2021 10:57:17 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkcas11.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 1 Dec 2021 10:57:16 +0800
From:   <xiayu.zhang@mediatek.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <haijun.liu@mediatek.com>, <zhaoping.shu@mediatek.com>,
        <hw.he@mediatek.com>, <srv_heupstream@mediatek.com>,
        Xiayu Zhang <Xiayu.Zhang@mediatek.com>
Subject: [PATCH] Fix Comment of ETH_P_802_3_MIN
Date:   Wed, 1 Dec 2021 10:57:13 +0800
Message-ID: <20211201025713.185516-1-xiayu.zhang@mediatek.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiayu Zhang <Xiayu.Zhang@mediatek.com>

The description of ETH_P_802_3_MIN is misleading.
The value of EthernetType in Ethernet II frame is more than 0x0600,
the value of Length in 802.3 frame is less than 0x0600.

Signed-off-by: Xiayu Zhang <Xiayu.Zhang@mediatek.com>
---
 include/uapi/linux/if_ether.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 5da4ee234e0b..c0c2f3ed5729 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -117,7 +117,7 @@
 #define ETH_P_IFE	0xED3E		/* ForCES inter-FE LFB type */
 #define ETH_P_AF_IUCV   0xFBFB		/* IBM af_iucv [ NOT AN OFFICIALLY REGISTERED ID ] */
 
-#define ETH_P_802_3_MIN	0x0600		/* If the value in the ethernet type is less than this value
+#define ETH_P_802_3_MIN	0x0600		/* If the value in the ethernet type is more than this value
 					 * then the frame is Ethernet II. Else it is 802.3 */
 
 /*
-- 
2.17.0

