Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355DB44C5A5
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 18:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhKJRGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 12:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhKJRGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 12:06:04 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF26C061764;
        Wed, 10 Nov 2021 09:03:16 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b13so3595476plg.2;
        Wed, 10 Nov 2021 09:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mBVJ5ckaj1U7LCVrGTqIX+IPqB1XJBNYQd38Ft9SXuo=;
        b=i3HPuC8amfjQDaCVo8OmB80yRP0Nf6qbPP5751y6IuSgmDz/oFWcWe25Qpz0nC6TdW
         Tkg2mHYf+YKimxrN3w3kwTe3axusXnhk+Rx+cizEJq8yuSknIa3K1W0F1MPSM2854Yrj
         P6+b4EKsdndVqQ35AAE5esvxwo/Mp75tkAfSpv+AfSoWzbp3SPZnMqqcKO67APAjQAX5
         chtxU5SRYTebHcxWGKc3rThQga8H22Fg2sMMRk7mnhN8aIrTvsHBh9oAjugNUo5heDGs
         jQAlgXpzmN2iBBKS+rGHup7/B5ymTJYnfWJd3txv2NBb4pQ9wCnxEcSvVosQNiBaWB1w
         9whw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mBVJ5ckaj1U7LCVrGTqIX+IPqB1XJBNYQd38Ft9SXuo=;
        b=LuLqPvTq0k/k+xo2ZYgGgvrVl1W1iVv89m3KbOyN6FXzwUMc3Zjk8qGxB/JXer2ziF
         hS87ZcNo9kIBuGQHpwbRYpKtlVojyKDntTU50QKPcQ76d39QD63Eg18YEaj0ptRC8zr7
         6J+JeykWPU148w/GUG3QCT6ffWVeDwmEhq9pBNsJ/P2b9d93Dix2s52k/Ye7Bwc0fbQ4
         Ay8y3GX5SBL+fhx7HCKdzay6mVpEz3kYpNhR48rCO6qvhCYGiN8PYDLdUL10OWWAxOh9
         +WPKfR5Ecy3RdNdNtf1S8K/Mh+0AqQwujMbSq9lEbCG7/VPXDec8vfdx7CQu2wMcZu3L
         P66A==
X-Gm-Message-State: AOAM5318owMZBBw/BeV8Beq1lXkaPBj1uHC57TizQsvkl0Md3aQ/iSFB
        CoQTroIDAjtvXWGhTDd8SgLtA3k76KijXEaX4eU=
X-Google-Smtp-Source: ABdhPJwYOvb+bKn8DdC8j6wI3L9MqGJeV5v4v/NNIFruOHmQHa5M6eQqnTTxSYB4LOd1qjaTMd76onmCgcNzzjoOUSs=
X-Received: by 2002:a17:90b:4c03:: with SMTP id na3mr429035pjb.62.1636563795875;
 Wed, 10 Nov 2021 09:03:15 -0800 (PST)
MIME-Version: 1.0
References: <20211105221904.3536-1-quentin@isovalent.com> <20211110071033.23d48b10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211110071033.23d48b10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 10 Nov 2021 09:03:04 -0800
Message-ID: <CAADnVQ+jQse2pgGEkGfTOBWSoFhoWwofBqQoauKJ2tyS5FACEw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: Fix SPDX tag for Makefiles and .gitignore
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Joe Stringer <joe@cilium.io>,
        Peter Wu <peter@lekensteyn.nl>, Roman Gushchin <guro@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 7:10 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  5 Nov 2021 22:19:04 +0000 Quentin Monnet wrote:
> > Bpftool is dual-licensed under GPLv2 and BSD-2-Clause. In commit
> > 907b22365115 ("tools: bpftool: dual license all files") we made sure
> > that all its source files were indeed covered by the two licenses, and
> > that they had the correct SPDX tags.
> >
> > However, bpftool's Makefile, the Makefile for its documentation, and the
> > .gitignore file were skipped at the time (their GPL-2.0-only tag was
> > added later). Let's update the tags.
> >
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Applied. Thanks everyone.
