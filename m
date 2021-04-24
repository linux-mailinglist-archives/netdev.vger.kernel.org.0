Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9867B36A33C
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 23:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhDXVqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 17:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhDXVqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 17:46:16 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05A2C061574;
        Sat, 24 Apr 2021 14:45:37 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id y136so21008580qkb.1;
        Sat, 24 Apr 2021 14:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJ8wJLMMAquK5WtfrTW6hzTEU+ckVaXd0nyZfZC6hyk=;
        b=Om5/5+hzFTmqf+55Fk2jo4zNCknQgMCWenWPL3gUhDNKGGBwMVRbNsopRbhxhBb4Qj
         GP0RHxv8GP6r/b1FFTDBwCCo5A0e7NKstxZrJc8hfybJ8ov5hzT8vViq2inNkmrFHHd5
         eEDvx6FlWkUw5ZVHyIm4/mdb/KsM+ytJTqNdBav09vG+vxQ/5VRAWThnXHOfre5NuQhP
         /xQbhTEE+uNlcBmbURuky/N42LvppPlVqexaF+aPJNwdeAKoBMjgKeSG2icfaph+iynE
         BEdzk/M7XK9lanw8R7WCaFgVQWo7CqMTs1OQC1048cBoFPvdZxU3cj3cN3DOJ3ca5rtI
         Ix6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJ8wJLMMAquK5WtfrTW6hzTEU+ckVaXd0nyZfZC6hyk=;
        b=PmJ0xLuPuMiANoJ3chAc+X+8PP/jzxOA2cT3pwezAkiG9jQvDjcog9dJ5aLG50RnD/
         CWwrxnEVKObUBhYzOSqWfJ1ws2JrCL1vYSH67n/Bnv3LHKWeP4BhfOftYBb98zIDZlfD
         rbig0mNbJYUavDcWKSR/6bDKoTmo1y8cpvulhh62tnLZ/9BlvfK0VRGn/j1698q4YyEs
         vlbL9WwOyZnjDLDNo7oIuW+X6NpcHKhc0UqhhiYlPhnQ2kqibWNpUlvzUMg74qQri8lA
         B544bZl2mx5+5SjpQ6lf9gr9PRjrUjWY+MR1MvvpqzU0dqbaRykxDRiOcA2d320PMS/s
         fcaA==
X-Gm-Message-State: AOAM532g6ABIclZ495AYAt0Obf1OLlNPbhHfPEXTj46JMV02w1fJp7gI
        KjK0NRYr3nk4f9JpjuMD0DY=
X-Google-Smtp-Source: ABdhPJzLZmTBQzvohUaspwiOSF1VO1y8v7lYyd71lzQ6jYrXsyFdmQ4Ii9IrPMqzo7ON71d+1lpf8w==
X-Received: by 2002:a37:7b41:: with SMTP id w62mr9916583qkc.256.1619300736679;
        Sat, 24 Apr 2021 14:45:36 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id b17sm6638904qto.88.2021.04.24.14.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 14:45:36 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v5 0/2] add batched ops for percpu array
Date:   Sat, 24 Apr 2021 18:45:08 -0300
Message-Id: <20210424214510.806627-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces batched operations for the per-cpu variant of
the array map.

Also updates the batch ops test for arrays.

v4 -> v5:
- Revert removal of percpu macros

v3 -> v4:
- Prefer 'calloc()' over 'malloc()' on batch ops tests
- Add missing static keyword in a couple of test functions
- 'offset' to 'cpu_offset' as suggested by Martin

v2 -> v3:
- Remove percpu macros as suggested by Andrii
- Update tests that used the per cpu macros

v1 -> v2:
- Amended a more descriptive commit message

Pedro Tammela (2):
  bpf: add batched ops support for percpu array
  bpf: selftests: update array map tests for per-cpu batched ops

 kernel/bpf/arraymap.c                         |   2 +
 .../bpf/map_tests/array_map_batch_ops.c       | 104 +++++++++++++-----
 2 files changed, 77 insertions(+), 29 deletions(-)

-- 
2.25.1

