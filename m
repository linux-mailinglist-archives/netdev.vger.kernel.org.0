Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F5D8B1C5
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfHMH5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:57:38 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45641 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfHMH5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:57:37 -0400
Received: by mail-qk1-f195.google.com with SMTP id m2so5128643qki.12;
        Tue, 13 Aug 2019 00:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ajCXkLrc00rBA8ZUOVEgUaqN7M+DNR8LSQCK9+5f2+g=;
        b=hR+W5SmZI7SOo4BGVPvIZJQxosWsVYirJtPWKqtwYUG4h951MUobU8A1IHUGe5qzao
         TtBr/p8Vxy/lFiVmXGpiO5WBm9R51Xr5vthjncjDN/KKXlFmWgnFqZ65m0OAyiXtfElZ
         S01PGGYrZpuQGqKrLZjUqz0Cuaezj6p/oemrkWZ/CFVWL9LDRx4WCoEiJAbOsMgdThK5
         pTJksOW3/Wr0V/4IgjzceOz+3Ja3Uu7gbOzZsQc7cww6PUuOZb+yxyfGnQM/hj2ZCEsr
         dG6uBKfeTPfR1sdzFe7Laj17gw9ztsrmbJDJQVTdqEy0Yco6QuRQiN8WV/xkJgzI5kZ3
         BgnA==
X-Gm-Message-State: APjAAAUJKhd+IZvDnXoyjnHErtGyZP31WaDrwgE5/ua5ZdHOnT0QZRoU
        /f64Z+ixBn77xHjrSk3J4cN8pPVZl2sSLyG2qvo=
X-Google-Smtp-Source: APXvYqyIdILv2tk5XVUYMgnMBZrQuAyYo/zEfj71JpNLscoa1cfLXGZuogSNmLMW/R63aVun8nd4KC2DKl1/nuu3cXA=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr32664415qkc.394.1565683056420;
 Tue, 13 Aug 2019 00:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com> <20190812215052.71840-13-ndesaulniers@google.com>
In-Reply-To: <20190812215052.71840-13-ndesaulniers@google.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 13 Aug 2019 09:57:20 +0200
Message-ID: <CAK8P3a2fSKT7AJXwfKQOJ5N3=NtwMOCw_5tuD+oOsmh2g-Kokw@mail.gmail.com>
Subject: Re: [PATCH 13/16] include/asm-generic: prefer __section from compiler_attributes.h
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, sedat.dilek@gmail.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Yonghong Song <yhs@fb.com>,
        Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:52 PM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

The patch looks fine, but it looks like you forgot to add a description.

       Arnd
