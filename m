Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C74467061
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378266AbhLCDCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:02:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:57249 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378188AbhLCDCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 22:02:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="260901965"
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="260901965"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 18:59:13 -0800
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="501015268"
Received: from liweilv-mobl.ccr.corp.intel.com (HELO lkp-bingo.fnst-test.com) ([10.255.30.243])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 18:59:09 -0800
From:   Li Zhijian <zhijianx.li@intel.com>
To:     kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizhijian@cn.fujitsu.com,
        Li Zhijian <zhijianx.li@intel.com>
Subject: [PATCH v3 2/3] selftests/tc-testing: add missing config
Date:   Fri,  3 Dec 2021 10:53:22 +0800
Message-Id: <20211203025323.6052-2-zhijianx.li@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211203025323.6052-1-zhijianx.li@intel.com>
References: <20211203025323.6052-1-zhijianx.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qdiscs/fq_pie requires CONFIG_NET_SCH_FQ_PIE, otherwise tc will fail
to create a fq_pie qdisc.

It fixes following issue:
 # not ok 57 83be - Create FQ-PIE with invalid number of flows
 #       Command exited with 2, expected 0
 # Error: Specified qdisc not found.

Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
---
 tools/testing/selftests/tc-testing/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index b71828df5a6d..b1cd7efa4512 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -60,6 +60,7 @@ CONFIG_NET_IFE_SKBTCINDEX=m
 CONFIG_NET_SCH_FIFO=y
 CONFIG_NET_SCH_ETS=m
 CONFIG_NET_SCH_RED=m
+CONFIG_NET_SCH_FQ_PIE=m
 
 #
 ## Network testing
-- 
2.32.0

