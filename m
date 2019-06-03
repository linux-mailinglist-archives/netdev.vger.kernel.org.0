Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F863327E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbfFCOoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:44:09 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:40857 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729350AbfFCOoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:44:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559573048; x=1591109048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=MoDjcMw7DaMtnqFXZabS72ZSdjtTffjEvahPd/9TvvQ=;
  b=mKWglVSfP2mSuPUaMOp/tAIMEK8nSuF7QxJxfjNJKfYXG03LZvcclE/9
   jkSo86dB7I7hMY0R4KLFq5SqNPXm41AdbKY9ITB5db4YoV7AaSRuEE1HA
   plMwQkMsmHcAhLRQfkiTuF8RTPpDWPplkRmnT36tV7o8LNuV+yiK0IRFW
   Y=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="735848845"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 03 Jun 2019 14:44:07 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 6C5EAA231E;
        Mon,  3 Jun 2019 14:44:07 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:54 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:54 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 14:43:51 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net 06/11] net: ena: documentation: update ena.txt
Date:   Mon, 3 Jun 2019 17:43:24 +0300
Message-ID: <20190603144329.16366-7-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603144329.16366-1-sameehj@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
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

