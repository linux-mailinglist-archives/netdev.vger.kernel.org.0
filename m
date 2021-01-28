Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B91306D73
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhA1GKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:10:05 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:40644 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229847AbhA1GKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:10:02 -0500
X-UUID: 542e0c67a5044297abde6c604f87533e-20210128
X-UUID: 542e0c67a5044297abde6c604f87533e-20210128
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2071832710; Thu, 28 Jan 2021 14:09:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 28 Jan 2021 14:09:19 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 28 Jan 2021 14:09:19 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH net-next 1/2] net: if_arp: add ARPHRD_PUREIP type
Date:   Thu, 28 Jan 2021 13:56:45 +0800
Message-ID: <20210128055645.14810-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add the definition of ARPHRD_PUREIP which can for
example be used by mobile ccmni device as device type.
ARPHRD_PUREIP means that this device doesn't need kernel to
generate the link-local address in any addr_gen_mode.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 include/uapi/linux/if_arp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_arp.h b/include/uapi/linux/if_arp.h
index c3cc5a9e5eaf..3602fc3d9488 100644
--- a/include/uapi/linux/if_arp.h
+++ b/include/uapi/linux/if_arp.h
@@ -61,6 +61,7 @@
 #define ARPHRD_DDCMP    517		/* Digital's DDCMP protocol     */
 #define ARPHRD_RAWHDLC	518		/* Raw HDLC			*/
 #define ARPHRD_RAWIP    519		/* Raw IP                       */
+#define ARPHRD_PUREIP	520		/* PURE IP			*/
 
 #define ARPHRD_TUNNEL	768		/* IPIP tunnel			*/
 #define ARPHRD_TUNNEL6	769		/* IP6IP6 tunnel       		*/
-- 
2.18.0

