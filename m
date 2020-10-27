Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB2F29C80A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817034AbgJ0TAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:00:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41551 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371355AbgJ0TAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id s9so3112875wro.8
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qug/l2PaHPdn5nmmo5MAN4jJnMHDysyaTDj3MD0cWk8=;
        b=yAQv4R8rgsLyHmAPm5o97IiojoAcx5+7ufwQVOSCinvt1RK0kxjCmtYzdoTwaAxiou
         H6764HMhlANaqp75yBugcbRLxBenWlYjL1RNs/AsO3qN6EG2Gnqi4Jh4ZRD+RhtCFIe3
         m7WKVivxJCNzzQkJkhyQqAnbbjUHQgmf9KyG+lIcXEjB6Qh+6uUZMHNiUX82WdN1oQRB
         Bl37O8AaW0AjdVaylhO0oyAylaFTbNwLNhz6BGZVQA92XSxulTg/eQTyCoXxSC/uLQZ2
         aFtorS94NL2uFpOTsjL6rSA15nxmKDWko6YzsdR3uE10HG+zWjn4a3gg3Dnky701E9Fh
         cuMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qug/l2PaHPdn5nmmo5MAN4jJnMHDysyaTDj3MD0cWk8=;
        b=QGAaWuThkqDQEOsztE4bs7yEgr62tzrOdVUTMicZH57sVmd+5q3CIcDBCdTOA59Amk
         2yNMjbpN/Fn1AZrVGX63mZpJzF9JJtaYD8QQynQY4zUKPfn25bZHKrcfiIgPcKX+rVi9
         QHl2StDrey6AJux0CnuLhOKEeBUvLvdpUP1F7szOMzjuYsxw0JLdKp6PI9ARSGcuaIET
         zkbZnaPs6MAfZgvjJbAtYjWEYXG1j+SbO3XfX+vfwBDOCp8TgYvhLRiC7VcEDn8ise63
         ivauD60uusCoYezovWE69hIUyS2f/iEXnUUbNmgViQ1MfWSfBDh6lVaEKny/e6uowDHw
         dWEA==
X-Gm-Message-State: AOAM532UR3/Yo/6s17rDXIwfLnFKoyx53xUm7xYgAFSG8zeM2idYJVrs
        ETMcfDG++XQ5UIQdgCZBjQwZn9OIvMxMqH/G
X-Google-Smtp-Source: ABdhPJw3dbU05kDu9XZ1JYoYS3bQsbXcEpPRJ+5nT0Cj2GCgiJCFERh1UrhYdAvjEY2KTjzvS651kQ==
X-Received: by 2002:adf:c3c6:: with SMTP id d6mr4586243wrg.206.1603825206322;
        Tue, 27 Oct 2020 12:00:06 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:05 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 01/16] selftests: net: bridge: rename current igmp tests to igmpv2
Date:   Tue, 27 Oct 2020 20:59:19 +0200
Message-Id: <20201027185934.227040-2-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027185934.227040-1-razor@blackwall.org>
References: <20201027185934.227040-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

To prepare the bridge_igmp.sh for IGMPv3 we need to rename the
current test to IGMPv2.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 tools/testing/selftests/net/forwarding/bridge_igmp.sh | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 88d2472ba151..481198300b72 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="reportleave_test"
+ALL_TESTS="v2reportleave_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -110,7 +110,7 @@ mcast_packet_test()
 	return $seen
 }
 
-reportleave_test()
+v2reportleave_test()
 {
 	RET=0
 	ip address add dev $h2 $TEST_GROUP/32 autojoin
@@ -118,12 +118,12 @@ reportleave_test()
 
 	sleep 5
 	bridge mdb show dev br0 | grep $TEST_GROUP 1>/dev/null
-	check_err $? "Report didn't create mdb entry for $TEST_GROUP"
+	check_err $? "IGMPv2 report didn't create mdb entry for $TEST_GROUP"
 
 	mcast_packet_test $TEST_GROUP_MAC $TEST_GROUP $h1 $h2
 	check_fail $? "Traffic to $TEST_GROUP wasn't forwarded"
 
-	log_test "IGMP report $TEST_GROUP"
+	log_test "IGMPv2 report $TEST_GROUP"
 
 	RET=0
 	bridge mdb show dev br0 | grep $TEST_GROUP 1>/dev/null
@@ -139,7 +139,7 @@ reportleave_test()
 	mcast_packet_test $TEST_GROUP_MAC $TEST_GROUP $h1 $h2
 	check_err $? "Traffic to $TEST_GROUP was forwarded without mdb entry"
 
-	log_test "IGMP leave $TEST_GROUP"
+	log_test "IGMPv2 leave $TEST_GROUP"
 }
 
 trap cleanup EXIT
-- 
2.25.4

