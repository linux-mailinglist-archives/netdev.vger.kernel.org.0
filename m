Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0251512C30B
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 16:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfL2PFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 10:05:39 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:55780 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfL2PFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 10:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1577631938; x=1609167938;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=0rtl6ep2RPr1saDQtLsZMU7/FksJX8TDRwiOCWM4dzk=;
  b=J+z9G3l7XVq+GyWLFQm8A90Jei5a36m0dw+H07Qtm2LW5n8PqZJLufZp
   qh/MMzyWLRzUqqItQooJKT0IyaYHTzG+q+L6Y4vxPb09c/8J2MbA0kBA0
   99Apdgv97djPkhuyRy6HIXagt2zNh2IS5cC6gtFcnsQfDcUnb5Mc9UDBW
   s=;
IronPort-SDR: iUmO/9ifaPcYiqGFrslTbmiE1noskE+K74z4ApcOcvz+GBv9CsIuJAtLtNwqGS24u6myuX0bu7
 loFudMVh1i7w==
X-IronPort-AV: E=Sophos;i="5.69,371,1571702400"; 
   d="scan'208";a="10273888"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 29 Dec 2019 15:05:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 54A6CA185C;
        Sun, 29 Dec 2019 15:05:36 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 29 Dec 2019 15:05:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB004.ant.amazon.com (10.43.161.121) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 29 Dec 2019 15:05:35 +0000
Received: from dev-dsk-netanel-2a-7f44fd35.us-west-2.amazon.com (172.19.37.7)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 29 Dec 2019 15:05:35 +0000
Received: by dev-dsk-netanel-2a-7f44fd35.us-west-2.amazon.com (Postfix, from userid 3129586)
        id 9BB66104; Sun, 29 Dec 2019 15:05:35 +0000 (UTC)
From:   Netanel Belgazal <netanel@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Netanel Belgazal <netanel@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>
Subject: [PATCH V1 net] MAINTAINERS: Add additional maintainers to ENA Ethernet driver
Date:   Sun, 29 Dec 2019 15:05:18 +0000
Message-ID: <20191229150518.28771-1-netanel@amazon.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Netanel Belgazal <netanel@amazon.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a049abccaa26..bc3736ade88b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -771,6 +771,8 @@ F:	drivers/thermal/thermal_mmio.c
 
 AMAZON ETHERNET DRIVERS
 M:	Netanel Belgazal <netanel@amazon.com>
+M:	Arthur Kiyanovski <akiyano@amazon.com>
+R:	Guy Tzalik <gtzalik@amazon.com>
 R:	Saeed Bishara <saeedb@amazon.com>
 R:	Zorik Machulsky <zorik@amazon.com>
 L:	netdev@vger.kernel.org
-- 
2.17.2

