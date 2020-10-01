Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901732804B0
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732981AbgJARJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732967AbgJARJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:09:21 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9F3C0613D0;
        Thu,  1 Oct 2020 10:09:20 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x20so4562052ybs.8;
        Thu, 01 Oct 2020 10:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4H6tqfFmYVuKV7tY9Iwf4g6YAYhBYzQtBBiSAWg+KwU=;
        b=UhdBeefnLTx7ql7vEdK8cudbbZajS39a2DmXV3qyKDVgCQT4Zsb20Fo1/E85oGsYaR
         9PWHWg/S6odW5Pa4kcMVYeXmSp4NZx4fui3MiRCV7FEaCFLVE4UWJOnTySqLfP8dowEC
         qHOSmOZwY/jDrFoh6rIE/0m1O8OcVtMkJFmodW72mfJiqVfBsHwsVuzHePbdzzfCsjeB
         KJOK2JRV5sLmJECtBzFdbU6Zq+iWS4nVO0ILuxP4rh2Q2DkTv2x1WJUD6FYN0+BCGK1E
         olFjVyNIA+irX8IJAkELTuanBuoQF2UQHSlIfXU/D1cDbXTH5psSD48VFh2CoBKMZRp5
         YTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4H6tqfFmYVuKV7tY9Iwf4g6YAYhBYzQtBBiSAWg+KwU=;
        b=hLlHJDBalljYDRgWFx+zUQrBGuvbLl4hScolPdL6U8NjgPkd8+pxXXOajSIphyNYjx
         6o5rc+IN1w0fkIB2eArsgc2N+MCfAw1iUlFg+/yuy1xlEHi+dI4GynnPd6GJKh6sLqQt
         oxjVP7GTo9bSJHyQVp0qa2glCC6WAiof35Z/b+PJi+WM1o4tr+1knAM5wZrEKWx6SI2F
         KhpzpYBU2/Sx3LRre2nvsGHWHLcRGxGsJdZHENAjjkdh/viR3IX8Z0ERKlbqhkzKSTDS
         MztRKion0bxe8QdS1BqzyJobq83lc3SHs+oijkpYtsnpAny2xQKkzEElMvu/9d3+63Pl
         hYZQ==
X-Gm-Message-State: AOAM531qIwnCRsYb8CMtsVyXTtqco8Ct63+KfhNgI1wtDOIYNCFVKjSt
        6Bgb2vPpaX4tkR/XG4/lur7e5ft4iUCJwzPBuF4=
X-Google-Smtp-Source: ABdhPJy1zOeLpy9Yefuk2yB6jWo19jgpRiWJ/iTHAmMA6aI2HtoV4FosQmHQeNGNyMPCeLcsvsR+WTLKRC83VGQiViI=
X-Received: by 2002:a25:2d41:: with SMTP id s1mr11517029ybe.459.1601572160010;
 Thu, 01 Oct 2020 10:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200928090805.23343-1-lmb@cloudflare.com> <20200928090805.23343-3-lmb@cloudflare.com>
 <20200929055851.n7fa3os7iu7grni3@kafai-mbp> <CAADnVQLwpWMea1rbFAwvR_k+GzOphaOW-kUGORf90PJ-Ezxm4w@mail.gmail.com>
 <CACAyw98WzZGcFnnr7ELvbCziz2axJA_7x2mcoQTf2DYWDYJ=KA@mail.gmail.com> <20201001072348.hxhpuoqmeln6twxw@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201001072348.hxhpuoqmeln6twxw@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 1 Oct 2020 10:09:09 -0700
Message-ID: <CAEf4Bzbjzj3wwxX84bLi-PLy=9+Bpe1bTDt=t0qR5t=xEkNjwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] selftests: bpf: Add helper to compare
 socket cookies
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Martin KaFai Lau <kafai@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 12:25 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 30, 2020 at 10:28:33AM +0100, Lorenz Bauer wrote:
> > On Tue, 29 Sep 2020 at 16:48, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >
> > ...
> >
> > > There was a warning. I noticed it while applying and fixed it up.
> > > Lorenz, please upgrade your compiler. This is not the first time such
> > > warning has been missed.
> >
> > I tried reproducing this on latest bpf-next (b0efc216f577997) with gcc
> > 9.3.0 by removing the initialization of duration:
> >
> > make: Entering directory '/home/lorenz/dev/bpf-next/tools/testing/selft=
ests/bpf'
> >   TEST-OBJ [test_progs] sockmap_basic.test.o
> >   TEST-HDR [test_progs] tests.h
> >   EXT-OBJ  [test_progs] test_progs.o
> >   EXT-OBJ  [test_progs] cgroup_helpers.o
> >   EXT-OBJ  [test_progs] trace_helpers.o
> >   EXT-OBJ  [test_progs] network_helpers.o
> >   EXT-OBJ  [test_progs] testing_helpers.o
> >   BINARY   test_progs
> > make: Leaving directory '/home/lorenz/dev/bpf-next/tools/testing/selfte=
sts/bpf'
> >
> > So, gcc doesn't issue a warning. Jakub did the following little experim=
ent:
> >
> > jkbs@toad ~/tmp $ cat warning.c
> > #include <stdio.h>
> >
> > int main(void)
> > {
> >         int duration;
> >
> >         fprintf(stdout, "%d", duration);
> >
> >         return 0;
> > }
> > jkbs@toad ~/tmp $ gcc -Wall -o /dev/null warning.c
> > warning.c: In function =E2=80=98main=E2=80=99:
> > warning.c:7:2: warning: =E2=80=98duration=E2=80=99 is used uninitialize=
d in this
> > function [-Wuninitialized]
> >     7 |  fprintf(stdout, "%d", duration);
> >       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> >
> > The simple case seems to work. However, adding the macro breaks things:
> >
> > jkbs@toad ~/tmp $ cat warning.c
> > #include <stdio.h>
> >
> > #define _CHECK(duration) \
> >         ({                                                      \
> >                 fprintf(stdout, "%d", duration);                \
> >         })
> > #define CHECK() _CHECK(duration)
> >
> > int main(void)
> > {
> >         int duration;
> >
> >         CHECK();
> >
> >         return 0;
> > }
> > jkbs@toad ~/tmp $ gcc -Wall -o /dev/null warning.c
> > jkbs@toad ~/tmp $
>
> That's very interesting. Thanks for the pointers.
> I'm using gcc version 9.1.1 20190605 (Red Hat 9.1.1-2)
> and I saw this warning while compiling selftests,
> but I don't see it with above warning.c example.
> clang warns correctly in both cases.

I think this might be the same problem I fixed for libbpf with [0].
Turns out, GCC explicitly calls out (somewhere in their docs) that
uninitialized variable warnings work only when compiled in optimized
mode, because some internal data structures used to detect this are
only maintained in optimized mode build.

Laurenz, can you try compiling your example with -O2?

  [0] https://patchwork.ozlabs.org/project/netdev/patch/20200929220604.8336=
31-2-andriin@fb.com/

>
> > Maybe this is https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D18501 ? Th=
e
> > problem is still there on gcc 10. Compiling test_progs with clang does
> > issue a warning FWIW, but it seems like other things break when doing
> > that.
>
> That gcc bug has been opened since transition to ssa. That was a huge
> transition for gcc. But I think the bug number is not correct. It points =
to a
> different issue. I've checked -fdump-tree-uninit-all dump with and withou=
t
> macro. They're identical. The tree-ssa-uninit pass suppose to warn, but i=
t
> doesn't. I wish I had more time to dig into it. A bit of debugging in
> gcc/tree-ssa-uninit.c can probably uncover the root cause.
