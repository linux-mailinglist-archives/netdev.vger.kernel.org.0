Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CB7488E9A
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 03:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbiAJCQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 21:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiAJCQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 21:16:47 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B700C06173F;
        Sun,  9 Jan 2022 18:16:47 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id s6so15693881ioj.0;
        Sun, 09 Jan 2022 18:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x59Bsdz00UuuK7CrUu0qSPeYM/0w695vGZHOVL5oxDw=;
        b=GctAjI1AzPKPYcU9URKAP2raqiTogkLOrbong4V/sIfaBzTEl2GvOPtC8aU1/F1Im4
         QE39EHGzLYTnokpWtsu44Fb7h7zmKPv+pugnqbfiAn+r6hbjh/FLdYiEv+SoUNY6a+1S
         5kh2yIbnBp3llv0J5uT+UAevlsyAlUVKdv+StMteJtmCeMRLWJHiv3Rbme49Bztdfk5H
         dwICCxegwZsyXNp2TTBWMvAwEe0XXoobpON9BTpM5t62IUmOIFgU4JWWLispA1Z0RH/K
         iJJ/x2Lc9gg80dgb3Z+pyVnWaujOnp48Blqk7MuXPjbx72YuR4mTtxMgxUIg0QJxnahu
         8gHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x59Bsdz00UuuK7CrUu0qSPeYM/0w695vGZHOVL5oxDw=;
        b=lgspyYwWJCB4FnSAuWFGXJNlweXKJicPR3W37jXWvXiOgajVWNOv0NztWlrywwrkIX
         Zc4iHiDxV5o3iPMF8IVqRCJ7A2thGTFnqxyrV1JS1S7qB7SwaBlXPg8siDQ0EFbEGz+3
         G4fK6P3ZJRUznvWZB1DNjQ/nj0fM6nzNLqskUYL+dMAawIYV52KLsKD/eeINdZvPt9kg
         Mzu1v8YcBqIDJ+Vjdz83064UAjKw5qcvySmmTa6mOvTBtiFD1PT5DObupjrNez3Or0i3
         xPsLeOKLg2RK/79wkTdBbH4PHune6yrr1tPTom8qFj1myWCuBUlG6lDuZ26uaB+N8KCj
         dBQg==
X-Gm-Message-State: AOAM531BNXfbOd1tVbAACeve4vzJsOdv8V2c9Mpbm8ZekVtWiY6yp9AQ
        9GNcgCUYNA5pjZ5fu1B9c1wHVgnOmD4NcCqzUSc=
X-Google-Smtp-Source: ABdhPJwGlQWEp3OigiEL/u6AlScXHwc4a0lJFK//WNiqGDhfvnmjwL4Y1QBaRtB3hb35NBZRfBcc/ycDO8DN/xymc/Q=
X-Received: by 2002:a05:6638:1193:: with SMTP id f19mr34813025jas.237.1641781006618;
 Sun, 09 Jan 2022 18:16:46 -0800 (PST)
MIME-Version: 1.0
References: <cover.1641641663.git.lorenzo@kernel.org> <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
In-Reply-To: <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 9 Jan 2022 18:16:35 -0800
Message-ID: <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce support for the following SEC entries for XDP multi-buff
> property:
> - SEC("xdp_mb/")
> - SEC("xdp_devmap_mb/")
> - SEC("xdp_cpumap_mb/")

Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
sleepable, seems like we'll have kprobe.multi or  something along
those lines as well), so let's stay consistent and call this "xdp_mb",
"xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
recognizable? would ".multibuf" be too verbose?). Also, why the "/"
part? Also it shouldn't be "sloppy" either. Neither expected attach
type should be optional.  Also not sure SEC_ATTACHABLE is needed. So
at most it should be SEC_XDP_MB, probably.

>
> Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7f10dd501a52..c93f6afef96c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -235,6 +235,8 @@ enum sec_def_flags {
>         SEC_SLEEPABLE = 8,
>         /* allow non-strict prefix matching */
>         SEC_SLOPPY_PFX = 16,
> +       /* BPF program support XDP multi-buff */
> +       SEC_XDP_MB = 32,
>  };
>
>  struct bpf_sec_def {
> @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
>         if (def & SEC_SLEEPABLE)
>                 opts->prog_flags |= BPF_F_SLEEPABLE;
>
> +       if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
> +               opts->prog_flags |= BPF_F_XDP_MB;

I'd say you don't even need SEC_XDP_MB flag at all, you can just check
that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
"xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
enough to warrant a flag.

> +
>         if ((prog->type == BPF_PROG_TYPE_TRACING ||
>              prog->type == BPF_PROG_TYPE_LSM ||
>              prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
> @@ -8600,8 +8605,11 @@ static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
>         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
>         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> +       SEC_DEF("xdp_devmap_mb/",       XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE | SEC_XDP_MB),
>         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> +       SEC_DEF("xdp_cpumap_mb/",       XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE | SEC_XDP_MB),
>         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> +       SEC_DEF("xdp_mb/",              XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX | SEC_XDP_MB),
>         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
>         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
>         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
> --
> 2.33.1
>
