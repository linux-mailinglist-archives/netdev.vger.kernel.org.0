Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF87222AA9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgGPSK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:10:59 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:18800 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgGPSK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 14:10:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594923058; x=1626459058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=tO9lQMDtoAIoliB9ZmdIUt7Njzuy9q7gICtbbozEDa4=;
  b=FrOcTJnBjnd387EmAIACaQS21BbzOa0igK5wb6QLMF6bzyP0fivm5xd/
   WVXaFc/E6cLmvgk21+9m3sswEh9Z07YeY3bPqi0e4caBPmYlQhcmIWOYz
   eIehhxQHiVp/6mhPl0UMTfQNQ+Lj04nb45W6N2PB7O7VqM17ndsOsED6H
   Q=;
IronPort-SDR: yGMdxnuiQYp3dGZZ2R8Ax8YfvaVH9Gc7KLPhvtDckrK7adwP40mWF1KChz0m0PU/DFGlvmnt38
 qLW6GZmIxxrA==
X-IronPort-AV: E=Sophos;i="5.75,360,1589241600"; 
   d="scan'208";a="52185704"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 16 Jul 2020 18:10:57 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 78590A1D33;
        Thu, 16 Jul 2020 18:10:57 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 18:10:56 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 18:10:56 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.20) by
 mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 16 Jul 2020 18:10:53 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 2/8] net: ena: add reserved PCI device ID
Date:   Thu, 16 Jul 2020 21:10:04 +0300
Message-ID: <1594923010-6234-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
References: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
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

