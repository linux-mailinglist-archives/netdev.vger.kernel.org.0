Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF33EE9DB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbhHQJaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbhHQJ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:52 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315C1C061764;
        Tue, 17 Aug 2021 02:29:17 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k8so8604273wrn.3;
        Tue, 17 Aug 2021 02:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Js4aPiiNf+QCexw6c4OlTvnLaWRKYRo1qKcpSX3F2uc=;
        b=PUE66P1XFZojOurEUj6Nb77sgVR48qvIPlCafe1546v4cx2Ze8XfbEpTxGwy+dPlrq
         5UpdhWZQZtHfpGP+PXu5S4LWWsnZx6TnA0Mfds0dsMXfXEjUuhUTac25RW09ppaXXrJg
         87MwmYQD1rJy3UuRJsfecu46ifpQQ8Ze/5YR3hH+FlOJ7NZG/wwuRxsgEFwoyJ/Sej2p
         thP/rom4UGPLNMSEbIqm45F8xNitJDStW0xYkSa/1qKR4TbXie0o2DAsVviY1V7FPd8x
         bR3+qq8+EnEhTR/xKdDJLLBag76oCCwzmZDzB34O+Ybl+CwZ0jWNaA9k/U3M010cVBMW
         DaSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Js4aPiiNf+QCexw6c4OlTvnLaWRKYRo1qKcpSX3F2uc=;
        b=QCwTHPXI9S4jPmWfrBgzO+wLzGqhk7RQotqxJxRYj103Dy0EJ3L1Mj0DkR7SI7T+Yi
         vqfNh6l/9OE1HSDEUhezpee+6l1o6AG84/mdb/e51tfOoXkQ6HUoeSpeifTXh0m3ngCw
         jgxt0BzRwK+TrFn6s6UqR0RLyN7CDtdh9TVbEg5jqqfRnh4DQk+l9RapcCjUFnKcUOg3
         Lg8Yr3cMm/C3T1XW0Y3lH4HZHgLkNtssB7mcLC5ndyqeZsVr8Cefwioq1y8UFCfmpLVY
         WD39KFgngCA1tGRmQHhvcuu7gXuMKI+KuBsnS2yfMwQSElXq7rD+PJCkWkueVdmnyTRp
         HNuw==
X-Gm-Message-State: AOAM530agnnIMwv0XZW0VME1kWbb5rB2i4Lm606qanY20DshioHAY3gR
        1lHlr1baOBCp3SDTVoAOZVY=
X-Google-Smtp-Source: ABdhPJzh8yzzcsIS1wqRCYm5JTxf1YiSvMopzGcbDkMKHXnhz8irssAfM1k1JXg7bhJrbGTdZZ9Wdg==
X-Received: by 2002:adf:f704:: with SMTP id r4mr2891068wrp.389.1629192555804;
        Tue, 17 Aug 2021 02:29:15 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.29.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:15 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 15/16] selftests: xsk: make enums lower case
Date:   Tue, 17 Aug 2021 11:27:28 +0200
Message-Id: <20210817092729.433-16-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make enums lower case as that is the standard. Also drop the
unnecessary TEST_MODE_UNCONFIGURED mode.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 11 +++--------
 tools/testing/selftests/bpf/xdpxceiver.h |  9 ++++-----
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 4160ba5f50a3..3c41dc23b97e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -105,14 +105,9 @@ static const u16 UDP_PORT2 = 2121;
 
 static void __exit_with_error(int error, const char *file, const char *func, int line)
 {
-	if (configured_mode == TEST_MODE_UNCONFIGURED) {
-		ksft_exit_fail_msg
-		("[%s:%s:%i]: ERROR: %d/\"%s\"\n", file, func, line, error, strerror(error));
-	} else {
-		ksft_test_result_fail
-		("[%s:%s:%i]: ERROR: %d/\"%s\"\n", file, func, line, error, strerror(error));
-		ksft_exit_xfail();
-	}
+	ksft_test_result_fail("[%s:%s:%i]: ERROR: %d/\"%s\"\n", file, func, line, error,
+			      strerror(error));
+	ksft_exit_xfail();
 }
 
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index f5b46cd3d8df..309a580fd1c5 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -43,14 +43,13 @@
 
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
 
-enum TEST_MODES {
-	TEST_MODE_UNCONFIGURED = -1,
+enum test_mode {
 	TEST_MODE_SKB,
 	TEST_MODE_DRV,
 	TEST_MODE_MAX
 };
 
-enum TEST_TYPES {
+enum test_type {
 	TEST_TYPE_NOPOLL,
 	TEST_TYPE_POLL,
 	TEST_TYPE_TEARDOWN,
@@ -60,7 +59,7 @@ enum TEST_TYPES {
 	TEST_TYPE_MAX
 };
 
-enum STAT_TEST_TYPES {
+enum stat_test_type {
 	STAT_TEST_RX_DROPPED,
 	STAT_TEST_TX_INVALID,
 	STAT_TEST_RX_FULL,
@@ -68,7 +67,7 @@ enum STAT_TEST_TYPES {
 	STAT_TEST_TYPE_MAX
 };
 
-static int configured_mode = TEST_MODE_UNCONFIGURED;
+static int configured_mode;
 static u8 debug_pkt_dump;
 static u32 num_frames = DEFAULT_PKT_CNT / 4;
 static bool second_step;
-- 
2.29.0

