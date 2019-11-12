Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A963F8ED2
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKLLps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:45:48 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44357 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLLpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:45:47 -0500
Received: by mail-yb1-f194.google.com with SMTP id g38so7449303ybe.11;
        Tue, 12 Nov 2019 03:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zze64Tjkpcna3jw2z4tcVgFoaR/PTDyV/TrWdLqNFp0=;
        b=JKKSqD83FUdkdnT5Dki0Sba5fcso+rZpA8tmSf7pku6J303dvhwHIXtIUj/RooAUMl
         1UAeFFl7S7H+HB+dQJZatpl7pY/rnJoQ89pgbplkDLAAqrLxNJhRDiobQ//m9KR9Q/YP
         fu/D+evgqhdbB9TkyMPQakIkZsh8USkuXXt2cJb/y17dmEMXgGFxZcL7GAgpjvpZyyHo
         MkHAXgBFwhBTUIl53iHIzbRx/5QgT7wam+tOrYa00PG4o0cgr8kUfcuV8HgzooorJeEP
         0YZJr+3NEEiLjQ8s6xm7zO6ysz6xvC3OE7mTcFxmeZXspaW9VWFRETE3Y1bQURcAfsRd
         1QqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zze64Tjkpcna3jw2z4tcVgFoaR/PTDyV/TrWdLqNFp0=;
        b=FxX0LSJEwlCbIy3dCtdS99sheOrsq/bZ8jidYUm3RyzicRwFwg9f26hKW+Fu9QxVvY
         6HnWe+jecoc32cUBJnkmNpXEjaqof2XRLSkTaFYs0tNRlBRsq595wRE0tOlhYR/4QGTf
         sTzX+ecMMQK0+83yXBx+x0BbbX1AunsG0oUbept+1Xsf5lZoGrvuC22TVZrHlU+yob02
         J1NRBPB5HhJ4UFQpy4qQ6kVEp3FLdkjlfYKKb4mHRx63kp7SEVVT4aX2c8cDv5k/Mes9
         URD8WXbxpoDXtC1OZBm+LWu0vMgQdHujettpArXK32Sz1UmhdmykV34GwW/HADaXqTjF
         S8+Q==
X-Gm-Message-State: APjAAAVp32PjQoyroGz+qJ+vVnhshdzqiJO8D30C9jZ6GbB3ycpRAr5w
        4La2qXhZ7knI7jPgLsp+Sx+bS25xM64tAVJUDQ==
X-Google-Smtp-Source: APXvYqzXVvPlqePTpm4+7jSq28ds4cuofCbIayRQNE4ktjkhekkJ4Fuvxn0KKSAlL8HCnHnSLOxNSFjTPAMQC6PuG7w=
X-Received: by 2002:a25:c503:: with SMTP id v3mr11928306ybe.333.1573559146429;
 Tue, 12 Nov 2019 03:45:46 -0800 (PST)
MIME-Version: 1.0
References: <20191110081901.20851-1-danieltimlee@gmail.com> <CAEf4BzYRqeg5vFm+Ac2TVVeAw=N+qhosy5qF9Dr_ka3hn8DsPg@mail.gmail.com>
In-Reply-To: <CAEf4BzYRqeg5vFm+Ac2TVVeAw=N+qhosy5qF9Dr_ka3hn8DsPg@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 12 Nov 2019 20:45:31 +0900
Message-ID: <CAEKGpzhEuNfZq+XGfTau4uaHhijtx316sLQmQWm7-P_H=iZ=bA@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: fix outdated README build command
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 3:09 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Nov 10, 2019 at 12:19 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Currently, building the bpf samples under samples/bpf directory isn't
> > working. Running make from the directory 'samples/bpf' will just shows
> > following result without compiling any samples.
> >
>
> Do you mind trying to see if it's possible to detect that plain `make`
> is being run from samples/bpf subdirectory, and if that's the case,
> just running something like `make M=samples/bpf -C ../../`? If that's
> not too hard, it would be a nice touch to still have it working old
> (and intuitive) way, IMO.
>

Thanks for the review!
And seems it works with `make M=samples/bpf -C ../../` and it's better
solution!

It's just the issue has been solved as Daniel Borkmann mentioned.
Anyway, thanks for the review!

Best,
Daniel

>
> >  $ make
> >  make -C ../../ /git/linux/samples/bpf/ BPF_SAMPLES_PATH=/git/linux/samples/bpf
> >  make[1]: Entering directory '/git/linux'
> >    CALL    scripts/checksyscalls.sh
> >    CALL    scripts/atomic/check-atomics.sh
> >    DESCEND  objtool
> >  make[1]: Leaving directory '/git/linux'
> >
> > Due to commit 394053f4a4b3 ("kbuild: make single targets work more
> > correctly"), building samples/bpf without support of samples/Makefile
> > is unavailable. Instead, building the samples with 'make M=samples/bpf'
> > from the root source directory will solve this issue.[1]
> >
> > This commit fixes the outdated README build command with samples/bpf.
> >
> > [0]: https://patchwork.kernel.org/patch/11168393/
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/README.rst | 19 +++++++++----------
> >  1 file changed, 9 insertions(+), 10 deletions(-)
> >
>
> [...]
