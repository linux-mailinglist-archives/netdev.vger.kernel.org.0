Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D136EE14B0
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390590AbfJWIuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:50:05 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37530 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390034AbfJWIuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 04:50:05 -0400
Received: by mail-io1-f65.google.com with SMTP id 1so12620973iou.4;
        Wed, 23 Oct 2019 01:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0hIzN5HFHwPOImmBdq7LkFsdyBlAk23Qhvjgx/Ct5Nw=;
        b=E0aVRSyFVDTbGH0GGXiaF1VO2bWh5525i8pepFFnqnmPD/L5ugBcaAy+CqFkn5ktmV
         FndoAt5eUgedUagQVvN1ASrfjlDHBsHqIzRU3MLm7Eb/cHQn7JkhnKRavYB/N0VGV3CX
         wX3KYj2af8Rl5v7/FUkacqU2I8MgHXbx9pamAmT/t5dYbEw0bzKyO/bzHNlhDOiT3NrZ
         26NHJVW5iXtWjkXxdQztamZGtsRKgTGGcvh8TXEQ+yazH5jm1oLLOYbXM8vTeHdkYxH9
         nbkJj29XxLNdPmXKY3P2Tk952iNMYcNZfLzYFwlWjHE04IYMBRzRs0MZkmxhHYSgdGF2
         ouyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0hIzN5HFHwPOImmBdq7LkFsdyBlAk23Qhvjgx/Ct5Nw=;
        b=YNY7kHQ1ulk1myjmFPGAROeYi/0wXjogIbL9odrH3aPVyrSIvFam79oids+pSTi5Ry
         urXdi4X2nJjCxpR2G87A/6uCz1wVw6kz8LH3r/M5s7ivuDy3vp4En3QfPGQvM9U1AOIt
         Bnfx0YP354gB20rTXyl+vwMA9PeUViGzbP5qW1nlFEXjl9sQbFTwxUOBAv24BRVv4L0R
         nnGuL1iBMf3Akp4jFfoMW4ZLPYgoagBuIC3algK0kd+RIWc2zE/VfSAdX8eMlwgT9k/b
         n00K9zeskFkW/5Oo6r931LYUxaGhjw3a4NKlxgSEO6H6Wi6Xgx+lRrAlPXPOzZJYGUpp
         gBMQ==
X-Gm-Message-State: APjAAAUx0lUQ9BwnATx7vkTBxTGoJutG0yx9nZiGON0NZsF8pdPEAzWn
        1BT3+2ZIDM+8o5VhuV0Eh6rvOEKVxdOEzO0dNeA=
X-Google-Smtp-Source: APXvYqyKP6o3polGJrn+yHmC9wL5Ygfjkzr5H+6Cugp8XI6oOVjTJpwNUMvOWQ45ebbfxxCyoTerkjpbkx2X1uO/MJE=
X-Received: by 2002:a5d:9a98:: with SMTP id c24mr2158623iom.203.1571820604517;
 Wed, 23 Oct 2019 01:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <8080a9a2-82f1-20b5-8d5d-778536f91780@gmail.com>
 <6fddbb7c-50e4-2d1f-6f88-1d97107e816f@fb.com> <CAJ2QiJLONfJKdMVGu6J-BHnfNKA3R+ZZWfJV2RNrmUO90LPWPQ@mail.gmail.com>
 <c854894e-6c0a-6d49-4d7f-ae81a34b5711@fb.com>
In-Reply-To: <c854894e-6c0a-6d49-4d7f-ae81a34b5711@fb.com>
From:   Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
Date:   Wed, 23 Oct 2019 14:19:53 +0530
Message-ID: <CAJ2QiJKqU5GDNa4YHggboy4YUJHB_rr6x_dXWy0hK+jD5Sv29g@mail.gmail.com>
Subject: Re: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault with
 llc -march=bpf
To:     Yonghong Song <yhs@fb.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 10:12 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 10/22/19 8:29 PM, Prabhakar Kushwaha wrote:
> > Thanks Yonghong for replying.
> >
> >
> >
> > On Wed, Oct 23, 2019 at 8:04 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 10/22/19 6:35 PM, Prabhakar Kushwaha wrote:
> >>>
> >>>    Adding other mailing list, folks...
> >>>
> >>> Hi All,
> >>>
> >>> I am trying to build kselftest on Linux-5.4 on ubuntu 18.04. I instal=
led
> >>> LLVM-9.0.0 and Clang-9.0.0 from below links after following steps fro=
m
> >>> [1] because of discussion [2]
> >>
> >> Could you try latest llvm trunk (pre-release 10.0.0)?
> >> LLVM 9.0.0 has some codes for CORE, but it is not fully supported and
> >> has some bugs which are only fixed in LLVM 10.0.0. We intend to make
> >> llvm 10 as the one we claim we have support. Indeed CORE related
> >> changes are mostly added during 10.0.0 development period.
> >>
> >
> > can you please help me the link to download as
> > "https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__prereleases.llv=
m.org_&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DDA8e1B5r073vIqRrFz7MRA&m=
=3D-6k0f7iKZO54kHLKBjYdU_7pDlCh61HdtyWQ-d43zwU&s=3D7fbobFiC619_9Pr5b1FbrKvo=
Hl6sg79NZc3rQgNWa1Q&e=3D " does not have LLVM-10.0.0 packages.
>
> llvm 10 has not been released.
> Could you follow LLVM source build insn at
> https://github.com/iovisor/bcc/blob/master/INSTALL.md?
>
> Specifically:
> git clone http://llvm.org/git/llvm.git
> cd llvm/tools; git clone http://llvm.org/git/clang.git
> cd ..; mkdir -p build/install; cd build
> cmake -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD=3D"BPF;X86" \
>    -DCMAKE_BUILD_TYPE=3DRelease -DCMAKE_INSTALL_PREFIX=3D$PWD/install ..
> make
> make install
> export PATH=3D$PWD/install/bin:$PATH
>

Thanks Yonghong..

after following above steps no more segmentation fault are there.

--pk
