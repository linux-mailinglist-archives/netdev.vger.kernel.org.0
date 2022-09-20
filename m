Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3305BE2A8
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiITKGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiITKFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:05:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B435AA3C;
        Tue, 20 Sep 2022 03:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663668338; x=1695204338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6UYyEPOTu4MzOtxQURaQvD4wYB0xJT6AU06TGe2VG8o=;
  b=MBhedeNvnbGVn9GYFXBBflVJ+ssGYPvE3lCO09/Plqeh5XF/A+yQap4A
   /VTJoiHwpyd3w2tv6MLpW5VDSQO6qaZT65M4iQiRZDe/SecNSoOZfIsth
   +2cEgbChmoY/t7bcd9R8dysT4s4k1r5bn8O77Ki6/4SmBxz4J5aTh417M
   3IOlRD5y7wWyEBCOKfQDYn6CKSHjAXKneWJqrTieZjlsXYlPVjPOBwC2q
   7l51vxWlkUQ8DAcdtTDjgi+DdryRkxbuLZzlOZMTR/kyOzuWY1mOo9meV
   RPAa6cj4fcNpgeD3AEVPOtKH/oT4H4I/xmQCwb70EDT428PcHrlMGRjD7
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,330,1654585200"; 
   d="scan'208";a="181221006"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2022 03:05:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 20 Sep 2022 03:05:37 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 20 Sep 2022 03:05:34 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <casper.casan@gmail.com>, <horatiu.vultur@microchip.com>,
        <rmk+kernel@armlinux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH net-next v2 5/5] maintainers: update MAINTAINERS file.
Date:   Tue, 20 Sep 2022 12:14:32 +0200
Message-ID: <20220920101432.139323-6-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920101432.139323-1-daniel.machon@microchip.com>
References: <20220920101432.139323-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update Maintainers file.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6705fb8bfd3a..19fdcf91f1c9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2401,6 +2401,7 @@ N:	atmel
 ARM/Microchip Sparx5 SoC support
 M:	Lars Povlsen <lars.povlsen@microchip.com>
 M:	Steen Hegelund <Steen.Hegelund@microchip.com>
+M:	Daniel Machon <daniel.machon@microchip.com>
 M:	UNGLinuxDriver@microchip.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
-- 
2.34.1

