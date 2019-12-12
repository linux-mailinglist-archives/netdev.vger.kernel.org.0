Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F0411D8CA
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbfLLVtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:49:55 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:46794 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730784AbfLLVtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:49:55 -0500
Received: by mail-qv1-f67.google.com with SMTP id t9so7821qvh.13;
        Thu, 12 Dec 2019 13:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bViWFxlrI/Tkwn0YJv/IZT4jZso6R2Pcj1F5qTaUWBI=;
        b=BDT4LojdCQjxbwyh8X6jzARaPfLEB2/rB327qG+cQtDTYwuun3FE5Z4GpU6ZWFsxO7
         CCzxKhSm42K0EDEyHSNxVmeyd72Fk+/5Z3Q+ZtsQjS/Oz9PvJuj1yG4CzmOYKoAV3PfU
         9EZF3c2k9UkJSP/VMUJwjCcpQPlJIHAcPyb3MmKK/eN6zuX3XlNyIsfJsdIQScq0+//K
         rHtYrwwEiwTbQox4p8bC24bv8g04CEhFUPFxHplPPo8vtlL+d/DMXQQR47M3gSZH1EEL
         VMXzdySLcXn1gJz5jb+H6kTL79QAfwZOv4ChcP3Fs72Rk9+6H4QeUVL2k3yQ6rIECAJd
         SMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bViWFxlrI/Tkwn0YJv/IZT4jZso6R2Pcj1F5qTaUWBI=;
        b=PTjZnfE6o1hVPVTQyhRpBeGASEXeqLePTegPt9td9PtqujUaY/hTtnHamo/j4YUAyL
         m4zTam9y3N6qg+ewreRTjdKmbnHWWsvuOftrROdzZEVvRcBi/jMiTAB5mvaYuLnLGFSg
         v2xn/bBFJLl8YTvOqD2u/mXVnxBI6AfOS/NSM4iq/2zrnuEyg+8fDPzHlJ+Py4KUCXjH
         e2inNZdyIVmMjfTI8b+D8OvowOIDesO5LeEyZjzXjXvf7O5UBPegsELeDE8gISfjuzOc
         3tG/KR/yLAxQ3/0WlDDHCRzEqgMy9/BInzw0LewC3fTeEK3gn0POggvd2gjdet08dqTl
         XHPA==
X-Gm-Message-State: APjAAAXOGX1J9pAsraYsSxfO7cZ+k0j3WqbVzisQ5zBhiEEY0BTaLQCE
        8CpR0qH1vXX/jUD33PFPCHT7ED0Qv03gnHAFNB0=
X-Google-Smtp-Source: APXvYqwzjgoVhWzetwURSQR1HqUT7cH9j5zKEb6ARgikG+kNhZYiSRzRjixzSMS+JfhQdfvGvVrZ1omDq3PC4wSP+Ms=
X-Received: by 2002:ad4:514e:: with SMTP id g14mr10463853qvq.196.1576187393968;
 Thu, 12 Dec 2019 13:49:53 -0800 (PST)
MIME-Version: 1.0
References: <20191212164129.494329-1-andriin@fb.com> <20191212164129.494329-16-andriin@fb.com>
 <8b39cb0b-9372-4f68-cded-e464d5b80ec2@netronome.com>
In-Reply-To: <8b39cb0b-9372-4f68-cded-e464d5b80ec2@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Dec 2019 13:49:42 -0800
Message-ID: <CAEf4BzbeYCA62FAe2zP1FaAtC83oXQcg5kDHQzM37OFNv3-6ug@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 15/15] bpftool: add `gen skeleton` BASH completions
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 1:12 PM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-12-12 08:41 UTC-0800 ~ Andrii Nakryiko <andriin@fb.com>
> > Add BASH completions for gen sub-command.
> >
> > Cc: Quentin Monnet <quentin.monnet@netronome.com>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/bash-completion/bpftool         | 11 +++++++++++
> >  tools/bpf/bpftool/main.c                          |  2 +-
> >  tools/testing/selftests/bpf/prog_tests/skeleton.c |  6 ++++--
> >  tools/testing/selftests/bpf/progs/test_skeleton.c |  3 ++-
> >  4 files changed, 18 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> > index 70493a6da206..986519cc58d1 100644
> > --- a/tools/bpf/bpftool/bash-completion/bpftool
> > +++ b/tools/bpf/bpftool/bash-completion/bpftool
> > @@ -716,6 +716,17 @@ _bpftool()
> >                      ;;
> >              esac
> >              ;;
> > +        gen)
> > +            case $command in
> > +                skeleton)
> > +                    _filedir
> > +                 ;;
> > +                *)
> > +                    [[ $prev == $object ]] && \
> > +                        COMPREPLY=( $( compgen -W 'skeleton help' -- "$cur" ) )
> > +                    ;;
> > +            esac
> > +            ;;
>
> Hi Andrii,
>
> Bpftool completion looks OK to me...
>
> >          cgroup)
> >              case $command in
> >                  show|list|tree)
> > diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> > index 758b294e8a7d..1fe91c558508 100644
> > --- a/tools/bpf/bpftool/main.c
> > +++ b/tools/bpf/bpftool/main.c
> > @@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
> >               "       %s batch file FILE\n"
> >               "       %s version\n"
> >               "\n"
> > -             "       OBJECT := { prog | map | cgroup | perf | net | feature | btf }\n"
> > +             "       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen }\n"
>
> ... but this is part of the usage message, and ideally should be added
> when you add the new feature to bpftool in patch 11. Not a major issue,
> but ...
>
> >               "       " HELP_SPEC_OPTIONS "\n"
> >               "",
> >               bin_name, bin_name, bin_name);
> > diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
> > index d65a0203e1df..94e0300f437a 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
> > @@ -39,8 +39,10 @@ void test_skeleton(void)
> >       CHECK(bss->out2 != 2, "res2", "got %lld != exp %d\n", bss->out2, 2);
> >       CHECK(bss->out3 != 3, "res3", "got %d != exp %d\n", (int)bss->out3, 3);
> >       CHECK(bss->out4 != 4, "res4", "got %lld != exp %d\n", bss->out4, 4);
> > -     CHECK(bss->out5.a != 5, "res5", "got %d != exp %d\n", bss->out5.a, 5);
> > -     CHECK(bss->out5.b != 6, "res6", "got %lld != exp %d\n", bss->out5.b, 6);
> > +     CHECK(bss->handler_out5.a != 5, "res5", "got %d != exp %d\n",
> > +           bss->handler_out5.a, 5);
> > +     CHECK(bss->handler_out5.b != 6, "res6", "got %lld != exp %d\n",
> > +           bss->handler_out5.b, 6);
>
> ... This and the code below does not seem to relate to bpftool
> completion at all. And it was not present in v1. I suspect this code was
> not intended to end up in this patch?
>

Oh yeah, I screwed up amending, sorry about that. I will fix both
issues, thanks.

> >
> >  cleanup:
> >       test_skeleton__destroy(skel);
> > diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/testing/selftests/bpf/progs/test_skeleton.c
> > index 303a841c4d1c..db4fd88f3ecb 100644
> > --- a/tools/testing/selftests/bpf/progs/test_skeleton.c
> > +++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
> > @@ -16,7 +16,6 @@ long long in4 __attribute__((aligned(64))) = 0;
> >  struct s in5 = {};
> >
> >  long long out2 = 0;
> > -struct s out5 = {};
> >  char out3 = 0;
> >  long long out4 = 0;
> >  int out1 = 0;
> > @@ -25,6 +24,8 @@ int out1 = 0;
> >  SEC("raw_tp/sys_enter")
> >  int handler(const void *ctx)
> >  {
> > +     static volatile struct s out5;
> > +
> >       out1 = in1;
> >       out2 = in2;
> >       out3 = in3;
> >
>
