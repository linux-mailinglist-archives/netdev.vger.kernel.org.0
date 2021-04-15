Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BC53603D8
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhDOIFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:05:54 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:56681 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDOIFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:05:52 -0400
X-Greylist: delayed 2136 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2021 04:05:51 EDT
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 13F856Vb022773;
        Thu, 15 Apr 2021 17:05:06 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 13F856Vb022773
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1618473906;
        bh=LC1wwORrxX4s+QOHO85pxZXBS/KtIoUE4bsRAFozad4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=da54tceNg+886hk0L1yXNqwic53kMAl/yYDA9rfAYHj0ARbrEgFju4bNK2u7DwSzr
         0Nzz3nN74NFBD6BY3vVYIsLJyVstisa/a9wZNFo5HTfFMQNiNdQt34xs/EogI5R2pe
         cGfTLcVB02siJoTnsZGY694SycVShDrvLKCT+fJH4c6gdApVr4yI8sDuiQRVb46uzf
         5zxp+cpLvrquwzMBoqWdhFppX0LrOMfnMp2ux+33w21NjgtbXApne1xnDYHSASKVVS
         d+1LtEJ5CKw8N5jVYem55TDcIAFV5Dpgqe/WelWt36GppnQoPbMUoN2vTaIcYxpiyl
         UETUaHqyqS3pw==
X-Nifty-SrcIP: [209.85.210.169]
Received: by mail-pf1-f169.google.com with SMTP id p67so10591283pfp.10;
        Thu, 15 Apr 2021 01:05:06 -0700 (PDT)
X-Gm-Message-State: AOAM531srx0f25gk07BlcHD6re3R/c0h0vtMMO8k4EDCH91XPITvrY15
        0r22kx+4zgJ8DL4Pd3zbcikywpxA58RKjrTsciQ=
X-Google-Smtp-Source: ABdhPJySz/Ot0PzvuAqwezBmRSJBPOAtDPcVcBLTIDgzgzX8BI0wuMQUhTWcJdx8cpQqmQVarwqfYRNaT9Sfb7D43/8=
X-Received: by 2002:aa7:946b:0:b029:24c:57ea:99bf with SMTP id
 t11-20020aa7946b0000b029024c57ea99bfmr2063757pfq.63.1618473905663; Thu, 15
 Apr 2021 01:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210415072700.147125-1-masahiroy@kernel.org> <20210415072700.147125-2-masahiroy@kernel.org>
 <9d33ee98-9de3-2215-0c0b-cc856cec1b69@redhat.com>
In-Reply-To: <9d33ee98-9de3-2215-0c0b-cc856cec1b69@redhat.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 15 Apr 2021 17:04:28 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQupbmeEVR0njSciv0X9FD+MofeB2Xm=wprEdNaO4TQKQ@mail.gmail.com>
Message-ID: <CAK7LNAQupbmeEVR0njSciv0X9FD+MofeB2Xm=wprEdNaO4TQKQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] tools: do not include scripts/Kbuild.include
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Harish <harish@linux.ibm.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 4:40 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 15/04/21 09:27, Masahiro Yamada wrote:
> > Since commit d9f4ff50d2aa ("kbuild: spilt cc-option and friends to
> > scripts/Makefile.compiler"), some kselftests fail to build.
> >
> > The tools/ directory opted out Kbuild, and went in a different
> > direction. They copy any kind of files to the tools/ directory
> > in order to do whatever they want to do in their world.
> >
> > tools/build/Build.include mimics scripts/Kbuild.include, but some
> > tool Makefiles included the Kbuild one to import a feature that is
> > missing in tools/build/Build.include:
> >
> >   - Commit ec04aa3ae87b ("tools/thermal: tmon: use "-fstack-protector"
> >     only if supported") included scripts/Kbuild.include from
> >     tools/thermal/tmon/Makefile to import the cc-option macro.
> >
> >   - Commit c2390f16fc5b ("selftests: kvm: fix for compilers that do
> >     not support -no-pie") included scripts/Kbuild.include from
> >     tools/testing/selftests/kvm/Makefile to import the try-run macro.
> >
> >   - Commit 9cae4ace80ef ("selftests/bpf: do not ignore clang
> >     failures") included scripts/Kbuild.include from
> >     tools/testing/selftests/bpf/Makefile to import the .DELETE_ON_ERROR
> >     target.
> >
> >   - Commit 0695f8bca93e ("selftests/powerpc: Handle Makefile for
> >     unrecognized option") included scripts/Kbuild.include from
> >     tools/testing/selftests/powerpc/pmu/ebb/Makefile to import the
> >     try-run macro.
> >
> > Copy what they want there, and stop including scripts/Kbuild.include
> > from the tool Makefiles.
>
> I think it would make sense to add try-run, cc-option and
> .DELETE_ON_ERROR to tools/build/Build.include?


To be safe, I just copy-pasted what the makefiles need.
If someone wants to refactor the tool build system, that is fine,
but, to me, I do not see consistent rules or policy under tools/.

-- 
Best Regards
Masahiro Yamada
