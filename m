Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48093147A7
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 05:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhBIEqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 23:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhBIEqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 23:46:35 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30823C061786;
        Mon,  8 Feb 2021 20:45:55 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id 133so4237616ybd.5;
        Mon, 08 Feb 2021 20:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A6BzBFq/h4O9r6Thlrxst/c/U1T17VZ5hS40vkBwc/Y=;
        b=LcJXMO8xiunbWqATrRgeIHzUFG5/EcP+UslcOUQh0ruyQzNobdHYE8XsmNeaLNV5h/
         O10U7u4vbMLUlmBgMcZJ8k9zGXpEclEdGE60tOBcE2berd3Mrk+1NSkaU/63z3YjYRTW
         x8xVpPI5c0flvl18gFaPFOglMOgAla9oN9fHnRaGnTn77+yyVEqhSG6TngS3sMx/+0qi
         5tytQtOd4WMkm+C0QDBdQtngg2RYjf4+ma85PCKq0DADGiGpp0RbVte1uJcmhec3zWCC
         hG6Snv//degpWwmlEKLkvdQ9kqxWEAQ1QcEPix7Pj0tBkKeaoXzFfW8Q+lQ5ldIne2PF
         QSgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A6BzBFq/h4O9r6Thlrxst/c/U1T17VZ5hS40vkBwc/Y=;
        b=CWhpaCaAjdMl1XEr4EgvIcxkhYA49XSAI8TRDGAfIKnq7V59mdd9JUI10aeSyIb5PP
         QuShWQpdWm8W+na0oNpKfbDr9129t5M6iVIrgLi5vu8qDh0Pm7xh2vNU4RG5u3xuW07p
         Nl39G5PvYDlaV3GmgH6J0A9UD7w1P1DnIaYAxphE5zsKzwLp3v+A9mVwOgyH6/z63kjT
         zvuBahCbF9iH7eDfUdyx6aMOK4xyDgLI7tLgtsUnqm+rwgN7ifCKfhFiVyiWUTu+1X0j
         ZH5/ZJnuP4QV+pwPKu1oxeMVTLJe4ZC2zZkE6E6t8zmSEjyaAkvoCDnToq7D1lVxkhzs
         dzwg==
X-Gm-Message-State: AOAM532q509r8k7rU6QlEHKfzjcudaolHvFzAz3aNCt9jq/xFyobwSQJ
        KAIQ1fh6etlCc27qJ4cRGmKfUEYYad7/yNiQIRE=
X-Google-Smtp-Source: ABdhPJwTHmlPJ5odFMU0zR5R39M/5rFywQYPwloIZVJAlmgnpe/XCEu0LEPh9FoS8LNa9b514A7GzdYx3OW257PZAbU=
X-Received: by 2002:a25:a183:: with SMTP id a3mr29427620ybi.459.1612845954258;
 Mon, 08 Feb 2021 20:45:54 -0800 (PST)
MIME-Version: 1.0
References: <20210209034416.GA1669105@ubuntu-m3-large-x86>
In-Reply-To: <20210209034416.GA1669105@ubuntu-m3-large-x86>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Feb 2021 20:45:43 -0800
Message-ID: <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 7:44 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Hi all,
>
> Recently, an issue with CONFIG_DEBUG_INFO_BTF was reported for arm64:
> https://groups.google.com/g/clang-built-linux/c/de_mNh23FOc/m/E7cu5BwbBAAJ
>
> $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
>                       LLVM=1 O=build/aarch64 defconfig
>
> $ scripts/config \
>     --file build/aarch64/.config \
>     -e BPF_SYSCALL \
>     -e DEBUG_INFO_BTF \
>     -e FTRACE \
>     -e FUNCTION_TRACER
>
> $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
>                       LLVM=1 O=build/aarch64 olddefconfig all
> ...
> FAILED unresolved symbol vfs_truncate
> ...
>
> My bisect landed on commit 6e22ab9da793 ("bpf: Add d_path helper")
> although that seems obvious given that is what introduced
> BTF_ID(func, vfs_truncate).
>
> I am using the latest pahole v1.20 and LLVM is at
> https://github.com/llvm/llvm-project/commit/14da287e18846ea86e45b421dc47f78ecc5aa7cb
> although I can reproduce back to LLVM 10.0.1, which is the earliest
> version that the kernel supports. I am very unfamiliar with BPF so I
> have no idea what is going wrong here. Is this a known issue?
>

I'll skip the reproduction games this time and will just request the
vmlinux image. Please upload somewhere so that we can look at DWARF
and see what's going on. Thanks.

> Cheers,
> Nathan
