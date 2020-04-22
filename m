Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962F41B39DB
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgDVIQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:16:50 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:25981 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgDVIQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543407; x=1619079407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mAvHU2ojTTur1PSw64NTF05adIU5J6yj6S/1l3hNaps=;
  b=lIZINro8QFVhkJ5pntWoFyG1yRCagf5LmOwAvd8AP34/uv63ZKDH1OMT
   C7B4T2EeQSpbVTOLAc9dGEwObNa4VJevPITTGtCA3dkWVAXyRvBxurZx7
   yF9ZMyLtx+Zqkia0W/OjPcgGrpF+8gIKTFIqiSR1Nffbme1zrBgkcAgNr
   k=;
IronPort-SDR: Y0v54bUwT6i+2tzlE48TvAhIfyn2n2n50myG4k+tSmOu6nhb98wdawtbTwa3mliCXtgG2a16Nz
 fyHcb6goOubg==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="38703250"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 Apr 2020 08:16:47 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 66180A1FEC;
        Wed, 22 Apr 2020 08:16:46 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:16:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 7E13681D1A; Wed, 22 Apr 2020 08:16:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V1 net-next 09/13] net: ena: implement ena_com_get_admin_polling_mode()
Date:   Wed, 22 Apr 2020 08:16:24 +0000
Message-ID: <20200422081628.8103-10-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422081628.8103-1-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Before this commit there was a function prototype named
ena_com_get_ena_admin_polling_mode() that was never implemented.

This commit:
1. Changes the name of the function by removing the redundant double "ena_" in it.
2. Adds an implementation to the function.
3. Fixes a typo in the description of the function.

Signed-off-by: Igor Chauskin <igorch@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 5 +++++
 drivers/net/ethernet/amazon/ena/ena_com.h | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index b51bf62af11b..b1ce95717de9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1659,6 +1659,11 @@ void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling)
 	ena_dev->admin_queue.polling = polling;
 }
 
+bool ena_com_get_admin_polling_mode(struct ena_com_dev *ena_dev)
+{
+	return ena_dev->admin_queue.polling;
+}
+
 void ena_com_set_admin_auto_polling_mode(struct ena_com_dev *ena_dev,
 					 bool polling)
 {
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index e2e2fd1dc820..94986cdc0b1a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -501,7 +501,7 @@ bool ena_com_get_admin_running_state(struct ena_com_dev *ena_dev);
  */
 void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling);
 
-/* ena_com_set_admin_polling_mode - Get the admin completion queue polling mode
+/* ena_com_get_admin_polling_mode - Get the admin completion queue polling mode
  * @ena_dev: ENA communication layer struct
  *
  * Get the admin completion mode.
@@ -511,7 +511,7 @@ void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling);
  *
  * @return state
  */
-bool ena_com_get_ena_admin_polling_mode(struct ena_com_dev *ena_dev);
+bool ena_com_get_admin_polling_mode(struct ena_com_dev *ena_dev);
 
 /* ena_com_set_admin_auto_polling_mode - Enable autoswitch to polling mode
  * @ena_dev: ENA communication layer struct
-- 
2.24.1.AMZN

