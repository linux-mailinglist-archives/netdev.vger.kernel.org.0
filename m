Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553B434FB73
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhCaIVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:21:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15115 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbhCaIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:21:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9K3L1t7Pz1BFw6;
        Wed, 31 Mar 2021 16:19:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 16:21:05 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yixing Liu <liuyixing1@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 4/7] net: amd: correct some format issues
Date:   Wed, 31 Mar 2021 16:18:31 +0800
Message-ID: <1617178714-14031-5-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
References: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

There should be a blank line after declarations.

Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/amd/hplance.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/amd/hplance.c b/drivers/net/ethernet/amd/hplance.c
index e10aceb..6784f87 100644
--- a/drivers/net/ethernet/amd/hplance.c
+++ b/drivers/net/ethernet/amd/hplance.c
@@ -170,6 +170,7 @@ static void hplance_init(struct net_device *dev, struct dio_dev *d)
 static void hplance_writerap(void *priv, unsigned short value)
 {
 	struct lance_private *lp = (struct lance_private *)priv;
+
 	do {
 		out_be16(lp->base + HPLANCE_REGOFF + LANCE_RAP, value);
 	} while ((in_8(lp->base + HPLANCE_STATUS) & LE_ACK) == 0);
@@ -178,6 +179,7 @@ static void hplance_writerap(void *priv, unsigned short value)
 static void hplance_writerdp(void *priv, unsigned short value)
 {
 	struct lance_private *lp = (struct lance_private *)priv;
+
 	do {
 		out_be16(lp->base + HPLANCE_REGOFF + LANCE_RDP, value);
 	} while ((in_8(lp->base + HPLANCE_STATUS) & LE_ACK) == 0);
@@ -187,6 +189,7 @@ static unsigned short hplance_readrdp(void *priv)
 {
 	struct lance_private *lp = (struct lance_private *)priv;
 	__u16 value;
+
 	do {
 		value = in_be16(lp->base + HPLANCE_REGOFF + LANCE_RDP);
 	} while ((in_8(lp->base + HPLANCE_STATUS) & LE_ACK) == 0);
-- 
2.8.1

