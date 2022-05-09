Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD81E5204D3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbiEITCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240352AbiEITCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:02:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CB620139D
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 11:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652122688; x=1683658688;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=dvw2Hjyo5G08axm7x3bAgNJzQl6tH8KgWi7GNvDR/eo=;
  b=jFhFsHekLVYHS0SRwrEwNOJ3gwqL9HITYyFyuFDkuNYq6ZZ486wVjlrj
   dLJt0GLIKSJEge6SyVaAt83x8aFSscjg+MKBGzSaMWkc1m0idlCDgcDtR
   JbqK0YRScu/LSJrjFxtoj27Ek6ASMlbgUOHFQxhReY9Ouajc2/TsphNnC
   kCBFPGlWipQr62XheHHXZtFCaBy6K/nvH/6JwRTkkjuFxcxd5JyrK/Fvt
   rmD7kNKzYp8/9mWYmykH+abmQwv17qdAxGB8MnhwFVQHshWQvkYi4RQit
   A2NEUn4g7JqJCFmv+MgqQeni+T7z03MXR4lB0fEUoxAnxYWKtrdTjKiSk
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="163289249"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2022 11:58:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 9 May 2022 11:58:06 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 9 May 2022 11:58:06 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <woojung.huh@microchip.com>, <yuiko.oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <ravi.hegde@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <kuba@kernel.org>
Subject: [PATCH net-next 2/2] net: phy: smsc: add comments for the LAN8742 phy ID mask.
Date:   Mon, 9 May 2022 11:58:04 -0700
Message-ID: <20220509185804.7147-3-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220509185804.7147-1-yuiko.oshino@microchip.com>
References: <20220509185804.7147-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add comments for the LAN8742 phy ID mask in the previous patch.
add one missing tab in the LAN8742 phy ID line.

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/smsc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 44fa9e00cc50..92225d0fc246 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -484,7 +484,11 @@ static struct phy_driver smsc_phy_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id	= 0x0007c130,	/* 0x0007c130 and 0x0007c131 */
+	.phy_id		= 0x0007c130,	/* 0x0007c130 and 0x0007c131 */
+	/* This mask (0xfffffff2) is to differentiate from
+	 * LAN88xx (phy_id 0x0007c132)
+	 * and allows future phy_id revisions.
+	 */
 	.phy_id_mask	= 0xfffffff2,
 	.name		= "Microchip LAN8742",
 
-- 
2.25.1

