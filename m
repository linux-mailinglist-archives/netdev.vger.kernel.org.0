Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 845D1B30B0
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731856AbfIOP1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 11:27:54 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:64319 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731547AbfIOP1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 11:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568561273; x=1600097273;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=TFgYf5eeUltLTT//HydivqRNXlV9tmdNrO+wCXCqwCY=;
  b=I1cpUdj89lXgQ/so/b67n253aqrI1JVmxKw1TAR89+YJVJHLlZI7Zum6
   mrjv08ozdnYLr4ohbC6FFM3KouLOWf8eO+bpv90LViWrPbHAzaoXjsY8O
   o4rrV2RrXSkkk2X/MnN6lsVHglPMhnK/g+mY/T0U5mmyMmHx2I7AUI1MP
   k=;
X-IronPort-AV: E=Sophos;i="5.64,509,1559520000"; 
   d="scan'208";a="702489166"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 15 Sep 2019 15:27:38 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 4AC20A0730;
        Sun, 15 Sep 2019 15:27:30 +0000 (UTC)
Received: from EX13d09UWC002.ant.amazon.com (10.43.162.102) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 15 Sep 2019 15:27:30 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC002.ant.amazon.com (10.43.162.102) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 15 Sep 2019 15:27:30 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 15 Sep 2019 15:27:26 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 0/5] Introduce ethtool's set_channels
Date:   Sun, 15 Sep 2019 18:27:17 +0300
Message-ID: <20190915152722.8240-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patch series introduces the support of "ethtool --set-channels/-L"
command to the ena driver.

This series is also a preparation for the upcoming xdp support in the ena
driver.

This patch series has been rebased over the series:
"net: ena: implement adaptive interrupt moderation using dim"

Sameeh Jubran (5):
  net: ena: change num_queues to num_io_queues for clarity and
    consistency
  net: ena: multiple queue creation related cleanups
  make ethtool -l show correct max number of queues
  net: ena:remove redundant print of number of queues and placement
    policy
  net: ena: ethtool: support set_channels callback

 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  37 +++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 173 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  14 +-
 3 files changed, 128 insertions(+), 96 deletions(-)

-- 
2.17.1

