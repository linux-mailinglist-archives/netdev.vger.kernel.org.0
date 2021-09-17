Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47FB40F90E
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbhIQN1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:27:42 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:65396 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbhIQN1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631885179; x=1663421179;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=odXSSfKgUwG9nonrDDCYJPBAvUhGTN3qXd57KF4ijHg=;
  b=P2BchmlHBu5FJqdszHepDBKKP9Ss7x7lWtJ+BpbiV37YS+IfQujvYoH4
   ncJOMTAFaagdyqlwdpOlAOzoXmDGo6FZfq8mC4brXJNdos6B8WJdxef2F
   IbBZxrlbeq/wJukMncWQwWgblVyZSU6944+wqx5cOmVGu3YZdCjYQw6cg
   YxO0BL1ZorO1jwPPCppx1hhIWop/FEj7g0rrUGvf54wbcNk6iAsl+kjNi
   4RofiNq0rgelIpAFWuEVsMwAtDjJzXmKvgdoLUlY5NwjbkiNXKxRO6zuS
   DczN3RXO/LUxikfkVu8l8Q7BxO4VK3TbgdoR1E1xN3cVyp2RxYZ2yn7zI
   g==;
IronPort-SDR: 6mUwOXIDMZePFRPZBHF3gC6io5dBYyHXo5HKbBpaMQwrxYjEFR7YawAngUK45jg74G71faBG18
 FVTS9N7xCUkdCQzpB988Wgk9GByvJfZWz+oCzJzV0J74faTp0/uxPQ2R0xWMnUolYtfa0IM6Iu
 NaQA8NUulsbQoJgWc9a7xT5ZrDffRN26EvhFze4iw1w4+q1j+YCRmS1N/9Y65vxCoQ9Ywc6aPf
 fO0+V8+7I3ZABTUAgCVaj5UVfjrQAhG6CbMOTf948SzNT/HzU2fHpblmdYTJbE1LI31EgPXLvX
 Fb/sAZe/w4QqcXS0SJI76XiR
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="144542053"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Sep 2021 06:26:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 17 Sep 2021 06:26:18 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 17 Sep 2021 06:26:16 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 0/4] net: macb: add support for MII on RGMII interface
Date:   Fri, 17 Sep 2021 16:26:11 +0300
Message-ID: <20210917132615.16183-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for MII mode on RGMII interface (patches 3/4,
4/4). Along with this the series also contains minor cleanups (patches 1/3,
2/3) on macb.h.

Thank you,
Claudiu Beznea

Changes in v2:
- added patch 4/4 to enable MII on RGMII support for SAMA7G5 MAC IPs

Claudiu Beznea (4):
  net: macb: add description for SRTSM
  net: macb: align for OSSMODE offset
  net: macb: add support for mii on rgmii
  net: macb: enable mii on rgmii for sama7g5

 drivers/net/ethernet/cadence/macb.h      | 7 +++++--
 drivers/net/ethernet/cadence/macb_main.c | 9 +++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.25.1

