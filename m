Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B822F9DF2
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390042AbhARLUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:20:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40262 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388594AbhARLTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 06:19:46 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l1SYo-0002Lb-DA; Mon, 18 Jan 2021 11:19:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] selftests: forwarding: Fix spelling mistake "succeded" -> "succeeded"
Date:   Mon, 18 Jan 2021 11:19:02 +0000
Message-Id: <20210118111902.71096-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two spelling mistakes in check_fail messages. Fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/testing/selftests/net/forwarding/tc_chains.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_chains.sh b/tools/testing/selftests/net/forwarding/tc_chains.sh
index 2934fb5ed2a2..b95de0463ebd 100755
--- a/tools/testing/selftests/net/forwarding/tc_chains.sh
+++ b/tools/testing/selftests/net/forwarding/tc_chains.sh
@@ -136,7 +136,7 @@ template_filter_fits()
 
 	tc filter add dev $h2 ingress protocol ip pref 1 handle 1102 \
 		flower src_mac $h2mac action drop &> /dev/null
-	check_fail $? "Incorrectly succeded to insert filter which does not template"
+	check_fail $? "Incorrectly succeeded to insert filter which does not template"
 
 	tc filter add dev $h2 ingress chain 1 protocol ip pref 1 handle 1101 \
 		flower src_mac $h2mac action drop
@@ -144,7 +144,7 @@ template_filter_fits()
 
 	tc filter add dev $h2 ingress chain 1 protocol ip pref 1 handle 1102 \
 		flower dst_mac $h2mac action drop &> /dev/null
-	check_fail $? "Incorrectly succeded to insert filter which does not template"
+	check_fail $? "Incorrectly succeeded to insert filter which does not template"
 
 	tc filter del dev $h2 ingress chain 1 protocol ip pref 1 handle 1102 \
 		flower &> /dev/null
-- 
2.29.2

