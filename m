Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6593D75B9
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhG0NSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbhG0NSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:10 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0E4C061760;
        Tue, 27 Jul 2021 06:18:10 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id c16so5343063wrp.13;
        Tue, 27 Jul 2021 06:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hZEC18504OHAsi2e9utRRxz2gA4Wf91ujANloy8IGrE=;
        b=H7UJBeBdmHb8CRixb4hG/jt8aetvnd77ww+940S00N3avNpovjX+W1iue4qQNrZbWc
         tzGL8lKPhnE+D7JHwOkokKqBKQ+qvojOCPXp3jzsOWnQq/tH/OnpnJlrcmwzIY+cc3ed
         YHFrCw9FyL6qHUeFr5MpEmMfvN0IP7aG/VXkLVhc+JtkIMIOYcZ3RGbAo6uwRO9J6LGG
         J4xaFveEm3Jp3M/WoaYFeA7S7WfQBR9+a3kJWZx4QrezjOq9xJ5T23dhdk/2DNDoKS4x
         /bJk5IAg7YnTJX6XQl5AFN5zV1wdXq1vfazbGTNcWrB02hJifrN62q9necGnrXSdUiCD
         3D3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hZEC18504OHAsi2e9utRRxz2gA4Wf91ujANloy8IGrE=;
        b=HhdBa5H7mMlTd2b+CBDegv4svl6Jx1d3uo/rnpATJnvSFObMSmrYzBjI/QoU1ABRhW
         MmtCY+T3lsRVG3dZQonDRhrQe2/gw9nzJzxasylSIdd9adDTmtsgHOuQlrRwbJRI0pZQ
         8uJgAt0BVIV9A2ch17O3mAVjJXEm6SSyqhfwFBhHhXw1x4TFGIJ9Iv1gQOl1tet9v4xi
         wyH2FLRet2D98k5R6wcX1ZQQh6jGAWkELu3SxtNp7QBcJoQkDOO3A7UVSuJ3teUU4NP2
         6SkevG9YIG0SkyAP8jlA1nj3e+GMyg7YCt9tK3IKz6OWtSyM2l2rZ1J6aW5I1lfxDkGA
         RbyA==
X-Gm-Message-State: AOAM5333+Cox/W2NNlOFNDPhD1J/AddC0z7rH40eu+N1v7G1R5RqUV+J
        7tm4OIQY3xUdGV4thnCH4fQ=
X-Google-Smtp-Source: ABdhPJxMuTDyEBT7BnVjvymxk6OtgHuOXr/tUMvOlnVobDAqqdr5VA8t4cWPmy+d/nucmdslbhoSVg==
X-Received: by 2002:a5d:6991:: with SMTP id g17mr13848206wru.253.1627391888964;
        Tue, 27 Jul 2021 06:18:08 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:08 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 01/17] selftests: xsk: remove color mode
Date:   Tue, 27 Jul 2021 15:17:37 +0200
Message-Id: <20210727131753.10924-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove color mode.

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

