Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4067E1265EA
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfLSPlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:41:06 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8139 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfLSPlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:41:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576770066; x=1608306066;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=bYnc/yn4cTmy2J9chcnhz5Hs78jz0tnCUpaz4vahLO8=;
  b=KWgbD2Ncp/ah2Uzxri1zT9DEmcokgME6LQ76iMUe1MAMtrYdRLmd30Ml
   MCmpfx7PLOQ5kHePUhffoxw2oDcMOrQas6Ixv11M6pX5c+38JpUr6/bvE
   4Wa4tNGMmRxLb3BXFbKgEGek405cX19iF44gsuXqYJtiPdsZSU1020TJH
   0=;
IronPort-SDR: elAaUYB66Fs30qfr57NmtYr3ypIoetIcxYmDoMJLexNcN0kJCduveQTRyLGDUeqOvuZrW42Ql7
 xDNn1N71q5DQ==
X-IronPort-AV: E=Sophos;i="5.69,332,1571702400"; 
   d="scan'208";a="8356950"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Dec 2019 15:41:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id BAB63A273E;
        Thu, 19 Dec 2019 15:41:03 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Dec 2019 15:41:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB004.ant.amazon.com (10.43.161.121) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Dec 2019 15:41:02 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.74) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 19 Dec 2019 15:40:58 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net 0/2] fixes of interrupt moderation bugs
Date:   Thu, 19 Dec 2019 17:40:54 +0200
Message-ID: <1576770056-1304-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>


Differences from V1:
1. Updated default tx interrupt moderation to 64us
2. Added "Fixes:" tags.
3. Removed cosmetic changes that are not relevant for these bug fixes

This patchset includes a couple of fixes of bugs in the implemenation of
interrupt moderation.

Arthur Kiyanovski (2):
  net: ena: fix default tx interrupt moderation interval
  net: ena: fix issues in setting interrupt moderation params in ethtool

 drivers/net/ethernet/amazon/ena/ena_com.h     |  2 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 24 ++++++++++--------------
 2 files changed, 11 insertions(+), 15 deletions(-)

-- 
2.7.4

