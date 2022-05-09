Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B0D5204D7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240411AbiEITCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240409AbiEITCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:02:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C45021B177
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 11:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652122692; x=1683658692;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=TkIxeXK40XqnXnLXDVl0euM4flSXkMpHCLusTHTTePw=;
  b=eU3EHPPzJRluN6s+/2/gwP3Udw3r81RSNj3upKbVDrspD/qzIpHVJjfW
   Rs7Nq9S/EEg41P5svNEbEIxG++LAhtuNR6VIt0Zjf58fHqMBi1F3zu3eV
   RI/gkHtCIShrJnso8EgChjkQ0UIAt5F3FM7icWPLNNQsaaS0ckP5ZxwzE
   675qW9kb9TduUOMtLYOj2fN+yd9/IVeP8qwOomi2wCfrOHUzmsgCQNIol
   LBPzjOBfoT3R8VN0PVkMtB/lkad+iCnGVSsiK4siMfq9VHzf7baMTKJiz
   O3WGsO32zp7tF79bs0WnjFQ8BqCgiaa/YfhgVSWFM1OmG/NIqd/aO1RIj
   w==;
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="172560101"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2022 11:58:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
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
Subject: [PATCH net-next 1/2] net: phy: microchip: add comments for the modified LAN88xx phy ID mask.
Date:   Mon, 9 May 2022 11:58:03 -0700
Message-ID: <20220509185804.7147-2-yuiko.oshino@microchip.com>
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

add comments for the updated LAN88xx phy ID mask in the previous patch.

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/microchip.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index 131caf659ed2..ccecee2524ce 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -345,6 +345,10 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
 static struct phy_driver microchip_phy_driver[] = {
 {
 	.phy_id		= 0x0007c132,
+	/* This mask (0xfffffff2) is to differentiate from
+	 * LAN8742 (phy_id 0x0007c130 and 0x0007c131)
+	 * and allows future phy_id revisions.
+	 */
 	.phy_id_mask	= 0xfffffff2,
 	.name		= "Microchip LAN88xx",
 
-- 
2.25.1

