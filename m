Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A6E311930
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhBFC5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhBFCrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:47:35 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A694DC0698D1;
        Fri,  5 Feb 2021 14:27:19 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id y4so8236892ybk.12;
        Fri, 05 Feb 2021 14:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZF+kVH13+yhFtpWltQEZs61WOnOm+RDU6OENTzqgftM=;
        b=FX3/yhSYZu2WlKBs037VWu5o38fnwMmwmslev82RnmoXC/UZqo9ACDdvZUW97Gtnvl
         0B5V4D17NLpQk2wMrYcikSomF4TMY8UpJ2nNtAoqxFavUqUhA/6XBH4Frgg7gUngspo6
         vvyVoMVsgU6Ei3gs40AlpaBeHMUnHphJ8rJRHAN2O+uj2dNQlkRbdNRNxjQ4S8DaOQ5E
         gVQl8mNta+J0vxwWCbyuM4Hifbjqo4k4X3NILuewRsOdVKRhaggmTZzLxgLrKMgI8CJW
         d1L/r7LX5RsH2t71y1Rz+XzqwBOiMN4C+wWAjCvSCFjauAkWYSyelIvu9kxaMAUN/tiE
         CJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZF+kVH13+yhFtpWltQEZs61WOnOm+RDU6OENTzqgftM=;
        b=b6SZwVGwtB/7LDM/aKntBlr/Fk0OQE3mdTSSqCdjxBZ6j9BCX9xQ4D/atdlt/vZ0Uc
         uDCMicj9JMUtBpoE7QJX9oE3KfAE8ZfEJqem2bmerZpc5/cLYgEb+AAuR6hYVJkg5gYD
         aJcOtEMyEKc5mNnneDZCfESJllqfzG4vRpy8iA4ilnownDzkcJWEizIMFqe7xcNt4tOw
         7Gsf/dDPmltBIiK/yFlO/LAXuS6WpC+Uo8Niau2jqk58PoaFU2rX55u2AzcX1cVHe52D
         vjtzyDLThI52nyOPfJYQiM4mSUipRsgC5PWlaOGj2Lb0GU2/S0u5PalBhbCUaVxTCZmQ
         ibtQ==
X-Gm-Message-State: AOAM532K4s+uFgEh56JD9givHOVFbyXGfGnUam4/5Fwn1dHsCYxNx/z7
        K0xOvxrndABMSKELK/qOBBRZXyGYgvcbiIystE8=
X-Google-Smtp-Source: ABdhPJzUq31FJeNv9UnC/OaU7XfN5zJ4gnklBIWPCabLBw0WdzDZ5wjzOiAS8Xcv2r5S/iv+s/2buOiAdnlYtfo59mI=
X-Received: by 2002:a25:da4d:: with SMTP id n74mr9798106ybf.347.1612564039083;
 Fri, 05 Feb 2021 14:27:19 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org>
In-Reply-To: <20210205124020.683286-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Feb 2021 14:27:08 -0800
Message-ID: <CAEf4Bzao-9wNdHxGu1mMhSie78FyWno-RYJM6_Jay8s=hyUWJg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 0/4] kbuild/resolve_btfids: Invoke
 resolve_btfids clean in root Makefile
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 4:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> resolve_btfids tool is used during the kernel build,
> so we should clean it on kernel's make clean.
>
> v2 changes:
>   - add Song's acks on patches 1 and 4 (others changed) [Song]
>   - add missing / [Andrii]
>   - change srctree variable initialization [Andrii]
>   - shifted ifdef for clean target [Andrii]
>
> thanks,
> jirka
>
>

FYI, your patch #2 didn't make it into the mailing list (see [0]). So
maybe wait for a bit and if it doesn't arrive, re-submit?

  [0] https://patchwork.kernel.org/user/todo/netdevbpf/?series=428711&delegate=121173&state=*

> ---
> Jiri Olsa (4):
>       tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
>       tools/resolve_btfids: Check objects before removing
>       tools/resolve_btfids: Set srctree variable unconditionally
>       kbuild: Add resolve_btfids clean to root clean target
>
>  Makefile                            |  7 ++++++-
>  tools/bpf/resolve_btfids/.gitignore |  2 --
>  tools/bpf/resolve_btfids/Makefile   | 44 ++++++++++++++++++++++----------------------
>  3 files changed, 28 insertions(+), 25 deletions(-)
>
