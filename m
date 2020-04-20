Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EDA1B0F99
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgDTPMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:12:02 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:3807 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbgDTPL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587395517; x=1618931517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=xoMFGgH5DELLbtoeobiA873J6IsfnJEOZCpVd+LRec0=;
  b=yJCzIVIJ0iaaRXr9NF+wjn/48ndoGk74JT+oPtw7R4f8nNY+oCZiCA2c
   iijINzVM/QxmirgoiD5Hz9E80n2KODLAZ2hOEIq5bPvmmCVxR9gqxBSZx
   TgADaLnGclK5VjHIVXFYqOnhPgNGP8mdhhcLAOw+gV+VJD9qu3CTTMeB4
   lGd3KYsPeDAxqrVOVjdMb35SjkwMhhH2QrKDn7uOrx+Sb8Uhn8s3rSZ5m
   0ndjuraLWZpS98DROnOZKmdRLYOABSP/cL/Agy7JfQcQxajudP6crudCE
   8CvmNC80FHzaWkzGJzKlaENkP0g83PWs1pdkPSfHzVLp7Xzhyq+odJwlz
   g==;
IronPort-SDR: f9c6UtfmsTQvwhLTF2AOtrCsYp8sFoitjbbIc31etdZvkz+Vrk0k41Fp7w/nP9+ETCQ3yKr4Yl
 RufnuOBX1Ng47KYQdfpFTd67PtvMBygOV2/nXiwQSfIHHVGrHjAhPXov4a+sh4NxBghDsUcYIS
 gSNjV14J6JB23vc6dwvCcYR/x987VxhZpi+qUfhVVqZFojmLdw5VKeqAKByocGGyazyvmCZU/j
 DqbKHL2ZbGB1dZt+xkwnyEyoJQYmfTM62YSULZDklM0NPiNVDvVwDkSHorKbSCfZQmJKjt9xb4
 8DA=
X-IronPort-AV: E=Sophos;i="5.72,406,1580799600"; 
   d="scan'208";a="73911539"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2020 08:11:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Apr 2020 08:11:55 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 20 Apr 2020 08:11:18 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 03/13] bridge: mrp: Update Kconfig
Date:   Mon, 20 Apr 2020 17:09:37 +0200
Message-ID: <20200420150947.30974-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420150947.30974-1-horatiu.vultur@microchip.com>
References: <20200420150947.30974-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the option BRIDGE_MRP to allow to build in or not MRP support.
The default value is N.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/Kconfig | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index e4fb050e2078..51a6414145d2 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -61,3 +61,15 @@ config BRIDGE_VLAN_FILTERING
 	  Say N to exclude this support and reduce the binary size.
 
 	  If unsure, say Y.
+
+config BRIDGE_MRP
+	bool "MRP protocol"
+	depends on BRIDGE
+	default n
+	help
+	  If you say Y here, then the Ethernet bridge will be able to run MRP
+	  protocol to detect loops
+
+	  Say N to exclude this support and reduce the binary size.
+
+	  If unsure, say N.
-- 
2.17.1

