Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869325F13D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 04:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfGDCMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 22:12:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:32356 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727363AbfGDCMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 22:12:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 19:12:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="scan'208";a="169319127"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 03 Jul 2019 19:12:26 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     dledford@redhat.com, jgg@mellanox.com, davem@davemloft.net
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, poswald@suse.com,
        david.m.ertman@intel.com, Mustafa Ismail <mustafa.ismail@intel.com>
Subject: [rdma 15/16] RDMA/irdma: Update MAINTAINERS file
Date:   Wed,  3 Jul 2019 19:12:58 -0700
Message-Id: <20190704021259.15489-17-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Add maintainer entry for irdma driver.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 MAINTAINERS | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ac03f3e3bd5..b552bf583c97 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8093,7 +8093,15 @@ L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	drivers/cpufreq/intel_pstate.c
 
-INTEL RDMA RNIC DRIVER
+INTEL ETHERNET RDMA DRIVER
+M:	Mustafa Ismail <mustafa.ismail@intel.com>
+M:	Shiraz Saleem <shiraz.saleem@intel.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/irdma/
+F:	include/uapi/rdma/irdma-abi.h
+
+INTEL X722 RDMA RNIC DRIVER
 M:	Faisal Latif <faisal.latif@intel.com>
 M:	Shiraz Saleem <shiraz.saleem@intel.com>
 L:	linux-rdma@vger.kernel.org
-- 
2.21.0

