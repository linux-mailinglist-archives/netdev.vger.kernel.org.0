Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B600821CBE5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgGLWgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:36:41 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:17593 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGLWgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:36:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594593401; x=1626129401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=z3T3/1NwnSM/qTbe+ux93S/onk2kmiNvLcCp2WHbWvo=;
  b=NKrciz7uXbiHABmm19h0hf8QlFTC08JzRWaicjGDVY6lqWa64O+P6fso
   nuTpxjhliFtAK6WI/Tp+HnRHyMgcibilPqrcbGhgmhXu0RSpCb5FdBvsn
   TmVztMTxv6QskKJu1alovQmExgIVSMb3J4Kr7jwmM71GDuSqeL/mQ/6At
   c=;
IronPort-SDR: iosBWaPdC/dvfTgCIRVscomQ55Waa7PXaOgXjn2RnRdXddjVg77t3gXAfB+iTlM2hU0OawOsQy
 1S1BLYMtJ9Yw==
X-IronPort-AV: E=Sophos;i="5.75,345,1589241600"; 
   d="scan'208";a="42808986"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 12 Jul 2020 22:36:40 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 3B1D0A1FB2;
        Sun, 12 Jul 2020 22:36:39 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:28 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:28 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.5) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 22:36:23 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 2/7] net: ena: add reserved PCI device ID
Date:   Mon, 13 Jul 2020 01:36:06 +0300
Message-ID: <1594593371-14045-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
References: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Add a reserved PCI device ID to the driver's table.
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
2.23.1

