Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DF641F7CB
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356070AbhJAW4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356044AbhJAW4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B21361AAB;
        Fri,  1 Oct 2021 22:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633128857;
        bh=zPKOut12759YrChMuTsMoqBL59Wp8+ZSlMnE3nY7Hxw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VT3UcaoD0bONpz3zAVK8zSuDtpknlVnI5yYKDwVx7/cUcUSzyhmKj2vYqWciZMzfF
         Vep+sTEsGejsrNs2ZL3oGrV+6vHVJ7vgZhDFV6Et67KY5vbJkWFlic813njFqu7hlK
         DC4tRYUxMrV8C7BxpMQsp4HhQ/uCpxrxplrDKR0STPuV+kshBTx/WrdojZiOqh8olI
         /1IsagfWsqLniUT+OSyQGMqImpo4CSfkHpZgo23E+/tY3XShDEx4yjCnhN6TWDxa34
         jjjBv/LFKnByWUVbHDPzqLufvx9fkk7f6vQdThgHVpOb2TzHwDwKOEDIba2zWXcKrB
         cXU4LNAxCIuPQ==
Received: by mail-lf1-f49.google.com with SMTP id m3so43776621lfu.2;
        Fri, 01 Oct 2021 15:54:17 -0700 (PDT)
X-Gm-Message-State: AOAM533auYCfv6NE/GJC5fZN4gPrTMMUYXX1hhiyRUBMKsti1LQloYNY
        jnK2D5l229Z67wu3+wxc/u/H1WfGzenYK7SMxro=
X-Google-Smtp-Source: ABdhPJz4ppbI+kmM0q97fUCL90jYIsKhzNAxoWSGqixPtk52OrSSKcXX3dWQlNFUNfbwvN9eO9jExFI/tYp4ZVaUgqs=
X-Received: by 2002:ac2:5182:: with SMTP id u2mr615797lfi.676.1633128855585;
 Fri, 01 Oct 2021 15:54:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211001215858.1132715-1-joannekoong@fb.com> <20211001215858.1132715-3-joannekoong@fb.com>
In-Reply-To: <20211001215858.1132715-3-joannekoong@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 1 Oct 2021 15:54:04 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5fUA84rZgVMuFgsqDDDtJkMgH3E49RShnfa3-rVKTvaA@mail.gmail.com>
Message-ID: <CAPhsuW5fUA84rZgVMuFgsqDDDtJkMgH3E49RShnfa3-rVKTvaA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 2/3] bpf/selftests: Rename test_tcp_hdr_options
 to test_sockops_tcp_hdr_options
To:     Joanne Koong <joannekoong@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 3:03 PM Joanne Koong <joannekoong@fb.com> wrote:
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
