Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F4E396B8A
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 04:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhFACrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 22:47:03 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:56929 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232356AbhFACrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 22:47:02 -0400
X-UUID: acfef08328d84f4080da7dbf870a062f-20210601
X-UUID: acfef08328d84f4080da7dbf870a062f-20210601
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1677590970; Tue, 01 Jun 2021 10:45:17 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 1 Jun 2021 10:45:16 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Jun 2021 10:45:09 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <frank-w@public-files.de>,
        <steven.liu@mediatek.com>, Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net, v2] net: Update MAINTAINERS for MediaTek switch driver
Date:   Tue, 1 Jun 2021 10:45:08 +0800
Message-ID: <49e67daeadace13a9fa3f4553f1ec14c6a93bdc8.1622445132.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update maintainers for MediaTek switch driver with Deng Qingfang who
contributes many useful patches (interrupt, VLAN, GPIO, and etc.) to
enhance MediaTek switch driver and will help maintenance.

Signed-off-by: Landen Chao <landen.chao@mediatek.com>
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v1 -> v2: Remove Change-Id.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bd7aff0c120f..3315627ebb6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11588,6 +11588,7 @@ F:	drivers/char/hw_random/mtk-rng.c
 MEDIATEK SWITCH DRIVER
 M:	Sean Wang <sean.wang@mediatek.com>
 M:	Landen Chao <landen.chao@mediatek.com>
+M:	DENG Qingfang <dqfext@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/dsa/mt7530.*
-- 
2.29.2

