Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91F76B2B7
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfGQAPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:15:01 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43851 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbfGQAPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:15:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so10220268pgv.10
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 17:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fojjWXnCNTwdB1qCbhOF2YM47yyMWWOW/0JcmLJ0iRk=;
        b=YE7a9qO4fPE3NGrT1o8cT7vFjeWdno0t+1GO570rBLthwBSE1+eLN/1L/jc5pfJ5jP
         MtK64Wb7UveXeN0rTPCsa6StaP3zPIpRsVc4GnIVCPrCuBGvNq2S9ZsOYgT7nLEjcdoy
         p64eEfbZ4VVVNzEOaG9Hz7tqL3oWZm14+OAtlVSGQnaG+MsJqca8gYcPs+4tWmThVknx
         JU24qAYA50i9deZOIlYHFvC/I/bM6NvLUaFj+SSaBegG2R4pat+Qi148jo/6038Fx0r/
         xlGTaPSiNKA5fYb4fLsYmwynvOMoqCR1ARUBI/dgi6bR9ejSkan5dzDjfG5VwhDcuzxW
         sElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fojjWXnCNTwdB1qCbhOF2YM47yyMWWOW/0JcmLJ0iRk=;
        b=sWtYzLwqpHd4Pz4lLIGkhaYB77FfCO2Ky/XQB6duUvbbWlNasEDIg8YduEGK2h0eKw
         cVMyL0SDBzjkuAfpKKpwCyVWHGp7CZV32NoQZGgGUmfoyf76Zz9McUUOpbmi5d8qkDV9
         KxoM29DAguQkUYxg6purCQqIjPbH0UZ7Ve0IfO3T0Mol82OqqA8yIRKSJnlqO9693YLo
         GgKc3cFQ/JULzWfc79Dg1IZYnufMdtEQFCxNdlPZXryoZmcvXC/AEbN9r4Kgo6hBVJ6w
         xzXM8EM0BixHq//pnbh0Xy+GE8/UgAk3DH9ooTX45DfU1+3MpmFyQVL30Au1X3MZe0WQ
         yl9Q==
X-Gm-Message-State: APjAAAUVw9FLN2+10maehz1i968z9R2Yi5rsLg/5jIghui7ZJxf7SbM7
        /JZiLeUChY7ZmClYJsV/K4A=
X-Google-Smtp-Source: APXvYqwFrMGDvFaAdW626eYVaWza9wE0Pvdrh0DP1UjjBmFCK8oOBeomd0JY9zDOycFmBA4GLLra+A==
X-Received: by 2002:a17:90a:374a:: with SMTP id u68mr39915485pjb.4.1563322499898;
        Tue, 16 Jul 2019 17:14:59 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id o13sm21338707pje.28.2019.07.16.17.14.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 17:14:57 -0700 (PDT)
Date:   Tue, 16 Jul 2019 17:14:57 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf 1/2] selftests/bpf: fix test_verifier/test_maps make
 dependencies
Message-ID: <20190717001457.GD14834@mini-arch>
References: <20190716193837.2808971-1-andriin@fb.com>
 <20190716195544.GB14834@mini-arch>
 <CAEf4BzZ4XAdjasYq+JGFHnhwEV3G5UYWBuqKMK1yu1KRLn19MQ@mail.gmail.com>
 <20190716225735.GC14834@mini-arch>
 <CAEf4BzY7NYZSGuRHVye_CerZ1BBBLsDyOT2ar5sBXsPGy8g0xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY7NYZSGuRHVye_CerZ1BBBLsDyOT2ar5sBXsPGy8g0xA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/16, Andrii Nakryiko wrote:
> On Tue, Jul 16, 2019 at 3:57 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 07/16, Andrii Nakryiko wrote:
> > > On Tue, Jul 16, 2019 at 12:55 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 07/16, Andrii Nakryiko wrote:
> > > > > e46fc22e60a4 ("selftests/bpf: make directory prerequisites order-only")
> > > > > exposed existing problem in Makefile for test_verifier and test_maps tests:
> > > > > their dependency on auto-generated header file with a list of all tests wasn't
> > > > > recorded explicitly. This patch fixes these issues.
> > > > Why adding it explicitly fixes it? At least for test_verifier, we have
> > > > the following rule:
> > > >
> > > >         test_verifier.c: $(VERIFIER_TESTS_H)
> > > >
> > > > And there should be implicit/builtin test_verifier -> test_verifier.c
> > > > dependency rule.
> > > >
> > > > Same for maps, I guess:
> > > >
> > > >         $(OUTPUT)/test_maps: map_tests/*.c
> > > >         test_maps.c: $(MAP_TESTS_H)
> > > >
> > > > So why is it not working as is? What I'm I missing?
> > >
> > > I don't know exactly why it's not working, but it's clearly because of
> > > that. It's the only difference between how test_progs are set up,
> > > which didn't break, and test_maps/test_verifier, which did.
> > >
> > > Feel free to figure it out through a maze of Makefiles why it didn't
> > > work as expected, but this definitely fixed a breakage (at least for
> > > me).
> > Agreed on not wasting time. I took a brief look (with make -qp) and I
> > don't have any clue.
> 
> Oh, -qp is cool, noted :)
> 
> >
> > By default implicit matching doesn't work:
> > # makefile (from 'Makefile', line 261)
> > /linux/tools/testing/selftests/bpf/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
> > /linux/tools/testing/selftests/bpf/test_maps: map_tests/sk_storage_map.c /linux/tools/testing/selftests/bpf/test_stub.o /linux/tools/testing/selftests/bpf/libbpf.a
> > #  Implicit rule search has not been done.
> > #  File is an intermediate prerequisite.
> > #  Modification time never checked.
> > #  File has not been updated.
> > # variable set hash-table stats:
> > # Load=1/32=3%, Rehash=0, Collisions=0/2=0%
> >
> > If I comment out the following line:
> > $(TEST_GEN_PROGS): $(OUTPUT)/test_stub.o $(BPFOBJ)
> >
> > Then it works:
> > # makefile (from 'Makefile', line 261)
> > /linux/tools/testing/selftests/bpf/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
> > /linux/tools/testing/selftests/bpf/test_maps: test_maps.c map_tests/sk_storage_map.c
> > #  Implicit rule search has been done.
> > #  Implicit/static pattern stem: 'test_maps'
> > #  File is an intermediate prerequisite.
> > #  File does not exist.
> > #  File has not been updated.
> > # variable set hash-table stats:
> > # Load=1/32=3%, Rehash=0, Collisions=0/2=0%
> > #  recipe to execute (from '../lib.mk', line 138):
> >         $(LINK.c) $^ $(LDLIBS) -o $@
> >
> > It's because "File is an intermediate prerequisite.", but I
> > don't see how it's is a intermediate prerequisite for anything...
> 
> Well, it's "File is an intermediate prerequisite." in both cases, so I
> don't know if that's it.
> Makefiles is not my strong suit, honestly, and definitely not an area
> of passion, so no idea
> 
> >
> >
> > One other optional suggestion I have to your second patch: maybe drop all
> > those dependencies on the directories altogether? Why not do the following
> > instead, for example (same for test_progs/test_maps)?
> 
> Some of those _TEST_DIR's are dependencies of multiple targets, so
> you'd need to replicate that `mkdir -p $@` in multiple places, which
> is annoying.
Agreed, but one single "mkdir -p $@" might be better than having three
lines that define XXX_TEST_DIR and then add a target that mkdir's it.
Up to you, I can give it a try once your changes are in; the
Makefile becomes hairier by the day, thx for cleaning it up a bit :-)

> But I also don't think we need to worry about creating them, because
> there is always at least one test (otherwise those tests are useless
> anyways) in those directories, so we might as well just remove those
> dependencies, I guess.
We probably care about them for "make -C tools/selftests O=$PWD/xyz" case
where OUTPUT would point to a fresh/clean directory.

> TBH, those explicit dependencies are good to specify anyways, so I
> think this fix is good. Second patch just makes the layout of
> dependencies similar, so it's easier to spot differences like this
> one.
> 
> As usual, I'll let Alexei and Daniel decide which one to apply (or if
> we need to take some other approach to fixing this).
I agree, both of your changes look good. I was just trying to understand
what's happening because I was assuming implicit rules to always kick
in.

> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 1296253b3422..c2d087ce6d4b 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -277,12 +277,9 @@ VERIFIER_TESTS_H := $(OUTPUT)/verifier/tests.h
> >  test_verifier.c: $(VERIFIER_TESTS_H)
> >  $(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
> >
> > -VERIFIER_TESTS_DIR = $(OUTPUT)/verifier
> > -$(VERIFIER_TESTS_DIR):
> > -       mkdir -p $@
> > -
> >  VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
> > -$(OUTPUT)/verifier/tests.h: $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
> > +$(OUTPUT)/verifier/tests.h: $(VERIFIER_TEST_FILES)
> > +       mkdir -p $(dir $@)
> >         $(shell ( cd verifier/; \
> >                   echo '/* Generated header, do not edit */'; \
> >                   echo '#ifdef FILL_ARRAY'; \
