Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546266B270
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 01:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388969AbfGPXhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 19:37:22 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39573 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387623AbfGPXhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 19:37:21 -0400
Received: by mail-qk1-f195.google.com with SMTP id w190so16031538qkc.6;
        Tue, 16 Jul 2019 16:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v5GkqRT93fkTP8BIazbltyBlI4Rs29NRIKAXiRzsYNg=;
        b=YxiJmcJ/JbDWjJLZecgwJR/GwBW2LNBWM6hDVHQepI2K4AJGtKY2D4+no0cfCjVRd+
         v6XaiRAhkI1Ys0f9mYAYaY3B49g/hNQLelqz4ReG8VNBhETOV27PMLIDxHowi7pqtbLB
         gtgreh0tV0hf0cNkpKAvWPIGjUJlOjqOdPJsSFNqnwLN++HYHA6JtWBvmtrlCEqoR4C6
         FRDW7y3c671+QB2VrK7hk1oklcBmkUIg8N2uRxzV8g3BUzlLbcP/hZ8lGjWcz+hEAdwg
         Z0N6jU8V9Q4dRHgPoMz1cE0TvyXDv3m9Fr5Y+fM8euw710lliL+rueiHJxN7VYR8DNgK
         J7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v5GkqRT93fkTP8BIazbltyBlI4Rs29NRIKAXiRzsYNg=;
        b=m8Vbn4lISIgIHi3q4J2bJNpglmHMgaDbzRa6yY0AT7LHuUpvY+wgwmzpOXkXL2QMDf
         hbvW9Hwi5CipXliSI5xBLvNEWut9MAqOicQqvY08Pi0w9VSXHnlAkrF2pMxwDuao0i/P
         m+J14uylzmJro8QSAC5ATxriyC0qkdT+4avhT86cszOlyys2wxdLYUwtiZV540miWs5e
         Tl8+PAU2QiQUVobTaRSwh2fybANPLFa06lmyzt+VW8jdREslhaR06F4fClI32AAcDwdy
         JrHNxrXeeQmraySd+uCZB6JNeM53buxVQrsajk84zNEFX12J1Z1cQBoAfB5Z+qUZnW4n
         W7LQ==
X-Gm-Message-State: APjAAAWnDsRGsCC26f09G8tvk51I1JUDfKYcL6R7zcW7crxCSdsFhYVQ
        XQN7s3LFH4RAs7TiCAbUmrSBmJKrieKS1Q5qJ5U=
X-Google-Smtp-Source: APXvYqzvAbZtiu/m/hAlglJ0EcKb017eA2pmCBAy2Me/9kE6sk8Okh/h4dM7FGYjxsAtI+cWYv+XZjzQpPWdRhOWwHE=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr24856940qke.449.1563320240187;
 Tue, 16 Jul 2019 16:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190716193837.2808971-1-andriin@fb.com> <20190716195544.GB14834@mini-arch>
 <CAEf4BzZ4XAdjasYq+JGFHnhwEV3G5UYWBuqKMK1yu1KRLn19MQ@mail.gmail.com> <20190716225735.GC14834@mini-arch>
In-Reply-To: <20190716225735.GC14834@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Jul 2019 16:37:08 -0700
Message-ID: <CAEf4BzY7NYZSGuRHVye_CerZ1BBBLsDyOT2ar5sBXsPGy8g0xA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] selftests/bpf: fix test_verifier/test_maps make dependencies
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 3:57 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/16, Andrii Nakryiko wrote:
> > On Tue, Jul 16, 2019 at 12:55 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 07/16, Andrii Nakryiko wrote:
> > > > e46fc22e60a4 ("selftests/bpf: make directory prerequisites order-only")
> > > > exposed existing problem in Makefile for test_verifier and test_maps tests:
> > > > their dependency on auto-generated header file with a list of all tests wasn't
> > > > recorded explicitly. This patch fixes these issues.
> > > Why adding it explicitly fixes it? At least for test_verifier, we have
> > > the following rule:
> > >
> > >         test_verifier.c: $(VERIFIER_TESTS_H)
> > >
> > > And there should be implicit/builtin test_verifier -> test_verifier.c
> > > dependency rule.
> > >
> > > Same for maps, I guess:
> > >
> > >         $(OUTPUT)/test_maps: map_tests/*.c
> > >         test_maps.c: $(MAP_TESTS_H)
> > >
> > > So why is it not working as is? What I'm I missing?
> >
> > I don't know exactly why it's not working, but it's clearly because of
> > that. It's the only difference between how test_progs are set up,
> > which didn't break, and test_maps/test_verifier, which did.
> >
> > Feel free to figure it out through a maze of Makefiles why it didn't
> > work as expected, but this definitely fixed a breakage (at least for
> > me).
> Agreed on not wasting time. I took a brief look (with make -qp) and I
> don't have any clue.

Oh, -qp is cool, noted :)

>
> By default implicit matching doesn't work:
> # makefile (from 'Makefile', line 261)
> /linux/tools/testing/selftests/bpf/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
> /linux/tools/testing/selftests/bpf/test_maps: map_tests/sk_storage_map.c /linux/tools/testing/selftests/bpf/test_stub.o /linux/tools/testing/selftests/bpf/libbpf.a
> #  Implicit rule search has not been done.
> #  File is an intermediate prerequisite.
> #  Modification time never checked.
> #  File has not been updated.
> # variable set hash-table stats:
> # Load=1/32=3%, Rehash=0, Collisions=0/2=0%
>
> If I comment out the following line:
> $(TEST_GEN_PROGS): $(OUTPUT)/test_stub.o $(BPFOBJ)
>
> Then it works:
> # makefile (from 'Makefile', line 261)
> /linux/tools/testing/selftests/bpf/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
> /linux/tools/testing/selftests/bpf/test_maps: test_maps.c map_tests/sk_storage_map.c
> #  Implicit rule search has been done.
> #  Implicit/static pattern stem: 'test_maps'
> #  File is an intermediate prerequisite.
> #  File does not exist.
> #  File has not been updated.
> # variable set hash-table stats:
> # Load=1/32=3%, Rehash=0, Collisions=0/2=0%
> #  recipe to execute (from '../lib.mk', line 138):
>         $(LINK.c) $^ $(LDLIBS) -o $@
>
> It's because "File is an intermediate prerequisite.", but I
> don't see how it's is a intermediate prerequisite for anything...

Well, it's "File is an intermediate prerequisite." in both cases, so I
don't know if that's it.
Makefiles is not my strong suit, honestly, and definitely not an area
of passion, so no idea

>
>
> One other optional suggestion I have to your second patch: maybe drop all
> those dependencies on the directories altogether? Why not do the following
> instead, for example (same for test_progs/test_maps)?

Some of those _TEST_DIR's are dependencies of multiple targets, so
you'd need to replicate that `mkdir -p $@` in multiple places, which
is annoying.

But I also don't think we need to worry about creating them, because
there is always at least one test (otherwise those tests are useless
anyways) in those directories, so we might as well just remove those
dependencies, I guess.

TBH, those explicit dependencies are good to specify anyways, so I
think this fix is good. Second patch just makes the layout of
dependencies similar, so it's easier to spot differences like this
one.

As usual, I'll let Alexei and Daniel decide which one to apply (or if
we need to take some other approach to fixing this).


>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 1296253b3422..c2d087ce6d4b 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -277,12 +277,9 @@ VERIFIER_TESTS_H := $(OUTPUT)/verifier/tests.h
>  test_verifier.c: $(VERIFIER_TESTS_H)
>  $(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
>
> -VERIFIER_TESTS_DIR = $(OUTPUT)/verifier
> -$(VERIFIER_TESTS_DIR):
> -       mkdir -p $@
> -
>  VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
> -$(OUTPUT)/verifier/tests.h: $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
> +$(OUTPUT)/verifier/tests.h: $(VERIFIER_TEST_FILES)
> +       mkdir -p $(dir $@)
>         $(shell ( cd verifier/; \
>                   echo '/* Generated header, do not edit */'; \
>                   echo '#ifdef FILL_ARRAY'; \
