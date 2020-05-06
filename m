Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFEF1C7817
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgEFRhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 13:37:18 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEDDC061A0F;
        Wed,  6 May 2020 10:37:17 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id ep1so1186121qvb.0;
        Wed, 06 May 2020 10:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xGQ1yPvQQ2d4yvO8gdt7qP/fesK+KhSPBz1cJgt/Fi8=;
        b=p5htD8f6a1n0wY4Jrj+ZCOU9SNlOYr4wlPux+phOYLxaCTKigviRybNj9mETW6lH1d
         2Uc3Rtx2y4eZcnTmyfKRDUL4moSWezV+r0q8yFnLcklFiYvkda2ROWfHD32pxXmHpbwJ
         Fh9tAnclKYh/imRJSIrZm/KPXbEMVZ+5FYXOdxqCYSX5GR9zZqikorfCrESi3sSjP/22
         Dn6qedSrNJKtMrO4OVr59Su94gaLrvBANOUDlVXptgvsT+/GlY95vzUiQPG9N6gFaqBt
         WgkCaD19S93TIes+R1UgycBwB2n2Mn6PPXfQaW3nBGth+p3vVJRO1QRQ+YHDALBrkyz6
         guuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xGQ1yPvQQ2d4yvO8gdt7qP/fesK+KhSPBz1cJgt/Fi8=;
        b=lrkHzJJhmatHUxGmbn447FpG7HUPM58VMe/90lUMHuWnT45Yz7TRRW5weWfQlIP+l2
         05w+vjzB24jAmgAw/D8t6xCNEX+sGeMuMiQt+IZXkcE4nUxCkV7or73fbeQ8wuN7OnJf
         C0987eDhORrVb1YCv8TlCyFPJD/cZMCQumKH9ElXBGBwWeIryrF8AlUZ2mtawTxV7Ehp
         xd2717ibL3qZ9gw4B3Qeaywff5S0kHR6FZuxaWbWWeAy5xQFn6WxymT65c3YmvYsk+jL
         JmSdsHMk1X/6rl6P09b1bKKKFYuXrIbiT8H2j3Dj2setHK8fjfksyU+2kWDEP1WsRbGz
         EHBw==
X-Gm-Message-State: AGi0PuaoeEP/rbRByPZ7+tEUQCYFQDlR/Cq5/9/xZAUCjsrHFMTlSsM4
        LleSr2NhjA5b2O+eP4zcBPiNPxpVi5PH/kiiSRc=
X-Google-Smtp-Source: APiQypJNrTQqVgeCfmB2Fgzz3cOX0vvjdesEjI2sB2q1Haxlem+GAPwMgVEx3W0bheLpcqqECoimkbhXEFD3QBe6yNg=
X-Received: by 2002:a0c:a892:: with SMTP id x18mr9048466qva.247.1588786636546;
 Wed, 06 May 2020 10:37:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062602.2048597-1-yhs@fb.com>
In-Reply-To: <20200504062602.2048597-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 May 2020 10:37:05 -0700
Message-ID: <CAEf4Bzb-COkgcLB=HK4ahtnEFD7QGY0s=Qb-kWTBKK56319JAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 13/20] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Two helpers bpf_seq_printf and bpf_seq_write, are added for
> writing data to the seq_file buffer.
>
> bpf_seq_printf supports common format string flag/width/type
> fields so at least I can get identical results for
> netlink and ipv6_route targets.
>

Does seq_printf() has its own format string specification? Is there
any documentation explaining? I was confused by few different checks
below...

> For bpf_seq_printf and bpf_seq_write, return value -EOVERFLOW
> specifically indicates a write failure due to overflow, which
> means the object will be repeated in the next bpf invocation
> if object collection stays the same. Note that if the object
> collection is changed, depending how collection traversal is
> done, even if the object still in the collection, it may not
> be visited.
>
> bpf_seq_printf may return -EBUSY meaning that internal percpu
> buffer for memory copy of strings or other pointees is
> not available. Bpf program can return 1 to indicate it
> wants the same object to be repeated. Right now, this should not
> happen on no-RT kernels since migrate_enable(), which guards
> bpf prog call, calls preempt_enable().

You probably meant migrate_disable()/preempt_disable(), right? But
could it still happen, at least due to NMI? E.g., perf_event BPF
program gets triggered during bpf_iter program execution? I think for
perf_event_output function, we have 3 levels, for one of each possible
"contexts"? Should we do something like that here as well?

>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/uapi/linux/bpf.h       |  32 +++++-
>  kernel/trace/bpf_trace.c       | 195 +++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |   2 +
>  tools/include/uapi/linux/bpf.h |  32 +++++-
>  4 files changed, 259 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 97ceb0f2e539..e440a9d5cca2 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3076,6 +3076,34 @@ union bpf_attr {
>   *             See: clock_gettime(CLOCK_BOOTTIME)
>   *     Return
>   *             Current *ktime*.
> + *

[...]

> +BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
> +          const void *, data, u32, data_len)
> +{
> +       int err = -EINVAL, fmt_cnt = 0, memcpy_cnt = 0;
> +       int i, buf_used, copy_size, num_args;
> +       u64 params[MAX_SEQ_PRINTF_VARARGS];
> +       struct bpf_seq_printf_buf *bufs;
> +       const u64 *args = data;
> +
> +       buf_used = this_cpu_inc_return(bpf_seq_printf_buf_used);
> +       if (WARN_ON_ONCE(buf_used > 1)) {
> +               err = -EBUSY;
> +               goto out;
> +       }
> +
> +       bufs = this_cpu_ptr(&bpf_seq_printf_buf);
> +
> +       /*
> +        * bpf_check()->check_func_arg()->check_stack_boundary()
> +        * guarantees that fmt points to bpf program stack,
> +        * fmt_size bytes of it were initialized and fmt_size > 0
> +        */
> +       if (fmt[--fmt_size] != 0)

If we allow fmt_size == 0, this will need to be changed.

> +               goto out;
> +
> +       if (data_len & 7)
> +               goto out;
> +
> +       for (i = 0; i < fmt_size; i++) {
> +               if (fmt[i] == '%' && (!data || !data_len))

So %% escaping is not supported?

> +                       goto out;
> +       }
> +
> +       num_args = data_len / 8;
> +
> +       /* check format string for allowed specifiers */
> +       for (i = 0; i < fmt_size; i++) {
> +               if ((!isprint(fmt[i]) && !isspace(fmt[i])) || !isascii(fmt[i]))

why these restrictions? are they essential?

> +                       goto out;
> +
> +               if (fmt[i] != '%')
> +                       continue;
> +
> +               if (fmt_cnt >= MAX_SEQ_PRINTF_VARARGS) {
> +                       err = -E2BIG;
> +                       goto out;
> +               }
> +
> +               if (fmt_cnt >= num_args)
> +                       goto out;
> +
> +               /* fmt[i] != 0 && fmt[last] == 0, so we can access fmt[i + 1] */
> +               i++;
> +
> +               /* skip optional "[0+-][num]" width formating field */
> +               while (fmt[i] == '0' || fmt[i] == '+'  || fmt[i] == '-')

There could be space as well, as an alternative to 0.

> +                       i++;
> +               if (fmt[i] >= '1' && fmt[i] <= '9') {
> +                       i++;
> +                       while (fmt[i] >= '0' && fmt[i] <= '9')
> +                               i++;
> +               }
> +
> +               if (fmt[i] == 's') {
> +                       /* disallow any further format extensions */
> +                       if (fmt[i + 1] != 0 &&
> +                           !isspace(fmt[i + 1]) &&
> +                           !ispunct(fmt[i + 1]))
> +                               goto out;

I'm not sure I follow this check either. printf("%sbla", "whatever")
is a perfectly fine format string. Unless seq_printf has some
additional restrictions?

> +
> +                       /* try our best to copy */
> +                       if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
> +                               err = -E2BIG;
> +                               goto out;
> +                       }
> +

[...]

> +
> +static int bpf_seq_printf_btf_ids[5];
> +static const struct bpf_func_proto bpf_seq_printf_proto = {
> +       .func           = bpf_seq_printf,
> +       .gpl_only       = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> +       .arg2_type      = ARG_PTR_TO_MEM,
> +       .arg3_type      = ARG_CONST_SIZE,

It feels like allowing zero shouldn't hurt too much?

> +       .arg4_type      = ARG_PTR_TO_MEM_OR_NULL,
> +       .arg5_type      = ARG_CONST_SIZE_OR_ZERO,
> +       .btf_id         = bpf_seq_printf_btf_ids,
> +};
> +
> +BPF_CALL_3(bpf_seq_write, struct seq_file *, m, const void *, data, u32, len)
> +{
> +       return seq_write(m, data, len) ? -EOVERFLOW : 0;
> +}
> +
> +static int bpf_seq_write_btf_ids[5];
> +static const struct bpf_func_proto bpf_seq_write_proto = {
> +       .func           = bpf_seq_write,
> +       .gpl_only       = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> +       .arg2_type      = ARG_PTR_TO_MEM,
> +       .arg3_type      = ARG_CONST_SIZE,

Same, ARG_CONST_SIZE_OR_ZERO?

> +       .btf_id         = bpf_seq_write_btf_ids,
> +};
> +

[...]
