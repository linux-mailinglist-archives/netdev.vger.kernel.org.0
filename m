Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A57482A81
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 08:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbiABHht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 02:37:49 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:24941 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiABHht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 02:37:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641109069; x=1672645069;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cZrleBmedPTbXU8gu5ULcQ1ZLeSDxZvH0yYCGgqXbl8=;
  b=NllukcUJNWo1kLLeo+pdQ7tCzfJ7hhseXPsqeoph/GJzyt444v4hbvfz
   EHb+tNE/ijo47FQIJS6c9DmvPlv1+AGTpuU01N+SLe5rG34I5nyqg7VDZ
   3eeOqWb02DHt7uCUauEPGxyr0Ob5kDABmSQbyOiTGWINaGlj4RlVUuuW/
   8=;
X-IronPort-AV: E=Sophos;i="5.88,255,1635206400"; 
   d="scan'208";a="981706930"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-28e6dbd8.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 02 Jan 2022 07:37:34 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-28e6dbd8.us-east-1.amazon.com (Postfix) with ESMTPS id 6A68385CC4;
        Sun,  2 Jan 2022 07:37:33 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 2 Jan 2022 07:37:32 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 2 Jan 2022 07:37:32 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Sun, 2 Jan 2022 07:37:30 +0000
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
Subject: [PATCH V2 net 0/3] ENA driver bug fixes
Date:   Sun, 2 Jan 2022 07:37:25 +0000
Message-ID: <20220102073728.12242-1-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Patchset V2 chages:
-------------------
Updated SHA1 of Fixes tag in patch 3/3 to be 12 digits long


Original cover letter:
----------------------
ENA driver bug fixes

Arthur Kiyanovski (3):
  net: ena: Fix undefined state when tx request id is out of bounds
  net: ena: Fix wrong rx request id by resetting device
  net: ena: Fix error handling when calculating max IO queues number

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 49 ++++++++++++--------
 1 file changed, 29 insertions(+), 20 deletions(-)

-- 
2.32.0

