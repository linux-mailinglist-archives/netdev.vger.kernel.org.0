Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA84756433B
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiGBW6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 18:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGBW6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 18:58:21 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC67F28
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 15:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656802699; x=1688338699;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=WXJgzmSi2pP90hS2qzspzUaC52oglmJidEKNvHiQPgY=;
  b=0oO8CqJJbqNVmFLo8BSf1T8BKdtnfSNQ4vOcGQvZClOLmEUUO1BmoUSb
   0YMJXe1WBbL/ZRgZMe16E7qmFAUGRVOKjVn2s9FfvBwLDGDvXf+JPKORZ
   e/dGtBhwFdTEcSei8Pk1llT2U9uorvIsWtERs0FietA9+zc5KxvaxCbCV
   zAhnSlgKBgnM4mMVMS/h04G6vSEJAp+UzBlhgcv04e5MR86Wui7lUMwwD
   pexriSihuGJrcTbQRhLHXFuHa0Wg3jXR0F74tgq4f4b/6IXH3Lit9F4n+
   ZS9epdfwt+zYGCpCXkgdCm+xxmfMgWwZAkv0JPDYkjIOZQCFfm4re77hk
   g==;
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; 
   d="scan'208";a="170546637"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2022 15:58:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 2 Jul 2022 15:58:14 -0700
Received: from hat-linux.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 2 Jul 2022 15:58:14 -0700
From:   <Tristram.Ha@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     Tristram Ha <Tristram.Ha@microchip.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 0/2] net: phy: smsc: add WoL and EEE support to LAN8740/LAN8742
Date:   Sat, 2 Jul 2022 15:58:26 -0700
Message-ID: <1656802708-7918-1-git-send-email-Tristram.Ha@microchip.com>
X-Mailer: git-send-email 1.9.1
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

From: Tristram Ha <Tristram.Ha@microchip.com>

These patches are to add WoL and EEE support to Microchip LAN8740 and
LAN8742 PHYs.

Tristram Ha (2):
  net: phy: smsc: add WoL support to LAN8740/LAN8742 PHYs.
  net: phy: smsc: add EEE support to LAN8740/LAN8742 PHYs.

 drivers/net/phy/smsc.c  | 329 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/smscphy.h |  39 ++++++
 2 files changed, 366 insertions(+), 2 deletions(-)

-- 
1.9.1

