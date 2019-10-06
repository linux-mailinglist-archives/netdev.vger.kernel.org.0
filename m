Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08596CD1E5
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 14:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfJFMdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 08:33:37 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:44200 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfJFMdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 08:33:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1570365216; x=1601901216;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=NHbAhq+9CwD3eHzdnXwZ0M70WBe1pHHxL5Y/3wERUfQ=;
  b=a7YIu3TAlGabROPT1s3SAxS5DBXKoPpiwcQ7AQ9OisCpyrpRMAVt83fM
   0U82lGk/cNW1SgipKM4GuFSVKdY+d4k9AuWRLGHyu6CZ8J/BAoXWSWh0X
   vO5LJ0/eqqIV9uv7IxU1Du80GTuWUuCob4GoqiR60a67zHfmn4dinIkMg
   I=;
X-IronPort-AV: E=Sophos;i="5.67,263,1566864000"; 
   d="scan'208";a="420198288"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 06 Oct 2019 12:33:34 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id DB2CEA1EB2;
        Sun,  6 Oct 2019 12:33:33 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 6 Oct 2019 12:33:33 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 6 Oct 2019 12:33:32 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 6 Oct 2019 12:33:30 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net-next 0/6] 
Date:   Sun, 6 Oct 2019 15:33:22 +0300
Message-ID: <20191006123328.24210-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>


Difference from v2:
* ethtool's set/get channels: Switched to using combined instead of
  separate rx/tx
* Fixed error handling in set_channels
* Fixed indentation and cosmetic issues as requested by Jakub Kicinski

Difference from v1:
* Dropped the print from patch 0002 - "net: ena: multiple queue creation
  related cleanups" as requested by David Miller

Sameeh Jubran (6):
  net: ena: change num_queues to num_io_queues for clarity and
    consistency
  net: ena: multiple queue creation related cleanups
  net: ena: ethtool: get_channels: use combined only
  net: ena: make ethtool -l show correct max number of queues
  net: ena: remove redundant print of number of queues
  net: ena: ethtool: support set_channels callback

 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  35 ++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 158 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  14 +-
 3 files changed, 114 insertions(+), 93 deletions(-)

-- 
2.17.1

