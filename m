Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02C9509DB4
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349484AbiDUKex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbiDUKev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:34:51 -0400
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3641E2AE1;
        Thu, 21 Apr 2022 03:32:01 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 21 Apr
 2022 18:32:03 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Thu, 21 Apr
 2022 18:31:59 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm/amd/display: Remove useless code
Date:   Thu, 21 Apr 2022 18:31:57 +0800
Message-ID: <1650537117-14450-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

payload only memset but no use at all, so we drop them.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index c8701ac955a8..1e74bdb215ec 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -672,12 +672,10 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
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
@@ -813,11 +811,9 @@ static void es0_entry_set(struct ocelot *ocelot, int ix,
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
2.7.4

