Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAFD3B1943
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhFWLwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:52:06 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:55181 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230019AbhFWLwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:52:05 -0400
X-UUID: ae228bc0d58a4ed3beff7636e4ac8608-20210623
X-UUID: ae228bc0d58a4ed3beff7636e4ac8608-20210623
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1720885147; Wed, 23 Jun 2021 19:49:44 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Jun 2021 19:49:43 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Jun 2021 19:49:41 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
CC:     <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <chao.song@mediatek.com>,
        <zhuoliang.zhang@mediatek.com>, <kuohong.wang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
Date:   Wed, 23 Jun 2021 19:34:49 +0800
Message-ID: <20210623113452.5671-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add the definition of ARPHRD_PUREIP which can for
example be used by mobile ccmni device as device type.
ARPHRD_PUREIP means that this device doesn't need kernel to
generate ipv6 link-local address in any addr_gen_mode.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 include/uapi/linux/if_arp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_arp.h b/include/uapi/linux/if_arp.h
index c3cc5a9e5eaf..4463c9e9e8b4 100644
--- a/include/uapi/linux/if_arp.h
+++ b/include/uapi/linux/if_arp.h
@@ -61,6 +61,7 @@
 #define ARPHRD_DDCMP    517		/* Digital's DDCMP protocol     */
 #define ARPHRD_RAWHDLC	518		/* Raw HDLC			*/
 #define ARPHRD_RAWIP    519		/* Raw IP                       */
+#define ARPHRD_PUREIP	520		/* Pure IP			*/
 
 #define ARPHRD_TUNNEL	768		/* IPIP tunnel			*/
 #define ARPHRD_TUNNEL6	769		/* IP6IP6 tunnel       		*/
-- 
2.18.0

