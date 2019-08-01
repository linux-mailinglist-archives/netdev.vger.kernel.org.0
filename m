Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C68A7D8AB
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 11:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731116AbfHAJf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 05:35:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43626 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHAJf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 05:35:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so72785126wru.10;
        Thu, 01 Aug 2019 02:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=5td4UiqtXNr4aAgiX49MfMtCsb9UpANwokqkSwvYTZM=;
        b=QIT8UUrGEB5buANI94Wnzpw7Eo/CH8bceXN4Ba6llNN4JuVA7vzoomP67jvEBKoMiK
         oN7bcyKl3+KdLw1rx46OxFbMQWYK+AGB3i6p1j/rSkah9dSGdrekSTV8GCw23IFmrxOD
         /gLJB0YfWBg7LXVs9ndnwLxUfXG5UK33fMumT6BWJKhlbZVfR5f2FJQkxYon9EiVNo1F
         fqnbnlXvkGJsJiIMZkrrmGLa8ePDNfrMIuooGgT2uV38GK7FoRb6CUauFIvI4MTuuws5
         68gCUrBXrfcao0DR59v/ysvQ9NuROgu9+xAhjf9a33WUa7vGUAnmpHo/gFC2IoVukQvm
         Y83g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=5td4UiqtXNr4aAgiX49MfMtCsb9UpANwokqkSwvYTZM=;
        b=cUEj+CFmn2SXpFXyi8FWZ64uwdcnm4pzIgp9aRONM3SqjDK4HASJkEzI7Ja5gIeQVY
         SXsK379rPWrfmY0qRqZ7ijirC868VnQZVRooEwFfLIlfosbpTW0W7ie+A/uft2U1cVHw
         ApzYJD6kAVHJtRSBlUK2fZXUe+m3wf571aodNGHC0caqBSYRs5wkw1SiisqLLh21hkGV
         XxGeTFVlZ7/v/TewqJw+7P8vMk0pxw6QbUHNzwH7c9QwarWbV17/FXYle52T7d+0+xF7
         xfFBTIhGCv91816wrJK7Ntk0UMPpIB+OfuUBFWwl8e5z4aUFKY8/SQC/3GcXP5OD/7tI
         Emtw==
X-Gm-Message-State: APjAAAXnLRC1kutESic7P0D4VTS3NwBzm/wPCirTYwAMkKgO2L2PAG1N
        jySLbkZuw3raezopT6w+9Vg4FnyJfR/A37YgUMA=
X-Google-Smtp-Source: APXvYqxldszoy+qm6gwieu5nvKrfQb1ofAtw8Yy4YdTAoFlolgpRYBjbsDnb1Mq2T41RBYjYbp60En6a66fnJ+5mAFs=
X-Received: by 2002:a5d:4212:: with SMTP id n18mr16954230wrq.261.1564652157499;
 Thu, 01 Aug 2019 02:35:57 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com> <CA+icZUW1YQqDjFCX5Ek100SbveX0Zevr7T5gbtdpcmZD+kCuZg@mail.gmail.com>
In-Reply-To: <CA+icZUW1YQqDjFCX5Ek100SbveX0Zevr7T5gbtdpcmZD+kCuZg@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 1 Aug 2019 11:35:45 +0200
Message-ID: <CA+icZUV8P=rQh3M3h23Hhd+jAziOwtXj37LZ8FgdZE+SPz-p6A@mail.gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
To:     Yonghong Song <yhs@fb.com>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 9:39 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> Hi,
>
> just want to let you know that I did a git bisect with Linux v5.3-rc2
> (where the problem also exists) and the result (details see [1]):
>
> e55a73251da335873a6e87d68fb17e5aabb8978e is the first bad commit
> commit e55a73251da335873a6e87d68fb17e5aabb8978e
> Author: Josh Poimboeuf <jpoimboe@redhat.com>
> Date:   Thu Jun 27 20:50:47 2019 -0500
>
>     bpf: Fix ORC unwinding in non-JIT BPF code
>
>     Objtool previously ignored ___bpf_prog_run() because it didn't understand
>     the jump table.  This resulted in the ORC unwinder not being able to unwind
>     through non-JIT BPF code.
>
>     Now that objtool knows how to read jump tables, remove the whitelist and
>     annotate the jump table so objtool can recognize it.
>
>     Also add an additional "const" to the jump table definition to clarify that
>     the text pointers are constant.  Otherwise GCC sets the section writable
>     flag and the assembler spits out warnings.
>
>     Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without
> CONFIG_FRAME_POINTER")
>     Reported-by: Song Liu <songliubraving@fb.com>
>     Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>     Acked-by: Alexei Starovoitov <ast@kernel.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Kairui Song <kasong@redhat.com>
>     Cc: Steven Rostedt <rostedt@goodmis.org>
>     Cc: Borislav Petkov <bp@alien8.de>
>     Cc: Daniel Borkmann <daniel@iogearbox.net>
>     Link: https://lkml.kernel.org/r/881939122b88f32be4c374d248c09d7527a87e35.1561685471.git.jpoimboe@redhat.com
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>
> :040000 040000 4735e9d14fa416c1c361ec3923440a3d586a627d
> 31de80b85c7b0292e47a719ecb6b1a451de2f8ef M      kernel
>
> Maybe you want to look at this, too.
>
> The object files are attached in [2].
>
> Thanks,
> - Sedat -
>
> [0] https://github.com/ClangBuiltLinux/linux/issues/619
> [1] https://github.com/ClangBuiltLinux/linux/issues/619#issuecomment-517152467
> [2] https://github.com/ClangBuiltLinux/linux/issues/619#issuecomment-517159635

After reverting above commit I can boot into Linux v5.3-rc2 built with
clang-9.0.0-rc1 and lld with no issues.

- Sedat -
