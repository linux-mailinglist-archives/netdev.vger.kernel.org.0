Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953CE1D117
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 23:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfENVMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 17:12:38 -0400
Received: from mail-oi1-f202.google.com ([209.85.167.202]:56640 "EHLO
        mail-oi1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfENVMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 17:12:38 -0400
Received: by mail-oi1-f202.google.com with SMTP id e5so171093oih.23
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 14:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ST8fThbwHB7FPyg/UYGhE320wSCcxJdrKK/TrBgEs88=;
        b=R3ALmlolgf8qQenjhtDTatJx1C6YLXjJj/KPwFTnaTz8tOuYLjlYjTrtuGSqYsUynU
         sGUT7dP60mO/doCNlzhHTh+BpSUNbuobTFFl96UJJwUa4QtEUEbCR3De6edSnrMgzL04
         bmYuHdafYOVGhqxz/UFT942qYt5fFgbWxKrU8AfJG0oPI/VGenN60h4Z+/9qfDdeEWlw
         9fdaC2cy08y8nuBFqLcUCtr4CM5SQl209NIFXXKHKoI8EkiKsUH9f8V//Ew8GgMezma0
         cbSdI7gXVVwBpBzOcAzU8ule6nnNV+cjnRJO41KzZVWfJIxShedPh0Ks5e5RRSA9VNDx
         BacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ST8fThbwHB7FPyg/UYGhE320wSCcxJdrKK/TrBgEs88=;
        b=M76DNZVTsS5lOXbHnN9cpu1uek7t2yhc6t+5OpJfIKC4VoQoxOxUtHqQQp47X2u+9e
         QeRukRd0O0skKgTRqdxTbZY4rzVZXh+o/VuJzAibZHsBKzKtdLsOxb2X/oAgzZLMdBKx
         4+q/tPczE1dZ9vF9LNm3UUUeCbsi13nMG8soLbpzD6OfCPmzdv6peEGFXUAQiWvRaC/5
         rgV3+LlK24xILaJkxBg75WUZO6ZuU+4ckFdvibEncN3t102k5skV2hVqQMqbFdOPf4z+
         q3erS8bs5t9dx0dvqDlDaDLss9jDDZMuHvx/SOJspfvKFvIrTs/7CIlMu3kc1Jipeb/F
         ajJA==
X-Gm-Message-State: APjAAAVJnGAHWdvuguMpbyypw3SAIkiXxi9QUxTraFM6nelCTKA034dD
        bpP704/jkPHPdfEPa0GlGcpUmBnQQ4pf4n8dBMBJtndhytyBbJJBvaxI08aviWG18g4AE/93Gi7
        wtpq1Xb2bAdraRleEuOYKS+bioUgXam4gCWvz/OxX3wVX5wOn/a4C4g==
X-Google-Smtp-Source: APXvYqwSR5YBY5Hae3ywGuyWpPCY8+qie2boxw8IZcOirVPvEt+vVISriL7y0U7Wie5c7e5OHS5+OtI=
X-Received: by 2002:aca:f444:: with SMTP id s65mr4191410oih.115.1557868357209;
 Tue, 14 May 2019 14:12:37 -0700 (PDT)
Date:   Tue, 14 May 2019 14:12:33 -0700
Message-Id: <20190514211234.25097-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf 1/2] selftests/bpf: add missing \n to flow_dissector CHECK errors
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, in case of an error, everything gets mushed together.

Fixes: a5cb33464e53 ("selftests/bpf: make flow dissector tests more extensible")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index 8b54adfd6264..d40cee07a224 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -242,12 +242,12 @@ void test_flow_dissector(void)
 	 */
 
 	err = bpf_prog_attach(prog_fd, 0, BPF_FLOW_DISSECTOR, 0);
-	CHECK(err, "bpf_prog_attach", "err %d errno %d", err, errno);
+	CHECK(err, "bpf_prog_attach", "err %d errno %d\n", err, errno);
 
 	tap_fd = create_tap("tap0");
-	CHECK(tap_fd < 0, "create_tap", "tap_fd %d errno %d", tap_fd, errno);
+	CHECK(tap_fd < 0, "create_tap", "tap_fd %d errno %d\n", tap_fd, errno);
 	err = ifup("tap0");
-	CHECK(err, "ifup", "err %d errno %d", err, errno);
+	CHECK(err, "ifup", "err %d errno %d\n", err, errno);
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		struct bpf_flow_keys flow_keys = {};
@@ -255,7 +255,7 @@ void test_flow_dissector(void)
 		__u32 key = 0;
 
 		err = tx_tap(tap_fd, &tests[i].pkt, sizeof(tests[i].pkt));
-		CHECK(err < 0, "tx_tap", "err %d errno %d", err, errno);
+		CHECK(err < 0, "tx_tap", "err %d errno %d\n", err, errno);
 
 		err = bpf_map_lookup_elem(keys_fd, &key, &flow_keys);
 		CHECK_ATTR(err, tests[i].name, "bpf_map_lookup_elem %d\n", err);
-- 
2.21.0.1020.gf2820cf01a-goog

