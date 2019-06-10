Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0D63B3EF
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 13:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389460AbfFJLT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 07:19:56 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:48458 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389335AbfFJLTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 07:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560165595; x=1591701595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8g2h/TKIi+2DdR6mnOitW+KI0/5zElHIYSQWX3LbUvM=;
  b=WqlySCR58+Ik4RoZ5NflWwH3svl8VVyB68zSVqfv9R76QiKQblmhpvOO
   uZdvWA0mE66YpHKCbA0SKU5V4K3OIay5tFXiwuJMKmYDBy7+LbDthR9Th
   CIx6M7MmhlgkuIYyR3pCgUaIF2vo4Jamc9uP8h3PXIXBD+otbIdTEYzjh
   I=;
X-IronPort-AV: E=Sophos;i="5.60,575,1549929600"; 
   d="scan'208";a="809514030"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 10 Jun 2019 11:19:54 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 8A3CCA22F3;
        Mon, 10 Jun 2019 11:19:54 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:41 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:41 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 10 Jun 2019 11:19:38 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 6/6] net: ena: update driver version from 2.0.3 to 2.1.0
Date:   Mon, 10 Jun 2019 14:19:18 +0300
Message-ID: <20190610111918.21397-7-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190610111918.21397-1-sameehj@amazon.com>
References: <20190610111918.21397-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Update driver version to match device specification.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index b9d590879..f2b6e2e05 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -44,8 +44,8 @@
 #include "ena_eth_com.h"
 
 #define DRV_MODULE_VER_MAJOR	2
-#define DRV_MODULE_VER_MINOR	0
-#define DRV_MODULE_VER_SUBMINOR 3
+#define DRV_MODULE_VER_MINOR	1
+#define DRV_MODULE_VER_SUBMINOR 0
 
 #define DRV_MODULE_NAME		"ena"
 #ifndef DRV_MODULE_VERSION
-- 
2.17.1

