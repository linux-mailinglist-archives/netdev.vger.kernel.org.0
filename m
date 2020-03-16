Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7BC186B2E
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbgCPMif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:38:35 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:7709 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731027AbgCPMif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 08:38:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584362315; x=1615898315;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=F2VZd3uGIxE6hDmCZjvbnCME+tF7b5YOlUzMprOlg6I=;
  b=L8sJ5N+zaTC5AaBD5G1V7x7KETw1SrxgQpYDX52pLJmLajnmWXo2O/VE
   e1MbibdegwZW2c+bm0/7AZQ/Kg8/q7rGZapzBvUzGQo/fpwEEX+/sz3XM
   N4x10xX4Ui4eTi89NBIqOO6jawP13eVWRPPazF+1+W+3OSBY4nYcMIqoR
   g=;
IronPort-SDR: sXKSZzRn5oN+RIY0Au8OLWABtYIoNbim0C8Vlw3rcHzzmO2l6WFZEYYprlZvNnGFC+cYGARPWP
 vneB62PDUZug==
X-IronPort-AV: E=Sophos;i="5.70,560,1574121600"; 
   d="scan'208";a="31410801"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 16 Mar 2020 12:38:33 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 97E14A2832;
        Mon, 16 Mar 2020 12:38:32 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Mar 2020 12:38:32 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 16 Mar 2020 12:38:31 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.27) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Mar 2020 12:38:27 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net 0/7] ENA driver bug fixes
Date:   Mon, 16 Mar 2020 14:38:17 +0200
Message-ID: <1584362304-274-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

ENA driver bug fixes

Arthur Kiyanovski (7):
  net: ena: fix incorrect setting of the number of msix vectors
  net: ena: avoid unnecessary admin command when RSS function set fails
  net: ena: fix inability to set RSS hash function without changing the
    key
  net: ena: remove code that does nothing
  net: ena: fix request of incorrect number of IRQ vectors
  net: ena: avoid memory access violation by validating req_id properly
  net: ena: fix continuous keep-alive resets

 drivers/net/ethernet/amazon/ena/ena_com.c     | 17 ++++++++----
 drivers/net/ethernet/amazon/ena/ena_com.h     | 21 ++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 15 +++++------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 27 +++++++++++++------
 4 files changed, 52 insertions(+), 28 deletions(-)

-- 
2.17.1

