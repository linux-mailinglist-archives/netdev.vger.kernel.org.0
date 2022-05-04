Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B3151A40B
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352493AbiEDPcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352366AbiEDPcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:32:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CAD44747
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651678118; x=1683214118;
  h=from:to:subject:date:message-id:mime-version;
  bh=cfEhkhl5TsNM7WE5DaStFCKRrYP/lxVyu7IaHCalIVU=;
  b=AK5WJOZjTOJYOD36UHpcbxRnFHEkV/WBs/aNgjp/jbMMtk8x+jAmPfOr
   nmERXS4A2B2WT2NSLnQZqduZ+zsv0M3F5MvxYtrZ6n8kXMtnEqFfo6k5H
   onbo5WgNa4SJQDk++q35W6hRHvQ9B6VJoJ75vVvybYxsytGV42KjGTeqT
   9TQ1wew5351JS4t+ifnX6uQ+n3dg2KApzYTDG0Tsm4mK5Ydsy/eD9ODAI
   P6nssVnt1CkTRM/V4ybLQUfhVWdDwesOjijq9E7MQYUJydenaOeB8pa5i
   jg9NytHOdfDRXD07YA7XHXf+jqrsOuUWLW79S0TegcrmPTfyrn/Yk6mAK
   A==;
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="162310189"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2022 08:28:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 4 May 2022 08:28:36 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 4 May 2022 08:28:36 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <woojung.huh@microchip.com>, <yuiko.oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <ravi.hegde@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: [PATCH v3 net-next 0/2] net: phy: add LAN8742 phy support
Date:   Wed, 4 May 2022 08:28:20 -0700
Message-ID: <20220504152822.11890-1-yuiko.oshino@microchip.com>
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

v2->v3:
-added comments about the 0xfffffff2 mask that is for the differentiation and 
 the future revisions.

v1->v2:
-removed "REVIEW REQUEST3" from the PATCH 1/2.

Yuiko Oshino (2):
  net: phy: microchip: update LAN88xx phy ID and phy ID mask.
  net: phy: smsc: add LAN8742 phy support.

 drivers/net/phy/microchip.c | 10 +++++++---
 drivers/net/phy/smsc.c      | 31 +++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

-- 
2.25.1

