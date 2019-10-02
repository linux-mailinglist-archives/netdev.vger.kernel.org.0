Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F290C4964
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfJBIWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:22:24 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:43214 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfJBIWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:22:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1570004543; x=1601540543;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=fpUFx92h4TkBz8v2tT0VFnqLFrMcCHcFFfF3oA07g+I=;
  b=FRO5Jog1w/VB7cTzDvEWcHvZ87r4c2T1vg/LVlJWheRNqHsL/II37Wu9
   kT9TutrUVrzsQOgefR+aQy1sSt40godvDGF1R9zqx2EDADxsEXiB2yZFF
   ecbpdPesoth75DAkPMLdSvxr1vUnOagXbKECYzzEz5kKulkxXt3kKXN3A
   o=;
X-IronPort-AV: E=Sophos;i="5.64,573,1559520000"; 
   d="scan'208";a="706092716"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 02 Oct 2019 08:21:39 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 09E79A1FA3;
        Wed,  2 Oct 2019 08:21:00 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 2 Oct 2019 08:21:00 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 2 Oct 2019 08:21:00 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 2 Oct 2019 08:20:57 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 0/5] Introduce ethtool's set_channels
Date:   Wed, 2 Oct 2019 11:20:47 +0300
Message-ID: <20191002082052.14051-1-sameehj@amazon.com>
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

