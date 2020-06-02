Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487E01EBCFE
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgFBNV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:21:56 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:10782 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgFBNV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591104116; x=1622640116;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0+EncCedI+ysiySHa/vqZPwQlMqgDah4VghMmjyu9DY=;
  b=WKQSWrr8RUaMeAwdISFUDtOJDOUT5SfgHg51LUh1+HOvPn24DIJqBPcB
   vc31ltn2zeeg//ME+uuudO1hU2Q4RvrJSeAbG1ty2lV9xTWwqY2LNmgJj
   hJx76rAVfBc9Iql3oDbhIUm78GpzLfB54rj4KW0j/9dNx5sDr5b9W+B+n
   w=;
IronPort-SDR: Bb5r8jfLfd+gzUemUZfBk+xMroD60NKdomxl43h2/9IKzbLRkWnlMFJIdpikay3SELHkW1eI9U
 6nkmm6k3o5Wg==
X-IronPort-AV: E=Sophos;i="5.73,464,1583193600"; 
   d="scan'208";a="40915313"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 02 Jun 2020 13:21:54 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 16129A0637;
        Tue,  2 Jun 2020 13:21:54 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Jun 2020 13:21:53 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Jun 2020 13:21:53 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 2 Jun 2020 13:21:53 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 1CCC381C99; Tue,  2 Jun 2020 13:21:53 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 0/2] Fix xdp in ena driver
Date:   Tue, 2 Jun 2020 13:21:49 +0000
Message-ID: <20200602132151.366-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patchset includes 2 XDP related bug fixes.

Sameeh Jubran (2):
  net: ena: xdp: XDP_TX: fix memory leak
  net: ena: xdp: update napi budget for DROP and ABORTED

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.24.1.AMZN

