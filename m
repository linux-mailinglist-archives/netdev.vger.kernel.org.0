Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A9331A844
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhBLXXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:23:44 -0500
Received: from mga04.intel.com ([192.55.52.120]:29000 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbhBLXXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 18:23:41 -0500
IronPort-SDR: 88w4Lv68GUJ4UdsOu4Vg6MxBGAQ7wdayHlHifSvcrHwwOL+D7hk2WqEfuDXHaW+jwt8mQQV7U4
 7ZblUvcrV2ow==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179934364"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179934364"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:36 -0800
IronPort-SDR: 8ofgBmkEM1cysfsqxtTThAcm4q4akLcw26mxhDDYxR2254SULeVTw4hCi+oWQxOHgaSiXby429
 yBdtJKuINozQ==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="360595938"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:35 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/4] selftests: mptcp: fix ACKRX debug message
Date:   Fri, 12 Feb 2021 15:20:28 -0800
Message-Id: <20210212232030.377261-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
References: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

Info from received MPCapable SYN were printed instead of the ones from
received MPCapable 3rd ACK.

Fixes: fed61c4b584c ("selftests: mptcp: make 2nd net namespace use tcp syn cookies unconditionally")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 0c6b9d3c03c0..9ab35ae41628 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -502,7 +502,7 @@ do_transfer()
 		echo "${listener_ns} SYNRX: ${cl_proto} -> ${srv_proto}: expect ${expect_synrx}, got ${stat_synrx_now_l}"
 	fi
 	if [ $expect_ackrx -ne $stat_ackrx_now_l ] ;then
-		echo "${listener_ns} ACKRX: ${cl_proto} -> ${srv_proto}: expect ${expect_synrx}, got ${stat_synrx_now_l}"
+		echo "${listener_ns} ACKRX: ${cl_proto} -> ${srv_proto}: expect ${expect_ackrx}, got ${stat_ackrx_now_l} "
 	fi
 
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ];then
-- 
2.30.1

