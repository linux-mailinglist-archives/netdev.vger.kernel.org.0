Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265125482F5
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240631AbiFMJMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240625AbiFMJMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:12:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598079FC5
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 02:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655111555; x=1686647555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AF4dLRfhVIq783aPm4eF8OpPp/B/3Nqr/5o7PxLHz+k=;
  b=RYYhjw9ZWWWBGDhnjNODxCXPol/9CDKDGHxbmLhCCigB4Jsokv0lSxeL
   vej5H3JkkfjYgKEnRxI6/cfG4Xfq6dO9wRlgs8L+31iMq3bIgC+KkayEL
   1JQtAas4hF00o09tsu/3rt1HnGlS3r6wPv1jQJ01OhwTkf2WbuT4jiNxn
   RaxKEkL05TsrLBONcP5atXXhrArvGRpztDGZ8fz3qm8NC0yDUmONUk8i1
   +Tj9d30lfdr/dGelyBwPRHfmWvcuTN+cmCboC5rqutz4+MDY9ohUIHAMc
   ZuqYrCb/7jIIDIatlX3xuVw2wQ/jblhem9h2kq4C+iaXosJfxPdyIk4zM
   w==;
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="163050316"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jun 2022 02:12:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Jun 2022 02:12:25 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 13 Jun 2022 02:12:22 -0700
From:   Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Jan.Huber@microchip.com>,
        Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 1/1] net: smsc95xx: add support for Microchip EVB-LAN8670-USB
Date:   Mon, 13 Jun 2022 14:42:07 +0530
Message-ID: <20220613091207.17374-2-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220613091207.17374-1-Parthiban.Veerasooran@microchip.com>
References: <20220613091207.17374-1-Parthiban.Veerasooran@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for Microchip's EVB-LAN8670-USB 10BASE-T1S
ethernet device to the existing smsc95xx driver by adding the new
USB VID/PID pairs.

Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bd03e16f98a1..35110814ba22 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -2088,6 +2088,11 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE(0x0424, 0x9E08),
 		.driver_info = (unsigned long) &smsc95xx_info,
 	},
+	{
+		/* Microchip's EVB-LAN8670-USB 10BASE-T1S Ethernet Device */
+		USB_DEVICE(0x184F, 0x0051),
+		.driver_info = (unsigned long)&smsc95xx_info,
+	},
 	{ },		/* END */
 };
 MODULE_DEVICE_TABLE(usb, products);
-- 
2.25.1

