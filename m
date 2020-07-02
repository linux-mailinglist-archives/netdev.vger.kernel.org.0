Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BF2211FD2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgGBJYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbgGBJYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:46 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A23C08C5DD
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:45 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a1so28441788ejg.12
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3ybsptQ1uDuYH5yr/joHYcohd4KEboQtBfB059oe4Vg=;
        b=gSeEI8cQUCh9Chub/HLEFbCB1unWvLNij8kVX6/rIPneSZkht0ksnmozVCkE33wCEw
         Flc2SxfrzsuwnZBCzIOyYn4oPVzKul+ddqO5wWHfpOMEWPdnm+Tsu96bbCfrCJCUSbUH
         z9xzQq2FElY4yc+W2VNX2+Lt6zXqYzGMs/F8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ybsptQ1uDuYH5yr/joHYcohd4KEboQtBfB059oe4Vg=;
        b=bNIl6bhgLtSZRCcnWIE2GgIPfnfhCGiEZi8ZX/TCa6DzL5diW5zAyNe59L5yTz0jeQ
         EYHSR8Eb3rr3MA6Mv9+Z3txNJJfvgFtKycBNSVxLhGoCM2zN8v0GbF/Fkzj1uzVhhNiN
         RzQGYjcb3K3WB3If2fG063bpnEW1r5CXmDf/huncO4bwVsV5Kt44yoqNqFjBiwLrYUVu
         /jYcLMOeWNFcNC2LsOGr2U8a8fu+VuP9Zoyyb7kIoZbhMPtuGMuUlppd4G8IZpFeCvSS
         r6rVXq7bHSEpLG9B0HPMg4PMvEC+zNdD+7w/shVwk2tTu65aeJsW8DeU66jraO4ECmA0
         lmBQ==
X-Gm-Message-State: AOAM532QBl/9yjMes3PmbECM77YioNIT12l/vBHzV0cuaB3VXtfKkWy5
        827Cqkso0zCOj3iOi7hZ1xNuTQ==
X-Google-Smtp-Source: ABdhPJzLGBXtzogWZ/UlSVZIMiV9loLF8MIVSP23mTF+TVAgJ2TBNZN5cFjAePuWK+5HFTwu4ly65A==
X-Received: by 2002:a17:906:87c8:: with SMTP id zb8mr26130500ejb.35.1593681884480;
        Thu, 02 Jul 2020 02:24:44 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id m22sm6519828ejb.47.2020.07.02.02.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:44 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v3 15/16] selftests/bpf: Rename test_sk_lookup_kern.c to test_ref_track_kern.c
Date:   Thu,  2 Jul 2020 11:24:15 +0200
Message-Id: <20200702092416.11961-16-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Name the BPF C file after the test case that uses it.

This frees up "test_sk_lookup" namespace for BPF sk_lookup program tests
introduced by the following patch.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/prog_tests/reference_tracking.c     | 2 +-
 .../bpf/progs/{test_sk_lookup_kern.c => test_ref_track_kern.c}  | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/bpf/progs/{test_sk_lookup_kern.c => test_ref_track_kern.c} (100%)

diff --git a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
index fc0d7f4f02cf..106ca8bb2a8f 100644
--- a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
+++ b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
@@ -3,7 +3,7 @@
 
 void test_reference_tracking(void)
 {
-	const char *file = "test_sk_lookup_kern.o";
+	const char *file = "test_ref_track_kern.o";
 	const char *obj_name = "ref_track";
 	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts,
 		.object_name = obj_name,
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c b/tools/testing/selftests/bpf/progs/test_ref_track_kern.c
similarity index 100%
rename from tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
rename to tools/testing/selftests/bpf/progs/test_ref_track_kern.c
-- 
2.25.4

