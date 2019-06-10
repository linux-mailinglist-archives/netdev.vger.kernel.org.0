Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7013C02E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390754AbfFJXvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:51:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41832 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390570AbfFJXvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 19:51:15 -0400
Received: by mail-qt1-f196.google.com with SMTP id 33so4279818qtr.8;
        Mon, 10 Jun 2019 16:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gcKM3lKoJLbSN9OjnPJmIQlFQNi/BcO8/RK5ehWVdT0=;
        b=r2+I0y7KG8frXrEMk2S9yDOhPJKU3AUhHn3rUKLMgvrgFsJPIBAV2tCLEh4J8pvfLv
         7kcaN0IbccTPN8MJ0onG7SRb8Agx76qwU7w/UcRjIVAIYYVNsdJqk7VUAn65gxAzpDU4
         obOR/c9GCjXdoTzOWbpV+qgSt1g0qMKkhx+FbCmtDreJDxbSvWJEAr2DymfaSHomxW7q
         sHIJTdPL3YRiJO+SZ/c2hOZl/c904ZC1qVtr6h9dfUi+gYReZPWK7yhxwuphkPcM6y34
         WgXbDQu3NCNWTMlfl5T9gufrWKA/8/9vxZhaCSXXEz9jwkRpl29in2Sz1PN6D6pt0ZP+
         r9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gcKM3lKoJLbSN9OjnPJmIQlFQNi/BcO8/RK5ehWVdT0=;
        b=YThIIE2YLpNpAJKlDw/SBkju5HjrdWVeic2o6ZwcZu5f4vcOOA6OapDof4Q2QphOus
         OtzJIQ63IZHm89zwqz0CclUzjjtplDrhD6Rsr2Rv4q2LzJuNg283+P8EO2cB8R/ulnz+
         J1S/fTbTsetfppiR5UiEYiRNqQgC+aTqhzELTwfTUL4Hi80fnE6JllIqEyehYTIKq1FR
         YzunBU1HTvK7ekPqPatapuo1VHrFfiWguLw6wio/HdabPfdJbH4NTUh/CWc3fIEWnVEk
         jBnuPw+nf+CtPvcsB25Yyf2aP1mgTjc6E2984vVU0QmW6AhIgAECIlgZe3h9sMi6o1SD
         MOtw==
X-Gm-Message-State: APjAAAWBXOFGck0lDi9OCjpM1iij1c1jbhVujvcReOBoIH1kUX4BF1al
        AaFLd+mpY/y6tA1kaduhxZ+kELLGzCb8x+sUscgcQ5g/
X-Google-Smtp-Source: APXvYqxjK0Q71/sZukyMJiHLxpa0O2Xg+QGyd2j9umTnTVb0q553Ks/iPeOOxxCMa+6VYCY+Zi4F+1HdGgiu589xAw0=
X-Received: by 2002:ac8:1087:: with SMTP id a7mr48016204qtj.141.1560210674077;
 Mon, 10 Jun 2019 16:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190610165708.2083220-1-hechaol@fb.com> <CAEf4BzZGK+SN1EPudi=tt8ppN58ovW8o+=JMd8rhEgr4KBnSmw@mail.gmail.com>
 <20190610190252.GA41381@hechaol-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190610190252.GA41381@hechaol-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Jun 2019 16:51:03 -0700
Message-ID: <CAEf4Bzb-vxbzF+JN+4khK-mQYOexgnigBrgym_T+86KfOctXbg@mail.gmail.com>
Subject: Re: [PATCH v1 bpf-next] selftests/bpf : Clean up feature/ when make clean
To:     Hechao Li <hechaol@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 12:03 PM Hechao Li <hechaol@fb.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote on Mon [2019-Jun-10 11:05:28 -0700]:
> > On Mon, Jun 10, 2019 at 9:57 AM Hechao Li <hechaol@fb.com> wrote:
> > >
> > > I got an error when compiling selftests/bpf:
> > >
> > > libbpf.c:411:10: error: implicit declaration of function 'reallocarray';
> > > did you mean 'realloc'? [-Werror=implicit-function-declaration]
> > >   progs = reallocarray(progs, nr_progs + 1, sizeof(progs[0]));
> > >
> > > It was caused by feature-reallocarray=1 in FEATURE-DUMP.libbpf and it
> > > was fixed by manually removing feature/ folder. This diff adds feature/
> > > to EXTRA_CLEAN to avoid this problem.
> > >
> > > Signed-off-by: Hechao Li <hechaol@fb.com>
> > > ---
> >
> > There is no need to include v1 into patch prefix for a first version
> > of a patch. Only v2 and further versions are added.
> >
> >
> > >  tools/testing/selftests/bpf/Makefile | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 2b426ae1cdc9..44fb61f4d502 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -279,4 +279,5 @@ $(OUTPUT)/verifier/tests.h: $(VERIFIER_TESTS_DIR) $(VERIFIER_TEST_FILES)
> > >                  ) > $(VERIFIER_TESTS_H))
> > >
> > >  EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(ALU32_BUILD_DIR) \
> > > -       $(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H)
> > > +       $(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H) \
> > > +       feature
> >
> > It doesn't seem any of linux's Makefile do that. From brief reading of
> > build/Makefile.feature, it seems like it is supposed to handle
> > transparently the case where environment changes and thus a set of
> > supported features changes. I also verified that FEATURE-DUMP.libbpf
> > is re-generated every single time I run make in
> > tools/testing/selftests/bpf, even if nothing changed at all. So I
> > don't think this patch is necessary.
> >
> > I'm not sure what was the cause of your original problem, though.
> >
> > > --
> > > 2.17.1
> > >
>
> # Background:
>
> My default GCC version is 4.8.5, which caused the following error when I
> run make under selftests/bpf:
> libbpf.c:39:10: fatal error: libelf.h: No such file or directory
>
> To fix it, I have to run:
>
> make CC=<Path to GCC 7.x>
>
> The I got reallocarray not found error. By deleting feature/ folder
> under selftests/bpf, it was fixed.
>
> # Root Cause:
>
> Now I found the root cause. When I run "make", which uses GCC 4.8.5, it
> generates feature/test-reallocarray.d which indicates reallocarray is
> enabled. However, when I switched to GCC 7.0, this file was not
> re-generated and thus even FEATURE-DUMP.libbpf was re-generated,
> feature-reallocarray is still 1 in it.
>
> This can be reproduced by the following steps:
> $ cd tools/testing/selftests/bpf
> $ make clean && make CC=<Path to GCC 4.8.5>
> (Fail due to libelf.h not found)
> $ make clean && make CC=<Path to GCC 7.x>
> (Should succeed but actually fail with reallocarray not defined)
>
> If adding feature to EXTRA_CLEAN is not the way to go, do you have any
> suggestion to fix such problem? I spent some time debugging this and I
> hope to fix it so that other people with similar situation won't have to
> waste time on this issue.

I think adding feature to EXTRA_CLEAN is just fine. I was hesitant
without understanding how this happened. Maybe condense this
explanation as part of commit message, I think it's useful, thanks for
explaining!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> Thanks,
> Hechao
