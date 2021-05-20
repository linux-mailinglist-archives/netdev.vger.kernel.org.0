Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1F138B07B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 15:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241592AbhETNwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 09:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242111AbhETNwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 09:52:35 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0059C06175F
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 06:51:13 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id u25-20020a0568302319b02902ac3d54c25eso14941143ote.1
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 06:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=QoJKNoGZkLVWx0eGjPbY8LJ6NfNL4w7xAI12ZqlaAHQ=;
        b=lAL6lpHaFTBHyGDiCOoo4teX9fcwQ2J2thK2sXa0hBhw4ztp+z1CCtLwbIWDrOcLbQ
         UViEv7rVp2D0edakm3eRMeDn+lSc+VpPi8nSc1lsBYCgBEP12rJVVL1oq8PJ2wg01S9f
         Gadjssxhsfi2RgR+UsvwZrC1/XRIjfF01jX4oytHpQYy3HsPp9ToPkUnwxkCW4lBqAly
         zSPYUAjofBi5rA3LK9e+qe0YSv521SiwGlWMhYXO6LOnPLZOKzYi9aw5KaYhHUKCYHGj
         G9Bi0jtaQXtsD+58Io6kTwtx2UAgcmciQrEZq5qOVkseD5ruSXbZcClkLL1qJ+jeHNqB
         AHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=QoJKNoGZkLVWx0eGjPbY8LJ6NfNL4w7xAI12ZqlaAHQ=;
        b=LGIzjGsc0aNxBZ32pT6ctULJYjQo5kHcdt3aWX4NzURQQzY9wAo5zNTKB9rm8QVb7+
         0OIG8w9o8z1kF+gw9DmMun98nZ2tEGvdMeVjfeiIK7n5uyWnj8J37BA7VykdtQOEX5zs
         qtyA417HTtXm7gx2STNakcI8EERp6scQcd5oGw9/VpAjPJ4an4Se1quTZWSKzpqyWUBA
         9pBJsEibNnMBhnRQ02U3Okoa++6f76ptruOXJyXrCbJ6nmYHqGAFwVgmPXaGEV02YMF1
         fw5BI4iPs0MigteYCxaGBpfMMjdMnOU0ymhD4Zr1gCMt3fOawAaDO6qQaijsq8DliS5X
         pG4g==
X-Gm-Message-State: AOAM532N6tatE1DvRV3f4flOQZ6+ISHsb26Iys5UKONzUG0fIhmSYqyh
        pF6zSNIbgIbZyapgO6APP/SEIsKw4Lk5wcuZdjzxcg==
X-Google-Smtp-Source: ABdhPJz67cGvGu69skBiSN6x005PF7+y4xxC1MQ0vAqDxwg7ksNn3OghNs9VED2b8vbGTgq+nRmAcHdYg24lqls6WKo=
X-Received: by 2002:a05:6830:14c5:: with SMTP id t5mr3948220otq.266.1621518672996;
 Thu, 20 May 2021 06:51:12 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 May 2021 19:21:01 +0530
Message-ID: <CA+G9fYtvmr09BwE79QzNxiauQtUD7tZhCAbVVH3Vv=anaqt-yA@mail.gmail.com>
Subject: bbpf_internal.h:102:22: error: format '%ld' expects argument of type
 'long int', but argument 3 has type 'int' [-Werror=format=]
To:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>, ast@fb.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The perf build failed on i386 on Linux next-20210519 and next-20210520 tag
 with gcc-7.3 due to below warnings / errors.

In file included from libbpf.c:55:0:
libbpf.c: In function 'init_map_slots':
libbpf_internal.h:102:22: error: format '%ld' expects argument of type
'long int', but argument 3 has type 'int' [-Werror=format=]
  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
                      ^
libbpf_internal.h:105:27: note: in expansion of macro '__pr'
 #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
                           ^~~~
libbpf.c:4568:4: note: in expansion of macro 'pr_warn'
    pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
    ^~~~~~~
libbpf.c:4568:44: note: format string is defined here
    pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
                                          ~~^
                                          %d
In file included from libbpf.c:55:0:
libbpf_internal.h:102:22: error: format '%ld' expects argument of type
'long int', but argument 5 has type 'int' [-Werror=format=]
  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
                      ^
libbpf_internal.h:105:27: note: in expansion of macro '__pr'
 #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
                           ^~~~
libbpf.c:4568:4: note: in expansion of macro 'pr_warn'
    pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
    ^~~~~~~
libbpf.c:4568:70: note: format string is defined here
    pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
                                                                    ~~^
                                                                    %d
  CC      /srv/oe/build/tmp-lkft-glibc/work/intel_core2_32-linaro-linux/perf/1.0-r9/perf-1.0/cpu.o
In file included from libbpf.c:55:0:
libbpf.c: In function 'bpf_core_apply_relo':
libbpf_internal.h:102:22: error: format '%ld' expects argument of type
'long int', but argument 3 has type 'int' [-Werror=format=]
  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
                      ^
libbpf_internal.h:105:27: note: in expansion of macro '__pr'
 #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
                           ^~~~
libbpf.c:6192:3: note: in expansion of macro 'pr_warn'
   pr_warn("// TODO core_relo: prog %ld insn[%d] %s %s kind %d\n",
   ^~~~~~~
libbpf.c:6192:38: note: format string is defined here
   pr_warn("// TODO core_relo: prog %ld insn[%d] %s %s kind %d\n",
                                    ~~^
                                    %d

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=lkft,MACHINE=intel-core2-32,label=docker-buster-lkft/1030/consoleText

--
Linaro LKFT
https://lkft.linaro.org
