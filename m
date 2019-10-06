Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D6BCCDE1
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 04:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfJFC34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 22:29:56 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43303 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfJFC34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 22:29:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id c4so1601175qtn.10;
        Sat, 05 Oct 2019 19:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lg2UH9Bj9JqFJwKOONBUbINvFF0X3vjPI+MK42vcRIo=;
        b=fANr13OagOD4qPEYuiyfpvCxKjGgxRP6KEtK9ZLcJugF9w+LKUjOhBgLiHKTHzf5jZ
         MF1hLD1Iww/vfEAkFGHS0yDKe2FVtGpsqRvj2mpuuTCFX9fsGhlBKrGCiwRomo4QHKQ5
         z5shwnhH0lXIKc4ymMTfRTwO3Gs7+SSXAFJqyP3kK1Rjmi4Ovu+FsTi1+2MHi8wwb1tE
         qtPP7hxlvAVdEZcCas7vvf/diyaK7ZmFFJUJVoEC92VydOF+Ond2feQ8xd5rmm/CMuK/
         +Xmnlhur18gC6zBDFJ6uAlVPR68yVnhS6cRhZdXXDfoJfySehmm9UeiSll/RMuafU+EY
         MbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lg2UH9Bj9JqFJwKOONBUbINvFF0X3vjPI+MK42vcRIo=;
        b=LeMSp5zunuee5I4ePCinW8dxTSg5dime0JZVx932Fj5lwPcNVv1VYhY/axMYI/Iryk
         C4mY9V7VltQIrSpwcal3A+Vb7wLV8zgckWOyv+Rbf5fe2Yb8/PTQZwEGLtLA+c4WeAJs
         Gu0J+oE7iD4J5RKqGyXzvQFvTpwYEZETiRe8gIIahEon6qXK+AxjLUOfaGe8dENLudip
         TJqLvSGiB70OPSOS7y6hc0T+w0AypnVczuyfwMC4Nqg/OPatf/Z/Wz5cwubRYFz8i/ZR
         wHR9ekVmHETA6sbUroF5bktCamVWxDrRBVjMxUXcVsL2mzUaOt4QMnhefINlFiZ0ok2F
         yadA==
X-Gm-Message-State: APjAAAVV9iGxBfsWGOk/K0Ijp/y/L4CDVz0OIS+3srsvFi7CU45GTqCC
        3tM8tbmZWJmFS9bKjUz3H0+AKHdrRpqriGnrvl0=
X-Google-Smtp-Source: APXvYqztS3bRyjyovgygfOrSRWjrrilgVv/qufNv5dDkO2gGj+x4awqwNeWoA4vcQPy+5JRCsAZtyGbaD9p2tsocqAg=
X-Received: by 2002:a0c:ae9a:: with SMTP id j26mr21937007qvd.163.1570328994953;
 Sat, 05 Oct 2019 19:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191005075921.3310139-1-andriin@fb.com> <20191005075921.3310139-4-andriin@fb.com>
 <b0df96f6-dc41-8baf-baa3-e98da94c54b7@fb.com> <CAEf4BzZdhBTovTfv+Ar0En__RmuP6Lr=RWF2ix3uo9hZ84oHcg@mail.gmail.com>
 <c621f33f-4c17-f96f-e2f5-625d452f3df3@fb.com>
In-Reply-To: <c621f33f-4c17-f96f-e2f5-625d452f3df3@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 19:29:43 -0700
Message-ID: <CAEf4Bzb1XF0HpJoW1d4Wa-bQu72fXtH181vi7GpDm5hVKNVgxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: auto-generate list of BPF helper definitions
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 5, 2019 at 6:01 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/5/19 11:24 AM, Andrii Nakryiko wrote:
> > On Sat, Oct 5, 2019 at 10:10 AM Alexei Starovoitov <ast@fb.com> wrote:
> >>
> >> On 10/5/19 12:59 AM, Andrii Nakryiko wrote:
> >>> Get rid of list of BPF helpers in bpf_helpers.h (irony...) and
> >>> auto-generate it into bpf_helpers_defs.h, which is now included from
> >>> bpf_helpers.h.
> >>>
> >>> Suggested-by: Alexei Starovoitov<ast@fb.com>
> >>> Signed-off-by: Andrii Nakryiko<andriin@fb.com>
> >>> ---
> >>>    tools/lib/bpf/Makefile           |    8 +-
> >>>    tools/lib/bpf/bpf_helpers.h      |  264 +--
> >>>    tools/lib/bpf/bpf_helpers_defs.h | 2677 ++++++++++++++++++++++++++++++
> >>>    3 files changed, 2685 insertions(+), 264 deletions(-)
> >>>    create mode 100644 tools/lib/bpf/bpf_helpers_defs.h
> >>
> >> Approach looks good to me.
> >> imo that's better than messing with macros.
> >>
> >> Using bpf_helpers_doc.py as part of build will help man pages too.
> >> I think we were sloppy documenting helpers, since only Quentin
> >> was running that script regularly.
> >
> > Yep, I agree, I had to fix few things, as well as (char *) vs (void *)
> > vs (__u8 *) differences were causing some extra warnings.
> > Please check the list of type translations whether they make sense.
>
> yes. These conversions make sense.

cool, thanks for checking!

> Only one sk_buff->__sk_buff won't work for too long.
> Once my btf vmlinux stuff lands both structs will be possible.

I guess it will have to be sk_buff -> void conversion then, but we'll
do it later.

>
> >>
> >> Only question is what is the reason to commit generated .h into git?
> >
> > So originally I didn't want to depend on system UAPI headers during
> > Github build. But now I recalled that we do have latest UAPI synced
> > into Github's include/ subdir, so that's not an obstacle really. We'll
> > just need to re-license bpf_helpers_doc.py (I don't think Quentin will
> > mind) and start syncing it to Github (not a big deal at all).
>
> github sync script can run make, grab generated .h,
> and check it in into github.

Haven't considered that. That will work as well, a bit more work for
me on sync script side, but that's ok.

>
> >
> > There is still a benefit in having it checked in: easy to spot if
> > script does something wrong and double-check the changes (after
> > initial big commit, of course).
> >
> > If you think that's not reason enough, let me know and I can drop it in v2.
>
> I don't remember too many cases when generated files were committed.
> My preference to keep it out of kernel git.
> github/libbpf is a pure mirror. That .h can be committed there.
> The whole thing is automatic, so we don't need to move .py
> into github too.
>

Yeah, makes sense, will submit v2 w/ bpf_helpers_defs.h added to .gitignore
