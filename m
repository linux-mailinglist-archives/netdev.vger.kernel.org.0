Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9893CB091
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 03:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhGPBwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 21:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhGPBwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 21:52:05 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3A9C06175F;
        Thu, 15 Jul 2021 18:49:10 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id u14so11872812ljh.0;
        Thu, 15 Jul 2021 18:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ooSnDnaRR1y2Zt84zTUnLEoZAoDuRHyWJmkvYjQARyY=;
        b=IjXqonnTm4PDZn+/7269i0JJN00zVfCYtT+x/4bKk5lHWl6H5aMSAElprq580/8juE
         1xAU6nQEqlEJ4zLpw30X+OIdNxFDMU/QssAqZS17eJVhNhUChK+M5eqjkFhiuEx56Qit
         8WuWx6fCJkCEYULYt0U3ZeSvaIVn3r/6PBinfskma7puk1fJiUqoxDPsYk1PDNAXjqAy
         OXSLWnRJ9+8fzTJ1f+bIlfG+rZuHpwAi46638Tq+lOTFjaAyu0e6cuS/A/BwFiUMFDT+
         gfK81TdTELwrCZuNwvh6UruV2CK0dI0zkp2qQ1pm5ZAf9hTC8JAbj6sxLAMt4CLDAyKv
         od9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ooSnDnaRR1y2Zt84zTUnLEoZAoDuRHyWJmkvYjQARyY=;
        b=bjPR3oSMfVrRx4fNUYoYFvUOm7YSkCtZUfR0Fq/YYbbEnXXkj73MLK+lWPzDgaCXoF
         8R5OmBYsPAtGWRqbN3/XXqWprlgdRfV11DUNpJTRBMr4VBkATtDUO/WiQuJUXQk7ZzB6
         T9diuuBchlkd82Nk1fyoW/pRG5KMI+vUrBX+giEvYLUqNrh1RQxizqrYSH77ZyPM4J80
         yXSzhZJMSlausR1BOnHPRaCbPih60aqGDUJqQ7icvlpYmn/qBpLAlCBE1yV3ezL0IM7U
         WHX6pFbD79UBgQFtPWYRx5LZAgplmssVfQm/SqpedMuXyDME+wj0YiZzdt1S6u5uxLKD
         Fmtw==
X-Gm-Message-State: AOAM531B10goftB/KdZsiIYicQcKI1kZXBNXPr1daprCSP9QzTfEfLSG
        5QSQE6aUMrNURrCalEZNe6837k9WYdkUooovSXc=
X-Google-Smtp-Source: ABdhPJxi3dW8s9VnSn6wSkvqXocXr6SGUM/bv49mLVpSdhOBoP9wU1TO0PiTIvxstkaRLHqVWXlHEwgRD2k/i8mNXVw=
X-Received: by 2002:a2e:a887:: with SMTP id m7mr2877598ljq.236.1626400148732;
 Thu, 15 Jul 2021 18:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <royujjal@gmail.com> <20210712173723.1597-1-royujjal@gmail.com> <60ee2dc76ac1c_196e22088d@john-XPS-13-9370.notmuch>
In-Reply-To: <60ee2dc76ac1c_196e22088d@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Jul 2021 18:48:57 -0700
Message-ID: <CAADnVQJ=DoRDcVkaXmY3EmNdLoO7gq1mkJOn5G=00wKH8qUtZQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-nxt] Documentation/bpf: Add heading and example for
 extensions in filter.rst
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     "Roy, UjjaL" <royujjal@gmail.com>, Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, BPF <bpf@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 5:20 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Roy, UjjaL wrote:
> > [1] https://www.kernel.org/doc/html/latest/bpf/
> >
> > Add new heading for extensions to make it more readable. Also, add one
> > more example of filtering interface index for better understanding.
> >
> > Signed-off-by: Roy, UjjaL <royujjal@gmail.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
>
> Looks OK to me. I thought the original was readable without the header, but
> if it helps someone seems easy enough to do.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

I cannot figure out how to apply this patch, because I see:
Applying: Documentation/bpf: Add heading and example for extensions in
filter.rst
fatal: empty ident name (for <>) not allowed

Any idea?
