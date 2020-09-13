Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260A8267E87
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 10:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgIMIR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 04:17:29 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:32898 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgIMIR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 04:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599985048; x=1631521048;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ft8jnmbKCKWKbkUjH9FqL0xelGQpRwbS5xyf7vUbzJg=;
  b=G3tw6FgdIkqK5bdjzzcKa3lHbS2sHETic0RU+/BfWEm0Ay4h8F6IbJLU
   RlE0o91VciUwjsHlWRQuziSxXkF3l/jDVA0DQGJU6HNc7j1otDFxmzxA4
   1n2FD8yd9hyu41wMZpMiILPCiZY8Ea/nXGvx6Pxf0teHt2Zbdqz6xCg03
   8=;
X-IronPort-AV: E=Sophos;i="5.76,421,1592870400"; 
   d="scan'208";a="53406805"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 13 Sep 2020 08:17:27 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 3EBA5120D8E;
        Sun, 13 Sep 2020 08:17:25 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.145) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 13 Sep 2020 08:17:16 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V1 net-next 0/8] Update license and polish ENA driver code
Date:   Sun, 13 Sep 2020 11:16:32 +0300
Message-ID: <20200913081640.19560-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D23UWC001.ant.amazon.com (10.43.162.196) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
This series adds the following:
- Change driver's license into SPDX format
- Make log messages in the driver have a uniform format
- Fix issues raised by static checkers
- Improve code readability by adding functions, fix spelling
  mistakes etc.
- Update driver's documentation

Shay Agroskin (8):
  net: ena: Change license into format to SPDX in all files
  net: ena: Add device distinct log prefix to files
  net: ena: Change log message to netif/dev function
  net: ena: Capitalize all log strings and improve code readability
  net: ena: Remove redundant print of placement policy
  net: ena: Change RSS related macros and variables names
  net: ena: Fix all static chekers' warnings
  net: ena: update ena documentation

 .../device_drivers/ethernet/amazon/ena.rst    |  25 +-
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  91 ++-
 drivers/net/ethernet/amazon/ena/ena_com.c     | 524 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_com.h     |  53 +-
 .../net/ethernet/amazon/ena/ena_common_defs.h |  31 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 163 +++---
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  54 +-
 .../net/ethernet/amazon/ena/ena_eth_io_defs.h |  31 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  33 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 139 ++---
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  31 +-
 .../net/ethernet/amazon/ena/ena_pci_id_tbl.h  |  31 +-
 .../net/ethernet/amazon/ena/ena_regs_defs.h   |  31 +-
 13 files changed, 526 insertions(+), 711 deletions(-)

-- 
2.17.1

