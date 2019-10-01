Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D2FC36D7
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 16:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388751AbfJAOQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 10:16:20 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42858 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfJAOQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 10:16:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id w14so21743341qto.9;
        Tue, 01 Oct 2019 07:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zqe/3yQ//FnSWGENLzctmWxawD8BEgiS/3EQrQ4HX8Q=;
        b=U5szjWsyE6rJuE1IsJodEcdG6EC9zXgWg6A1w9p6+VcT3Ug/y6Xf0r6pQ8e3EyaHtJ
         SHuWDz50EB2O+ZJ3Ca4aTVtSbuFgmK+G3EI44O3R+2zpu0kyjzXXOeRhcIh8EPjMVBA3
         Q8dpXPkI4L177mVxdw6QXwBvQsegsNHR71bJLYcv42T6atSGrk8YbrzC4xcsTGsULGqB
         64OB27zXFiLEFyTTSQh6XyO2w8yPC6jW35qlEkoupPUZ+boU5fWvhhAnkmGppaGjnQOu
         oKSMC5PzD7KkhEh2rl6DMF1TpM6SObOk2nBwCbwnLpfFqFQMVXE6fEr17l8+qdJxUv5h
         YWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zqe/3yQ//FnSWGENLzctmWxawD8BEgiS/3EQrQ4HX8Q=;
        b=Fw7foO3f2PASYJVqStJ4mMWRQ6XLykqVTdkur49JeJM80FIWTn2Bvx8Bmq7uRVGaqt
         0N4hvyo+SIhSY7qb9lgkhcqGEIf1BhdsdMNbXlWW/xBkBnxGQZqPNVJclKGgdVd5Hlrn
         EWn3ZKyXtVahkHhKLph8mQFypm1EoFO8mxYFbDCB5FFop8j4zRKh8/jGdIvhYTJfUf96
         09B+hJulFkgevjSlgoKL4oAScKaf403MCzbzQehL9oAA+r9aKtXM60clIm+Y45wwsAb4
         LoczYeBuGMDe5SDboQXASh+x3wjYTdO+eCU2ymrGzenZqNJRhtrC9RimRIly3pp0nHHd
         7Myw==
X-Gm-Message-State: APjAAAVe2cMHQOHWavwUrTPI2U+RkmBqpAXa6yFcdzb78rLNKyKyNSpT
        kAI+4DOS1GPnsgg5pvFr4cQ8mGJtZHPqRr74eDo=
X-Google-Smtp-Source: APXvYqwy5L7lsArt7eRzsOObi54HA7rJbsTO0TkfyRzzAV4GNqKD8qOP15LcFgfixXyNieEk8mnHY5psxc3M3RmPVBM=
X-Received: by 2002:a05:6214:1369:: with SMTP id c9mr25800672qvw.3.1569939377523;
 Tue, 01 Oct 2019 07:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com> <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
In-Reply-To: <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 1 Oct 2019 16:16:05 +0200
Message-ID: <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Oct 2019 at 14:33, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> Hi Bjorn
>
> On Tue, Oct 1, 2019 at 7:14 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
> >
[...]
> >  subdir-$(CONFIG_SAMPLE_VFS)            +=3D vfs
> > +subdir-$(CONFIG_SAMPLE_BPF)            +=3D bpf
>
>
> Please keep samples/Makefile sorted alphabetically.
>

Thank you, I'll address that in the v2!

>
>
>
> I am not checking samples/bpf/Makefile, but
> allmodconfig no longer compiles for me.
>
>
>
> samples/bpf/Makefile:209: WARNING: Detected possible issues with include =
path.
> samples/bpf/Makefile:210: WARNING: Please install kernel headers
> locally (make headers_install).
> error: unable to create target: 'No available targets are compatible
> with triple "bpf"'
> 1 error generated.
> readelf: Error: './llvm_btf_verify.o': No such file
> *** ERROR: LLVM (llc) does not support 'bpf' target
>    NOTICE: LLVM version >=3D 3.7.1 required
>

Yes, the BPF samples require clang/LLVM with BPF support to build. Any
suggestion on a good way to address this (missing tools), better than
the warning above? After the commit 394053f4a4b3 ("kbuild: make single
targets work more correctly"), it's no longer possible to build
samples/bpf without support in the samples/Makefile.


Thanks,
Bj=C3=B6rn

> --
> Best Regards
> Masahiro Yamada
