Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AC038D199
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhEUWfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:35:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:57192 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhEUWfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 18:35:38 -0400
IronPort-SDR: sG+MgvNCADZ84Uri2RVNwKoaQzW9VE5q7W8Vuy/GJcSu/AAjZADHtWOujozDoCyZ00Khhw2p8m
 8YyblTb9r+wA==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="201621638"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="201621638"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 15:34:14 -0700
IronPort-SDR: My78/1cOeqAJ0j8hJjY78K+bsx3tSZpuBLbcQVpem4drTKXvtSfn5V8dBJuMG9MOi7a2XZ5p4G
 FdrBC1jFTaPQ==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="395503692"
Received: from mooremel-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.209.84.48])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 15:34:14 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org
Subject: [PATCH net-next v1] MAINTAINERS: Add entries for CBS, ETF and taprio qdiscs
Date:   Fri, 21 May 2021 15:33:37 -0700
Message-Id: <20210521223337.1873836-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Vinicius Costa Gomes as maintainer for these qdiscs.

These qdiscs are all TSN (Time Sensitive Networking) related.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 MAINTAINERS | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b9f329249a5a..96b44fef2a89 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4138,6 +4138,12 @@ S:	Odd Fixes
 F:	Documentation/devicetree/bindings/arm/cavium-thunder2.txt
 F:	arch/arm64/boot/dts/cavium/thunder2-99xx*
 
+CBS QDISC
+M:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
+S:	Maintained
+L:	netdev@vger.kernel.org
+F:	net/sched/sch_cbs.c
+
 CC2520 IEEE-802.15.4 RADIO DRIVER
 M:	Varka Bhadram <varkabhadram@gmail.com>
 L:	linux-wpan@vger.kernel.org
@@ -6782,6 +6788,12 @@ M:	Mark Einon <mark.einon@gmail.com>
 S:	Odd Fixes
 F:	drivers/net/ethernet/agere/
 
+ETF QDISC
+M:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
+S:	Maintained
+L:	netdev@vger.kernel.org
+F:	net/sched/sch_etf.c
+
 ETHERNET BRIDGE
 M:	Roopa Prabhu <roopa@nvidia.com>
 M:	Nikolay Aleksandrov <nikolay@nvidia.com>
@@ -17743,6 +17755,12 @@ F:	Documentation/filesystems/sysv-fs.rst
 F:	fs/sysv/
 F:	include/linux/sysv_fs.h
 
+TAPRIO QDISC
+M:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
+S:	Maintained
+L:	netdev@vger.kernel.org
+F:	net/sched/sch_taprio.c
+
 TASKSTATS STATISTICS INTERFACE
 M:	Balbir Singh <bsingharora@gmail.com>
 S:	Maintained
-- 
2.31.1

