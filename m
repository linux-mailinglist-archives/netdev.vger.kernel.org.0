Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768536B226
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388880AbfGPW5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:57:39 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39092 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfGPW5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:57:38 -0400
Received: by mail-pf1-f196.google.com with SMTP id f17so5834653pfn.6
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 15:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B/BnPtXDbrAr+em181xJn9+a7aECLVlxMcetcrW7FmE=;
        b=WMuhCKufAV6eCTxPi222WfC1tEfDQKwROmajkFDGjqcjMCdActRdeP15LNt0kdm1y8
         5V3rOrdkv+EKGP0rA7nf8NbpjwZBVxIGn1N9+59/9GpavADGGFN9qDuWBivIgp2sBQcS
         hOMIwAFr+QvA0maVMCnXW/wTs+5Pr433J5N8O3US8eCpNeU1XhB0WCJdEhxNV8gH5ioE
         gJGHln5JUfh3/I5EEnvrUv9y+3/2AaVaJYKCsV0v0ze7MSiSfGTWKuoOaNm7TiERC/Kh
         4FFzHM/Ucxb49WZfzMeRW20+Fw5tl7emyo62tuv1bLl1r8WgQSfEaskNzVTla6+o+4jK
         tqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B/BnPtXDbrAr+em181xJn9+a7aECLVlxMcetcrW7FmE=;
        b=I2elPy2dLQhm9nRAE59JNi2Q0aG6UEMdDvnZNaDvLjSczZKGfF/aD4MOYdGelwj0Jp
         nKGAeV5spxmoq4OSX2aI3X2i+qDSHj/cPUSwW0ExebiUi8URauQbwbb9iWG7BwaguVkt
         QNRmJaj3ooVKymjJERwAXXTvODq/OJ9bwfL6yQcIXttxVLfPIRJXGe9QTUwHqxZ6ZFE0
         pjnZqf2NyGYENbu3IrnI3h+0EXD9fwtc316yUYmSIHfuZg0iTGlgdYT/mETg6lT9IQHu
         4t8sl3rqqARMWR0DE35V05dKB5DPX0JBhkJog6MF5ghs0d/0/lr7TA4EagpIn+hlQFdH
         m2Jw==
X-Gm-Message-State: APjAAAX40VDI2S/nrPex4T7HNqI+TlOHv6eymQt44bNI8+GEd8Qm7GO/
        /zyv64flvT5Wqa3jK7Wi3eE=
X-Google-Smtp-Source: APXvYqw/Wnk98gEIDVPW70HpHABrNzagGDDwvx1T41nR6oVsNnuJ7SPfE3zGod6/D97vK+05BUJ3gw==
X-Received: by 2002:a65:52ca:: with SMTP id z10mr37860305pgp.424.1563317857677;
        Tue, 16 Jul 2019 15:57:37 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id k64sm1377406pge.65.2019.07.16.15.57.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 15:57:36 -0700 (PDT)
Date:   Tue, 16 Jul 2019 15:57:35 -0700
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
Message-ID: <20190716225735.GC14834@mini-arch>
References: <20190716193837.2808971-1-andriin@fb.com>
 <20190716195544.GB14834@mini-arch>
 <CAEf4BzZ4XAdjasYq+JGFHnhwEV3G5UYWBuqKMK1yu1KRLn19MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ4XAdjasYq+JGFHnhwEV3G5UYWBuqKMK1yu1KRLn19MQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/16, Andrii Nakryiko wrote:
> On Tue, Jul 16, 2019 at 12:55 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 07/16, Andrii Nakryiko wrote:
> > > e46fc22e60a4 ("selftests/bpf: make directory prerequisites order-only")
> > > exposed existing problem in Makefile for test_verifier and test_maps tests:
> > > their dependency on auto-generated header file with a list of all tests wasn't
> > > recorded explicitly. This patch fixes these issues.
> > Why adding it explicitly fixes it? At least for test_verifier, we have
> > the following rule:
> >
> >         test_verifier.c: $(VERIFIER_TESTS_H)
> >
> > And there should be implicit/builtin test_verifier -> test_verifier.c
> > dependency rule.
> >
> > Same for maps, I guess:
> >
> >         $(OUTPUT)/test_maps: map_tests/*.c
> >         test_maps.c: $(MAP_TESTS_H)
> >
> > So why is it not working as is? What I'm I missing?
> 
> I don't know exactly why it's not working, but it's clearly because of
> that. It's the only difference between how test_progs are set up,
> which didn't break, and test_maps/test_verifier, which did.
> 
> Feel free to figure it out through a maze of Makefiles why it didn't
> work as expected, but this definitely fixed a breakage (at least for
> me).
Agreed on not wasting time. I took a brief look (with make -qp) and I
don't have any clue.

By default implicit matching doesn't work:
# makefile (from 'Makefile', line 261)
/linux/tools/testing/selftests/bpf/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
/linux/tools/testing/selftests/bpf/test_maps: map_tests/sk_storage_map.c /linux/tools/testing/selftests/bpf/test_stub.o /linux/tools/testing/selftests/bpf/libbpf.a
#  Implicit rule search has not been done.
#  File is an intermediate prerequisite.
#  Modification time never checked.
#  File has not been updated.
# variable set hash-table stats:
# Load=1/32=3%, Rehash=0, Collisions=0/2=0%

If I comment out the following line:
$(TEST_GEN_PROGS): $(OUTPUT)/test_stub.o $(BPFOBJ)

Then it works:
# makefile (from 'Makefile', line 261)
/linux/tools/testing/selftests/bpf/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
/linux/tools/testing/selftests/bpf/test_maps: test_maps.c map_tests/sk_storage_map.c
#  Implicit rule search has been done.
#  Implicit/static pattern stem: 'test_maps'
#  File is an intermediate prerequisite.
#  File does not exist.
#  File has not been updated.
# variable set hash-table stats:
# Load=1/32=3%, Rehash=0, Collisions=0/2=0%
#  recipe to execute (from '../lib.mk', line 138):
        $(LINK.c) $^ $(LDLIBS) -o $@

It's because "File is an intermediate prerequisite.", but I
don't see how it's is a intermediate prerequisite for anything...


One other optional suggestion I have to your second patch: maybe drop all
those dependencies on the directories altogether? Why not do the following
instead, for example (same for test_progs/test_maps)?

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1296253b3422..c2d087ce6d4b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -277,12 +277,9 @@ VERIFIER_TESTS_H := $(OUTPUT)/verifier/tests.h
 test_verifier.c: $(VERIFIER_TESTS_H)
 $(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)
 
-VERIFIER_TESTS_DIR = $(OUTPUT)/verifier
-$(VERIFIER_TESTS_DIR):
-       mkdir -p $@
-
 VERIFIER_TEST_FILES := $(wildcard verifier/*.c)
-$(OUTPUT)/verifier/tests.h: $(VERIFIER_TEST_FILES) | $(VERIFIER_TESTS_DIR)
+$(OUTPUT)/verifier/tests.h: $(VERIFIER_TEST_FILES)
+       mkdir -p $(dir $@)
        $(shell ( cd verifier/; \
                  echo '/* Generated header, do not edit */'; \
                  echo '#ifdef FILL_ARRAY'; \
