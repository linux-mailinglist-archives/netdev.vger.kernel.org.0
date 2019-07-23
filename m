Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B3971DC5
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391104AbfGWRdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:33:46 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44930 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732740AbfGWRdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 13:33:46 -0400
Received: by mail-qk1-f196.google.com with SMTP id d79so31696843qke.11;
        Tue, 23 Jul 2019 10:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ianeBA17102/BpQCzS79EjRxDFZz+OeJn7S6DvR1afg=;
        b=rvzqgfScfMMkHvk7HZNn6hbTdZLBAapK6yOK3XeHoHc29xvoGVojTBA/rCOveKH0Z8
         hAI6q/Kox+ul6vHz1ba4HITHpVFq4sJGP8a1SDBavpD43ajqmvJXOaNPKK8W7/65ip5E
         GKO5BhB+Hd7rcIrz8h4Q1ZSNi4LTTxxJYx7cF1WVM4/XxX5OXt+2vTmLTmjaPjf71U+5
         AUnMB1wGSheUQba8aXXvSLrD6erR5CPByIkCb3W+N53vmbUMKD2W0y7Q8OIYnd1nH8gr
         T3Axyl4JzYPBA4C0zSvQK5q3aDeQBoU+xLgtna6l2++n/OthM6hgWtMt+fD21XT+UO90
         sDuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ianeBA17102/BpQCzS79EjRxDFZz+OeJn7S6DvR1afg=;
        b=axi/vWxkFmst7AMOq1AtyFZ3Hjn91UAaUm9NFJaTcqngfdMUkLiFe8wVI1GacydYAV
         /cNV5zddwV+1CkNZOa0NspEEe242S+dxav4/+fWt9Il2BRItyB/dZS9GAOGl6zsz0arc
         D79zEhU5tvp8UUKNCT5fuvVI9EgkNw3y/L8NVHC2olFFtMGRHsTydFNZDRDP80vBkCLJ
         3IoTM9DUeK48b8Lb3nAx7wlcCpNN3SFsuqZZ9GRXipX/rslNepPoTuPuDIQt2I/EQlaC
         VJRgezj9dg2KFoS1URVT6QM4DoBm8REkrp9eWStypnxgCtDrSCg1AffjMzFfdYtz7Xd/
         mcKw==
X-Gm-Message-State: APjAAAUhTPQE+GlKrn9h3cC+gZ5qNcOSsL6FyGxuuk2xZZqIUyzDxo2j
        +HkINyWGF1mg+uzLpaxCG9LLAC8ZAs5X7pY2510=
X-Google-Smtp-Source: APXvYqzpFkMX5l3v7Rn8NqFyC0UBM5MlpkZoBRpLgvmLlWGtaPPo3g/mqNzyu1EI6Yrn8WBEQ1r5cKkNxVcDA6wxOgo=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr53814986qke.449.1563903225025;
 Tue, 23 Jul 2019 10:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190723042329.3121956-1-andriin@fb.com> <ECB3771E-B6E8-45EC-B673-A0E0F79340BF@fb.com>
In-Reply-To: <ECB3771E-B6E8-45EC-B673-A0E0F79340BF@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jul 2019 10:33:34 -0700
Message-ID: <CAEf4Bza_CgAvfSOmPPPR9Q+FVct2QkXyzo3UgJf1X0rkR1oK2w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: provide more helpful message on
 uninitialized global var
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 1:51 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 22, 2019, at 9:23 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > When BPF program defines uninitialized global variable, it's put into
> > a special COMMON section. Libbpf will reject such programs, but will
> > provide very unhelpful message with garbage-looking section index.
> >
> > This patch detects special section cases and gives more explicit error
> > message.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/lib/bpf/libbpf.c | 14 +++++++++++---
> > 1 file changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 794dd5064ae8..5f9e7eedb134 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -1760,15 +1760,23 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
> >                        (long long) sym.st_value, sym.st_name, name);
> >
> >               shdr_idx = sym.st_shndx;
> > +             insn_idx = rel.r_offset / sizeof(struct bpf_insn);
> > +             pr_debug("relocation: insn_idx=%u, shdr_idx=%u\n",
> > +                      insn_idx, shdr_idx);
> > +
> > +             if (shdr_idx >= SHN_LORESERVE) {
> > +                     pr_warning("relocation: not yet supported relo for non-static global \'%s\' variable "
> > +                                "in special section (0x%x) found in insns[%d].code 0x%x\n",
>
> For easy grep, we should keep this one long long string.

I was worried it's way too long, so split it. But yeah, I'll just
merge it back into single line, thanks!

>
> Thanks,
> Song
