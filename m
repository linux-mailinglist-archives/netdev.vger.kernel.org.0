Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5C8DB755
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407055AbfJQTTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:19:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44257 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfJQTTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:19:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id m13so3710645ljj.11;
        Thu, 17 Oct 2019 12:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pVfkFNPnlQwA+KcUzCM2RDsYTKi71hV6zw8Mlz/JNN0=;
        b=ZsrAc+AbqSaSAmc/YZFuAKhVTkObd1vG+m8XmkFEtQV4TpdeKs2UlP0Qr6aJGHq39/
         mfwfqYuQ373KsMHDzxBxVBIF6M9TWnPvHz9ER/w/StLj5uAKH4DBBvbHFDZyxCT/CXYl
         MHz6PUsEQhyaf8x4rlaiictRlxuCnKwmvTBysjwteCRRPpQvII0oPYn9He9vqEEThcE8
         JxWG6iJ3GJVFRf4+vTdNIQaeJcUol4y8bIbtv+mHreRNetjbdk8TxMBhGgh40cqGF1V2
         utmmHPBx37WBatZOevC1kIaHf7h8mVf1i6wPEGCiwp/oHCeeLZFeBQeNbgXkMAtwJoWA
         OWSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pVfkFNPnlQwA+KcUzCM2RDsYTKi71hV6zw8Mlz/JNN0=;
        b=tLKBhA4T4skg7j8CVeioHZYx/wjfalSRMQ0BMLY2CUzG4hnhaQXMVHi7f3tVPB9Kj1
         ArXjw4ig4LrvCteVpgQ8UnxOi8/H60/rg0XiqyfZ/0+LpLrY2sFhXtWW7A4tueQyfYio
         bnPdZm+01GBiEfarEk6XRULiWh0dEgWSINLS89TF5kLco9wUj/HrNefz2xL5y5ehgNLX
         iyhndhOs7yNZc7lI4HraCQz1M9YG12iK1898OM64+9K/lEjwXKYo6+rcXyNm8IYaOHOH
         /Q462GociYlu0QsLoodAsEKLpmWOV3fG54OAMktWsoG1pJyB3K7cwk0AS5XnpQpUATPy
         v4lA==
X-Gm-Message-State: APjAAAWvaGFLILDtUSyjZ81YY+5H61slnFpimYicMtEDMJ1LyNglY2EZ
        lhGAB3JDCmgb3deGlJ6FS70vN+2or50/3sptVHMScA==
X-Google-Smtp-Source: APXvYqy7Y+bLYa2auEVAx3jtSdnENivJdF4Y8fbNHOQCUFZOEVGneNmqPYgR09XmmfsoLQ4L3MIJHmcvbQOQXLUaqIc=
X-Received: by 2002:a2e:4e12:: with SMTP id c18mr3695247ljb.51.1571339943936;
 Thu, 17 Oct 2019 12:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191016060051.2024182-1-andriin@fb.com> <CAADnVQJKESit7tDy0atn0-Q7Se=kLhkCWGAmRPJSVPdNAS8BVg@mail.gmail.com>
 <CAEf4BzZaSznrp0xLZ6Skpt3yuompUJU6XV863zSOPQfq4VL-UA@mail.gmail.com> <877e53oktg.fsf@cloudflare.com>
In-Reply-To: <877e53oktg.fsf@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Oct 2019 12:18:51 -0700
Message-ID: <CAADnVQL1pgYFD2A_v7qPTDHy2N51Lx7siB3SfVrJj3TJZ3LuRw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/7] Fix, clean up, and revamp selftests/bpf Makefile
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 1:09 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Oct 17, 2019 at 08:52 AM CEST, Andrii Nakryiko wrote:
> > On Wed, Oct 16, 2019 at 9:28 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Wed, Oct 16, 2019 at 4:49 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >> >
> >> > This patch set extensively revamps selftests/bpf's Makefile to generalize test
> >> > runner concept and apply it uniformly to test_maps and test_progs test
> >> > runners, along with test_progs' few build "flavors", exercising various ways
> >> > to build BPF programs.
> >> >
> >> > As we do that, we fix dependencies between various phases of test runners, and
> >> > simplify some one-off rules and dependencies currently present in Makefile.
> >> > test_progs' flavors are now built into root $(OUTPUT) directory and can be run
> >> > without any extra steps right from there. E.g., test_progs-alu32 is built and
> >> > is supposed to be run from $(OUTPUT). It will cd into alu32/ subdirectory to
> >> > load correct set of BPF object files (which are different from the ones built
> >> > for test_progs).
> >> >
> >> > Outline:
> >> > - patch #1 teaches test_progs about flavor sub-directories;
> >> > - patch #2 fixes one of CO-RE tests to not depend strictly on process name;
> >> > - patch #3 changes test_maps's usage of map_tests/tests.h to be the same as
> >> >   test_progs' one;
> >> > - patch #4 adds convenient short `make test_progs`-like targets to build only
> >> >   individual tests, if necessary;
> >> > - patch #5 is a main patch in the series; it uses a bunch of make magic
> >> >   (mainly $(call) and $(eval)) to define test runner "skeleton" and apply it
> >> >   to 4 different test runners, lots more details in corresponding commit
> >> >   description;
> >> > - patch #6 does a bit of post-clean up for test_queue_map and test_stack_map
> >> >   BPF programs;
> >> > - patch #7 cleans up test_libbpf.sh/test_libbpf_open superseded by test_progs.
> >> >
> >> > v3->v4:
> >> > - remove accidentally checked in binaries;
> >>
> >> something really odd here.
> >> Before the patchset ./test_progs -n 27 passes
> >> after the patch it simply hangs.
> >> Though strace -f ./test_progs -n 27 passes.
> >> Any idea?
> >
> > Interesting. For me test_progs -n27 passes by itself, whether with or
> > without Makefile changes. But when run together with #8
> > flow_dissector_reattach, it fails with
> > "(prog_tests/sockopt_inherit.c:28: errno: Network is unreachable) Fail
> > to connect to server", even without Makefile changes. It doesn't hang,
> > but the test has server and client threads being coordinated, so I
> > wouldn't be surprised that under some specific timing and error
> > conditions it can hang.
> >
> > I bisected this failure to f97eea1756f3 ("selftests/bpf: Check that
> > flow dissector can be re-attached"), that's when
> > flow_dissector_reattach test was added. So apparently there is some
> > bad interaction there.
> >
> > So I suspect my Makefile changes have nothing to do with this, it
> > would be really bizarre...
> >
> > Jakub, do you mind checking as well?
>
> This is my fault. flow_dissector_reattach test is not returning to the
> netns we started in. Sorry about the oversight. Let me post a fix.

Thanks for the fix.
Now it all works nicely and selftests/bpf build time improvement
is dramatic.

Applied the set to bpf-next.
Thanks
