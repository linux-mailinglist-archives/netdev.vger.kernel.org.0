Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC62F271E1A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgIUIiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:38:24 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:64381 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIUIiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 04:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600677504; x=1632213504;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/Zndkhk6pVrRy0JJoFBBU/EsmaTEi2Xq+xtPEWJBD+A=;
  b=CZ9UaI67AZNxkhpVXne4JxniNFb4mSgHFPyRr62mHQO8wPbkUJ/a7j6x
   S73b3fExJoYlJ4C8bvyG/3kHleHVPYUnl7lGJqC/Bar7V17SW78344dx4
   TOqZSD0JdpMWh9gk190CNkkvpE3pBTC5aLMklKCg25WEO+z2dCsp+INUD
   g=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="77823183"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 Sep 2020 08:38:19 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id F270FA17CF;
        Mon, 21 Sep 2020 08:38:16 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.229) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 08:38:07 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V2 net-next 0/7] Update license and polish ENA driver code
Date:   Mon, 21 Sep 2020 11:37:35 +0300
Message-ID: <20200921083742.6454-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D23UWA003.ant.amazon.com (10.43.160.194) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
This series adds the following:
- Change driver's license into SPDX format
- Capitalize all log prints in ENA driver
- Fix issues raised by static checkers
- Improve code readability by adding functions, fix spelling
  mistakes etc.
- Update driver's documentation

Changed from previous version:
v1->v2: dropped patch that transforms pr_* log prints into dev_* prints

Shay Agroskin (7):
  net: ena: Change license into format to SPDX in all files
  net: ena: Change log message to netif/dev function
  net: ena: Capitalize all log strings and improve code readability
  net: ena: Remove redundant print of placement policy
  net: ena: Change RSS related macros and variables names
  net: ena: Fix all static chekers' warnings
  net: ena: update ena documentation

 .../device_drivers/ethernet/amazon/ena.rst    |  25 +-
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  91 +++----
 drivers/net/ethernet/amazon/ena/ena_com.c     | 226 +++++++++---------
 drivers/net/ethernet/amazon/ena/ena_com.h     |  33 +--
 .../net/ethernet/amazon/ena/ena_common_defs.h |  31 +--
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  84 +++----
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  37 +--
 .../net/ethernet/amazon/ena/ena_eth_io_defs.h |  31 +--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  33 +--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 139 +++++------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  31 +--
 .../net/ethernet/amazon/ena/ena_pci_id_tbl.h  |  31 +--
 .../net/ethernet/amazon/ena/ena_regs_defs.h   |  31 +--
 13 files changed, 254 insertions(+), 569 deletions(-)

-- 
2.17.1

