Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98812529A7
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 10:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHZI7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 04:59:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36642 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbgHZI7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 04:59:12 -0400
Received: from cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net ([80.193.200.194] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kArGt-00053L-L8; Wed, 26 Aug 2020 08:59:07 +0000
From:   Colin King <colin.king@canonical.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] selftests/bpf: fix spelling mistake "scoket" -> "socket"
Date:   Wed, 26 Aug 2020 09:59:07 +0100
Message-Id: <20200826085907.43095-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake an a check error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/testing/selftests/bpf/prog_tests/d_path.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
index 058765da17e6..4ce2bb799afb 100644
--- a/tools/testing/selftests/bpf/prog_tests/d_path.c
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -38,7 +38,7 @@ static int trigger_fstat_events(pid_t pid)
 		return ret;
 	/* unmountable pseudo-filesystems */
 	sockfd = socket(AF_INET, SOCK_STREAM, 0);
-	if (CHECK(sockfd < 0, "trigger", "scoket failed\n"))
+	if (CHECK(sockfd < 0, "trigger", "socket failed\n"))
 		goto out_close;
 	/* mountable pseudo-filesystems */
 	procfd = open("/proc/self/comm", O_RDONLY);
-- 
2.27.0

