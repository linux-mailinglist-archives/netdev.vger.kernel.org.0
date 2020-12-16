Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD27B2DC0F5
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 14:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgLPNQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 08:16:41 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9535 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgLPNQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 08:16:41 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CwwbX40Dpzhmwh;
        Wed, 16 Dec 2020 21:15:20 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 16 Dec 2020 21:15:49 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] mscc: ocelot_vcap: Delete unused variable payload
Date:   Wed, 16 Dec 2020 21:16:22 +0800
Message-ID: <20201216131622.14773-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable `payload` is set but not used, so delete it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index d8c778ee6f1b..c474b63bf228 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -671,12 +671,10 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 {
 	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
 	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
-	struct ocelot_vcap_u64 payload;
 	struct vcap_data data;
 	int row = ix / 2;
 	u32 type;
 
-	memset(&payload, 0, sizeof(payload));
 	memset(&data, 0, sizeof(data));
 
 	/* Read row */
@@ -811,11 +809,9 @@ static void es0_entry_set(struct ocelot *ocelot, int ix,
 {
 	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
 	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
-	struct ocelot_vcap_u64 payload;
 	struct vcap_data data;
 	int row = ix;
 
-	memset(&payload, 0, sizeof(payload));
 	memset(&data, 0, sizeof(data));
 
 	/* Read row */
-- 
2.22.0

