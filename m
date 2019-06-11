Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451FE3CA9C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404420AbfFKL7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:59:01 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:48928 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403877AbfFKL7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560254340; x=1591790340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8g2h/TKIi+2DdR6mnOitW+KI0/5zElHIYSQWX3LbUvM=;
  b=rEk66d25u1lA27x5w4pWYD8SWgXKjGw56EJ3d/1wqtHo2Y+sB4TYAbaL
   cyeBEwAxJKsMiwbyFrsTNl25MT5Wob0wWRAMqmaoHL3CsVtXmfYNarTfT
   yFoGxHcoXuR4zQYPjy8KHfBnIWt4U+xGR6Wgc2JHQUUCzeTvheJbrhpmO
   8=;
X-IronPort-AV: E=Sophos;i="5.60,579,1549929600"; 
   d="scan'208";a="804742893"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 11 Jun 2019 11:59:00 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 9FA5CA243E;
        Tue, 11 Jun 2019 11:58:59 +0000 (UTC)
Received: from EX13d09UWC003.ant.amazon.com (10.43.162.113) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Jun 2019 11:58:46 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC003.ant.amazon.com (10.43.162.113) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Jun 2019 11:58:45 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Jun 2019 11:58:42 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net 7/7] net: ena: update driver version from 2.0.3 to 2.1.0
Date:   Tue, 11 Jun 2019 14:58:11 +0300
Message-ID: <20190611115811.2819-8-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611115811.2819-1-sameehj@amazon.com>
References: <20190611115811.2819-1-sameehj@amazon.com>
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

