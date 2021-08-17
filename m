Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E2E3EE9BD
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbhHQJ33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbhHQJ32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:28 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF23BC061764;
        Tue, 17 Aug 2021 02:28:55 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o1-20020a05600c5101b02902e676fe1f04so1370292wms.1;
        Tue, 17 Aug 2021 02:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TFxXv+JEDyBSP+0ivETIiLsWzQlD0yqEZGyjBoEiO6s=;
        b=cxxABQQprkc4cyMscC/EUrESLebPUT23GFoBj3gGJdAsHg9TRPJ+Ta/k0Cvafmoa9T
         OIGX+V6b0PKTd/zu/oJ2CSzUYHzeZsBYKD7jPvLifIu3IiG1vLrquGh2viH4+LNgfpUD
         g2I3jGise6rXwdLwc8AWgu4HJVZQ3TEscp7FlTX8W71/Bo4oT4D1FvhMnaYsf9utK4iO
         SBMGhJW81eWeDmn64qsZsexEYkmmrIlsqccMGSJqHs9WLMKHxRVmT+rxoAnWJhdxAuQV
         rvBQctOIYNuQn01BJWWkD94ShFBqk7/+GYm3SrEM30QiKaBTsbG36Olo8ccDWmwN/3xu
         fPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TFxXv+JEDyBSP+0ivETIiLsWzQlD0yqEZGyjBoEiO6s=;
        b=kwTC67UYqAt73jHMr+u7jY9MwRq7yiVxiPZo2lL+FNCvhLuS+D7I8ZBTEyzlokNRqj
         +RRpY+wytElG2Wu+FAzhqmTqd0lrq/u28C2K3dBbW0EYtHmGDtWGQRdzDdIVtGHCrpBf
         toyMg8Bxo3KsNQQn8poka9cxZuU0h3fBP6Fl72FaOYYJP/2lDq8SxkGIuzAWeG5i5Il6
         dUOZuWeVjd6V5eNdY1NYQHjNvuShi/WSdJOlCHAxER3CYWgB015mFfzhrNGfhNh+zBR6
         +NLwIcgEjffCVKk/sF2yD3aX1y3LBUOfs0kRk8XRkAQ/9u4cYDE52yryCbvin/mgHwQF
         rsjg==
X-Gm-Message-State: AOAM533CYQOYW4qxTAtHq3qbXRMnKPFbb7Lm+WyWbRCBCMZ1SvV8EhAR
        /iiiA0g0BrDhCTvl3K54zd4=
X-Google-Smtp-Source: ABdhPJzPrKlFR4HJ1dekhUHk7WLXPMindzsKkvp7HbRtwn89cGc0SlkwkMn8unaYsadUPM7i/KBfYw==
X-Received: by 2002:a1c:f405:: with SMTP id z5mr2365605wma.33.1629192534547;
        Tue, 17 Aug 2021 02:28:54 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.28.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:28:54 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 01/16] selftests: xsk: remove color mode
Date:   Tue, 17 Aug 2021 11:27:14 +0200
Message-Id: <20210817092729.433-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove color mode since it does not add any value and having less code
means less maintenance which is a good thing.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 10 +++-----
 tools/testing/selftests/bpf/xsk_prereqs.sh | 27 +++++-----------------
 2 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 46633a3bfb0b..cd7bf32e6a17 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -63,14 +63,11 @@
 # ----------------
 # Must run with CAP_NET_ADMIN capability.
 #
-# Run (full color-coded output):
-#   sudo ./test_xsk.sh -c
+# Run:
+#   sudo ./test_xsk.sh
 #
 # If running from kselftests:
-#   sudo make colorconsole=1 run_tests
-#
-# Run (full output without color-coding):
-#   sudo ./test_xsk.sh
+#   sudo make run_tests
 #
 # Run with verbose output:
 #   sudo ./test_xsk.sh -v
@@ -83,7 +80,6 @@
 while getopts "cvD" flag
 do
 	case "${flag}" in
-		c) colorconsole=1;;
 		v) verbose=1;;
 		D) dump_pkts=1;;
 	esac
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index dac1c5f78752..8fe022a4dbfa 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -8,11 +8,6 @@ ksft_xfail=2
 ksft_xpass=3
 ksft_skip=4
 
-GREEN='\033[0;92m'
-YELLOW='\033[0;93m'
-RED='\033[0;31m'
-NC='\033[0m'
-STACK_LIM=131072
 SPECFILE=veth.spec
 XSKOBJ=xdpxceiver
 NUMPKTS=10000
@@ -50,22 +45,12 @@ validate_veth_spec_file()
 test_status()
 {
 	statusval=$1
-	if [ -n "${colorconsole+set}" ]; then
-		if [ $statusval -eq 2 ]; then
-			echo -e "${YELLOW}$2${NC}: [ ${RED}FAIL${NC} ]"
-		elif [ $statusval -eq 1 ]; then
-			echo -e "${YELLOW}$2${NC}: [ ${RED}SKIPPED${NC} ]"
-		elif [ $statusval -eq 0 ]; then
-			echo -e "${YELLOW}$2${NC}: [ ${GREEN}PASS${NC} ]"
-		fi
-	else
-		if [ $statusval -eq 2 ]; then
-			echo -e "$2: [ FAIL ]"
-		elif [ $statusval -eq 1 ]; then
-			echo -e "$2: [ SKIPPED ]"
-		elif [ $statusval -eq 0 ]; then
-			echo -e "$2: [ PASS ]"
-		fi
+	if [ $statusval -eq 2 ]; then
+		echo -e "$2: [ FAIL ]"
+	elif [ $statusval -eq 1 ]; then
+		echo -e "$2: [ SKIPPED ]"
+	elif [ $statusval -eq 0 ]; then
+		echo -e "$2: [ PASS ]"
 	fi
 }
 
-- 
2.29.0

