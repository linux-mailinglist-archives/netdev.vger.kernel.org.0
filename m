Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D2F128D4C
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 10:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfLVJsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 04:48:13 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11136 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfLVJsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 04:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1577008092; x=1608544092;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=0rtl6ep2RPr1saDQtLsZMU7/FksJX8TDRwiOCWM4dzk=;
  b=VLgOfC5b0vo4WOt6TM6YlKaXVIGAu6ysg3wRYiDFWEK+MkyWEQfuJUhO
   rtLhbGx52Yxwra4E9bzFqdJko7t1e6f9V4pDqKEg3XkR2g14Nwpd9AY6B
   BGv4VEqmDBViBiC8rSWf5TFo3VLMzaglB7GJ+/kDToevuO1jes8imc3mq
   Y=;
IronPort-SDR: 04t+aq1hvUZAH+Jc9vlGE2zjdMJmzgzAZwEr1iv+3mGFTYHl/UXs2ATZ9ldXmwlt9UDgOC63A/
 zy24bTlLMwhQ==
X-IronPort-AV: E=Sophos;i="5.69,343,1571702400"; 
   d="scan'208";a="10187511"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 Dec 2019 09:48:11 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id E0550A1DF1;
        Sun, 22 Dec 2019 09:48:09 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 22 Dec 2019 09:48:08 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 22 Dec 2019 09:48:07 +0000
Received: from dev-dsk-netanel-2a-7f44fd35.us-west-2.amazon.com (172.19.37.7)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 22 Dec 2019 09:48:07 +0000
Received: by dev-dsk-netanel-2a-7f44fd35.us-west-2.amazon.com (Postfix, from userid 3129586)
        id 8833BA7; Sun, 22 Dec 2019 09:48:07 +0000 (UTC)
From:   Netanel Belgazal <netanel@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Netanel Belgazal <netanel@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>
Subject: [PATCH V1 net-next] MAINTAINERS: Add additional maintainers to ENA Ethernet driver
Date:   Sun, 22 Dec 2019 09:47:59 +0000
Message-ID: <20191222094759.17542-1-netanel@amazon.com>
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

