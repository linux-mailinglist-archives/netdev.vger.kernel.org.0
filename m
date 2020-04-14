Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E751A72FC
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 07:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405509AbgDNF2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 01:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729112AbgDNF2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 01:28:13 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945A0C0A3BDC;
        Mon, 13 Apr 2020 22:28:13 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id o19so4748064qkk.5;
        Mon, 13 Apr 2020 22:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ECPnL4O1esYaha2phRo52qP3NWwRwpdDhvP+yrOVz0=;
        b=eRaI2qWClNb1MJ+osv2y3a6+iV+30lVEwT4vmJkuWy1GS3X+crP4/WCoeBrebWrLin
         AmLETTMdji1IK0WwBowZHq8ih2UDi7QE10yil/26R+uGbe06/M4Iq3At3U68XIKcTVfJ
         f9Rbsbackb9j85iKzO1XZ2ywTHjBNm3yLxBJjRtTcaICosKnx5mqv16CZntyZ0WGKJ7s
         0m9CXLcIoB2k2NiSXPDruQG2m9gRdikJVWSGuVT0+hCsvjAASwAi5TP+XBFbtWWgF73e
         3ifPPCtYlxxAl9QX6gvQJU8RJC93+sD01CoQi2QNzbnFUKCKigFPZ/Y1pRnUBhnbGT7X
         nJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ECPnL4O1esYaha2phRo52qP3NWwRwpdDhvP+yrOVz0=;
        b=acxays+bsDMedH93ZebIiSvQXaS1L9iiSmu9MAbuiKxErk95/OBUjGc7nGLfqO0pl0
         y4p4HxMbb2JqVHeep/3HcjsssB8ZgQ4gDV1Ba7+bT/K8Zbe+NAYgOZHC4MtVMRSqffH+
         UhdcGRVfINTzw7+oTi2d/crwseB6DfuoXUxHfEV0lweGyyPreeMdvLXzcWLuxu/Jn18+
         WwAxsG0VI8ei8yJEJ6MAMuIT3qp1aNZjd9CGbkZ4IxDmB4m+LoKVhkFKtDWfDgWk8PS/
         IYAjCZ6kjLb/WbrfhbZoQpUdkBiefUgA41Yo3S+kI2rtaEx/AFXbysLO1A+0blJnF3PN
         tu6w==
X-Gm-Message-State: AGi0PuYZYHNPVjllRT7o0ys+tW43dvwxFSpoPjU7y8pLem/i+vLrX4HV
        3PBO7i0we0bn3v1CtslrXau6i5XOFSyMRJthjUg=
X-Google-Smtp-Source: APiQypIHMXkUdwTT/Ut6IKNMNfAaySG9eyUwhzJX1tx3/FUGFCNky1PX5WCfea9goIZknFY93zVRj3LXooMogKZv63g=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr19633421qkg.36.1586842092674;
 Mon, 13 Apr 2020 22:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232531.2676134-1-yhs@fb.com>
In-Reply-To: <20200408232531.2676134-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 22:28:01 -0700
Message-ID: <CAEf4Bzb_q5XsZKu9gDJO__hOHCrGfmw5-vz4qPyNtk13CZ=Zdg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 09/16] bpf: add bpf_seq_printf and
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

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Two helpers bpf_seq_printf and bpf_seq_write, are added for
> writing data to the seq_file buffer.
>
> bpf_seq_printf supports common format string flag/width/type
> fields so at least I can get identical results for
> netlink and ipv6_route targets.
>
> For bpf_seq_printf, return value 1 specifically indicates
> a write failure due to overflow in order to differentiate
> the failure from format strings.
>
> For seq_file show, since the same object may be called
> twice, some bpf_prog might be sensitive to this. With return
> value indicating overflow happens the bpf program can
> react differently.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/uapi/linux/bpf.h       |  18 +++-
>  kernel/trace/bpf_trace.c       | 172 +++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |   2 +
>  tools/include/uapi/linux/bpf.h |  18 +++-
>  4 files changed, 208 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b51d56fc77f9..a245f0df53c4 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3030,6 +3030,20 @@ union bpf_attr {
>   *             * **-EOPNOTSUPP**       Unsupported operation, for example a
>   *                                     call from outside of TC ingress.
>   *             * **-ESOCKTNOSUPPORT**  Socket type not supported (reuseport).
> + *
> + * int bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size, ...)
> + *     Description
> + *             seq_printf
> + *     Return
> + *             0 if successful, or
> + *             1 if failure due to buffer overflow, or
> + *             a negative value for format string related failures.

This encoding feels a bit arbitrary, why not stick to normal error
codes and return, for example, EAGAIN on overflow (or EOVERFLOW?..)

> + *
> + * int bpf_seq_write(struct seq_file *m, const void *data, u32 len)
> + *     Description
> + *             seq_write
> + *     Return
> + *             0 if successful, non-zero otherwise.

Especially given that bpf_seq_write will probably return <0 on the same error?

>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3156,7 +3170,9 @@ union bpf_attr {
>         FN(xdp_output),                 \
>         FN(get_netns_cookie),           \
>         FN(get_current_ancestor_cgroup_id),     \
> -       FN(sk_assign),
> +       FN(sk_assign),                  \
> +       FN(seq_printf),                 \
> +       FN(seq_write),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index ca1796747a77..e7d6ba7c9c51 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -457,6 +457,174 @@ const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>         return &bpf_trace_printk_proto;
>  }
>
> +BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size, u64, arg1,
> +          u64, arg2)
> +{

I honestly didn't dare to look at implementation below, but this
limitation of only up to 2 arguments in bpf_seq_printf (arg1 and arg2)
seem extremely limiting. It might be ok for bpf_printk, but not for
more general and non-debugging bpf_seq_printf.

How about instead of passing arguments as 4th and 5th argument,
bpf_seq_printf would require passing a pointer to a long array, where
each item corresponds to printf argument? So on BPF program side, one
would have to do this, to printf 5 arguments;

long __tmp_arr[] = { 123, pointer_to_str, some_input_int,
some_input_long, 5 * arg_x };
return bpf_seq_printf(m, fmt, fmt_size, &__tmp_arr, sizeof(__tmp_arr));

And the bpf_seq_printf would know that 4th argument is a pointer to an
array of size provided in 5th argument and process them accordingly.
This would theoretically allow to have arbitrary number of arguments.
This local array construction can be abstracted into macro, of course.
Would something like this be possible?

[...]

> +/* Horrid workaround for getting va_list handling working with different
> + * argument type combinations generically for 32 and 64 bit archs.
> + */
> +#define __BPF_SP_EMIT()        __BPF_ARG2_SP()
> +#define __BPF_SP(...)                                                  \
> +       seq_printf(m, fmt, ##__VA_ARGS__)
> +
> +#define __BPF_ARG1_SP(...)                                             \
> +       ((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))        \
> +         ? __BPF_SP(arg1, ##__VA_ARGS__)                               \
> +         : ((mod[0] == 1 || (mod[0] == 0 && __BITS_PER_LONG == 32))    \
> +             ? __BPF_SP((long)arg1, ##__VA_ARGS__)                     \
> +             : __BPF_SP((u32)arg1, ##__VA_ARGS__)))
> +
> +#define __BPF_ARG2_SP(...)                                             \
> +       ((mod[1] == 2 || (mod[1] == 1 && __BITS_PER_LONG == 64))        \
> +         ? __BPF_ARG1_SP(arg2, ##__VA_ARGS__)                          \
> +         : ((mod[1] == 1 || (mod[1] == 0 && __BITS_PER_LONG == 32))    \
> +             ? __BPF_ARG1_SP((long)arg2, ##__VA_ARGS__)                \
> +             : __BPF_ARG1_SP((u32)arg2, ##__VA_ARGS__)))

hm... wouldn't this make it impossible to print 64-bit numbers on
32-bit arches? It seems to be truncating to 32-bit unconditionally....

> +
> +       __BPF_SP_EMIT();
> +       return seq_has_overflowed(m);
> +}
> +

[...]
