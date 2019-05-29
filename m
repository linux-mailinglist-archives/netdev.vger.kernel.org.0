Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E4D2D976
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfE2JvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:51:01 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:48730 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfE2JvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123460; x=1590659460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=MoDjcMw7DaMtnqFXZabS72ZSdjtTffjEvahPd/9TvvQ=;
  b=mgA6xfuZoCeZfTZApho08+aks2s6k3ZkpB4b7fAYZ+fEDFLNtqNCdeZ2
   NyhlX2IsYYZ8Ol5tliH1Tf6uc2/3i2PenJN1b85JFP6DTExgmXgLgnvOH
   XJyOaM5/hsn0NMT58+aVapIV2SZE9qmPJbC5Bk4XH6ZraNkrIY7OetFd6
   M=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="768083193"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 29 May 2019 09:51:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 446E6A1E3B;
        Wed, 29 May 2019 09:50:59 +0000 (UTC)
Received: from EX13D02UWB001.ant.amazon.com (10.43.161.240) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB001.ant.amazon.com (10.43.161.240) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:37 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:34 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 06/11] net: ena: documentation: update ena.txt
Date:   Wed, 29 May 2019 12:49:59 +0300
Message-ID: <20190529095004.13341-7-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529095004.13341-1-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Small cosmetic changes to ena.txt

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 Documentation/networking/device_drivers/amazon/ena.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/amazon/ena.txt b/Documentation/networking/device_drivers/amazon/ena.txt
index 2b4b6f57e..1bb55c7b6 100644
--- a/Documentation/networking/device_drivers/amazon/ena.txt
+++ b/Documentation/networking/device_drivers/amazon/ena.txt
@@ -73,7 +73,7 @@ operation.
 AQ is used for submitting management commands, and the
 results/responses are reported asynchronously through ACQ.
 
-ENA introduces a very small set of management commands with room for
+ENA introduces a small set of management commands with room for
 vendor-specific extensions. Most of the management operations are
 framed in a generic Get/Set feature command.
 
@@ -202,11 +202,14 @@ delay value to each level.
 The user can enable/disable adaptive moderation, modify the interrupt
 delay table and restore its default values through sysfs.
 
+RX copybreak:
+=============
 The rx_copybreak is initialized by default to ENA_DEFAULT_RX_COPYBREAK
 and can be configured by the ETHTOOL_STUNABLE command of the
 SIOCETHTOOL ioctl.
 
 SKB:
+====
 The driver-allocated SKB for frames received from Rx handling using
 NAPI context. The allocation method depends on the size of the packet.
 If the frame length is larger than rx_copybreak, napi_get_frags()
-- 
2.17.1

