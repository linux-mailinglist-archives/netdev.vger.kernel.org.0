Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253E1D9BEA
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437225AbfJPUsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:48:04 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46562 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfJPUsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:48:04 -0400
Received: by mail-qk1-f196.google.com with SMTP id e66so3557192qkf.13;
        Wed, 16 Oct 2019 13:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UbeoWoE2uZaczN47NwT0wD0UOD+v+MGySpZ07iHNajA=;
        b=MmhdLiA1djl8h014HSkbfYyQsC8OUpz/vtFvEaCBBArvTELABiN18iEerBMHVgDyOt
         Mh8F9YUylIAEEq+2CNLuEjC+PYWsuxQ3brn2l8fXUsUzp7yiBXXKZo9LAIkIX8eeDGG5
         vhLddvQo39oi0iF06PbaRrD4hP39Dy6vZh2fRYBJxitTLrhQOCwKQUp8BSlNoYdgIb6a
         q2//el4etkLHspZdZyCxFfRB/8z+C1RmnlxubBOM6moCWN9/sist+dh04J8ZJ0V7xBjL
         pDwkWAlRxi2U0qA2xIJyoJ8sDRpEvBB0c4V+HaU7TspX+G2OcahxZwfrpGUGPIlgzfdp
         Vryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UbeoWoE2uZaczN47NwT0wD0UOD+v+MGySpZ07iHNajA=;
        b=nkXTm5gRX5mjvnM9cCHR4rLyUmTu3dQNdmZ2LCrp5uYUjcDBkh6NAZf3yHOQht+Xze
         C9Kow4qMl0Gk6MbwP00bUEaMTzR057V+AgKGrZS+Zttiutxcbzx482xHING/pr2x3eas
         NI8vDW9eIMHOCTcKL8elH8j4uDKPCWhDWuSrUtdwr/323IN2DesNoPKHDj4ztUhi/g/2
         9+9+aSOQmn8Zw1PxguUbUiqPDhoU2C9T2STMLo7Quctvxi5rUCmQv6R/5HtdnsE3Lvtf
         7VGs4n53KIcV5blt1kceR0ihRAOs9xV2tGJvn8CYb8C+rg3iOSPdltcKi410swNMRO9n
         7Wwg==
X-Gm-Message-State: APjAAAVR55Iv9cMEeG+l5x3CyOtpJS+o/04nHSb4DFt9KGhq69tgYES4
        6307EzZf/qF4fSusyXK3aqsE0h32o1nrMKAL8EAcHwdTDbo=
X-Google-Smtp-Source: APXvYqwgbJXcMEGJg3C/4vBpbuqKCMcOL4xEUaMIXzeT0I5U3cjqTgg0WNq4zzYhI69f83ic0ea2msSVgVDu8ZKPpdQ=
X-Received: by 2002:a37:b447:: with SMTP id d68mr3416545qkf.437.1571258883057;
 Wed, 16 Oct 2019 13:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191016060051.2024182-1-andriin@fb.com> <20191016060051.2024182-6-andriin@fb.com>
 <20191016163249.GD1897241@mini-arch>
In-Reply-To: <20191016163249.GD1897241@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Oct 2019 13:47:52 -0700
Message-ID: <CAEf4BzYVWc8RWNSthN8whROYJUEijR1Uh3Lyt6bkuhM2tRsq2Q@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/7] selftests/bpf: replace test_progs and
 test_maps w/ general rule
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

On Wed, Oct 16, 2019 at 9:32 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 10/15, Andrii Nakryiko wrote:
> > Define test runner generation meta-rule that codifies dependencies
> > between test runner, its tests, and its dependent BPF programs. Use that
> > for defining test_progs and test_maps test-runners. Also additionally define
> > 2 flavors of test_progs:
> > - alu32, which builds BPF programs with 32-bit registers codegen;
> > - bpf_gcc, which build BPF programs using GCC, if it supports BPF target.
> Question:
>
> Why not merge test_maps tests into test_progs framework and have a
> single binary instead of doing all this makefile-related work?
> We can independently address the story with alu32/gcc progs (presumably
> in the same manner, with make defines).

test_maps wasn't a reason for doing this, alue2/bpf_gcc was. test_maps
is a simple sub-case that was just easy to convert to. I dare you to
try solve alu32/bpf_gcc with make defines (whatever you mean by that)
and in a simpler manner ;)

>
> I can hardly follow the existing makefile and now with the evals it's
> 10x more complicated for no good reason.

I agree that existing Makefile logic is hard to follow, especially
given it's broken. But I think 10x more complexity is gross
exaggeration and just means you haven't tried to follow rules' logic.
The rules inside DEFINE_TEST_RUNNER_RULES are exactly (minus one or
two ifs to prevent re-definition of target) the rules that should have
been written for test_progs, test_progs-alu32, test_progs-bpf_gcc.
They define a chain of BPF .c -> BPF .o -> tests .c -> tests .o ->
final binary + test.h generation. Previously we were getting away with
this for, e.g., test_progs-alu32, because we always also built
test_progs in parallel, which generated necessary stuff. Now with
recent changes to test_attach_probe.c which now embeds BPF .o file,
this doesn't work anymore. And it's going to be more and more
prevalent form, so we need to fix it.

Surely $(eval) and $(call) are not common for simple Makefiles, but
just ignore it, we need that to only dynamically generate
per-test-runner rules. DEFINE_TEST_RUNNER_RULES can be almost read
like a normal Makefile definitions, module $$(VAR) which is turned
into a normal $(VAR) upon $(call) evaluation.

But really, I'd like to be wrong and if there is simpler way to
achieve the same - go for it, I'll gladly review and ack.

>
> > Overall, this is accomplished through $(eval)'ing a set of generic
> > rules, which defines Makefile targets dynamically at runtime. See
> > comments explaining the need for 2 $(evals), though.
> >
> > For each test runner we have (test_maps and test_progs, currently), and,
> > optionally, their flavors, the logic of build process is modeled as
> > follows (using test_progs as an example):
> > - all BPF objects are in progs/:
> >   - BPF object's .o file is built into output directory from
> >     corresponding progs/.c file;
> >   - all BPF objects in progs/*.c depend on all progs/*.h headers;
> >   - all BPF objects depend on bpf_*.h helpers from libbpf (but not
> >     libbpf archive). There is an extra rule to trigger bpf_helper_defs.h
> >     (re-)build, if it's not present/outdated);
> >   - build recipe for BPF object can be re-defined per test runner/flavor;
> > - test files are built from prog_tests/*.c:
> >   - all such test file objects are built on individual file basis;
> >   - currently, every single test file depends on all BPF object files;
> >     this might be improved in follow up patches to do 1-to-1 dependency,
> >     but allowing to customize this per each individual test;
> >   - each test runner definition can specify a list of extra .c and .h
> >     files to be built along test files and test runner binary; all such
> >     headers are becoming automatic dependency of each test .c file;
> >   - due to test files sometimes embedding (using .incbin assembly
> >     directive) contents of some BPF objects at compilation time, which are
> >     expected to be in CWD of compiler, compilation for test file object does
> >     cd into test runner's output directory; to support this mode all the
> >     include paths are turned into absolute paths using $(abspath) make
> >     function;
> > - prog_tests/test.h is automatically (re-)generated with an entry for
> >   each .c file in prog_tests/;
> > - final test runner binary is linked together from test object files and
> >   extra object files, linking together libbpf's archive as well;
> > - it's possible to specify extra "resource" files/targets, which will be
> >   copied into test runner output directory, if it differes from
> >   Makefile-wide $(OUTPUT). This is used to ensure btf_dump test cases and
> >   urandom_read binary is put into a test runner's CWD for tests to find
> >   them in runtime.
> >
> > For flavored test runners, their output directory is a subdirectory of
> > common Makefile-wide $(OUTPUT) directory with flavor name used as
> > subdirectory name.
> >
> > BPF objects targets might be reused between different test runners, so
> > extra checks are employed to not double-define them. Similarly, we have
> > redefinition guards for output directories and test headers.
> >
> > test_verifier follows slightly different patterns and is simple enough
> > to not justify generalizing TEST_RUNNER_DEFINE/TEST_RUNNER_DEFINE_RULES
> > further to accomodate these differences. Instead, rules for
> > test_verifier are minimized and simplified, while preserving correctness
> > of dependencies.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/.gitignore |   5 +-
> >  tools/testing/selftests/bpf/Makefile   | 313 ++++++++++++++-----------
> >  2 files changed, 180 insertions(+), 138 deletions(-)
> >


Please truncate irrelevant parts, easier to review.

[...]
