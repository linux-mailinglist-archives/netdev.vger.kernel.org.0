Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5D741F84A
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhJAXmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhJAXmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 19:42:35 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209A9C061775;
        Fri,  1 Oct 2021 16:40:51 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id s4so7393196ybs.8;
        Fri, 01 Oct 2021 16:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O1D8oZVXToA4pvTbmtzcpTG4TdrFZTbxyfGVdrjw1NU=;
        b=XbW9uSztHiQUZlFNG10H++5sMOElFvBpHj7ChPBOCf+ZOT9CCIn+ZgwzePuCd+et+q
         MG8AVqCbkVK4fjW+CPBMlfuAUAWbKp+f5OmETssk6G2Tf9VZ1oQMfqwCh9iuiErx2oHm
         NernIqFSDVgpJlw1BYQZ0K+DVX2BP1aNNiZHVzB0C/Wa73XxzP1AE2nHwl0TizUcDqjK
         fJlQ4bBCzRyFdstVOtF367Xsi0VoposIifzRFKLIDptn5/gHWytuk2ULA3Imt2Z1Asd+
         5IWUjv1N6Hyk8BgczoG/lUmRbaqylrQTS70lWAuwQgbgjpUpL15BeArFbN5lfgAHRw/u
         Targ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O1D8oZVXToA4pvTbmtzcpTG4TdrFZTbxyfGVdrjw1NU=;
        b=EKclcFJV6+kTgplWJIBMXQsuDw3Sv3UEteCChwCw0eWswCxl86RIeOoDJzMU+tePJg
         6LQNqTwhe/71FW9cFp4vRFq8XrsppOYcTt8mEocOY+uLcW67AfcnkPE0U0IEpcN4Y5Uo
         Hq59WvKcq0VmpCWy981r6FHrXvxdTTfjBJNXwK1NaQrw0zRM1LibUEZanX9+rGoqQW7A
         bsfR8TQEtFAPxEdBAqAiSIyGzB6c2IeHJbJTVkxqgHMzhQPXboj93xhdQ4FZayHL8Xr6
         vKD1C/No0b5fOKwbJdb5cithfM5jBYFrwRgifHhM+uXmX5Pe0LNqR5Q3jT80DpLEDWap
         lKiw==
X-Gm-Message-State: AOAM53353YIItTLpmZpZowFyu8VtDq4gg/eVe3m3dPdN80vrn4OkUbM6
        kxiLQVQB47z/pBKiZO7PqphbPaV5kCoc0KSswxU=
X-Google-Smtp-Source: ABdhPJzhyy/8maGjG3cBwiJhYueopV9Mytg/faKKrQpaPt3z/oeoK/2u0e30WMaVn15mDHYUnnHLH89U8Kj1NhyzUL4=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr692987ybj.504.1633131650405;
 Fri, 01 Oct 2021 16:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211001215858.1132715-1-joannekoong@fb.com> <20211001215858.1132715-4-joannekoong@fb.com>
In-Reply-To: <20211001215858.1132715-4-joannekoong@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 16:40:39 -0700
Message-ID: <CAEf4BzYdx9heDyPcXqVR4yhgoWj+Qg-v62UgLFY6WVd0qChH=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/3] bpf/selftests: Add xdp
 bpf_load_tcp_hdr_options tests
To:     Joanne Koong <joannekoong@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 3:04 PM Joanne Koong <joannekoong@fb.com> wrote:
>
> This patch adds tests for bpf_load_tcp_hdr_options used by xdp
> programs.
>
> test_xdp_tcp_hdr_options.c:
> - Tests ipv4 and ipv6 packets with TCPOPT_EXP and non-TCPOPT_EXP
> tcp options set. Verify that options can be parsed and loaded
> successfully.
> - Tests error paths: TCPOPT_EXP with invalid magic, option with
> invalid kind_len, non-existent option, invalid flags, option size
> smaller than kind_len, invalid packet
>
> Signed-off-by: Joanne Koong <joannekoong@fb.com>
> ---
>  .../bpf/prog_tests/xdp_tcp_hdr_options.c      | 158 ++++++++++++++
>  .../bpf/progs/test_xdp_tcp_hdr_options.c      | 198 ++++++++++++++++++
>  2 files changed, 356 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_options.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_tcp_hdr_options.c
>

[...]

> +static void check_opt_out(struct test_xdp_tcp_hdr_options *skel)
> +{
> +       struct bpf_test_option *opt_out;
> +       __u32 duration = 0;
> +
> +       opt_out = &skel->bss->exprm_opt_out;
> +       CHECK(opt_out->flags != opt_flags, "exprm flags",
> +             "flags = 0x%x", opt_out->flags);
> +       CHECK(opt_out->max_delack_ms != exprm_max_delack_ms, "exprm max_delack_ms",
> +             "max_delack_ms = 0x%x", opt_out->max_delack_ms);
> +       CHECK(opt_out->rand != exprm_rand, "exprm rand",
> +             "rand = 0x%x", opt_out->rand);
> +
> +       opt_out = &skel->bss->regular_opt_out;
> +       CHECK(opt_out->flags != opt_flags, "regular flags",
> +             "flags = 0x%x", opt_out->flags);
> +       CHECK(opt_out->max_delack_ms != regular_max_delack_ms, "regular max_delack_ms",
> +             "max_delack_ms = 0x%x", opt_out->max_delack_ms);
> +       CHECK(opt_out->rand != regular_rand, "regular rand",
> +             "rand = 0x%x", opt_out->rand);

Please use ASSERT_xxx() macros for new tests. CHECK()s are confusing
and actually require more typing and work to output actual arguments
that failed. In this case, you'd just write

ASSERT_EQ(opt_out->rand, regular_rand, "regular_rand");

And if they are not equal, ASSERT_EQ() will print actual values of
both opt_out->rand and regular_rand.

> +}
> +
> +void test_xdp_tcp_hdr_options(void)
> +{
> +       int err, prog_fd, prog_err_path_fd, prog_invalid_pkt_fd;
> +       struct xdp_ipv6_packet ipv6_pkt, invalid_pkt;
> +       struct test_xdp_tcp_hdr_options *skel;
> +       struct xdp_ipv4_packet ipv4_pkt;
> +       struct xdp_test_opt test_opt;
> +       __u32 duration, retval, size;
> +       char buf[128];
> +

[...]
