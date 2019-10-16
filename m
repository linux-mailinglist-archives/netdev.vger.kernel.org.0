Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9D1D9C51
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 23:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437453AbfJPVOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 17:14:24 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:31198 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727542AbfJPVOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 17:14:24 -0400
X-UUID: f9a2bdba61694a888cf6cf18331c88e7-20191017
X-UUID: f9a2bdba61694a888cf6cf18331c88e7-20191017
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1589608840; Thu, 17 Oct 2019 05:14:18 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 17 Oct 2019 05:14:08 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 17 Oct 2019 05:14:09 +0800
From:   <sean.wang@mediatek.com>
To:     <davem@davemloft.net>
CC:     <john@phrozen.org>, <nbd@openwrt.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net-next] net: Update address for MediaTek ethernet driver in MAINTAINERS
Date:   Thu, 17 Oct 2019 05:14:08 +0800
Message-ID: <fc0692002216a32b045a69f910e95c83c1ff559c.1571260085.git.sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7C6ADE6E34B7E473A3934605950146B500CBE6C8027DA7036AD9E205285D4E242000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

Update maintainers for MediaTek ethernet driver with Mark Lee.
He is familiar with MediaTek mt762x series ethernet devices and
will keep following maintenance from the vendor side.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Mark Lee <Mark-MC.Lee@mediatek.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b431e6d5f43f..97027098899a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10258,7 +10258,7 @@ MEDIATEK ETHERNET DRIVER
 M:	Felix Fietkau <nbd@openwrt.org>
 M:	John Crispin <john@phrozen.org>
 M:	Sean Wang <sean.wang@mediatek.com>
-M:	Nelson Chang <nelson.chang@mediatek.com>
+M:	Mark Lee <Mark-MC.Lee@mediatek.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/mediatek/
-- 
2.18.0

