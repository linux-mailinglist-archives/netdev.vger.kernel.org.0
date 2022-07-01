Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA2A5629F5
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbiGAD5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiGAD5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:57:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2469E65D5D;
        Thu, 30 Jun 2022 20:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656647842; x=1688183842;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=PggEE9DDBJP9KD2bExipUIkHMECZ9C6jGbC1yl7I8pA=;
  b=LXhyIm+zaLlLWL60eSh6thd9Y+tvz1buylSVqUG2c1QGQrn1y8omB9DO
   8xv2TK7+iL8kAScHrAAfuBoBd6P2nPOXCtEx7PwRI/DCAgmPLxXyRxt82
   Kj7BmAccrpgWPmXlyDpau+ZZz0GaKL+zX3xdVZS0yx6kvs+3JC9MD+RFv
   g3yYO9J4atXJn5+istFYDevMvip7I9d19PYDfMuMiXxFBO0rT1HXS0/et
   oWGlNkYBp37ZoCAXa7L94JaLv5N6ZVinNQYig1un5nCEDghU5tuqBK3lp
   IKVzRkbjHUGJiMl4z4rgkHy1q6TZdT8OpiWPnGQ6VGXRZQd+T22oHGfnj
   w==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="170630180"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 20:57:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 20:57:20 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 30 Jun 2022 20:57:15 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: [PATCH v3 net-next 0/2] LED feature for LAN8814 PHY
Date:   Fri, 1 Jul 2022 09:27:07 +0530
Message-ID: <20220701035709.10829-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable LED mode configuration for LAN8814 PHY

v2 -> v3:
- Fixed compilation issues

v1 -> v2:
- Updated dt-bindings for micrel,led-mode in LAN8814 PHY

Divya Koppera (2):
  dt-bindings: net: Updated micrel,led-mode for LAN8814 PHY
  net: phy: micrel: Adding LED feature for LAN8814 PHY

 .../devicetree/bindings/net/micrel.txt        |  1 +
 drivers/net/phy/micrel.c                      | 73 ++++++++++++++-----
 2 files changed, 57 insertions(+), 17 deletions(-)

-- 
2.17.1

