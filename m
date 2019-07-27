Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DBC77B40
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 20:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388052AbfG0Sxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 14:53:41 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44971 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbfG0Sxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 14:53:40 -0400
Received: by mail-qk1-f194.google.com with SMTP id d79so41440412qke.11;
        Sat, 27 Jul 2019 11:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z9cho60COAaI1MuHirslk6ZK0cSSVNeS7/9hJsI097Q=;
        b=Er/hdYwUZKWpGf0qqgAzufqlWD6xrubQsjVq/Sq+Co3yYnrMASORZSEvUbr8NfkS21
         58YnmGMuv1Sca/Q4/tvaGCycozz1NkxW9Ehw7GZlOsFGP0lmTsIVPZksrEXpB7HVWP6/
         xzWIvrvm27UjnHAhWL+98AryaZloMb3hR7xYz2Z4jctQGdqVE/23n7iYlIZchTpFVGxE
         HiMQKQyLTS909NDRw/mqVSpMv1M6fCNfdGz+fNIMTBpkbgwsEzmRM48YIKuPtrQYb8Gg
         CFzEvGzrVWHi3J7t4OMnMn/LKLlkodrozPvkG4BgjMVU5LM27yC7Rf5dO7ufvk46zpVU
         nI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9cho60COAaI1MuHirslk6ZK0cSSVNeS7/9hJsI097Q=;
        b=s2mLtAc0K72wsAIjV4cdDEKfH6yTG0WHgVpkqZOeBCBEuqfSUWk0xFJvnNznyDQcmX
         hCjn/wOPI2xCbHqGSsZ7VXJVCO0P5CbZdqqNGTAREyURvWGOLTbU0BLoYXeBXjQ3kuPS
         KWgLTYk/l7h/bowyMFUidT2fZqbRf8iZhkMBEEgni6OvQIPaJJlDkm7lWvZKI9sHptA6
         /ei+yogxJNhSEWAR0K4mAXTiuDPKTLNKXVtZoiWIkx1Att1WFFv721PxA0fSsapR4YU+
         e+zX6E6Dj/gStDKDducZySusBgxsnNlWE6u70MEAzpDO53YLnjISazCiO2smeT1+1Pkz
         8bzA==
X-Gm-Message-State: APjAAAVn+05qdvQo6OIrktvZAOSCf6XNaKrUNkDMY3Kpl0akwaERVnWt
        X1bZk229gL9ZZn/1vogg7yRCVs3PeykreP/hskl7oPT2OEk=
X-Google-Smtp-Source: APXvYqywAunKei+y4li5vf03mIdlyeqm02RsjdyK59zVEdtkJI/jhbyeqoPUWpne3fG0vbxcU0ixKQp6+K7n4JW8d5Q=
X-Received: by 2002:a37:660d:: with SMTP id a13mr40289236qkc.36.1564253619458;
 Sat, 27 Jul 2019 11:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190726203747.1124677-1-andriin@fb.com> <20190726203747.1124677-2-andriin@fb.com>
 <20190726212152.GA24397@mini-arch> <CAEf4BzYDvZENJqrT0KKpHbfHNCdObB9p4ZcJqQj3+rM_1ESF3g@mail.gmail.com>
 <20190726220119.GE24397@mini-arch>
In-Reply-To: <20190726220119.GE24397@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Jul 2019 11:53:28 -0700
Message-ID: <CAEf4Bzbj6RWUo8Q7wgMnbL=T7V2yK2=gbdO3sSfxJ71Gp6jeYA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] selftests/bpf: prevent headers to be
 compiled as C code
To:     Stanislav Fomichev <sdf@fomichev.me>
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

On Fri, Jul 26, 2019 at 3:01 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/26, Andrii Nakryiko wrote:
> > On Fri, Jul 26, 2019 at 2:21 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 07/26, Andrii Nakryiko wrote:
> > > > Apprently listing header as a normal dependency for a binary output
> > > > makes it go through compilation as if it was C code. This currently
> > > > works without a problem, but in subsequent commits causes problems for
> > > > differently generated test.h for test_progs. Marking those headers as
> > > > order-only dependency solves the issue.
> > > Are you sure it will not result in a situation where
> > > test_progs/test_maps is not regenerated if tests.h is updated.
> > >
> > > If I read the following doc correctly, order deps make sense for
> > > directories only:
> > > https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
> > >
> > > Can you maybe double check it with:
> > > * make
> > > * add new prog_tests/test_something.c
> > > * make
> > > to see if the binary is regenerated with test_something.c?
> >
> > Yeah, tested that, it triggers test_progs rebuild.
> >
> > Ordering is still preserved, because test.h is dependency of
> > test_progs.c, which is dependency of test_progs binary, so that's why
> > it works.
> >
> > As to why .h file is compiled as C file, I have no idea and ideally
> > that should be fixed somehow.
> I guess that's because it's a prerequisite and we have a target that
> puts all prerequisites when calling CC:
>
> test_progs: a.c b.c tests.h
>         gcc a.c b.c tests.h -o test_progs
>
> So gcc compiles each input file.

If that's really a definition of the rule, then it seems not exactly
correct. What if some of the prerequisites are some object files,
directories, etc. I'd say the rule should only include .c files. I'll
add it to my TODO list to go and check how all this is defined
somewhere, but for now I'm leaving everything as is in this patch.

>
> I'm not actually sure why default dependency system that uses 'gcc -M'
> is not working for us (see scripts/Kbuild.include) and we need to manually
> add tests.h dependency. But that's outside of the scope..
>
> > I also started with just removing header as dependency completely
> > (because it's indirect dependency of test_progs.c), but that broke the
> > build logic. Dunno, too much magic... This works, tested many-many
> > times, so I was satisfied enough :)
> Yeah, that's my only concern, too much magic already and we add
> quite a bit more.
>
> > > Maybe fix the problem of header compilation by having '#ifndef
> > > DECLARE_TEST #define DECLARE_TEST() #endif' in tests.h instead?
> >
> > That's ugly, I'd like to avoid doing that.
> That's your call, but I'm not sure what's uglier: complicating already
> complex make rules or making a header self contained.

The right call is to fix selftests/bpf Makefile for good (there are
more issues, e.g., we rebuild all the prog_tests/*.c for alu32 tests,
even if we only modified test_progs.c), but that's for another patch
set, unless someone beats me and fixes that first.

>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  tools/testing/selftests/bpf/Makefile | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > > index 11c9c62c3362..bb66cc4a7f34 100644
> > > > --- a/tools/testing/selftests/bpf/Makefile
> > > > +++ b/tools/testing/selftests/bpf/Makefile
> > > > @@ -235,7 +235,7 @@ PROG_TESTS_H := $(PROG_TESTS_DIR)/tests.h
> > > >  PROG_TESTS_FILES := $(wildcard prog_tests/*.c)
> > > >  test_progs.c: $(PROG_TESTS_H)
> > > >  $(OUTPUT)/test_progs: CFLAGS += $(TEST_PROGS_CFLAGS)
> > > > -$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_H) $(PROG_TESTS_FILES)
> > > > +$(OUTPUT)/test_progs: test_progs.c $(PROG_TESTS_FILES) | $(PROG_TESTS_H)
> > > >  $(PROG_TESTS_H): $(PROG_TESTS_FILES) | $(PROG_TESTS_DIR)
> > > >       $(shell ( cd prog_tests/; \
> > > >                 echo '/* Generated header, do not edit */'; \
> > > > @@ -256,7 +256,7 @@ MAP_TESTS_H := $(MAP_TESTS_DIR)/tests.h
> > > >  MAP_TESTS_FILES := $(wildcard map_tests/*.c)
> > > >  test_maps.c: $(MAP_TESTS_H)
> > > >  $(OUTPUT)/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
> > > > -$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_H) $(MAP_TESTS_FILES)
> > > > +$(OUTPUT)/test_maps: test_maps.c $(MAP_TESTS_FILES) | $(MAP_TESTS_H)
> > > >  $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
> > > >       $(shell ( cd map_tests/; \
> > > >                 echo '/* Generated header, do not edit */'; \
> > > > @@ -277,7 +277,7 @@ VERIFIER_TESTS_H := $(VERIFIER_TESTS_DIR)/tests.h
> > > >  VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
> > > >  test_verifier.c: $(VERIFIER_TESTS_H)
> > > >  $(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
> > > > -$(OUTPUT)/test_verifier: test_verifier.c $(VERIFIER_TESTS_H)
> > > > +$(OUTPUT)/test_verifier: test_verifier.c | $(VERIFIER_TEST_FILES) $(VERIFIER_TESTS_H)
> > > >  $(VERIFIER_TESTS_H): $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
> > > >       $(shell ( cd verifier/; \
> > > >                 echo '/* Generated header, do not edit */'; \
> > > > --
> > > > 2.17.1
> > > >
