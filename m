Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F8D2491DF
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgHSAmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHSAmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:42:10 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B64C061389;
        Tue, 18 Aug 2020 17:42:09 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id y134so12407692yby.2;
        Tue, 18 Aug 2020 17:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QNCt/jQvfZzMlOFbozneM3aGVKd5BcnhozhE8JQoC6g=;
        b=ITSsd4zAml6pOwyAgSJJ177nWodBVdJM3zc1Fj+aGKoM4WJQdX5BulHe6LV6c314nP
         HIo0uEaqiwrlOnV87ekaEN3Fs8a6CtEoejRZn9m2o2enB7WudhYZMvzWUQ4rRkYAdFrE
         mdzkBE0FZebVZ/2+OBg4OK/VvJELHVQsNo+lyK+5tvM4ZZF/48Pk9pMFxwLbSu20DKYu
         VBmFCVzq6t3PKuJkBtj2wM3VDryWU575RdVjU0QsE0HBUslKVExv+z74xwIBbWmDkWbi
         4vNqUnQ4bsKQmJIql8l9zvCyaSwTBPDggutIpLYI5jylrDIH+rT4yfcNvna4ZS8gYYH+
         219A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QNCt/jQvfZzMlOFbozneM3aGVKd5BcnhozhE8JQoC6g=;
        b=PxU4uUF0B/YF3DhlbhLvAH3n7hg+0jtzgJPDShz+1m38JPuMsG2+nKxsKgN0woEbPU
         yHxOsq5CG9EJJw7kJRlaxcgmzOVZp7cC8gfL3oSlvqGzQowDGIerwpO0o0vW6hLdUnu+
         6WBJsnCXCmoIhZjik79QaGo010R0bmm0jzmcFX+qT6qvapbZ64PX+zyOkSejtyoLsmbJ
         kuySbmazIwUv7QA8DPd6ApbQqBnYKi3MU5DUkwEmOrpZdW8fNb9Xct67Kd3MlBmpdVAk
         NOHWAdssJIRpWGfizTCuKyZI0H4ak5NmqB+qlGxmR7dzcY2ADx2M53vb6mSAgIi5tH1J
         VUAw==
X-Gm-Message-State: AOAM531+9z1pr/MdpKw8BtxUOECN6D4zyZDCF24rM2YjUhI8EymBGlZ5
        EP4r107LHryv0iziLXI3+67ISiBNmmavFH2/6kFbTtEVLX0=
X-Google-Smtp-Source: ABdhPJyFSB/Qk9DECtvUF/s787O7+VBr0DRxogEvCXlX1Os05iRb/Rv9+FvPFzAvvZhYibyqkQFO/rRjQV3LnNnSN7k=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr30569914ybm.425.1597797728836;
 Tue, 18 Aug 2020 17:42:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200818204325.26228-1-cneirabustos@gmail.com>
In-Reply-To: <20200818204325.26228-1-cneirabustos@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Aug 2020 17:41:57 -0700
Message-ID: <CAEf4Bzbd32RLcPThiXnmPYfBkN+eghWqAgHG5YfA6ovO88u7aQ@mail.gmail.com>
Subject: Re: [PATCH v5] bpf/selftests: fold test_current_pid_tgid_new_ns into test_progs.
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 1:44 PM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> This change folds a test case into test_progs.
>
> Changes from V4:
>  - Added accidentally removed blank space in Makefile.
>  - Added () around bit-shift operations.
>  - Fixed not valid C89 standard-compliant code.
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/.gitignore        |   2 +-
>  tools/testing/selftests/bpf/Makefile          |   2 +-
>  .../bpf/prog_tests/ns_current_pid_tgid.c      |  85 ----------
>  .../bpf/prog_tests/ns_current_pidtgid.c       |  55 ++++++
>  .../bpf/progs/test_ns_current_pid_tgid.c      |  37 ----
>  .../bpf/progs/test_ns_current_pidtgid.c       |  25 +++
>  .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
>  .../bpf/test_ns_current_pidtgid_newns.c       |  91 ++++++++++
>  8 files changed, 173 insertions(+), 283 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
>  delete mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
>  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
>  create mode 100644 tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
>
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index 1bb204cee853..022055f23592 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -30,8 +30,8 @@ test_tcpnotify_user
>  test_libbpf
>  test_tcp_check_syncookie_user
>  test_sysctl
> -test_current_pid_tgid_new_ns
>  xdping
> +test_ns_current_pidtgid_newns
>  test_cpp
>  *.skel.h
>  /no_alu32
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index e7a8cf83ba48..e308cc7c8598 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -37,7 +37,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>         test_cgroup_storage \
>         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
>         test_progs-no_alu32 \
> -       test_current_pid_tgid_new_ns
> +       test_ns_current_pidtgid_newns

Have you tried doing a parallel build with make -j$(nproc) or
something like that? It fails for me:

test_ns_current_pidtgid_newns.c:6:10: fatal error:
test_ns_current_pidtgid.skel.h: No such file or directory

 #include "test_ns_current_pidtgid.skel.h"

          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The problem seems to be that you haven't recorded dependency on the
skeleton file for this new test_ns_current_pidtgid_newns.

But rather than fixing it, let's just fold
test_ns_current_pidtgid_newns into test_progs as well? Then all such
issues will be handled automatically and this test will be executed
regularly.

>
>  # Also test bpf-gcc, if present
>  ifneq ($(BPF_GCC),)

[...]
