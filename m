Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6017B1258B0
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfLSAlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:41:05 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:35909 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfLSAlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:41:05 -0500
Received: by mail-qv1-f67.google.com with SMTP id m14so1547122qvl.3;
        Wed, 18 Dec 2019 16:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ENbXLgUUzOfEcEXEG8XQeI7hw5PFUF1OSzEY4w4gS8=;
        b=X9hDYb1LicvSxY06AASPf4+tkdckTa36DStYcKjZA/n0hsU7mR3WmO4YdFixSZTdaQ
         cKEpsw/VfROV2QLIGXQnfRr4QNswMi+RDw7U7DpWgehlYQhssF2+kiXUYSTQEURCeiGK
         MpnXvUTbIL49mcHnFZt28B2iMCIoBZx2RpW2Snc+HRQOhXY23qz/pVREjcf1wVUFG+J2
         6iGWIrRdC/jgkx9ljmvoL/z/BNUP7kIQhoZ76lKcyEP5Tt1jwlb1IxektjnORfEBjlvZ
         eRAY7uwMDCiaK+AQp3zIeow6PJ2H2FF3bzcaZ3qDqgW6ktPKSkcPj8TEC4YvyVEPV+zF
         REPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ENbXLgUUzOfEcEXEG8XQeI7hw5PFUF1OSzEY4w4gS8=;
        b=pdsWpORqo+uBiyEaWGSBJWqYy9Eiul9AfrDG4WeuHfoeLq6LpPkLs99kWq9SxBe+Ku
         QGiPgNF+Ta5ONS0i/ovu1H3y9hJVfwfZpQOUQkc47htaXt8C+nS4mMJOQNsQY1nyP33f
         TjlbKEkHhEkfuROEN2VOgFRQ+9v1hmUak5s8NSHmoUXnTvtC3Y/Ujgmcs6bTo4OLAUyP
         EdUcrLw/PIHhqQaI+cGhFSSEVCTn+K3v/U1qfQv3jORX+UMIDxZY1BZt2FIwWN1LweF8
         XGAUy5lkHDJwE+xMXQKnF15PqTd6C9DtOCI1SD06K7BYdDRPva90St9uUl19qVota0us
         YE4A==
X-Gm-Message-State: APjAAAVSgvUMv3+J1px400I1IfBvCdwb3K+MLup4qrIUxKGLIhM2YZNd
        qpOe5wCcTZZzXAIys/UIoGjhhYv2ObydhPcqCPQ=
X-Google-Smtp-Source: APXvYqyHBSDhZ8jl4btobVaxKpsh/07XMVnfrRpx/auUyMhvQlu1clVUwwnuSzHyqkZyL/ZRbyZ0oBMsg5hAeKVyft8=
X-Received: by 2002:a0c:990d:: with SMTP id h13mr5104299qvd.247.1576716064147;
 Wed, 18 Dec 2019 16:41:04 -0800 (PST)
MIME-Version: 1.0
References: <20191218221707.2552199-1-andriin@fb.com> <bc49104a-01a7-8731-e811-53a6c9861a48@fb.com>
In-Reply-To: <bc49104a-01a7-8731-e811-53a6c9861a48@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Dec 2019 16:40:53 -0800
Message-ID: <CAEf4BzboNRcqaeZ7drGCDiMqRRHjCipAG992rnn46fBSfcnxbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: work-around rst2man conversion bug
To:     Yonghong Song <yhs@fb.com>
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

On Wed, Dec 18, 2019 at 3:35 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/18/19 2:17 PM, Andrii Nakryiko wrote:
> > Work-around what appears to be a bug in rst2man convertion tool, used to
> > create man pages out of reStructureText-formatted documents. If text line
> > starts with dot, rst2man will put it in resulting man file verbatim. This
> > seems to cause man tool to interpret it as a directive/command (e.g., `.bs`), and
> > subsequently not render entire line because it's unrecognized one.
> >
> > Enclose '.xxx' words in extra formatting to work around.
> >
> > Fixes: cb21ac588546 ("bpftool: Add gen subcommand manpage")
> > Reported-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/bpf/bpftool/Documentation/bpftool-gen.rst | 15 ++++++++-------
> >   1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> > index b6a114bf908d..86a87da97d0b 100644
> > --- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> > +++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
> > @@ -112,13 +112,14 @@ DESCRIPTION
> >
> >                 If BPF object has global variables, corresponding structs
> >                 with memory layout corresponding to global data data section
> > -               layout will be created. Currently supported ones are: .data,
> > -               .bss, .rodata, and .extern structs/data sections. These
> > -               data sections/structs can be used to set up initial values of
> > -               variables, if set before **example__load**. Afterwards, if
> > -               target kernel supports memory-mapped BPF arrays, same
> > -               structs can be used to fetch and update (non-read-only)
> > -               data from userspace, with same simplicity as for BPF side.
> > +               layout will be created. Currently supported ones are: *.data*,
> > +               *.bss*, *.rodata*, and *.kconfig* structs/data sections.
> > +               These data sections/structs can be used to set up initial
> > +               values of variables, if set before **example__load**.
> > +               Afterwards, if target kernel supports memory-mapped BPF
> > +               arrays, same structs can be used to fetch and update
> > +               (non-read-only) data from userspace, with same simplicity
> > +               as for BPF side.
>
> Still does not look right.
>
> After build, I did `man ./bpftool-gen.8`, and I got the following,
>
>                   sponding to global data data section layout will be
> created. Currently supported ones
>                   are: .data, data sections/structs can be used to set
> up initial values of  variables,
>
> .bss, .rodata .kconfig etc. are missing. I am using:
>

looks like stale man page, can you please try re-building? Double
checked on my side, it looks good here.

> -bash-4.4$ man --version
> man 2.6.3
>
> >
> >       **bpftool gen help**
> >                 Print short help message.
> >
