Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94376DB5CA
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503113AbfJQSTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:19:54 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39114 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438684AbfJQSTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:19:53 -0400
Received: by mail-qt1-f196.google.com with SMTP id n7so4981409qtb.6;
        Thu, 17 Oct 2019 11:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BZGDaHRbot/zkFBLsDuahXid2If7g7NHv2paIMjRMmQ=;
        b=uESyCx4p0BcCVGA523iokmsdWIej74AcIIz+Nmb6AU29v3GzbnmcUV8SEB30s8YSlu
         iE9i4H5LeWuwle85Yq5qg+Fuc+AvvDrDy/hCoTmkzti628RIypR+z7fQs6lezpKmS19G
         Ce1vZABQJOuEXyNpXwKpkOCG/LqTWEAgJExzdD5sDJwM+HRKpIEiiQnQQsy9PSYN1etN
         BxkDS1rbGWb5+d0ktbBM3o0Laq7jtSEG3J1zPGMPPeFwLpjT1THwCi6HxXwkdoXrdjQJ
         bN9cV/qqFbySCnXkv6PklgrgGcneQX6TB5R/Qy3wOZFakUJONW//Gy2FkoQ2K5TebveF
         p6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BZGDaHRbot/zkFBLsDuahXid2If7g7NHv2paIMjRMmQ=;
        b=IsMYMRveelsOd+Cfl/YUrAryLLBxqEIp57QwwET/NoWL20pp3CGE7XPNMK6VKbeEdl
         hGDIVhm9vhPw8sKkcEDcuIZeb2IC11jLYANZ0f6GkLHDbQkdVgIw3XCaZGfvOvihhJMX
         zSzfIJVuuB1u9je7iQGd2JYKgFjT/lbiDjpzK6tbeXWspH2wdseTES50k0pmlsdGHJqX
         FxMBuxCuHdvAo+l6Xqwa8xh3kC2y64qTZzoO3m2Y/4YNuZgT5Rxy+zKOH6es/nwzkPWd
         C2aNExSO/vGGZ7bmFq/liY7zirI9JFjj65mkLlCkX6nR0+1+VBsAHBTVsHtYP5JnLH3O
         S0cQ==
X-Gm-Message-State: APjAAAXH65pORNddHSdG2vMUDMeoCBtiOvUtpMEZn3dtcb1pBq8SxmLS
        FvTxnWwd3WLr1b7OyBaJAf8mF/jE1Q+kfVdcIxmSvlv8
X-Google-Smtp-Source: APXvYqw9SKTaAaRwPtouNF/y4lqkk3aDyz5kb354ncU98pGiNIEcarm4S5KEEw/c6HGUtlTIGQ3L1qKpq0ZGZQzZInA=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr5279459qtn.117.1571336391372;
 Thu, 17 Oct 2019 11:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191016060051.2024182-1-andriin@fb.com> <20191016060051.2024182-6-andriin@fb.com>
 <CAEf4BzZvNQwcn3=sUHjnVfGzAMkfECpiJ7=YEDWSnLFZD7xeCA@mail.gmail.com> <a5076b0f-9cc2-8f5c-7b3c-5882aa595332@fb.com>
In-Reply-To: <a5076b0f-9cc2-8f5c-7b3c-5882aa595332@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Oct 2019 11:19:39 -0700
Message-ID: <CAEf4BzbFEHUqL00cF8bckOfEzeCky9vcRbgaiNK2=mAe=rAY_w@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/7] selftests/bpf: replace test_progs and
 test_maps w/ general rule
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 10:54 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/17/19 10:50 AM, Andrii Nakryiko wrote:
> > On Tue, Oct 15, 2019 at 11:01 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >>
> >> Define test runner generation meta-rule that codifies dependencies
> >> between test runner, its tests, and its dependent BPF programs. Use that
> >> for defining test_progs and test_maps test-runners. Also additionally define
> >> 2 flavors of test_progs:
> >> - alu32, which builds BPF programs with 32-bit registers codegen;
> >> - bpf_gcc, which build BPF programs using GCC, if it supports BPF target.
> >>
> >> Overall, this is accomplished through $(eval)'ing a set of generic
> >> rules, which defines Makefile targets dynamically at runtime. See
> >> comments explaining the need for 2 $(evals), though.
> >>
> >> For each test runner we have (test_maps and test_progs, currently), and,
> >> optionally, their flavors, the logic of build process is modeled as
> >> follows (using test_progs as an example):
> >> - all BPF objects are in progs/:
> >>    - BPF object's .o file is built into output directory from
> >>      corresponding progs/.c file;
> >>    - all BPF objects in progs/*.c depend on all progs/*.h headers;
> >>    - all BPF objects depend on bpf_*.h helpers from libbpf (but not
> >>      libbpf archive). There is an extra rule to trigger bpf_helper_defs.h
> >>      (re-)build, if it's not present/outdated);
> >>    - build recipe for BPF object can be re-defined per test runner/flavor;
> >> - test files are built from prog_tests/*.c:
> >>    - all such test file objects are built on individual file basis;
> >>    - currently, every single test file depends on all BPF object files;
> >>      this might be improved in follow up patches to do 1-to-1 dependency,
> >>      but allowing to customize this per each individual test;
> >>    - each test runner definition can specify a list of extra .c and .h
> >>      files to be built along test files and test runner binary; all such
> >>      headers are becoming automatic dependency of each test .c file;
> >>    - due to test files sometimes embedding (using .incbin assembly
> >>      directive) contents of some BPF objects at compilation time, which are
> >>      expected to be in CWD of compiler, compilation for test file object does
> >>      cd into test runner's output directory; to support this mode all the
> >>      include paths are turned into absolute paths using $(abspath) make
> >>      function;
> >> - prog_tests/test.h is automatically (re-)generated with an entry for
> >>    each .c file in prog_tests/;
> >> - final test runner binary is linked together from test object files and
> >>    extra object files, linking together libbpf's archive as well;
> >> - it's possible to specify extra "resource" files/targets, which will be
> >>    copied into test runner output directory, if it differes from
> >>    Makefile-wide $(OUTPUT). This is used to ensure btf_dump test cases and
> >>    urandom_read binary is put into a test runner's CWD for tests to find
> >>    them in runtime.
> >>
> >> For flavored test runners, their output directory is a subdirectory of
> >> common Makefile-wide $(OUTPUT) directory with flavor name used as
> >> subdirectory name.
> >>
> >> BPF objects targets might be reused between different test runners, so
> >> extra checks are employed to not double-define them. Similarly, we have
> >> redefinition guards for output directories and test headers.
> >>
> >> test_verifier follows slightly different patterns and is simple enough
> >> to not justify generalizing TEST_RUNNER_DEFINE/TEST_RUNNER_DEFINE_RULES
> >> further to accomodate these differences. Instead, rules for
> >> test_verifier are minimized and simplified, while preserving correctness
> >> of dependencies.
> >>
> >> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >> ---
> >
> > BTW, if correctness and DRY-ness argument is not strong enough, these
> > changes makes clean rebuild from scratch about 2x faster for me:
> >
> > BEFORE: `make clean && time make -j50` is 14-15 seconds
> > AFTER: `make clean && time make -j50` is 7-8 seconds
>
> I noticed that too and was about to ask "why?" .. :)

alu32 BPF .o's were dependent on alu32/test_progs for some reason, so
they blocked on all tests be built first, which is completely
backwards and slower. Now all the flavors are built completely in
parallel. Overall CPU usage across all cores increased (because we do
more work compiling binaries), but it's more parallel.
