Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC643D75D9
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbhG0NTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236685AbhG0NSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:41 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861D1C06179B;
        Tue, 27 Jul 2021 06:18:35 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r2so15243881wrl.1;
        Tue, 27 Jul 2021 06:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jhOPU4ZdNQWyxxh+bW8gPfzYm3tNZLnjBWDs3WiussQ=;
        b=Gpfe28UmZ1+5Hm9oT9VNQjRuvnnZ6ZBUxALkUOgeldJW1G1qa4zccmYEnW1KuEs77z
         Hw3edEGuc4LuCXObiGqteCQ5IZItTqttWtE/8phCDQP/6Fs+jSQjC0CLwIi1WjuH6MCg
         ywsej6yyJkvyNTAcDufQFue0W+bJlKZOtYnlBRbv2f0Cbyt+PiiXi3Zt0oRbsHSDjt3p
         jXgfxvHBhS6YJXOFIGEWu1i6FihC8EYJBGLb4a1zqW4wF0EiwCN80eRwKCzDIo5sCYF0
         2Tl5AWAXzducJTWMBwH/qejZXxYlTEdOXFHr0VYROJmfiUVTbxBm/vtdMLV2Uec3zksN
         pCsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jhOPU4ZdNQWyxxh+bW8gPfzYm3tNZLnjBWDs3WiussQ=;
        b=JNIRpPSTmFkrvVDndMYhJ40+RjlOpT7QxLokp5FGHlAfwYbGY/q3yO8f8FJAyPU2ob
         2VGePkWW0FXF2yAh/8IFmr0RLTnQRHxtpEulU4Wv6lUBmZ0/TexNEEdJxvIf0qR/qmNA
         iCteCM4oylK+R6P2aR7TB1+oYJYUQxaQ3tcvE1+b+/CfiGo4vb1te5FuunaszXvJFpqD
         +k3j39SDaKlz4q6vGMHqmHgowDA4RhWDYiURbSQT3nyq7gQcO46TFQrr2EyV9fuUxR5E
         xj49Lep9FHBKq0neYtxj7DR8/h+SDeFw8ZsrlRflkkLiJGBJYQ1U6yuHRXMCb529eDhI
         Ps4g==
X-Gm-Message-State: AOAM5324hEj4lKF4b+B2Qn5AbEwkSluyx3MSEWY41nai+xsRSyn6ihIZ
        RYwfz11PYCLQxre0w42eu8Y=
X-Google-Smtp-Source: ABdhPJxbCNZP4MuMS0dJN43o7ugoly9EdPVLhnSjZjoEgzQhiHpzgwd0EiXA+oRsxJQFN5WYkQahNw==
X-Received: by 2002:adf:efc6:: with SMTP id i6mr24323909wrp.213.1627391914194;
        Tue, 27 Jul 2021 06:18:34 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:33 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 16/17] selftests: xsk: make enums lower case
Date:   Tue, 27 Jul 2021 15:17:52 +0200
Message-Id: <20210727131753.10924-17-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
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
index 422b34b5afcc..f0616200d5b5 100644
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

