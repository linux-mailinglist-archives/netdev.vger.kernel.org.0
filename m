Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61C851C6D3
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382865AbiEESRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357569AbiEESQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:16:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3425C373
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 11:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651774399; x=1683310399;
  h=from:to:subject:date:message-id:mime-version;
  bh=rAE2QANMhCh2QOevk7CeE7tdh96ZzCZkW4jefN/y9yE=;
  b=ADer8ng4Muumon3mKZzPA6YtZ7J0cupU9JkpVII0aLngEbNQ6tqtfLF1
   fXmQZyCqPUasj4ARh9jzUEEYnzWPnAoWYyNaworGXjvbURewOuHopiF/F
   zOIiQEusgOo3Qm48K91EBAW7LV2p8HE+mX58DI0ZIoLkGcb7a+8JaVn1H
   XG3FA/nYYH3OjQ376mxkPK7BQm5lo778z9UkNPoS798xThNTfaddz6X+O
   CfD8O52NnlpTICGDYIP3zc8soGSMpUe1c9t2M2PjO79XRRLpQuVOSVoql
   x2hqW4kzZDBl+Q2P6ZeCJ5YC2iGYdocUdpWshNjf3vnEYmUMoPT+6/yG4
   g==;
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="94702630"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 May 2022 11:13:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 5 May 2022 11:13:08 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 5 May 2022 11:13:08 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <woojung.huh@microchip.com>, <yuiko.oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <ravi.hegde@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <kuba@kernel.org>
Subject: [PATCH v4 net-next 0/2] net: phy: add LAN8742 phy support
Date:   Thu, 5 May 2022 11:12:50 -0700
Message-ID: <20220505181252.32196-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
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

add LAN8742 phy support
update LAN88xx phy ID and phy ID mask so that it can coexist with LAN8742

The current phy IDs on the available hardware.
    LAN8742 0x0007C130, 0x0007C131
    LAN88xx 0x0007C132

v3->v4:
- fixed the one tab missing issue in the smsc.c.

v2->v3:
-added comments about the 0xfffffff2 mask that is for the differentiation and the future revisions.

v1->v2:
-removed "REVIEW REQUEST3" from the PATCH 1/2.

Yuiko Oshino (2):
  net: phy: microchip: update LAN88xx phy ID and phy ID mask.
  net: phy: smsc: add LAN8742 phy support.

 drivers/net/phy/microchip.c |  6 +++---
 drivers/net/phy/smsc.c      | 27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)

-- 
2.25.1

