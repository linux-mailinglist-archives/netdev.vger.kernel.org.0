Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E398638D2A9
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 02:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhEVAsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 20:48:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:2689 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230307AbhEVAs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 20:48:29 -0400
IronPort-SDR: Cmppp7Q1fe+XEc24+bjNFmJj6drkNKNj+GXia4aUUz38KkP74w6SCglltO9MRpVNKzpEGbzt+Y
 7s2mYTnot1mA==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="262820662"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="262820662"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:47:04 -0700
IronPort-SDR: a3RY8MmpuvCnGY05jo/ap04JBGsh/ycOyvdvUifLkjRAQxDV8aw04uU5N07Elj9pAIREUXtDio
 xNwiIpZKDfSQ==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="474758176"
Received: from mooremel-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.209.84.48])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:47:04 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org
Subject: [PATCH net-next v2] MAINTAINERS: Add entries for CBS, ETF and taprio qdiscs
Date:   Fri, 21 May 2021 17:46:54 -0700
Message-Id: <20210522004654.2058118-1-vinicius.gomes@intel.com>
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

