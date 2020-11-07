Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957342AA49D
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgKGLUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbgKGLUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 06:20:08 -0500
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E8AC0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 03:20:08 -0800 (PST)
Received: from vlad-x1g6.localdomain (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id DC30B1FFAD;
        Sat,  7 Nov 2020 13:20:05 +0200 (EET)
From:   Vlad Buslov <vlad@buslov.dev>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Vlad Buslov <vlad@buslov.dev>
Subject: [PATCH net] selftest: fix flower terse dump tests
Date:   Sat,  7 Nov 2020 13:19:28 +0200
Message-Id: <20201107111928.453534-1-vlad@buslov.dev>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Iproute2 tc classifier terse dump has been accepted with modified syntax.
Update the tests accordingly.

Signed-off-by: Vlad Buslov <vlad@buslov.dev>
Fixes: e7534fd42a99 ("selftests: implement flower classifier terse dump tests")
---
 .../testing/selftests/tc-testing/tc-tests/filters/tests.json  | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index bb543bf69d69..361235ad574b 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -100,7 +100,7 @@
         ],
         "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 ingress flower dst_mac e4:11:22:11:4a:51 action drop",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter show terse dev $DEV2 ingress",
+        "verifyCmd": "$TC -br filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower.*handle",
         "matchCount": "1",
         "teardown": [
@@ -119,7 +119,7 @@
         ],
         "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 ingress flower dst_mac e4:11:22:11:4a:51 action drop",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter show terse dev $DEV2 ingress",
+        "verifyCmd": "$TC -br filter show dev $DEV2 ingress",
         "matchPattern": "  dst_mac e4:11:22:11:4a:51",
         "matchCount": "0",
         "teardown": [
-- 
2.29.1

