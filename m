Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EF2508BF6
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 17:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380002AbiDTPXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 11:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379944AbiDTPXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 11:23:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0157245531;
        Wed, 20 Apr 2022 08:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650468056; x=1682004056;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wxoaJO2kvqSl0xXAu4pLhjew/U0rpaw2gG5T0IZAMIQ=;
  b=Kki00YoBwmJ45Rgpp4GADd5u0VZuRJhLXRakjdOQ3bmjghIBzhgF23Gw
   LJGx4uVp17Am44CF8lOwYI1naNE88yGHIm6HyyXAhLgBi1Il+4IgnG/8Y
   S3v1gdM9E+Yx8b76zD56VKSsjlWyL8ib5Hl2eXbiDGZrxn4w9Cmml/3uc
   8RGdO6sUbSMAsdp87vRbHVpdi5PA0FX5+3u26koPr/9NJLeAS9dNI12S0
   2yn8lVvqCu9+Gk9htJ24KMzzmYP8CjpYJmmMT/KQTsPBQc6Jxk4s3hI4O
   YgUOg4gO+MigzS64xQPbWGF72+1CVdftICZSRDj9RaVZ45M4qOSye7G2/
   w==;
X-IronPort-AV: E=Sophos;i="5.90,276,1643698800"; 
   d="scan'208";a="92976702"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2022 08:20:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 20 Apr 2022 08:20:32 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 20 Apr 2022 08:20:27 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: [Patch net-next v3 0/2] add ethtool SQI support for LAN87xx T1 Phy
Date:   Wed, 20 Apr 2022 20:50:14 +0530
Message-ID: <20220420152016.9680-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the Signal Quality Index measurement for the LAN87xx and
LAN937x T1 phy. Updated the maintainers file for microchip_t1.c.

v2 - v3
------
Rebased to latest commit

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


base-commit: 365014f5c39422fa7ccd75b36235155d9041f883
-- 
2.33.0

