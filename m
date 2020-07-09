Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA9421A785
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgGITGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:06:18 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:52422 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgGITGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594321575; x=1625857575;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=BHQBbfh4Y9KZW2WZUgVmIV4yiEp/f7OQSSMAdN33fxk=;
  b=ThvRc2SwLcJZc0nLZ1o5+qiyhkBv/nLpX/b218xWg2jLgzXjl6iDqqyi
   tAxgCoHZSoIhBf6u1NSaiG6P6iv7WrJLXMT4ZXY5C+3j5Wdvdz1PJqZ9+
   9QGXFZNJlJeGSOiRVf4OZrc1jwddzMmY0MIpxg/y+DEfzv9okB6MgQUn3
   U=;
IronPort-SDR: sF5fmTEQ1Jsu3lxezeGUdQTkAl8devdYOCZOE7QX7eZ3oN3oDUL9TOYCmEswY9B1y1bJ386B5u
 C1iMbeo9DMxQ==
X-IronPort-AV: E=Sophos;i="5.75,332,1589241600"; 
   d="scan'208";a="57413728"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 09 Jul 2020 19:05:50 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 10DF0A17B9;
        Thu,  9 Jul 2020 19:05:49 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:20 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.15) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 9 Jul 2020 19:05:16 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 2/8] net: ena: add reserved PCI device ID
Date:   Thu, 9 Jul 2020 22:04:57 +0300
Message-ID: <1594321503-12256-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Add a reserved PCI device ID to the driver's table

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_pci_id_tbl.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_pci_id_tbl.h b/drivers/net/ethernet/amazon/ena/ena_pci_id_tbl.h
index f80d2a47fa94..426e57e10a7f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_pci_id_tbl.h
+++ b/drivers/net/ethernet/amazon/ena/ena_pci_id_tbl.h
@@ -53,10 +53,15 @@
 #define PCI_DEV_ID_ENA_LLQ_VF	0xec21
 #endif
 
+#ifndef PCI_DEV_ID_ENA_RESRV0
+#define PCI_DEV_ID_ENA_RESRV0	0x0051
+#endif
+
 #define ENA_PCI_ID_TABLE_ENTRY(devid) \
 	{PCI_DEVICE(PCI_VENDOR_ID_AMAZON, devid)},
 
 static const struct pci_device_id ena_pci_tbl[] = {
+	ENA_PCI_ID_TABLE_ENTRY(PCI_DEV_ID_ENA_RESRV0)
 	ENA_PCI_ID_TABLE_ENTRY(PCI_DEV_ID_ENA_PF)
 	ENA_PCI_ID_TABLE_ENTRY(PCI_DEV_ID_ENA_LLQ_PF)
 	ENA_PCI_ID_TABLE_ENTRY(PCI_DEV_ID_ENA_VF)
-- 
2.23.1

