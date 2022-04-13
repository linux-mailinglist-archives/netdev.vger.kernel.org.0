Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F58D4FF03A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbiDMG6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiDMG6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:58:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEECB2F3BC;
        Tue, 12 Apr 2022 23:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649832976; x=1681368976;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+PTrNZSbJCN60c6KFo25ZlefAggd/0VGFamMSfR4pZE=;
  b=B5P51RRCM6Pn7i43w8ZsWX/1019+8BkBaNmPi7qj7mXaOBSmjl4HeTyv
   3CEiFWpVrBW8S1WRS9+6n9ZHdqEZ8HikzOOyQAk9c7o/DMeGalHuDz//+
   RvURbWFiM6nIyHKYJGZ7C3XrsFBge832KfxnYJhDW5zrJr9fAubIGnXC/
   BYqR+Lh7+2NtlVQEAg7mF3WjldB2DxWtDwDSaLd7seeiAKLVzQBHv71n2
   KVk+DBBUFykIh5dD36iaa6wmSe7SyuGahKf7OPdfqgcnz78RmtLvFJGh5
   NHwhg+XZP7fgPm0a5H6QpKvvBXpHHB57Qb995tN6MZ+YB/Za9FazLMyCH
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,256,1643698800"; 
   d="scan'208";a="152483777"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2022 23:56:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Apr 2022 23:56:14 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Apr 2022 23:56:11 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: [Patch net-next v2 0/2] add ethtool SQI support for LAN87xx T1 Phy
Date:   Wed, 13 Apr 2022 12:25:55 +0530
Message-ID: <20220413065557.12914-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the Signal Quality Index measurement for the LAN87xx and
LAN937x T1 phy. Updated the maintainers file for microchip_t1.c.

v1 - v2
------
- Seperated the PHY_POLL_CABLE_TEST flag patch as a fix to net tree.
- Updated the individual people as Maintainer.

Arun Ramadoss (2):
  net: phy: LAN87xx: add ethtool SQI support
  MAINTAINERS: Add maintainers for Microchip T1 Phy driver

 MAINTAINERS                    |  7 +++++
 drivers/net/phy/microchip_t1.c | 48 ++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)


base-commit: f45ba67eb74ab4b775616af731bdf8944afce3f1
-- 
2.33.0

