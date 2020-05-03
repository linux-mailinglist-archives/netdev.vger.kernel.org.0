Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25961C2B09
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgECJwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:52:45 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:43871 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgECJwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499559; x=1620035559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SCgI9EbB8jwnRZTfsB24tMtJF9735DlvvdRLpbJqpHI=;
  b=OmNaezgMsTrouxchb+ZPSKVQKCEfp3Gwn+37kL+eQxxP1ExPYuuYf3OT
   hvgvCM7M/CCkgY/1FwHNj8IaiMrm2eWFAJl/wpxIBKOo3xTmVRvzk7e9Z
   M7Vyx2Y+CE0Vz8lf3ab+G0jWmi3MFi1Af6wBFKn7bs3u6/2XFl5mg8Xf4
   Y=;
IronPort-SDR: umTSSyMK1HAjojtar8QIzhxf+LLe6/T0aTN6OyoOTmGyYqqAzHthTDy7hJNTa3mcqvi5fL+70N
 wZB9X1jiDaNQ==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="29750315"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 03 May 2020 09:52:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id E8766A2187;
        Sun,  3 May 2020 09:52:25 +0000 (UTC)
Received: from EX13D02UWB004.ant.amazon.com (10.43.161.11) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB004.ant.amazon.com (10.43.161.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 3 May 2020 09:52:24 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 8869D81F73; Sun,  3 May 2020 09:52:23 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V3 net-next 11/12] net: ena: cosmetic: remove unnecessary spaces and tabs in ena_com.h macros
Date:   Sun, 3 May 2020 09:52:20 +0000
Message-ID: <20200503095221.6408-12-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200503095221.6408-1-sameehj@amazon.com>
References: <20200503095221.6408-1-sameehj@amazon.com>
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
index a55379471f98..13a1b7812c46 100644
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

