Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4458E1ECBE0
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgFCIum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 04:50:42 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:4693 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgFCIul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 04:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591174241; x=1622710241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=D1/fKfTMDsn8GPm+5gyGyQv195JKuM7BSlt8UBNJv7E=;
  b=AI9NcYb0wqFYdcuJUoPAaQs/35dYCVy0RU+3OvORvehQVdyhYoWvePMh
   8voBSa7vwlfXrtkig7WCEBX2gZp927EKiDl185NvY3pCzJiHMoDE3b0jM
   60VDKawQ4vS1AqXkR4kMoisOz79eosiACD4cYr47PZUC4nk3oPniV5Wfx
   4=;
IronPort-SDR: PIpuHBOcnqC+ciq2u8eIuHVXzWnPMl7YnZg+NuIDZn8u0qQzqlxZGRU5v0o0nqNXTHUG2Emcdq
 XiyTcHZ/KDzQ==
X-IronPort-AV: E=Sophos;i="5.73,467,1583193600"; 
   d="scan'208";a="34162858"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 03 Jun 2020 08:50:28 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 15A7FA25D3;
        Wed,  3 Jun 2020 08:50:27 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 3 Jun 2020 08:50:26 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 3 Jun 2020 08:50:26 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 3 Jun 2020 08:50:25 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 1A7B5816BB; Wed,  3 Jun 2020 08:50:26 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 0/2] Fix xdp in ena driver
Date:   Wed, 3 Jun 2020 08:50:21 +0000
Message-ID: <20200603085023.24221-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patchset includes 2 XDP related bug fixes

Difference from v1:
* Fixed "Fixes" tag

Sameeh Jubran (2):
  net: ena: xdp: XDP_TX: fix memory leak
  net: ena: xdp: update napi budget for DROP and ABORTED

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.24.1.AMZN

