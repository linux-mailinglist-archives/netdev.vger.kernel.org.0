Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6A64813BB
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbhL2OAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:00:41 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:61575 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhL2OAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:00:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1640786441; x=1672322441;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gaXwJSKbdaao28p2jSX4BMydVPN5NeRmd9+1JHnSww4=;
  b=eTmhMI5xl+Z+5wlvXmbMWDnogZNe25tENTuPBH9eovW5SBzInE5Q1Pwg
   bHCmIIGoLdrlCWeetvmZvKE1slhee5sPxeXrZ4hh6B5H+/I7X+J0n5gZD
   OsN7XD+Ly4Q93zg9OqkskznPhsoH3y2Xrhx+xBOQQRyrfDC7K/lBrY8Sm
   c=;
X-IronPort-AV: E=Sophos;i="5.88,245,1635206400"; 
   d="scan'208";a="51547247"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 29 Dec 2021 14:00:26 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com (Postfix) with ESMTPS id 0BA16815F0;
        Wed, 29 Dec 2021 14:00:24 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 29 Dec 2021 14:00:24 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 29 Dec 2021 14:00:24 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Wed, 29 Dec 2021 14:00:22 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V1 net 0/3] ENA driver bug fixes
Date:   Wed, 29 Dec 2021 14:00:18 +0000
Message-ID: <20211229140021.8053-1-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENA driver bug fixes

Arthur Kiyanovski (3):
  net: ena: Fix undefined state when tx request id is out of bounds
  net: ena: Fix wrong rx request id by resetting device
  net: ena: Fix error handling when calculating max IO queues number

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 49 ++++++++++++--------
 1 file changed, 29 insertions(+), 20 deletions(-)

-- 
2.32.0

