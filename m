Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F44ABF6FD
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfIZQpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:45:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:46252 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727602AbfIZQpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 12:45:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 09:45:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="219465178"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2019 09:45:38 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
Date:   Thu, 26 Sep 2019 09:45:19 -0700
Message-Id: <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Mark i40iw as deprecated/obsolete.

irdma is the replacement driver that supports X722.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/i40iw/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/i40iw/Kconfig
index e4b45f4cd8f8..208e7525fb55 100644
--- a/drivers/infiniband/hw/i40iw/Kconfig
+++ b/drivers/infiniband/hw/i40iw/Kconfig
@@ -1,9 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config INFINIBAND_I40IW
-	tristate "Intel(R) Ethernet X722 iWARP Driver"
+	tristate "Intel(R) Ethernet X722 iWARP Driver (DEPRECATED)"
 	depends on INET && I40E
 	depends on IPV6 || !IPV6
 	depends on PCI
+	depends on !(INFINBAND_IRDMA=y || INFINIBAND_IRDMA=m) || COMPILE_TEST
 	select GENERIC_ALLOCATOR
 	---help---
 	Intel(R) Ethernet X722 iWARP Driver
+	This driver is being replaced by irdma.
-- 
2.21.0

