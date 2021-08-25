Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A4A3F71F8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239973AbhHYJjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239928AbhHYJjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:39:06 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D584C0617AF;
        Wed, 25 Aug 2021 02:38:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k20-20020a05600c0b5400b002e87ad6956eso2460360wmr.1;
        Wed, 25 Aug 2021 02:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k1HJRSJMwl0Oep5SI3/5ET+XuXdJP32c8tVWrTf0FdU=;
        b=bl9vHTzutCnxlStSFlq56I2B0tS+1t33qeosIMbdjbZe7I3kW73cq0qy+PzSXpyq8W
         o3IVA4bIPVSHlXL7DJKvkCHNkTWPIfGfNBt5Nmn958+W/VjWyEtol8lPKafhBPuhQeVQ
         ClCNvcb/TZAT73OI3ZmOzgVEkhHBFCHzCeX4fVdLAzX5Y+Jbx3Fej03lSYm5cKjLy2Aw
         AXI3iLI8Qg725RGzkXlAHdvaoFSGWDGJs63fibniKuvpAFvGsY9144JbnI195vrraZfi
         Luj3NcEglKFYVWoHCIHC5p4lZ0qkVDT+553MYVvspcYj/X5TJeAptpBsvNz+PNP/xxHL
         jbbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k1HJRSJMwl0Oep5SI3/5ET+XuXdJP32c8tVWrTf0FdU=;
        b=RXti0AvNL++jKgCtvciIKtP8Z+z/cPRcJwfKmRoXrtAgGBwsirVArEwuloZOkmnxbS
         eUanCfRLPc7Bh+W9DcEiZ+YlU9Pw1hTT+DK9hcq1hW8IVzfhuxywvRdRSEIqlEv/pXGS
         nVCbk/xme+e5Fd09pMJEzBxY2IzIrlDSMgsG+/MzS+iUqAwkkEYJciv77hpcJ83J9vib
         8ngaYKlP3GqCeTrtjp0gZSTK3uRd2ujcXnIgqwjxOW48SOLHB0hFxdhIPWOd235CnBNe
         LKDCWMorPhpNP57zqdAQfVdFSLpkg3uJ5Xg4lu3UjpYEqxsUzuJJ+H9hL32z/AmIUNnm
         RpIg==
X-Gm-Message-State: AOAM5329UVp4lbiWZlMFI74MUvLIQxnQbL+G+qKiBaptHCsiSPrWgteH
        +KSZOn3yH4x2Mng3fMHMqlk=
X-Google-Smtp-Source: ABdhPJyLQalIztQWckm2f17BF/EbdjiIHusQOJi8/5p/mGxWQL+hlA6QzyYaBW9/t33V80pFtcN4ag==
X-Received: by 2002:a05:600c:1c08:: with SMTP id j8mr8464798wms.27.1629884294099;
        Wed, 25 Aug 2021 02:38:14 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.38.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:38:13 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 15/16] selftests: xsk: make enums lower case
Date:   Wed, 25 Aug 2021 11:37:21 +0200
Message-Id: <20210825093722.10219-16-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
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
index 5ca853cf27a1..0c7b40d5f4b6 100644
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
index 3e5394295ac1..582af3505c15 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -44,14 +44,13 @@
 
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
@@ -61,7 +60,7 @@ enum TEST_TYPES {
 	TEST_TYPE_MAX
 };
 
-enum STAT_TEST_TYPES {
+enum stat_test_type {
 	STAT_TEST_RX_DROPPED,
 	STAT_TEST_TX_INVALID,
 	STAT_TEST_RX_FULL,
@@ -69,7 +68,7 @@ enum STAT_TEST_TYPES {
 	STAT_TEST_TYPE_MAX
 };
 
-static int configured_mode = TEST_MODE_UNCONFIGURED;
+static int configured_mode;
 static u8 debug_pkt_dump;
 static u32 num_frames = DEFAULT_PKT_CNT / 4;
 static bool second_step;
-- 
2.29.0

