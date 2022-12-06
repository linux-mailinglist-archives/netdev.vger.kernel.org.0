Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE945643DA8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiLFHfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLFHfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:35:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A4210063;
        Mon,  5 Dec 2022 23:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670312120; x=1701848120;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=mFnvXBwt56HHY/ogwjOCDoOdDhabCyCbeVUMtAwZ4v0=;
  b=OX6SFE1gz2V5Lhqnu5NgTsvP7tS8RjvpS3gLvDZbrKda1Npx4kI6Lq9/
   V6SOyr3qYl6bSHJGnIniyZZ0X78GB6FzDqSLJFJausUuLPl8gMYkS4BIp
   4B9hua2qJoMxaXTaA8phP3ldJgPcMWDrX0ZncKVi2FX1hvikUJDwKq3WD
   xL8k5Z7ombXVDa5WBRPqpzAMxJs0fgAawpsvqR4U6WzYu74XJAT9lOCUa
   Pp1k4qVYrE2MJYvD1uGQpePSmmPupC92mqC3kQJtR15vtNrAAZooQr6lK
   5TPVT4TrMjP+LOFZaM3l9ewP40J+d1RviAeVHK7O2p68P+fS+AvhgvSqd
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="126679785"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 00:35:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 00:35:17 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 00:35:13 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v5 net-next 0/2] Fixed warnings 
Date:   Tue, 6 Dec 2022 13:05:09 +0530
Message-ID: <20221206073511.4772-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

