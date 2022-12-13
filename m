Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C783264ADAF
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiLMCgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbiLMCgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:36:31 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876311D0C6
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:14 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id m13-20020a170902f64d00b001899a70c8f1so12023217plg.14
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qvvIC7YrDQMRyZvpvAP4n+tRFkpRWKJ/6Yf2M75Qa3M=;
        b=AQmLlkOwM+PjHCIjUllzOz2prpi9ZfYy0ptb4bI8FYikZWpBw7yL+pHvng3TiXDbhe
         cySGOjVaG7GOwiT2Nj69f/P0anH/WtlywuCRrh04mzmvu+oktD7mtxTzcXqoQ2soStuG
         wNf+fquL3Xqkhz+hgq83Ro9e8LHrYbh8OidCzG8XtlYy9pKxZRFa4dpCRdhB/+7keB/4
         zID1bPp3pfHzyzY0sXJ9tdfleUNc2BIyBL7KsGm1dsNGjPCqfUlLah4Z7IvITv8nElkK
         XbK1NFJSntAPIH5Tk82Fzs7qjgGY6+NNeIxik6H8hULF/LprVWN0/v1JhdQRcaOF7EOq
         bdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvvIC7YrDQMRyZvpvAP4n+tRFkpRWKJ/6Yf2M75Qa3M=;
        b=53dUatsjgVR7rRLL7xHuciNzYJ48lACtq62ry1ziZp6m55nlilgffiOvHQpRHtw2Vc
         U78RL5664IKrqPlz/qhSx2AMj9vI1ykXsC0FHSfB3tCZJiivp+v6bhJrzmXHH3McTSOU
         LUgLl7DnHE4zjJ0sMNzhDSkmJ+/8r37pcE9LXLFQm1UDyOP+eUwSzNObbkhidgvGTV1K
         dInsJkzVH0Dn26QstQz54WypHpWgpmDwdDNSw/X82185Bw9P3Ykafo/G/4l27yskAHUy
         DKD1FNMxDHSZRcwBdQK8WAG2aGvQ07nbXqJlMK27UOOb66O03aadLVKjcfIAm5vWy/sD
         lvAg==
X-Gm-Message-State: ANoB5pnoPIrpbHzgenaBwsO1+LIjNsMVmrGFZ68xcUuIDickiWBt57qP
        2e8CWmZSklc/xP6VaK5gm6kSO7U=
X-Google-Smtp-Source: AA0mqf6ciZA8rokylYS3W9hhZ7SyYnvGkNX6Ju2z5ynQu8qDYkxxS60UW4sBaBHfC6+Ktw2lOmUXGUY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:1dcd:0:b0:576:4b38:c08e with SMTP id
 d196-20020a621dcd000000b005764b38c08emr31155877pfd.37.1670898973905; Mon, 12
 Dec 2022 18:36:13 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:35:54 -0800
In-Reply-To: <20221213023605.737383-1-sdf@google.com>
Mime-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213023605.737383-5-sdf@google.com>
Subject: [PATCH bpf-next v4 04/15] selftests/bpf: Update expected
 test_offload.py messages
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generic check has a different error message, update the selftest.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_offload.py | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 7cb1bc05e5cf..40cba8d368d9 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -1039,7 +1039,7 @@ netns = []
     offload = bpf_pinned("/sys/fs/bpf/offload")
     ret, _, err = sim.set_xdp(offload, "drv", fail=False, include_stderr=True)
     fail(ret == 0, "attached offloaded XDP program to drv")
-    check_extack(err, "Using device-bound program without HW_MODE flag is not supported.", args)
+    check_extack(err, "Using offloaded program without HW_MODE flag is not supported.", args)
     rm("/sys/fs/bpf/offload")
     sim.wait_for_flush()
 
@@ -1088,12 +1088,12 @@ netns = []
     ret, _, err = sim.set_xdp(pinned, "offload",
                               fail=False, include_stderr=True)
     fail(ret == 0, "Pinned program loaded for a different device accepted")
-    check_extack_nsim(err, "program bound to different dev.", args)
+    check_extack(err, "Program bound to different device.", args)
     simdev2.remove()
     ret, _, err = sim.set_xdp(pinned, "offload",
                               fail=False, include_stderr=True)
     fail(ret == 0, "Pinned program loaded for a removed device accepted")
-    check_extack_nsim(err, "xdpoffload of non-bound program.", args)
+    check_extack(err, "Program bound to different device.", args)
     rm(pin_file)
     bpftool_prog_list_wait(expected=0)
 
@@ -1334,12 +1334,12 @@ netns = []
     ret, _, err = simA.set_xdp(progB, "offload", force=True, JSON=False,
                                fail=False, include_stderr=True)
     fail(ret == 0, "cross-ASIC program allowed")
-    check_extack_nsim(err, "program bound to different dev.", args)
+    check_extack(err, "Program bound to different device.", args)
     for d in simdevB.nsims:
         ret, _, err = d.set_xdp(progA, "offload", force=True, JSON=False,
                                 fail=False, include_stderr=True)
         fail(ret == 0, "cross-ASIC program allowed")
-        check_extack_nsim(err, "program bound to different dev.", args)
+        check_extack(err, "Program bound to different device.", args)
 
     start_test("Test multi-dev ASIC cross-dev map reuse...")
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

