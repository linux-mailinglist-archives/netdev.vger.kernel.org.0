Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1C794C4E
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfHSSEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:04:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38911 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbfHSSEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 14:04:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id m125so349299wmm.3;
        Mon, 19 Aug 2019 11:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=tUcOXNX2zC70q2t+0okvMXMrXAEyzz9rz6/LOSIeTAk=;
        b=Rnh0DQu+/MB2jLgSBMXi3BoGmqfY2khDvuyDn+rKPwoIXpFUS1IexJmmWhHJazgwPS
         4CL5bakfS3BpOE99QkmNOhsCyehQ4q5+QWiQK1jJfD+msg8iJ7d0sKZaKH3wRgF5zrc5
         4e7YdHWecSMb8FRMK9/JYZpNRynwBaMidnGw5z1Ij02xFtPHXthA+QRfYVM5B0Fn3Sze
         4qYqpk+QYDh6SnJSf4k1xAkgySXGeh0M50cZTY/hJm3An9z09UctJgBiqVmPMqJeeLHz
         YZSzFuacwb/JECnLu+LTCylvzT3PN4pxcJzSKK8QbzpaKQGwyd3KDhrOKXgrLLZOUVgd
         3aiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=tUcOXNX2zC70q2t+0okvMXMrXAEyzz9rz6/LOSIeTAk=;
        b=AI7Lsb/TWf2jOrznE+pdGvsFy6TlTKRIc/rsi0fwJa6zuxsOzzSowxUvAO8BfuXNAj
         GcGH9GqgfaKI6tGhHwZgssWF7Qjyujt4agNR6kVbj+e0WSdxhSXwkch5ZjHFsAFHCXJw
         J8fQ2Pj9FN1dJVr3IIrov3SbgNlCrHMbsFRC24s4U7kNcBokqoMQV8rF5EkPWGUkDwwA
         IR4IPe2RBmsAn2ZMXPT9LjToythTAArSU+yyAE5/QBh06ZJxcWhsR+sMZtpLk6sH7U/5
         ew5f6JbrvJlvgO57FLtzOanMIB4cB2a/l1TFScF0JkWlm3tun/OfSAAzyxI6xuLAO0PU
         xSVw==
X-Gm-Message-State: APjAAAX7ffX1H7isV1RbuY5D02WTNrdCK3qPNllFQ1BjCA/GmW9RErw1
        SsQzeZj3P8tZjT0vyuf3PGmL0V6oWG6AZpNIqys=
X-Google-Smtp-Source: APXvYqwY0mCPH7GrFalAdiROKYfTw8WmuByZgq2+NAqg3yMSCHDG65TVNUR0/FIX/jM3uDBy5DkALYvf70twGNdTVKY=
X-Received: by 2002:a05:600c:10ce:: with SMTP id l14mr21400781wmd.118.1566237851230;
 Mon, 19 Aug 2019 11:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com> <20190812215052.71840-15-ndesaulniers@google.com>
In-Reply-To: <20190812215052.71840-15-ndesaulniers@google.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 19 Aug 2019 20:03:58 +0200
Message-ID: <CA+icZUWjJ27CHwRExsvxrnWkaEx71j8pcf7HBeZc8GWnjLcLQw@mail.gmail.com>
Subject: Re: [PATCH 15/16] include/linux/compiler.h: remove unused KENTRY macro
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     akpm@linux-foundation.org, jpoimboe@redhat.com, yhs@fb.com,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:53 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> This macro is not used throughout the kernel. Delete it rather than
> update the __section to be a fully spelled out
> __attribute__((__section__())) to avoid
> https://bugs.llvm.org/show_bug.cgi?id=42950.
>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> [ Linux v5.3-rc5 ]

Patchset "for-5.3/x86-section-name-escaping" (5 patches):

compiler_attributes.h: add note about __section
include/linux/compiler.h: remove unused KENTRY macro
include/linux: prefer __section from compiler_attributes.h
include/asm-generic: prefer __section from compiler_attributes.h
x86: prefer __section from compiler_attributes.h

Thanks.

- Sedat -

> ---
>  include/linux/compiler.h | 23 -----------------------
>  1 file changed, 23 deletions(-)
>
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 5e88e7e33abe..f01c1e527f85 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -136,29 +136,6 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
>  } while (0)
>  #endif
>
> -/*
> - * KENTRY - kernel entry point
> - * This can be used to annotate symbols (functions or data) that are used
> - * without their linker symbol being referenced explicitly. For example,
> - * interrupt vector handlers, or functions in the kernel image that are found
> - * programatically.
> - *
> - * Not required for symbols exported with EXPORT_SYMBOL, or initcalls. Those
> - * are handled in their own way (with KEEP() in linker scripts).
> - *
> - * KENTRY can be avoided if the symbols in question are marked as KEEP() in the
> - * linker script. For example an architecture could KEEP() its entire
> - * boot/exception vector code rather than annotate each function and data.
> - */
> -#ifndef KENTRY
> -# define KENTRY(sym)                                           \
> -       extern typeof(sym) sym;                                 \
> -       static const unsigned long __kentry_##sym               \
> -       __used                                                  \
> -       __section("___kentry" "+" #sym )                        \
> -       = (unsigned long)&sym;
> -#endif
> -
>  #ifndef RELOC_HIDE
>  # define RELOC_HIDE(ptr, off)                                  \
>    ({ unsigned long __ptr;                                      \
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>
