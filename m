Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D26A26201B
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgIHUJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730307AbgIHUJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 16:09:14 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0260EC061573;
        Tue,  8 Sep 2020 13:09:14 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h126so277487ybg.4;
        Tue, 08 Sep 2020 13:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tB6J0ngK5PxIG3DLtdZuGHgu/Z1tc40KkGkSiX12t3g=;
        b=OAvajyJ3x9vqOUwdvFeOevzk3cnY8QI1Tfm5SNOAnOZVKwSYU1LRaI1oTX1hx3tvI0
         g62nR6yvsrNo3unJG7XN4lEqwOm8eFtnrGeCOgIlk3tTnFDSIAyqL2D8R5xassDNdreG
         uQasm86Qnoawdpu0ar5VMyyExtoj5ejm7P2jDjum702Ux819pP1iM2xY5ZHQtP/KPnzU
         3ZcTFmihABByecXF/zZY7cAeIOCg4Tr1o0fQZFGBlffHJXSWqPq1msSksLtt8HKqbgJf
         7YpTyORxLMw6nGyPsySZTkyN3YkOdES9vx3tIX91jiFleqleSJeo2RJ1NWAkT0ZxErIQ
         MyEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tB6J0ngK5PxIG3DLtdZuGHgu/Z1tc40KkGkSiX12t3g=;
        b=kIK+Qr23ItW7nAQ16hHCXufyC+lCAOq6MZM73vptdP1Zrh+naVsPe5+fJqvzSx37lW
         375byoGgkezWmaVLjUDgtrrBa8Olm77mXBkNyXngdcuxP+TpE/dVLiMGmYUirivijnrd
         +rtBv8XF8aC2KciRArPMoWW0ukuGStD9bBQpYlJzlj3MlEXK9LKDX+uduqPaFS2RtIk6
         h86xWRzYzXnuVyq+2fTrINv1+6dzZ9qNwiu8BnBhkbtA71qPsDMNd87RIEyOJR2f7461
         wmHgErl+FUzdgtdvsQ/R9w/4mSko4hQcFmRycnBQqvRjohAW9BgZ5fWJYiWzL/GWL7JH
         3n0A==
X-Gm-Message-State: AOAM531SFgj7tRZhnCoxCIR/LMqpAjG7rnFUm6KVKdrUkVbWA4KN+99c
        CGMJihj4wRd382g+NunMRSkHPeBuSkRyhnvm0t4=
X-Google-Smtp-Source: ABdhPJzDdgTdoHXBAoSQeNNUIn4uO2J6L1KhA0ZEU4cKOmddUfGFzd92LNnv+XSjO8zLaGOz1a2rMZseH6Yk8DneZDI=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr806520ybg.425.1599595752868;
 Tue, 08 Sep 2020 13:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200904161454.31135-1-quentin@isovalent.com> <CAEf4BzYi8ELhNhxPikFQLQmB7HAXr7sRsyKi6QYJs+XBoDiwhw@mail.gmail.com>
 <35e3b69b-3df3-d384-9969-b03d1c816bb5@isovalent.com>
In-Reply-To: <35e3b69b-3df3-d384-9969-b03d1c816bb5@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 13:09:02 -0700
Message-ID: <CAEf4BzZ48qPGfmKjdg=vYkBcaOZF1zYN2ui66gjK6p9TqdE_Tg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] bpf: format fixes for BPF helpers and
 bpftool documentation
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 7:48 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 04/09/2020 22:40, Andrii Nakryiko wrote:
> > On Fri, Sep 4, 2020 at 9:15 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> This series contains minor fixes (or harmonisation edits) for the
> >> bpftool-link documentation (first patch) and BPF helpers documentation
> >> (last two patches), so that all related man pages can build without errors.
> >>
> >> Quentin Monnet (3):
> >>   tools: bpftool: fix formatting in bpftool-link documentation
> >>   bpf: fix formatting in documentation for BPF helpers
> >>   tools, bpf: synchronise BPF UAPI header with tools
> >>
> >>  include/uapi/linux/bpf.h                      | 87 ++++++++++---------
> >>  .../bpftool/Documentation/bpftool-link.rst    |  2 +-
> >>  tools/include/uapi/linux/bpf.h                | 87 ++++++++++---------
> >>  3 files changed, 91 insertions(+), 85 deletions(-)
> >>
> >> --
> >> 2.20.1
> >>
> >
> > This obviously looks good to me:
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > But do you think we can somehow prevent issues like this? Consider
> > adding building/testing of documentation to selftests or something.
> > Not sure if that will catch all the issues you've fixed, but that
> > would be a good start.
> >
>
> Thanks for the review.
>
> As for preventing future issues, I see two cases. Some minor fixes done
> to harmonise the look of the description for the different helpers could
> be checked with some kind of dedicated checkpatch-like script that would
> validate new helpers I suppose, but I'm not sure whether that's worth
> the trouble of creating that script, creating rules and then enforcing them.
>
> The issues that do raise warnings are more important to fix, and easier
> to detect. We could simply build bpftool's documentation (which also
> happens to build the doc for eBPF helpers) and checks for warnings. We
> already have a script to test bpftool build in the selftests, so I can
> add it there as a follow-up and make doc build fail on warnings.

Yeah, that would be good. I constantly forget to try building
documentation for bpftool, so having this automated would be an
improvement (provided building docs doesn't require unreasonable
dependencies).

>
> On a somewhat related note I also started to work on a script to check
> that bpftool is correctly sync'ed (with kernel regarding prog names /
> map names etc., and between source code / doc / bash completion) but I
> haven't found the time to finish that work yet.
>
> Quentin
