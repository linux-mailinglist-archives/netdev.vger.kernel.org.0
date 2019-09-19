Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9C8B7B6F
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732303AbfISOCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:02:34 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:32637 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732249AbfISOCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:02:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568901753; x=1600437753;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=fpUFx92h4TkBz8v2tT0VFnqLFrMcCHcFFfF3oA07g+I=;
  b=N4LIIQy1CaojhFKu5If6EdqbeShTlVhwkd+oFQ6vFlZ7LVbuFphyncNN
   aFRpk27pjDCXDMT84PqDfhPQY1KlIQVN+a3naOXD9B8S3zx8Sx8+166Gj
   M5BVev9M2smCGruFp9hvOKOR3IEwoUGDA/rVdHeEDoifde7pdf1894+qa
   k=;
X-IronPort-AV: E=Sophos;i="5.64,523,1559520000"; 
   d="scan'208";a="422033315"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Sep 2019 14:02:32 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 1EC1CA2DB7;
        Thu, 19 Sep 2019 14:02:31 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 14:02:31 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 14:02:31 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 19 Sep 2019 14:02:28 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 0/5] Introduce ethtool's set_channels
Date:   Thu, 19 Sep 2019 17:02:19 +0300
Message-ID: <20190919140224.9137-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Difference from v1:
* Dropped the print from patch 0002 - "net: ena: multiple queue creation
  related cleanups" as requested by David Miller

Sameeh Jubran (5):
  net: ena: change num_queues to num_io_queues for clarity and
    consistency
  net: ena: multiple queue creation related cleanups
  net: ena: make ethtool -l show correct max number of queues
  net: ena: remove redundant print of number of queues
  net: ena: ethtool: support set_channels callback

 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  37 ++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 160 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  14 +-
 3 files changed, 121 insertions(+), 90 deletions(-)

-- 
2.17.1

