Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D372E4FA94
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 09:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFWHHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 03:07:01 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:30489 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFWHHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 03:07:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561273620; x=1592809620;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=vww9uXm+mdnR04m40kCiwVhWIZvu0oaBozg7Hi3tPug=;
  b=mIMfARHuqLjqFI0S8iJ29byCt4r+iuAKaZ8Kv1sqgiGpqWpFEgRRBRpn
   wvMD6RuYaTia0GztzbNNbbUYWBBZo1uT76IyrNxzTWqMCqHglKarSAONY
   1pbJ2fpTInyEWsVUVOabTQ2Lj9MPzIbhFrflUTkjPtFrrfXqY/x+0oyGB
   A=;
X-IronPort-AV: E=Sophos;i="5.62,407,1554768000"; 
   d="scan'208";a="407645070"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 23 Jun 2019 07:06:59 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 4C81FA1D32;
        Sun, 23 Jun 2019 07:06:58 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 23 Jun 2019 07:06:58 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 23 Jun 2019 07:06:58 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 23 Jun 2019 07:06:55 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [RFC V1 net-next 0/1] Introduce xdp to ena
Date:   Sun, 23 Jun 2019 10:06:48 +0300
Message-ID: <20190623070649.18447-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patch set has one patch which implements xdp drop support in the
ena driver.

Sameeh Jubran (1):
  net: ena: implement XDP drop support

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 83 +++++++++++++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 29 +++++++
 2 files changed, 111 insertions(+), 1 deletion(-)

-- 
2.17.1

