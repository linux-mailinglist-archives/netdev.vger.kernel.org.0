Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4137DEDF67
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 12:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfKDL66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 06:58:58 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:13300 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfKDL65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 06:58:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1572868737; x=1604404737;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=LRzZShdaKro0PsBu5LloyO1mGBnFA/TkuAFcka5Z30Q=;
  b=VlUWYCu1T1RVWQO2vlvT9TXBon30t6HVfZP49UgjjX4lao4f05vX7cLt
   cO3MQMcMCrIg9f07qckTq3+s51lyNBSrw8XjnMe5r6KeKbtL+NcHf5ChI
   lRjvhv4QpFYGsX8OZvrYflFLoPN/3fjJVQlqGo3UT9JyZR5A2L7hXPqB/
   4=;
IronPort-SDR: ebaJ1BzVeZjTyCbcwuIoi2VixZMKj6/o0iMQVmxcJ/Iz9ZVioQ9MbGjSzmIzOHChqeKvq9jP3V
 4wR+s1ljB3RQ==
X-IronPort-AV: E=Sophos;i="5.68,267,1569283200"; 
   d="scan'208";a="2508991"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 04 Nov 2019 11:58:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 22937A1BC2;
        Mon,  4 Nov 2019 11:58:55 +0000 (UTC)
Received: from EX13d09UWC003.ant.amazon.com (10.43.162.113) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 4 Nov 2019 11:58:54 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC003.ant.amazon.com (10.43.162.113) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 4 Nov 2019 11:58:54 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.87) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 4 Nov 2019 11:58:50 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>
Subject: [PATCH V1 net 0/2] fixes of interrupt moderation bugs 
Date:   Mon, 4 Nov 2019 13:58:46 +0200
Message-ID: <1572868728-5211-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This patchset includes a couple of fixes of bugs in the implemenation of
interrupt moderation.

Arthur Kiyanovski (2):
  net: ena: fix issues in setting interrupt moderation params in ethtool
  net: ena: fix too long default tx interrupt moderation interval

 drivers/net/ethernet/amazon/ena/ena_com.h     |  2 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 40 ++++++++-----------
 2 files changed, 17 insertions(+), 25 deletions(-)

-- 
2.17.1

