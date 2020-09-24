Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EB62779E5
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIXUHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXUHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 16:07:07 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6696C0613DB;
        Thu, 24 Sep 2020 13:07:06 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 133so319411ybg.11;
        Thu, 24 Sep 2020 13:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hxxs+CqXcjzm9/10GBg9XlC9NqGhBburIqZkxr+CoV8=;
        b=jkfFyBy5F7W6SajVgcBWXvhYr0siwPrZDyQTul52gwHaJSpDujlWFcyfnTRcxfK7Zl
         k/ZoFiZn2T77LnBPFYuRlRMSitk7QjurNG5AbvXdd1gt0j6ZJn+PaLUMLcurYeNAo5ZT
         i8P1udJVPuWUFchTpoYIr8Lj8wtrZBreTJqDCKGl1FzkYHbQ1z3Ni+gWJWovM36i5Slr
         DoXlZGPsXywGDB/Mum59MY5ilKuyFpw8gLLS4+eZ+9dpOjAxx/EUyRWCF+VAkEQ5CrUY
         myKYwOVlJexRtJrgZ7+oPTU8rciCSVO4axVcR3Qn+hoXDMctjUeG4kuSm9ubBnvmOrYx
         gNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hxxs+CqXcjzm9/10GBg9XlC9NqGhBburIqZkxr+CoV8=;
        b=M+Hd9T75STE0ikO0E1g5hjFZw264bps0dazpk2zAzyQeVs+r8iEwtWX4Ed42t3dkFB
         H8t+PR6Ht/tyI8ynqHZluZdWUx2XcnzcGl4Eh49iGPZY9lLzWaOmlQEtmUnakqZ+WtIY
         rImL0vqF+BwMfl+bsC5bcaMpGPeABuhivKDOSFPw6zZzeRFcydLaxliLVB/v8IggYqj2
         IpIbH8NPSlA+aut7D5+gd7BniepM5GUvI2UmKdmQJ7ALu4P7kjPS01lUanijOB2itAfN
         KoHYkVtZIuxBzdJtVwP1ja5jGAh0PmGJXUU1wIKGXyjDrr2nxFnchx+rFzA8moYLCemF
         URlw==
X-Gm-Message-State: AOAM533EPQwxI/k2RWfO/SE9Xv7fNgmGOBqGQM5hH1eZo7cHheqsXN1i
        yyC9Ev0CCDdVeH+rKFJCuHi3ZKI/lfUKpd4HoapUld99+sJHnQ==
X-Google-Smtp-Source: ABdhPJx/XbdBBOZH2228ESnVTc9FrG455E/cvUwJSbWLsxMkwlh+/YWOCAId8ErvGtmCiTlnRPfrVdBrKwaXRAlzvtA=
X-Received: by 2002:a25:cbc4:: with SMTP id b187mr704368ybg.260.1600978026182;
 Thu, 24 Sep 2020 13:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200924011951.408313-1-songliubraving@fb.com> <20200924011951.408313-3-songliubraving@fb.com>
In-Reply-To: <20200924011951.408313-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 13:06:55 -0700
Message-ID: <CAEf4BzZqQ3EA8Po7Jjash3hAjT_e-u2QmfjsQqoC+obZXLakrw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/3] libbpf: support test run of raw
 tracepoint programs
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 6:45 PM Song Liu <songliubraving@fb.com> wrote:
>
> Add bpf_prog_test_run_opts() with support of new fields in bpf_attr.test,
> namely, flags and cpu. Also extend _opts operations to support outputs via
> opts.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  tools/lib/bpf/bpf.c             | 31 +++++++++++++++++++++++++++++++
>  tools/lib/bpf/bpf.h             | 26 ++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.map        |  1 +
>  tools/lib/bpf/libbpf_internal.h |  5 +++++
>  4 files changed, 63 insertions(+)
>

[...]

>  static int bpf_obj_get_next_id(__u32 start_id, __u32 *next_id, int cmd)
>  {
>         union bpf_attr attr;
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 8c1ac4b42f908..4f13ec4323aff 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -251,6 +251,32 @@ struct bpf_prog_bind_opts {
>
>  LIBBPF_API int bpf_prog_bind_map(int prog_fd, int map_fd,
>                                  const struct bpf_prog_bind_opts *opts);
> +
> +struct bpf_test_run_opts {
> +       size_t sz; /* size of this struct for forward/backward compatibility */
> +       int repeat;
> +       const void *data_in;
> +       __u32 data_size_in;
> +       void *data_out;      /* optional */
> +       __u32 data_size_out; /* in: max length of data_out
> +                             * out: length of data_out
> +                             */
> +       __u32 retval;        /* out: return code of the BPF program */
> +       __u32 duration;      /* out: average per repetition in ns */
> +       const void *ctx_in; /* optional */
> +       __u32 ctx_size_in;
> +       void *ctx_out;      /* optional */
> +       __u32 ctx_size_out; /* in: max length of ctx_out
> +                            * out: length of cxt_out
> +                            */
> +       __u32 flags;
> +       __u32 cpu;
> +};

lots of holes in there, let's reorder (it doesn't have to match the
order in bpf_attr):

      size_t sz; /* size of this struct for forward/backward compatibility */

      const void *data_in;
      void *data_out;
      __u32 data_size_in;
      __u32 data_size_out;

      const void *ctx_in;
      void *ctx_out;
      __u32 ctx_size_in;
      __u32 ctx_size_out;

      __u32 retval;
      int repeat;
      __u32 duration;
      __u32 flags;
      __u32 cpu;

?

> +#define bpf_test_run_opts__last_field cpu
> +
> +LIBBPF_API int bpf_prog_test_run_opts(int prog_fd,
> +                                     struct bpf_test_run_opts *opts);
> +
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif

[...]
