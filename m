Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6B64C5D2
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 10:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbiLNJZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 04:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiLNJZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 04:25:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E6B25F5;
        Wed, 14 Dec 2022 01:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671009943; x=1702545943;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=jdLGkBrqaiJB+dzchBoVMXO4tcey19FNxVWX7NoFdCs=;
  b=GaaB98lyfsZoqWSE0XKHBQABEWdnKH+bl58JcCpU4w14uUrLOf3mNXQt
   +qZ62dAvyx2EbRqcsUK4cIcRXnKb6m9ERVUZxRXnlOCLrbHwQPaWJk4nK
   fvUSVJlu9KVo1npSyyW/Wi+m2x9eVrJMif+KJd+kxjY/i2+VyZMeyGvnO
   DAgho4l8VdkiOdK7KoPwCMJQJxfniBqfNmlOeixIw5k1GKf/RRTE2zXur
   pJ5TfvgJPwo8K74BFE08JMrNDFdYbl8OHU6xFNqrNSk3UHx51F+okm63i
   dianbEYXjAIefxn6r0aFfxuQerXgeJc4KKpgCkPGjiO93dpj2scN1U+gg
   g==;
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="188100259"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Dec 2022 02:25:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 02:25:39 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 02:25:35 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [RESEND PATCH v5 net-next 0/2] Fixed warnings
Date:   Wed, 14 Dec 2022 14:55:22 +0530
Message-ID: <20221214092524.21399-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed warnings related to PTR_ERR and initialization.

Divya Koppera (2):
  net: phy: micrel: Fixed error related to uninitialized symbol ret
  net: phy: micrel: Fix warn: passing zero to PTR_ERR

 drivers/net/phy/micrel.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--
2.17.1

