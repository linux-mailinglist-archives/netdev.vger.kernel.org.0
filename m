Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9790737394
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfFFL4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:56:03 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:56420 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbfFFL4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559822161; x=1591358161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3WqT5C86Rb+8AGSkMvWBSRND5JwsBf24M0cQ0ilrRfc=;
  b=nlxobOCWINDjP7h67HwYn8BgLxJnhwx/cgmgCbl11Veh28sxyiz/VfZg
   3UTKCIbluQUnFmDWUyw7v4mPObA4fir87L10K6HQZ45RhSrSaSAqOmwRj
   6L+4PdV3UUrajtp8FHt8EjGMJuMdpBZ/7zd812v2j7cuRPG3M/oYSZHCg
   M=;
X-IronPort-AV: E=Sophos;i="5.60,559,1549929600"; 
   d="scan'208";a="803947851"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 06 Jun 2019 11:56:01 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 07792A1AC2;
        Thu,  6 Jun 2019 11:56:00 +0000 (UTC)
Received: from EX13d09UWC002.ant.amazon.com (10.43.162.102) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 11:55:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC002.ant.amazon.com (10.43.162.102) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 11:55:51 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 6 Jun 2019 11:55:48 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 6/6] net: ena: update driver version from 2.0.3 to 2.1.0
Date:   Thu, 6 Jun 2019 14:55:20 +0300
Message-ID: <20190606115520.20394-7-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606115520.20394-1-sameehj@amazon.com>
References: <20190606115520.20394-1-sameehj@amazon.com>
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
index 2da20ad5a..e83a5e041 100644
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

