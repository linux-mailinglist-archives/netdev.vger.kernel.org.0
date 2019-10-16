Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A06D86B3
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391062AbfJPDej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:34:39 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39300 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391051AbfJPDeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:34:37 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so34000879qtb.6;
        Tue, 15 Oct 2019 20:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cHMSwUMQCjqTsQYOITYbvuWALygpIA6MBM/zI7lJttM=;
        b=ODn8uExzLq5SGS2CZVXPKjaxLqK9w80qxTMEMT7VDqzFYb2z2xduzlMcb2pVdot3bX
         8uTe1UXS4HCXbhfENkMCxw5Rla2pcN9FtW3QiaIV3b4QV5/2YSLk/M76Y4w6aeiasK2p
         1Vz34xh5ZkErLAtPEM6DDZt6T6jkRZMTnZskJv/9/Q7RxX+5MP2P3dmAfyFnWPtPA1jo
         QwSzsZQVWVUAG5CIobagrDY0VEu+MeW2M3DFbomOu5YQDYKOdS8EqunbdOiLGpTIZ1Ry
         IxCDQ+HyYRJXFU1sdq55/+mz6Cv+g38cIKge0h5PE666hvsziDfFoRGys10JUmFNZCZW
         FnXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cHMSwUMQCjqTsQYOITYbvuWALygpIA6MBM/zI7lJttM=;
        b=B0ZYB6sTTn0Yvfu7II7/7YxiE5eS8zvuZQTEiz7QwIHxKm923Ak+ZxOZUtiA12LsHX
         QBS0juBZwdp63KsrObg2gNAYlp5UYP7CSIYFbYSFTxvOb5jaJG+OWC8FjMZ9hNEBlSFR
         7tiIcfvNEPOCRLqdxc0qza8/BLfrT34TKYgGAULhcxb8zMj+2H0VQgNLF835EvZCHzt4
         Xur1J95ZMUX/IKUCIs9JSUTgDClp5K6Ic42HD6tlCHMaeMl8av6JNTKRww2ALyMk+cN1
         ztho9JW7/g+FFdEvfpq0tN0EZCGH0KG8FBwHmfrenc+NgFlA55PRWicnLoM9uITamyVP
         tTiA==
X-Gm-Message-State: APjAAAW/SGkO4zZe2VtSyYpTRaHZwKeQmZx5ENwxM4ii9m68jPFHuI2f
        vEnmdDiD827EEFfcG3h3vmTTOp3XEHnaX55vDbnL9fmD
X-Google-Smtp-Source: APXvYqwfg3gBZt772I9auJljUVT0oQCyEtFZNSq4slj7T3FXIxYEzjBrYDofBrvXVcngKgrD74BbelSE0JD89UuAmZA=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr41352702qtj.171.1571196875887;
 Tue, 15 Oct 2019 20:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20191015220352.435884-1-andriin@fb.com> <20191015220352.435884-6-andriin@fb.com>
 <ca129d11-f243-8e46-38df-df0a52cb9c97@fb.com> <CAEf4BzbahEkKfU_Eys1Tu6SJkZd=RDv=-H01m5KesNGfAuBK6g@mail.gmail.com>
In-Reply-To: <CAEf4BzbahEkKfU_Eys1Tu6SJkZd=RDv=-H01m5KesNGfAuBK6g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Oct 2019 20:34:24 -0700
Message-ID: <CAEf4BzbG9u-hhgX1HDf1PavfWv1fc-hs_DD_6khemerxi=qxew@mail.gmail.com>
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

On Tue, Oct 15, 2019 at 4:50 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Oct 15, 2019 at 4:41 PM Alexei Starovoitov <ast@fb.com> wrote:
> >
> > On 10/15/19 3:03 PM, Andrii Nakryiko wrote:
> > > Define test runner generation meta-rule that codifies dependencies
> > > between test runner, its tests, and its dependent BPF programs. Use that
> > > for defining test_progs and test_maps test-runners. Also additionally define
> > > 3 flavors of test_progs:
> > > - alu32, which builds BPF programs with 32-bit registers codegen;
> > > - bpf_gcc, which build BPF programs using GCC, if it supports BPF target;
> > > - native, which uses a mix of native Clang target and BPF target for LLC.
> >
> > Great improvement, but it's taking it too far.
> > (clang  -I. -I/data/users/ast/net-next/tools/testing/selftests/bpf -g
> > -D__TARGET_ARCH_x86 -I. -I./include/uapi
> > -I/data/users/ast/net-next/tools/include/uapi
> > -I/data/users/ast/net-next/tools/lib/bpf
> > -I/data/users/ast/net-next/tools/testing/selftests/usr/include
> > -idirafter /usr/local/include -idirafter
> > /data/users/ast/llvm/bld/lib/clang/10.0.0/include -idirafter
> > /usr/include -Wno-compare-distinct-pointer-types -O2 -emit-llvm -c
> > progs/test_core_reloc_existence.c -o - || echo "BPF obj compilation
> > failed") | llc -march=bpf -mcpu=probe   -filetype=obj -o
> > /data/users/ast/net-next/tools/testing/selftests/bpf/native/test_core_reloc_existence.o
> > progs/test_core_reloc_existence.c:47:18: error: use of unknown builtin
> > '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
> >          out->a_exists = bpf_core_field_exists(in->a);
>
> Do you use latest clang that supports __builtin_preserve_field_info()?
> All the flavors are building just fine for me with latest clang.

Ok, so I didn't have __builtin_preserve_field_info() tests together
with these Makefile changes and thus test_progs-native was compiling
just fine for me. __builtin_preserve_access_index() is not
BPF-target-only built-in, so it was compiling fine for non-BPF target.

I've dropped test_progs-native and added back test_xdp.o override, but
now **after** we define generic rule for test_progs, which will cause
it to override previous test_xdp.o recipe. This causes make to emit
warning about rule re-definition, which I'm not excited about, but
avoiding it would require some further checks and filterings in
DEFINE_TEST_RUNNER_RULES just for the sake of avoiding this warning,
which seems to be an overkill...

I'm wondering if we can just drop that mixed native Clang/bpf LLC mode
altogether? But for now we have it with a warning in v2.

>
> >
> > native clang + llc is useful for old school tracing only (before CO-RE).
>
> Don't disagree (I actually have little context why we needed this
> special case at all), but I had no errors or warnings whatsoever. I
> think in this particular case it's not specific to test_progs-native
> build, can you please double-check on your side?
