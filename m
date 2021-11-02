Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE88A442C1E
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhKBLHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 07:07:49 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:14863 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhKBLHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 07:07:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1635851115; x=1667387115;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ry04JUzd3h3vVKPkr+8Rya+vcn4Q37/2/vN5pSRIBDE=;
  b=BfxcTd5ya/EuDpIMmUc7cEk8RH4+g+N8fV8ZtruvOPlqU1rPAq2FoCHC
   EarIYCIxD1OOEusjujBokINYgfOiZdNr53rdZTfVAo6zQAvzEO3P7kO6R
   lr8dBzdN/f0fkNtdALvezC6eEvsPM8Szrhz20hZ40ZmKqL7YZAJX6mFop
   g=;
X-IronPort-AV: E=Sophos;i="5.87,202,1631577600"; 
   d="scan'208";a="38492854"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 02 Nov 2021 11:04:59 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id 495B1C482E;
        Tue,  2 Nov 2021 11:04:58 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.160.7) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Tue, 2 Nov 2021 11:04:50 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [Patch v1 net-next] MAINTAINERS: Update ENA maintainers information
Date:   Tue, 2 Nov 2021 13:04:00 +0200
Message-ID: <20211102110358.193920-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.7]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ENA driver is no longer maintained by Netanel and Guy

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 MAINTAINERS | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a2491ce4c77..81d57778f1f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -866,9 +866,10 @@ F:	Documentation/devicetree/bindings/thermal/amazon,al-thermal.txt
 F:	drivers/thermal/thermal_mmio.c
 
 AMAZON ETHERNET DRIVERS
-M:	Netanel Belgazal <netanel@amazon.com>
+M:	Shay Agroskin <shayagr@amazon.com>
 M:	Arthur Kiyanovski <akiyano@amazon.com>
-R:	Guy Tzalik <gtzalik@amazon.com>
+R:	David Arinzon <darinzon@amazon.com>
+R:	Noam Dagan <ndagan@amazon.com>
 R:	Saeed Bishara <saeedb@amazon.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.25.1

