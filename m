Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD5041BB0D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243313AbhI1Xfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243285AbhI1Xfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 19:35:45 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3AEC06161C;
        Tue, 28 Sep 2021 16:34:05 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 75so738346pga.3;
        Tue, 28 Sep 2021 16:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h24Y/kU4aKtRh6g7biQbWx3x7udSPQEcujcIEn455v0=;
        b=Mo1um+Z+QYjFY/3/an5OPYNFh+LEMl1J3HqnTAyDZaoYFJU1/zWYVG5v3qZdxy9Ndk
         BFPBZ9AF/esBWOvQ+JWl8TxjscwgTN04e9uA3WgDulYBxOE4XRjlYw0k+bydNPafVL8t
         FItKfZWmzqWTspr5d5hFdW+2fa+7CaSMYq5+5hcyxqsdh7YlcLDNwu5DH//ce+zSH/nq
         lsx3i2Jy++83X2T8vvG1ZBqvGf771MgPUN1rYpTL3/3Gg/8wp9dsK9CWqqZTI24MbybD
         rq7OwoJ+ehTi8QMRJvyID6D6EhaR/t6VYR93anBQStPD2GRgAPYPxRPyGjh81SQkqukW
         GnMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h24Y/kU4aKtRh6g7biQbWx3x7udSPQEcujcIEn455v0=;
        b=DXJHie8yTHFrosmFQY2oIDUaeck80O7fJwdgimKJ3A93z5+hFVEhKeBzl493Ejx5la
         PEp+5TgX9JeMvJN6R0jvB5M0U0sdL0aCG/eCdRrFvJ5GQUS172Qy8JqAOG+vAVzWy4ZD
         v2rdzgPsoMv2vQK4xhezHju5kQMU/PnVABqx4pp3ntk81w8X3gm5g2a6rEXMHuwXg9mJ
         ng+BUIGv1M57QAlQXCHZLNJnEMiMABvRgJbpGZol0IgecChfNauNwhE6qVEGUpGFfpkp
         sIhfYRoayjzZiZRvJmHoZBGDwtVDp0j9TbgCduOKx3qlATV6CjGkPmnxHKU19PBA/Brz
         tfMg==
X-Gm-Message-State: AOAM531y7ROyXaaUn0uaWyb3DfnascMs2kAdvZSS2+eaJ4ClB7uMQZoa
        IgJo/8dtRyTnlJ88yBhWTbHOg7pw0YILf5MN/VQ=
X-Google-Smtp-Source: ABdhPJz30jvU7lO+zF3B5UC0yuoIV5T9T/sFi3ZGEZLGPXoPHji902/gE1XIbkGFGU3Fc+XmdI5bjHjt2rmV/m64yok=
X-Received: by 2002:a63:374c:: with SMTP id g12mr3873161pgn.35.1632872044701;
 Tue, 28 Sep 2021 16:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210928230946.4062144-1-keescook@chromium.org>
In-Reply-To: <20210928230946.4062144-1-keescook@chromium.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 Sep 2021 16:33:53 -0700
Message-ID: <CAADnVQL7eY1Vs5S+DuYhFKYoP83Vr5CQ5sjn=UT_6Xo3=HGMvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/2] bpf: Build with -Wcast-function-type
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 4:09 PM Kees Cook <keescook@chromium.org> wrote:
>
> Hi,
>
> In order to keep ahead of cases in the kernel where Control Flow Integrity
> (CFI) may trip over function call casts, enabling -Wcast-function-type
> is helpful. To that end, replace BPF_CAST_CALL() as it triggers warnings
> with this option and is now one of the last places in the kernel in need
> of fixing.
>
> Thanks,
>
> -Kees
>
> v2:
> - rebase to bpf-next
> - add acks
> v1: https://lore.kernel.org/lkml/20210927182700.2980499-1-keescook@chromium.org

Applied. Thanks
