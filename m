Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783A92A65AF
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbgKDOAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:00:41 -0500
Received: from mga04.intel.com ([192.55.52.120]:11837 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgKDOAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:00:39 -0500
IronPort-SDR: XqUclAvqz/xMZOPzxW8SUID4ZZgA8zYYelrQzOyi9WsGpXeBFLA4TJB3aW1phH84wc3fdIEB8f
 MIJ7oGuV6MkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="166627059"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="166627059"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 06:00:37 -0800
IronPort-SDR: xlA1/JcpnIA/IBpPU9hgDGrOzym1OWu4qMHNXYGmi0KVaN24Vc9r35DrsuXev+wrjCE/YKFy4o
 UWixCZ6Tb4FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="396910286"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 04 Nov 2020 06:00:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 3D044A23; Wed,  4 Nov 2020 16:00:31 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 10/10] MAINTAINERS: Add Isaac as maintainer of Thunderbolt DMA traffic test driver
Date:   Wed,  4 Nov 2020 17:00:30 +0300
Message-Id: <20201104140030.6853-11-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
References: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Isaac Hazan <isaac.hazan@intel.com>

I will be maintaining the Thunderbolt DMA traffic test driver.

Signed-off-by: Isaac Hazan <isaac.hazan@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b516bb34a8d5..fcd84749defd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17371,6 +17371,12 @@ W:	http://thinkwiki.org/wiki/Ibm-acpi
 T:	git git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
 F:	drivers/platform/x86/thinkpad_acpi.c
 
+THUNDERBOLT DMA TRAFFIC TEST DRIVER
+M:	Isaac Hazan <isaac.hazan@intel.com>
+L:	linux-usb@vger.kernel.org
+S:	Maintained
+F:	drivers/thunderbolt/dma_test.c
+
 THUNDERBOLT DRIVER
 M:	Andreas Noever <andreas.noever@gmail.com>
 M:	Michael Jamet <michael.jamet@intel.com>
-- 
2.28.0

