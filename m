Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2E43E24D8
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243441AbhHFIOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:14:52 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:3178 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242582AbhHFIOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 04:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628237677; x=1659773677;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kDzHlDKsv7d3c1Tw+yWVmxOYSZW9+A6zwJbml0UBzJw=;
  b=v8aOacPaBFViiAgok56znQzG4+DLUAKcf/7h+oXiy+8GY6ra8QRUXvzx
   MuAujTJ7J8cvzAY/oG2q8lAOpsAjYhiGkmQIS+5TsmdCkcc4WS/sM9+0L
   fdOmZiesQWVq9Vrx2zqQrZubRDAVDqna2k6V4hOiKtuvLaHvZ06mH9APx
   8mIzUnSU7dWjw4ZJ/8YXVVrSVUW3FvC1sHjGk7+VTQR6JrpXiYWSDdOd8
   n1dAbxn1p3vWfyh337i9OJVSlPJ3l6gOxwjc909Pv/5pHrbmvAppQ1qxY
   NfmGN3NiA4EHP32RZcm5RbISbMY3AVVflJgoDyl2mY471rK6DQg5TXAZD
   g==;
IronPort-SDR: 3woTmiICg8iwsPe0f9gdjwLzjJbWErbax8n23HJGn3wv80FkaiRsumrV3kcAXMV6M/wppcf//p
 ekanJVD6GQcK4BoME04iGuDXlB5btbzQ+1ay7oH45ietFB3N4aHYtxRJ4P2Fi6RC2zFIX2KmFr
 KxkW3rsLDa84Anfut0PFg1JDmbo41KbqOetlyJcl6BRZV0jR/dg8TVs817GFNnXphi8ksrPjj+
 UFP6iyJ9/a5NUs9399PYXPv1jVqRDfZ4VeUL/0VRu1sOfb8PkSub8id4d7NEh8dwRWf6pnYIdl
 iQ31+gNokSNY/TGb1Kc9Hhdp
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="131275789"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Aug 2021 01:14:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 01:14:35 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 6 Aug 2021 01:14:33 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <ajay.kathat@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 0/3] wilc1000: minor cleanups
Date:   Fri, 6 Aug 2021 11:12:26 +0300
Message-ID: <20210806081229.721731-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The series contains some cleanups for wilc1000 driver.

Thank you,
Claudiu Beznea

Claudiu Beznea (3):
  wilc1000: use goto labels on error path
  wilc1000: dipose irq on failure path
  wilc1000: use devm_clk_get_optional()

 .../net/wireless/microchip/wilc1000/sdio.c    | 29 ++++++++++---------
 drivers/net/wireless/microchip/wilc1000/spi.c | 29 ++++++++++---------
 2 files changed, 32 insertions(+), 26 deletions(-)

-- 
2.25.1

