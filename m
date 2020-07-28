Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4525E23122B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgG1THK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729168AbgG1THJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:07:09 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDDCC061794;
        Tue, 28 Jul 2020 12:07:09 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 11so19813321qkn.2;
        Tue, 28 Jul 2020 12:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a4k23v6u+Ynb9I+UZreRULUB5erdIyY4Rw8+D/r4YBg=;
        b=rzHKu3oiRxCv2rWjVM5ZT2ZfECTv55bKcEn0gOGRiBmvtND8mTEbnNMiLNxSDTS889
         VTBm52iBupzS6bnS07qgGUIQZJVUZYlZZFijnyrFr2eJl8fe0U+oJFUAU57Jm7FrnbJc
         iegIINWy6pTqFXKEat61aTh++Ah5z6gstdnrNic4u0Da3dV80oTEsqLB23Y7Kd3PT7CY
         zgRwvLoi3g1kQZnnrhiiDUBCR2K/moIZYx+Rp4AEvP3eBEVliFOqvDaCUFIfcwQkkNoe
         Q6noOUBjW1vNKAuq9qGfWIpeJfaaxsPy9lvdUiXnu0eHOVqgXda++KZ9b2aIWQnuB2ur
         7WTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a4k23v6u+Ynb9I+UZreRULUB5erdIyY4Rw8+D/r4YBg=;
        b=hicpyvuE0AvYDtysY6403lxtpdSTYvaIATpewSdtuGvxrcOUzTB1KvumHqZ8PBdLGR
         KSlx/ctD0UIqh2lhdCuEseRFqCVnd2dd03QwHKuhtoGO0Df0XgW+Dt2dlnZ2Id7Rzg9+
         lraC1U8nIBEBUaSsU0fUYtVlev+Pl4Gf9RUzq+TOzaWp3xSpA9XEIpIKjfUat6MHdD84
         QNqBK6azwWOWT+RQbN7qJCxSQvyaK6Al9tAbtpfSwmKMfqIKqOHGYcZlZxfj7ZcJf8HA
         J73nyp9rMj+EUHXykgqLcK2FLQgVjs7KxXlvZg6lSSbLb1p75UDZa93Yxu8G3AMVxu9m
         IGOQ==
X-Gm-Message-State: AOAM532O4UVczxNxnObDsaLM2UyMJwMI6JWHsy4uDCRkQb0COqwRuuNB
        H1Z2tEHZn4CRYfs9gwvqu+ZcbyDECiZ9xgv2JeQ=
X-Google-Smtp-Source: ABdhPJynywuwc/59HutV2Wmn/jRKU1gHMVeo7tUzFSE/COhAoW50C/APPJJa6wl5xuMZcvDGkNw4DcUaMD3g9MzD+rA=
X-Received: by 2002:a05:620a:4c:: with SMTP id t12mr3913142qkt.449.1595963228377;
 Tue, 28 Jul 2020 12:07:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200727232346.0106c375@canb.auug.org.au> <e342e8ce-db29-1603-3fd9-40792a783296@infradead.org>
 <CAEf4BzYD-PiA2cDvD5qRv7hHZ_GTDdKqAm1jfg2ZWBWM_3YO5w@mail.gmail.com> <f5613a75-efcb-93e6-e139-e16b87b373f5@infradead.org>
In-Reply-To: <f5613a75-efcb-93e6-e139-e16b87b373f5@infradead.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 12:06:57 -0700
Message-ID: <CAEf4BzbVxJG4WBC10sW7N0OJ9HAZGK4WTCp2GQVF6+UzVSqkrA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 27 (kernel/bpf/syscall.o)
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 11:01 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 7/27/20 10:48 PM, Andrii Nakryiko wrote:
> > On Mon, Jul 27, 2020 at 11:58 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> >>
> >> On 7/27/20 6:23 AM, Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20200724:
> >>>
> >>
> >> on i386:
> >> when CONFIG_XPS is not set/enabled:
> >>
> >> ld: kernel/bpf/syscall.o: in function `__do_sys_bpf':
> >> syscall.c:(.text+0x4482): undefined reference to `bpf_xdp_link_attach'
> >>
> >
> > I can't repro this on x86-64 with CONFIG_XPS unset. Do you mind
> > sharing the exact config you've used?
>
> No problem. I see this on i386 or x86_64. I am attaching the x86_64
> randconfig file instead of the i386 one.
>
> > I see that kernel/bpf/syscall.c doesn't include linux/netdevice.h
> > directly, so something must be preventing netdevice.h to eventually
> > get to bpf/syscall.c, but instead of guessing on the fix, I'd like to
> > repro it first. Thanks!
>
> The build failure was causing me to see lots of builds failing, so I made
> a simple patch so that I could get past this issue.  My patch follows.
> Feel free to fix it any way you like.
>

I was confused for a while by CONFIG_XPS, as nothing really depends on
it. So it turned out the real dependency is CONFIG_NET, which is also
unset in your random config. I just sent a fix, thanks for reporting
and sharing the config!


> Thanks.
> ---
> ---
>  kernel/bpf/syscall.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> --- mmotm-2020-0727-1818.orig/kernel/bpf/syscall.c
> +++ mmotm-2020-0727-1818/kernel/bpf/syscall.c
> @@ -3924,7 +3924,11 @@ static int link_create(union bpf_attr *a
>                 ret = netns_bpf_link_create(attr, prog);
>                 break;
>         case BPF_PROG_TYPE_XDP:
> +#ifdef CONFIG_XPS
>                 ret = bpf_xdp_link_attach(attr, prog);
> +#else
> +               ret = -EINVAL;
> +#endif
>                 break;
>         default:
>                 ret = -EINVAL;
>
