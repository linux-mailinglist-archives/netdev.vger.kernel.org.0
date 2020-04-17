Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B561AE37B
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgDQRNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:13:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:30119 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbgDQRNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:13:37 -0400
IronPort-SDR: z+3uh82xf/gZ2VoNx3wPzPH+sN8wJkDTg+YfsVYxlgByAbF8H2zfYQSskn2yyh6nbyO+lHGDfF
 sbLpjHPOu2cw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:13:02 -0700
IronPort-SDR: 2RsX+xqMuuxlAB4NnD2LSiK4r4smDmobxkFgQH5RFhaVTS2N+gnguLGrjv65UNKsW95gXApWkd
 S0nFhoOilyfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383766"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:59 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Mustafa Ismail <mustafa.ismail@intel.com>
Subject: [RFC PATCH v5 16/16] RDMA/irdma: Update MAINTAINERS file
Date:   Fri, 17 Apr 2020 10:12:51 -0700
Message-Id: <20200417171251.1533371-17-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Add maintainer entry for irdma driver.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bae1419745aa..87c93a3cc956 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8725,6 +8725,14 @@ L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	drivers/cpufreq/intel_pstate.c
 
+INTEL ETHERNET PROTOCL DRIVER FOR RDMA
+M:	Mustafa Ismail <mustafa.ismail@intel.com>
+M:	Shiraz Saleem <shiraz.saleem@intel.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/irdma/
+F:	include/uapi/rdma/irdma-abi.h
+
 INTEL SPEED SELECT TECHNOLOGY
 M:	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.25.2

