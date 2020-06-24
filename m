Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C30D206D2E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 09:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389383AbgFXG76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 02:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388568AbgFXG75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 02:59:57 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F856C061573;
        Tue, 23 Jun 2020 23:59:52 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id v19so887484qtq.10;
        Tue, 23 Jun 2020 23:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SX0LkdckOxLVzccpso8HMeVTakB6cir0xF7K9saKPIY=;
        b=YGqOcSP2oAtE5odrudLj+tHnhO6dwPgzln7AI1N4pSibHdMGZBB5QJjtb9J2jXaeyN
         2mqKmM+qNIWf2O0Le9t+fbbeXp8oWZz4LiKdy6a9yKPp47aYhs8wGEcsBAgAg8XLcTo3
         lUNGQ34LOzVsjOpD9lZE8dU9eD0xirp1lkB6m7TlAMT+WX0n2eGsvItE8jOg90CN3JI2
         MxGn25/AEwuBZ9ApK2dSZVy5c5568i1s1oePl8T3AhuLHzCLc7IeoGm/CY2n6U7bt3hP
         O6VW5NiwuqwAhSFPAQMLrkmaVpeTw13AjJCMDWYslmVOaH4klPfQng6VCsN4kLYtaJy1
         RrGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SX0LkdckOxLVzccpso8HMeVTakB6cir0xF7K9saKPIY=;
        b=IMIJXz+bF0afEMHZUj7KYGx6uGxEPoPEZXblmAXBGKR+/2raLgJ5pv4G4MER4rkIfa
         qJcUkqo5WWJ0a/WCMTEMoQQ0N+3rJ2CvhjuQlsmrhwpBAtXtonNYwQx0fSeNVZZbBjFc
         AAEjT/o+qoEideHm0uTPpmQajjh6qGJJUp5hKJNguLSSUB1m4BaQsc/jIzBaTlk1QJnW
         Se7X/e443Ch3AcySPu4xDBOyZSt3Z8r8s4FeIbBajAGyqDJOV6iv4VCiBAhMYCT4pyRC
         DDgV4GDhDsBAtsEinlTT1wM5kxc8znNskck8Sbct44l0JWieq8rGI6qY9iA+CfrEjBGM
         8e8g==
X-Gm-Message-State: AOAM532dBzqToI5xYCkR5lbknWD9q7uWqOIBbQf7KahrG9+cYCcuYNbx
        vpRmK0fp+aTwqJWJ6PRXG6m4ZwnyhKOzdfwqIs8=
X-Google-Smtp-Source: ABdhPJxF+Pncc7pVwU67aWWppZm2yalgH3we0won1lk2yzs4IINDKU4pea6PtsnxAM1gwh/he4i4XvWFHBvOU4QvBc4=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr24979504qtm.171.1592981991389;
 Tue, 23 Jun 2020 23:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200624003340.802375-1-andriin@fb.com> <CAADnVQJ_4WhyK3UvtzodMrg+a-xQR7bFiCCi5nz_qq=AGX_FbQ@mail.gmail.com>
In-Reply-To: <CAADnVQJ_4WhyK3UvtzodMrg+a-xQR7bFiCCi5nz_qq=AGX_FbQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 23:59:40 -0700
Message-ID: <CAEf4BzYKV=A+Sd1ByA2=7CG7WJedB0CRAU7RGN6jO8B9ykpHiA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add debug message for each created program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 11:47 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jun 23, 2020 at 5:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Similar message for map creation is extremely useful, so add similar for BPF
> > programs.
>
> 'extremely useful' is quite subjective.
> If we land this patch then everyone will be allowed to add pr_debug()
> everywhere in libbpf with the same reasoning: "it's extremely useful pr_debug".

We print this for maps, making it clear which maps and with which FD
were created. Having this for programs is just as useful. It doesn't
overwhelm output (and it's debug one either way). "everyone will be
allowed to add pr_debug()" is a big stretch, you can't just sneak in
or force random pr_debug, we do review patches and if something
doesn't make sense we can and we do reject it, regardless of claimed
usefulness by the patch author.

So far, libbpf debug logs were extremely helpful (subjective, of
course, but what isn't?) to debug "remotely" various issues that BPF
users had. They don't feel overwhelmingly verbose and don't have a lot
of unnecessary info. Adding a few lines (how many BPF programs are
there per each BPF object?) for listing BPF programs is totally ok.

But I'm not going to fight it, up to you, of course.

>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 18461deb1b19..f24a90c86c58 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -5379,8 +5379,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
> >         }
> >
> >         ret = bpf_load_program_xattr(&load_attr, log_buf, log_buf_size);
> > -
> >         if (ret >= 0) {
> > +               pr_debug("prog '%s' ('%s'): created successfully, fd=%d\n",
> > +                        prog->name, prog->section_name, ret);
> >                 if (log_buf && load_attr.log_level)
> >                         pr_debug("verifier log:\n%s", log_buf);
> >                 *pfd = ret;
> > --
> > 2.24.1
> >
