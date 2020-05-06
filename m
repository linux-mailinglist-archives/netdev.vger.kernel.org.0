Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2409B1C6763
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 07:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgEFFV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 01:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725771AbgEFFV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 01:21:57 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDF2C061A0F;
        Tue,  5 May 2020 22:21:57 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id j2so405228qtr.12;
        Tue, 05 May 2020 22:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pv+HrQ8QZJZWWwdQFbQldF8NsVO28BKs1xF18zhP+u4=;
        b=p8A1ZZUcYigjVr0O4HQPGSbor+9rco8hNU0bGEoUXo6hmGNYtVP+z3DWd5ZpRX9C+X
         nxougCmtzeDODBT/CY1VlDbYfGe+cD1P8bJ+qIcP2cKsppdM9bA9UrKSPvvMWB0wHuTX
         XDjCGJKTavUUHPOHB0vYuQrs7PtPojSgNHPWY0/KPVhT9sB6fFaicXlHluyS5JNCY2v/
         U3FKW6xwB2gJDuW06lafxeXQC+P1J/ujXoTLdf7SiCVl/0if4Q9Q8BWYYrVWrXnnSPGJ
         kfZLk7g2AF0Aw6CTvzeZrvhxxbRva1n40Yz+67ZXDBnfGQsAvbhjR2MRIPB/MqWrZNEX
         h5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pv+HrQ8QZJZWWwdQFbQldF8NsVO28BKs1xF18zhP+u4=;
        b=IkripkaUUzEDFWovN2Vt83hKCU7ap/IhTCGhmrLA/5zFV2lebFMDWYrbea3kDiFEwy
         akQfsyLdn/5QLnp1YHjLL9ntLBnFDPDSg58ixAewOr5HaiYAHhl7vyU+JUw/owHtWaba
         pZiUuDQVuZCoT1zClt2D8A60GvXhbk/3MpNBvVlpgsKivTKqzBB4Ly67atP+4JP0aiT9
         H88XJAV0btuvfvIegsbOss+Ct6fDX8pwQ56ddN/rTT+WXC7EGuEFjXW644/00ebrmdyE
         KnddJCI6QDu8xSWZKqr5nuf+UZ/nH8inWawHZvqUGKI/R5ETP47uAi+7S9uldB2R7y9J
         C73A==
X-Gm-Message-State: AGi0PuasRO7grI8P8P4/1dYNHq7kwvOkTzW6QrbkeSMMzWA6D7nhKRkS
        zZ96PL4tK3xQ1zMqIxnVj2bMGvjXTPnS0VCaj/M=
X-Google-Smtp-Source: APiQypIH8zDlUBDSMfYUJXR3ewdsKUlxrKN7m8ESwWhC/5zkfXrCthkBa5DIqtLpuC17Cv7b82aPIHB/SJdtWUU+fXU=
X-Received: by 2002:ac8:51d3:: with SMTP id d19mr4169497qtn.141.1588742516671;
 Tue, 05 May 2020 22:21:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062558.2048168-1-yhs@fb.com>
In-Reply-To: <20200504062558.2048168-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 22:21:45 -0700
Message-ID: <CAEf4BzbtR71iWPdNmjy0kvfQC4xQr+MFe6Vh2k6Kzu0cfsVVzg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 10/20] net: bpf: add netlink and ipv6_route
 bpf_iter targets
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

On Sun, May 3, 2020 at 11:29 PM Yonghong Song <yhs@fb.com> wrote:
>
> This patch added netlink and ipv6_route targets, using
> the same seq_ops (except show() and minor changes for stop())
> for /proc/net/{netlink,ipv6_route}.
>
> The net namespace for these targets are the current net
> namespace at file open stage, similar to
> /proc/net/{netlink,ipv6_route} reference counting
> the net namespace at seq_file open stage.
>
> Since module is not supported for now, ipv6_route is
> supported only if the IPV6 is built-in, i.e., not compiled
> as a module. The restriction can be lifted once module
> is properly supported for bpf_iter.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  fs/proc/proc_net.c       | 19 +++++++++
>  include/linux/proc_fs.h  |  3 ++
>  net/ipv6/ip6_fib.c       | 65 +++++++++++++++++++++++++++++-
>  net/ipv6/route.c         | 27 +++++++++++++
>  net/netlink/af_netlink.c | 87 +++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 197 insertions(+), 4 deletions(-)
>

[...]

>  int __init ip6_route_init(void)
>  {
>         int ret;
> @@ -6455,6 +6474,14 @@ int __init ip6_route_init(void)
>         if (ret)
>                 goto out_register_late_subsys;
>
> +#if IS_BUILTIN(CONFIG_IPV6)
> +#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
> +       ret = bpf_iter_register();
> +       if (ret)
> +               goto out_register_late_subsys;

Seems like bpf_iter infra is missing unregistering API.
ip6_route_init(), if fails, undoes all the registrations, so probably
should also unregister ipv6_route target as well?

> +#endif
> +#endif
> +
>         for_each_possible_cpu(cpu) {
>                 struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
>

[...]

> +static void netlink_seq_stop(struct seq_file *seq, void *v)
> +{
> +       struct bpf_iter_meta meta;
> +       struct bpf_prog *prog;
> +
> +       if (!v) {
> +               meta.seq = seq;
> +               prog = bpf_iter_get_info(&meta, true);
> +               if (prog)
> +                       netlink_prog_seq_show(prog, &meta, v);

nit: netlink_prog_seq_show() can return failure (from BPF program),
but you are not returning it. Given seq_file's stop is not supposed to
fail, you can explicitly cast result to (void)? I think it's done in
few other places in BPF code, when return result is explicitly
ignored.


> +       }
> +
> +       netlink_native_seq_stop(seq, v);
> +}
> +#else

[...]
