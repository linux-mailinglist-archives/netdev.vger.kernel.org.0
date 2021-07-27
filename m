Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34EF3D6CD1
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 05:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbhG0Cwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 22:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbhG0Cwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 22:52:50 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94ED9C061757;
        Mon, 26 Jul 2021 20:33:17 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id m193so18454015ybf.9;
        Mon, 26 Jul 2021 20:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QdeVN6Yrp8BCXWx3T1YVZzGUy63biAiHMHNxhQDVUsY=;
        b=Eirvxm5IZvCTiFeyg9gnFJShgAb10jrYzecJVyouIDLjC+6MiJPkbcah9EzvbZVrnM
         yvyvqsh1yNNJtnVwuENW3zY8eygyZOUOH42CHjT2oj3ZZYv9OuZJi3Bl/BK6Uvwy/Xot
         9A1CDNhqPjq4M2Zq6A+n3Qw1D/4GAyn/ls/NJFCPYnMoQk+jmtgQ7jVAs3ZqRFy28N5v
         zLzvJv+uRI2OscPOSWKQwt8pQbEqNlrYIbECMl+YtzOhxnAtROwUS+jKiHfIQxqy0KRQ
         eDpRAPe4yEl5ZwkTMYLEVKydjR2ORAOjGpLfbbI3YvEpGUTcf0BcAgCo5H32PE312mQ2
         1L6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QdeVN6Yrp8BCXWx3T1YVZzGUy63biAiHMHNxhQDVUsY=;
        b=GmQk9PSTjnv5Sgz9Q8zPu6egVpf6ODQ7oKNxcKkAAFrPP+WygXdomkIsF7gXEB6UCV
         +7XV88pc1NjLEAwRggS64ZJShWoAY8czOh+69CSdYugcSDHgG+7gjUzAL6yZYuu40fy6
         b5mRdb1CEV5UsT67FNayWLFZwu4nJp/NNPzHWhTjGouVexs1DIR+Au60mCMd27TfKY5n
         k/lzUDDezN1+aMAeaaP/DXYF9klBSEOEpiAKfxGcm9oGXEOssYYZ8aswDGLhnp0ySwL2
         JAnUB0VV/JnwQL1+RqJj80zqCPNAFYFXIYWXpuMIlhx+wvsKwa5x23dZCdIcN06HLXgM
         pfaQ==
X-Gm-Message-State: AOAM532yPu0dpj4d6mH/cXvIKPf5K9IoasWLqPJrw9DgNdGSv5ijrCbz
        Zrud1Y29xhRbFS7cA/JLp5YcCdvPmOrb7UzAP+M=
X-Google-Smtp-Source: ABdhPJzbPWveM1BLPDEscw9t44WDEDhXlr2bP59I+K8BDLjAnSu6Q/QFFcN4FWY2o19eXT3pFsau0kXbzR0Nxciplhc=
X-Received: by 2002:a25:2396:: with SMTP id j144mr21349553ybj.481.1627356796838;
 Mon, 26 Jul 2021 20:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210724152124.9762-1-claudiajkang@gmail.com> <CAEf4Bzb-9TKKdL4x4UYw8T925pASYjt3+29+0xXq-reNG3qy8A@mail.gmail.com>
In-Reply-To: <CAEf4Bzb-9TKKdL4x4UYw8T925pASYjt3+29+0xXq-reNG3qy8A@mail.gmail.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Tue, 27 Jul 2021 12:32:41 +0900
Message-ID: <CAK+SQuTQ7OfxCLzrwtV6K7-Kug6ZL+11=_f+hBgNteKtqnXGYw@mail.gmail.com>
Subject: Re: [bpf-next 1/2] samples: bpf: Fix tracex7 error raised on the
 missing argument
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 5:08 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Jul 24, 2021 at 8:21 AM Juhee Kang <claudiajkang@gmail.com> wrote:
> >
> > The current behavior of 'tracex7' doesn't consist with other bpf samples
> > tracex{1..6}. Other samples do not require any argument to run with, but
> > tracex7 should be run with btrfs device argument. (it should be executed
> > with test_override_return.sh)
> >
> > Currently, tracex7 doesn't have any description about how to run this
> > program and raises an unexpected error. And this result might be
> > confusing since users might not have a hunch about how to run this
> > program.
> >
> >     // Current behavior
> >     # ./tracex7
> >     sh: 1: Syntax error: word unexpected (expecting ")")
> >     // Fixed behavior
> >     # ./tracex7
> >     ERROR: Run with the btrfs device argument!
> >
> > In order to fix this error, this commit adds logic to report a message
> > and exit when running this program with a missing argument.
> >
> > Additionally in test_override_return.sh, there is a problem with
> > multiple directory(tmpmnt) creation. So in this commit adds a line with
> > removing the directory with every execution.
> >
> > Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> > ---
> >  samples/bpf/test_override_return.sh | 1 +
> >  samples/bpf/tracex7_user.c          | 5 +++++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/samples/bpf/test_override_return.sh b/samples/bpf/test_override_return.sh
> > index e68b9ee6814b..6480b55502c7 100755
> > --- a/samples/bpf/test_override_return.sh
> > +++ b/samples/bpf/test_override_return.sh
> > @@ -1,5 +1,6 @@
> >  #!/bin/bash
> >
> > +rm -rf tmpmnt
>
> Do we need -rf or -r would do?
>

It works properly using only -r.
Thanks for pointing it out! I will stick to this method.

I will send the next version as soon as possible.

> >  rm -f testfile.img
> >  dd if=/dev/zero of=testfile.img bs=1M seek=1000 count=1
> >  DEVICE=$(losetup --show -f testfile.img)
> > diff --git a/samples/bpf/tracex7_user.c b/samples/bpf/tracex7_user.c
> > index fdcd6580dd73..8be7ce18d3ba 100644
> > --- a/samples/bpf/tracex7_user.c
> > +++ b/samples/bpf/tracex7_user.c
> > @@ -14,6 +14,11 @@ int main(int argc, char **argv)
> >         int ret = 0;
> >         FILE *f;
> >
> > +       if (!argv[1]) {
> > +               fprintf(stderr, "ERROR: Run with the btrfs device argument!\n");
> > +               return 0;
> > +       }
> > +
> >         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> >         obj = bpf_object__open_file(filename, NULL);
> >         if (libbpf_get_error(obj)) {
> > --
> > 2.27.0
> >



-- 

Best regards,
Juhee Kang
