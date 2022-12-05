Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFCB6426BF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 11:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiLEKgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 05:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLEKgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 05:36:01 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833B4120A3;
        Mon,  5 Dec 2022 02:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670236560; x=1701772560;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Wdo83nd+UkE2clMU8uIx9XV2HbXSv9RcIg6To8usxK4=;
  b=zm5EUa1hz5Q8QIfNscsBUVO67evxFXKZz4L1g/b+KaFRktZe5Ey+h1NC
   dzE3hyRGdIaE4O4KNPhhchTjrFcAA9gYs8QzZv8qTsWD00d12PwkhSAqD
   Fm74pVtRg7JtE/enKq4r4+IwPt7VY1cEEe7J6IN6e67jpb61CfhSVvMyo
   vbRgOR7g+d6G+QFEHAln+ULcc18WWdxdBox4FHnpiu4vghkPt6P1204Dt
   cOT5wSaXxPIYPztx3ifrqU76MLHq7SFw1ieLLmGG21OhWqf5LC22dLNBi
   OhUu4NkDssH374x+vpaByYObFuk9k+CHyRsZaPUOwqPvxQQYyDIjHqZdu
   g==;
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="191713793"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2022 03:35:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Dec 2022 03:35:59 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 5 Dec 2022 03:35:55 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: [PATCH v4 net-next 0/2] Fixed warnings
Date:   Mon, 5 Dec 2022 16:05:48 +0530
Message-ID: <20221205103550.24944-1-Divya.Koppera@microchip.com>
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

 drivers/net/phy/micrel.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

-- 
2.17.1

