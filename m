Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5B21B39AF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgDVIJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:09:58 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:19304 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgDVIJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587542989; x=1619078989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/TRPJJx5wL8iDEhG0/EipHn76JSEJqEwwsHFNx8GYx0=;
  b=HdmRl/2UY/krqLXp3rUWgAxWgfU9GY2Ctmr9HBmomXNkybjqVH2rTDA2
   pciRmXsmGcOyfPHbJHuaqODFl44BEt3qI7jtEPXT/EFxX4+9Y3J5A8nRa
   sDCtGk4Q/9+ihP3FYgweEmT0igG0hQPvlITYvRbyw7XqCqcSLUl5eDtET
   w=;
IronPort-SDR: MaCCfVkpb8cmmNmTca9Rv5w3LVLlOGu7ANjtpHxEJtxrQs5spDKpAHbmZALeu7Is9lGFfz8V/y
 WosZ66PHcQCw==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="26715959"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 22 Apr 2020 08:09:39 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id AAEEEA21D0;
        Wed, 22 Apr 2020 08:09:37 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:09:32 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 78C3181D25; Wed, 22 Apr 2020 08:09:31 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 12/13] net: ena: cosmetic: remove unnecessary spaces and tabs in ena_com.h macros
Date:   Wed, 22 Apr 2020 08:09:22 +0000
Message-ID: <20200422080923.6697-13-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422080923.6697-1-sameehj@amazon.com>
References: <20200422080923.6697-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The macros in ena_com.h have inconsistent spaces between
the macro name and it's value.

This commit sets all the macros to have a single space between
the name and value.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 94986cdc0b1a..b3a4b53b6a86 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -54,9 +54,9 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define ENA_MAX_NUM_IO_QUEUES		128U
+#define ENA_MAX_NUM_IO_QUEUES 128U
 /* We need to queues for each IO (on for Tx and one for Rx) */
-#define ENA_TOTAL_NUM_QUEUES		(2 * (ENA_MAX_NUM_IO_QUEUES))
+#define ENA_TOTAL_NUM_QUEUES (2 * (ENA_MAX_NUM_IO_QUEUES))
 
 #define ENA_MAX_HANDLERS 256
 
@@ -73,13 +73,13 @@
 /*****************************************************************************/
 /* ENA adaptive interrupt moderation settings */
 
-#define ENA_INTR_INITIAL_TX_INTERVAL_USECS		64
-#define ENA_INTR_INITIAL_RX_INTERVAL_USECS		0
-#define ENA_DEFAULT_INTR_DELAY_RESOLUTION		1
+#define ENA_INTR_INITIAL_TX_INTERVAL_USECS 64
+#define ENA_INTR_INITIAL_RX_INTERVAL_USECS 0
+#define ENA_DEFAULT_INTR_DELAY_RESOLUTION 1
 
-#define ENA_HW_HINTS_NO_TIMEOUT				0xFFFF
+#define ENA_HW_HINTS_NO_TIMEOUT	0xFFFF
 
-#define ENA_FEATURE_MAX_QUEUE_EXT_VER	1
+#define ENA_FEATURE_MAX_QUEUE_EXT_VER 1
 
 struct ena_llq_configurations {
 	enum ena_admin_llq_header_location llq_header_location;
-- 
2.24.1.AMZN

