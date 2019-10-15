Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7F8D8492
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbfJOXvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:51:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39937 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbfJOXvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:51:11 -0400
Received: by mail-qt1-f195.google.com with SMTP id m61so33353085qte.7;
        Tue, 15 Oct 2019 16:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1MOJStCOUv8KHV3oQ5oTGIgvH48SjsRLCavXI4SQNqg=;
        b=ArqtleoVBOrEfsARRB9ksodwi5tzbxe8pvf8vUhl6X4Jb0GYtE2fo4hfxdhGUR8HLF
         S+spv6Xag85Re78/fakRBIsj7wdlvxPBpYwc7TkeLJhQRIrgMLjhXTnO4LR04U3mt5sA
         X5YdV5xp+2hhwYbob3VPtx29IQ7asuw41oCcc9LPbDWPFc30xNZox/8pYiKSGk2RX+L2
         0tixu3k6XUpp64ToVHO0ZAQ1/usx14rSKhtILQNQX3jetUhFSX1eX8Gzy5lZjSHeCReq
         PKQTrYEDt7zMorBh56osoUlnTJwbrhMYODjr1yoBXkqrJ75MK/jHr/vnmU3A+KmHbbbz
         OsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1MOJStCOUv8KHV3oQ5oTGIgvH48SjsRLCavXI4SQNqg=;
        b=H7njb4p8dy6fg5A5mW28ac0cTdFQ9eMnd6pBNsgjKMTzUq/3ZtDCjh28SEGTth3bPU
         lKWl4UdxpVZJW8kWq07xaHuJzZp0mHuYTAZoY6G20wPKzBrdgvGdD5L4guCqxR8CBJmD
         qEN4C39btOWMr4V7OhlMrdIwmHOXqN2Eg/stWidVrWJ0yPIoUKuhwgQubx8pgOnjkek5
         T8yPkyGhFWEU1g4ej7v01WLnFVRjI5B65M1EUr5tJzFVsSlwqPHcnklEWB9vb6CQ38kZ
         tMYE9J8WM2pjzEi1r0oqMDF0ze4U3IEqIt3l2a21XE75jxWxSU6jihKBffNFT8dgcokp
         x5Xg==
X-Gm-Message-State: APjAAAUXiWQfYs8nezX+MGJb2f8/dt4CHM0vu0wAyh/ivBtQS2EGu1Z8
        Tl2Rx/eihoM9/oqAanvKdj2O+C4kdVOUfYCHkb0=
X-Google-Smtp-Source: APXvYqw14fZ3VIjRO8VyfpjolDBiVT58/EFq37rDiv6ZUw9XP8/GPtOp6kch298fFXkOSlsHjsM58GZFcZe5wJhwTtM=
X-Received: by 2002:ac8:379d:: with SMTP id d29mr39748902qtc.93.1571183470319;
 Tue, 15 Oct 2019 16:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191015220352.435884-1-andriin@fb.com> <20191015220352.435884-6-andriin@fb.com>
 <ca129d11-f243-8e46-38df-df0a52cb9c97@fb.com>
In-Reply-To: <ca129d11-f243-8e46-38df-df0a52cb9c97@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Oct 2019 16:50:58 -0700
Message-ID: <CAEf4BzbahEkKfU_Eys1Tu6SJkZd=RDv=-H01m5KesNGfAuBK6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] selftests/bpf: replace test_progs and
 test_maps w/ general rule
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 4:41 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/15/19 3:03 PM, Andrii Nakryiko wrote:
> > Define test runner generation meta-rule that codifies dependencies
> > between test runner, its tests, and its dependent BPF programs. Use that
> > for defining test_progs and test_maps test-runners. Also additionally define
> > 3 flavors of test_progs:
> > - alu32, which builds BPF programs with 32-bit registers codegen;
> > - bpf_gcc, which build BPF programs using GCC, if it supports BPF target;
> > - native, which uses a mix of native Clang target and BPF target for LLC.
>
> Great improvement, but it's taking it too far.
> (clang  -I. -I/data/users/ast/net-next/tools/testing/selftests/bpf -g
> -D__TARGET_ARCH_x86 -I. -I./include/uapi
> -I/data/users/ast/net-next/tools/include/uapi
> -I/data/users/ast/net-next/tools/lib/bpf
> -I/data/users/ast/net-next/tools/testing/selftests/usr/include
> -idirafter /usr/local/include -idirafter
> /data/users/ast/llvm/bld/lib/clang/10.0.0/include -idirafter
> /usr/include -Wno-compare-distinct-pointer-types -O2 -emit-llvm -c
> progs/test_core_reloc_existence.c -o - || echo "BPF obj compilation
> failed") | llc -march=bpf -mcpu=probe   -filetype=obj -o
> /data/users/ast/net-next/tools/testing/selftests/bpf/native/test_core_reloc_existence.o
> progs/test_core_reloc_existence.c:47:18: error: use of unknown builtin
> '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
>          out->a_exists = bpf_core_field_exists(in->a);

Do you use latest clang that supports __builtin_preserve_field_info()?
All the flavors are building just fine for me with latest clang.

>
> native clang + llc is useful for old school tracing only (before CO-RE).

Don't disagree (I actually have little context why we needed this
special case at all), but I had no errors or warnings whatsoever. I
think in this particular case it's not specific to test_progs-native
build, can you please double-check on your side?
