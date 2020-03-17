Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F21187A29
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgCQHHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:07:03 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:11267 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgCQHHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:07:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584428823; x=1615964823;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=gS2zqY/Lj6zwHpA1NH+Lb5NR3XXV5iWcb5Fauuu1IWU=;
  b=EG2iF+sIs6Q/lv4aJt1bP+HL1wTzlf1k5O86P0RAxgPf/QGOxtL91Xb6
   6oQUgfii42pjfzt22OozhhjU7Vl1b/ekm10D/OYju6ANP9PAydh3Lbp2b
   fP9eRRJiaeZR2NEEuMXypIz+x59bHaekhpjGMbMA1Zwu6FAt/n62Oeu+n
   M=;
IronPort-SDR: iNZVnKBBGfH++dU83YeHwsMe1s4DYV6WKDJqawH+Pz7phcxbsNUzm85MFoUAPCTORCvZkuojzi
 VjpFIFmTYerQ==
X-IronPort-AV: E=Sophos;i="5.70,563,1574121600"; 
   d="scan'208";a="21349774"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 17 Mar 2020 07:06:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 2C7DAA18EB;
        Tue, 17 Mar 2020 07:06:49 +0000 (UTC)
Received: from EX13D21UWA004.ant.amazon.com (10.43.160.252) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Mar 2020 07:06:49 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA004.ant.amazon.com (10.43.160.252) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Mar 2020 07:06:48 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.76.85) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 17 Mar 2020 07:06:44 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net 0/4] ENA driver bug fixes
Date:   Tue, 17 Mar 2020 09:06:38 +0200
Message-ID: <1584428802-440-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

ENA driver bug fixes

Arthur Kiyanovski (4):
  net: ena: fix incorrect setting of the number of msix vectors
  net: ena: fix request of incorrect number of IRQ vectors
  net: ena: avoid memory access violation by validating req_id properly
  net: ena: fix continuous keep-alive resets

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 27 ++++++++++++++------
 1 file changed, 19 insertions(+), 8 deletions(-)

-- 
2.17.1

