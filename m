Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F45424AAC
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 01:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbhJFXtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 19:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239804AbhJFXtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 19:49:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F268661131;
        Wed,  6 Oct 2021 23:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633564067;
        bh=8s+k4kTXB8ysVtN8Kdkqpl+R8UGBcoXNZufzIVBseTo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=m9dPP9kelPTwf+YzPS0dOEvqaVn1zeZSFjDGJAdiw1q+U0ibZyhZATSuvNOwzrIpX
         iINA4kmqgHPdg0YTbpIGduG0jYcyst5p4AuL/EDFxiK5zE/Bfbxn6+H+GRYjFykn30
         GZjIhfq0t2l7VrXBDUieimtoiYV3/JiLzyfFWjAib08gO9PcAnDTA6CrcfY252mU0w
         0PHFgy6cDJltZU+eN34fqrKWpPSV0S/jKPsR1mkg3nkufcGxjIPonuKlK9DBzYfzz/
         xbrY0yrUBLMq9FDfLLKNPSFdcLaJusE8gBqKPG4KP5HUNN581qnJwPXdbmfokYa/UB
         weO4QHdfKl0tQ==
Received: by mail-lf1-f41.google.com with SMTP id t9so16840539lfd.1;
        Wed, 06 Oct 2021 16:47:46 -0700 (PDT)
X-Gm-Message-State: AOAM533odY9Gf09Nzv2v17cGpS7ROZ5ny950K8aZmGC0UDjoN2kJnB5f
        7uy4GSIAjfnRjVmcZyp/vm0UE+G4madnRvoJ14A=
X-Google-Smtp-Source: ABdhPJxJYq2g75fn6j4k6+iEb6lsp3dVgZz3TXy4QciH/BbKriLwit2fZ1fEKDIiv+kNq4JxisTfdulhj6SSa3UskPo=
X-Received: by 2002:ac2:5182:: with SMTP id u2mr890749lfi.676.1633564065298;
 Wed, 06 Oct 2021 16:47:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211006230543.3928580-1-joannekoong@fb.com> <20211006230543.3928580-3-joannekoong@fb.com>
In-Reply-To: <20211006230543.3928580-3-joannekoong@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 6 Oct 2021 16:47:34 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6+ndDCBJuOJhubOf5c2_a2YwJYJ=DAzSFyjsJdB0fzHA@mail.gmail.com>
Message-ID: <CAPhsuW6+ndDCBJuOJhubOf5c2_a2YwJYJ=DAzSFyjsJdB0fzHA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf/selftests: Rename test_tcp_hdr_options
 to test_sockops_tcp_hdr_options
To:     Joanne Koong <joannekoong@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 4:14 PM Joanne Koong <joannekoong@fb.com> wrote:
>
> Currently, tcp_hdr_options is only supported for sockops type programs.
> This patchset adds xdp tcp_hdr_options support. To more easily
> differentiate between these two tests, this patch does the following
> renames (with  no functional changes):
>
> test_tcp_hdr_options -> test_sockops_tcp_hdr_options
> test_misc_tcp_hdr_options -> test_sockops_misc_tcp_hdr_options
>
> The next patch will add xdp_test_tcp_hdr_options.
>
> Signed-off-by: Joanne Koong <joannekoong@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

IIRC, I already acked 2/3 in v1, so you can include the Acked-by tag in v2.

Thanks,
Song

> ---
>  ...hdr_options.c => sockops_tcp_hdr_options.c} | 18 +++++++++---------
>  ...s.c => test_sockops_misc_tcp_hdr_options.c} |  0
>  ...ptions.c => test_sockops_tcp_hdr_options.c} |  0
>  3 files changed, 9 insertions(+), 9 deletions(-)
>  rename tools/testing/selftests/bpf/prog_tests/{tcp_hdr_options.c => sockops_tcp_hdr_options.c} (96%)
>  rename tools/testing/selftests/bpf/progs/{test_misc_tcp_hdr_options.c => test_sockops_misc_tcp_hdr_options.c} (100%)
>  rename tools/testing/selftests/bpf/progs/{test_tcp_hdr_options.c => test_sockops_tcp_hdr_options.c} (100%)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/tools/testing/selftests/bpf/prog_tests/sockops_tcp_hdr_options.c
> similarity index 96%
> rename from tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
> rename to tools/testing/selftests/bpf/prog_tests/sockops_tcp_hdr_options.c
> index 1fa772079967..f8fb12f4c1ed 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockops_tcp_hdr_options.c
> @@ -12,8 +12,8 @@
>  #include "cgroup_helpers.h"
>  #include "network_helpers.h"
>  #include "test_tcp_hdr_options.h"
> -#include "test_tcp_hdr_options.skel.h"
> -#include "test_misc_tcp_hdr_options.skel.h"
> +#include "test_sockops_tcp_hdr_options.skel.h"
> +#include "test_sockops_misc_tcp_hdr_options.skel.h"
>
>  #define LO_ADDR6 "::1"
>  #define CG_NAME "/tcpbpf-hdr-opt-test"
> @@ -25,8 +25,8 @@ static struct bpf_test_option exp_active_fin_in;
>  static struct hdr_stg exp_passive_hdr_stg;
>  static struct hdr_stg exp_active_hdr_stg = { .active = true, };
>
> -static struct test_misc_tcp_hdr_options *misc_skel;
> -static struct test_tcp_hdr_options *skel;
> +static struct test_sockops_misc_tcp_hdr_options *misc_skel;
> +static struct test_sockops_tcp_hdr_options *skel;
>  static int lport_linum_map_fd;
>  static int hdr_stg_map_fd;
>  static __u32 duration;
> @@ -570,15 +570,15 @@ static struct test tests[] = {
>         DEF_TEST(misc),
>  };
>
> -void test_tcp_hdr_options(void)
> +void test_sockops_tcp_hdr_options(void)
>  {
>         int i;
>
> -       skel = test_tcp_hdr_options__open_and_load();
> +       skel = test_sockops_tcp_hdr_options__open_and_load();
>         if (CHECK(!skel, "open and load skel", "failed"))
>                 return;
>
> -       misc_skel = test_misc_tcp_hdr_options__open_and_load();
> +       misc_skel = test_sockops_misc_tcp_hdr_options__open_and_load();
>         if (CHECK(!misc_skel, "open and load misc test skel", "failed"))
>                 goto skel_destroy;
>
> @@ -600,6 +600,6 @@ void test_tcp_hdr_options(void)
>
>         close(cg_fd);
>  skel_destroy:
> -       test_misc_tcp_hdr_options__destroy(misc_skel);
> -       test_tcp_hdr_options__destroy(skel);
> +       test_sockops_misc_tcp_hdr_options__destroy(misc_skel);
> +       test_sockops_tcp_hdr_options__destroy(skel);
>  }
> diff --git a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c b/tools/testing/selftests/bpf/progs/test_sockops_misc_tcp_hdr_options.c
> similarity index 100%
> rename from tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
> rename to tools/testing/selftests/bpf/progs/test_sockops_misc_tcp_hdr_options.c
> diff --git a/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c b/tools/testing/selftests/bpf/progs/test_sockops_tcp_hdr_options.c
> similarity index 100%
> rename from tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
> rename to tools/testing/selftests/bpf/progs/test_sockops_tcp_hdr_options.c
> --
> 2.30.2
>
