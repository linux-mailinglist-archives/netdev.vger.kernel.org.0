Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC4894C23
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfHSR5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:57:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41032 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbfHSR5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:57:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id j16so9622047wrr.8;
        Mon, 19 Aug 2019 10:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=PstLfxbMd5uoHoJPwRPUMJ1FERZxzGFsbBHxhmU6GgM=;
        b=MG19Is3dPCN98xTwP6riTi4/XtA8nqkTg5DgcBE1s2L3xAtPjE+Q95eXVYN56XY/9e
         U/C6RC0Wl65YP3wWHbHxEWF47jayukaycOMmshAwoByZnt7rm3vTQmFdSZRiRTovSDua
         HrsSvudnabx3aSwqCOmCIGUbry1aE0UB/gfePzf8uiL70QjTOR8tIhu7dWyGAcACVpy5
         S1nQJ4SfcthHknqRLcbKLbvMbAkn3GfXgm7a/8sb40hlSSsVzhobhUh8YwRUVDL0sKkL
         S03dzURd2DGMMHGFHl7QQrezspQZW0Kvu8WjMbEpn/gJE4hmZUrnJ5o0nIKnYtl+gCXd
         fXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=PstLfxbMd5uoHoJPwRPUMJ1FERZxzGFsbBHxhmU6GgM=;
        b=JVSJuunIPjPcDunPiSuAM+BHKik+LqLh1xmccpDGxna5IsXPs+KXkVKvjtw0gwbSbH
         53qnUTzj6oxoSJ51g0bDYiq/90kI2nNG8oVc7/Sc55Wrw4kbNTa9pY/OzYS+i6Rkeb1l
         8iO3rGGeyHsaZYnYSbMGM8ABPvBuZcvyh0OY4OyZnuiUih0Te6CrNoReV4zMB35uf456
         0/gyJLBCWprF5ip5zHyue5gUTHgynxMCz2KbVjS5+GuyZJ6gNTXqcKjVdFF4I/vjMemZ
         xmM4Dgnjtk9dkYQQhyMtqPy7dAI8AyuCjLFyppkBXEg0NUSTOf6uxE3PSPxHSoegiO2k
         OnTQ==
X-Gm-Message-State: APjAAAUyWTk7XMJzMDQQjsxPcJ+hAZpZe9v9IzUUxJd/tL6ulrZuXSZ8
        ZnRt0pXPo/X7rVbWQVU2Q09nLRUgl5nID0Be0hE=
X-Google-Smtp-Source: APXvYqwFNnwyaoB69+3OxmGvRN0oyjjcPSYFhKHpiHgnrimAOmyWjxgq7YWAf5sHV4VAzU3QvwQ1qVWq4DKEcWbqM5E=
X-Received: by 2002:a5d:4101:: with SMTP id l1mr30615382wrp.202.1566237420255;
 Mon, 19 Aug 2019 10:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-13-ndesaulniers@google.com> <1566237106.8670clhnrk.naveen@linux.ibm.com>
In-Reply-To: <1566237106.8670clhnrk.naveen@linux.ibm.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 19 Aug 2019 19:56:47 +0200
Message-ID: <CA+icZUVc528uRJ7SPcnzzZQuomdGGOE6+BFPPyRSUpFP2J+Lnw@mail.gmail.com>
Subject: Re: [PATCH 13/16] include/asm-generic: prefer __section from compiler_attributes.h
To:     "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc:     akpm@linux-foundation.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, jpoimboe@redhat.com,
        Martin KaFai Lau <kafai@fb.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        netdev@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 7:52 PM Naveen N. Rao
<naveen.n.rao@linux.ibm.com> wrote:
>
> Nick Desaulniers wrote:
> > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
>
> Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> [ Linux v5.3-rc5 ]

Patchset "for-5.3/x86-section-name-escaping":

include/linux/compiler.h: remove unused KENTRY macro
include/linux: prefer __section from compiler_attributes.h
include/asm-generic: prefer __section from compiler_attributes.h
x86: prefer __section from compiler_attributes.h

- Sedat -
