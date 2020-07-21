Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748A4228116
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGUNjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:39:03 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:63919 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbgGUNjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:39:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595338743; x=1626874743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=tO9lQMDtoAIoliB9ZmdIUt7Njzuy9q7gICtbbozEDa4=;
  b=NTYqKmTEhXd8AKrWlGhQ/kuhkWKAdgOxMQYsbu+ing8wYUZpqxm4BGf7
   QCKm1IQ3ykpciyHcQMIskoGC/cUN0Sn1zeJKgwVWMBYYI3qltpT2GJTd8
   peM45P9FbjmIlXcBvPZBsSspiMzbdMGs4Jhea56wUD5b5D1zFGILjobLJ
   4=;
IronPort-SDR: amHaQBCdBMcFCoQY+A+sMoX3pGTNb0KBq6bZOy20Sxm+FvR6UQaIYmmKImTJNohTfniojoc7rA
 or6fFKoQBAtQ==
X-IronPort-AV: E=Sophos;i="5.75,379,1589241600"; 
   d="scan'208";a="43308608"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Jul 2020 13:39:01 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 9708DA209F;
        Tue, 21 Jul 2020 13:39:00 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:39 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:39 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 13:38:34 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 2/8] net: ena: add reserved PCI device ID
Date:   Tue, 21 Jul 2020 16:38:05 +0300
Message-ID: <1595338691-3130-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
References: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Add a reserved PCI device ID to the driver's table
Used for internal testing purposes.

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
2.23.3

