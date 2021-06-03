Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602E739AD7D
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhFCWQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:16:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:13377 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCWQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:16:20 -0400
IronPort-SDR: GRPVb7m9JSOU+6bfzUPjT2YAhqEV9JakLuAwSVeEObOf8xlPv1Qnb/qtfzxdpLvfFqp60Lzpuj
 pfaUitGg2qWw==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="203979184"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="203979184"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 15:14:31 -0700
IronPort-SDR: UvBjgF/j7+Ma+wtTRph7e8WyPO0VHqqxB2vuVIFcRvood17ezqMK0qMBKiOI9NSPHLzPNZlU2g
 hlYMAElHq7og==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="446450297"
Received: from mwnomani-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.209.86.185])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 15:14:30 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org
Subject: [PATCH net-next v2] MAINTAINERS: Add entries for CBS, ETF and taprio qdiscs
Date:   Thu,  3 Jun 2021 15:14:10 -0700
Message-Id: <20210603221414.3820562-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603221414.3820562-1-vinicius.gomes@intel.com>
References: <20210603221414.3820562-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Vinicius Costa Gomes as maintainer for these qdiscs.

These qdiscs are all TSN (Time Sensitive Networking) related.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b9f329249a5a..a245fa344206 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4138,6 +4138,14 @@ S:	Odd Fixes
 F:	Documentation/devicetree/bindings/arm/cavium-thunder2.txt
 F:	arch/arm64/boot/dts/cavium/thunder2-99xx*
 
+CBS/ETF/TAPRIO QDISCS
+M:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
+S:	Maintained
+L:	netdev@vger.kernel.org
+F:	net/sched/sch_cbs.c
+F:	net/sched/sch_etf.c
+F:	net/sched/sch_taprio.c
+
 CC2520 IEEE-802.15.4 RADIO DRIVER
 M:	Varka Bhadram <varkabhadram@gmail.com>
 L:	linux-wpan@vger.kernel.org
-- 
2.31.1

