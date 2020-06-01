Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDCE1EB18E
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgFAWOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgFAWOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:14:14 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E534C061A0E;
        Mon,  1 Jun 2020 15:14:14 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z13so10148542ljn.7;
        Mon, 01 Jun 2020 15:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RzKgCrc8vg8fqNSIHGUDZYQQW78gZB/RF3qSjZmaXYA=;
        b=RpLII1yLNE/BEbcqLZFkDDi6L26sc0pz2B+rtP+B5I7Oqppu4qunjjSH0ciXNH6Ox8
         yLW2rJIDaTJmpMBRQpppXPxLpTgGzigo9ofPFdD1JpJmj9QKSji0+XhtgO9XMd4GqG0o
         0cn7wxBEU7B6u33nCMb4RO3J2OTiJLEla9468VfuAd5Te5SNIQzepebI4QEDYsEPnZkU
         QtASA3Qhso2L/yjube9Wi4bYi6qKKCxy6jOHjnSgr9+kVNn52w2cpewtrKoeijDqa59E
         l5NoDo0zFUOx8tUVv47BFzRt92SqS7HF78xQeMM80wUYpanVQpXnSbXzz6ur9tlGgrMP
         wKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RzKgCrc8vg8fqNSIHGUDZYQQW78gZB/RF3qSjZmaXYA=;
        b=oneDMb+lSH9d7ti43aC0pEjV7o6dcuGNj+fKQajSzhAQpvPWvM19oi1E7ZApWeqN0v
         NW732aiaMQumuMbGQxJTuvMMmMeWsglo12Pek/stJ9BCDxgCrQfxtsBPWgjYK4bYD18L
         4kPn6y9Ncu4NwMQMrKt7+TCRHHWgmLQ/zvk0axTjgyvC15X6CjVKRbgcW5Ct8G+aUhxk
         Sv0RoW96ZtHbLqvGZb2oVUTXZF+w0kXLnjKSPUrPGFGZyUrQ/pmdWTqt8VOqhkUMs087
         N2bfCJR0S5XNHgsbhGO8Pg96rrenquGljKHe0DwTBh4VbVcGCuNulFWIRLOgFwooPwmg
         wvnw==
X-Gm-Message-State: AOAM531cJFuNAGjGHRhudHasv2bWYL6KHox2VwwepuEprl2JLhWTtrrX
        kf0+h4bQseSlCEwctCQZCYI9WXCcl0IwcjLb3Ow=
X-Google-Smtp-Source: ABdhPJwXLyg0F2Ec1klMoIbDt2W7UJcvdeuLDtQ6PizueeFsiKLawAOV6NFGHJtV1PWR/FXgtv8weA3ej47B9uZnfXQ=
X-Received: by 2002:a2e:974a:: with SMTP id f10mr5907492ljj.283.1591049652823;
 Mon, 01 Jun 2020 15:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200601202601.2139477-1-andriin@fb.com> <CAPhsuW7PooK=u12k2NDeSdm8NMTW1aUKGRbmAuLAXgRKT12MpQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7PooK=u12k2NDeSdm8NMTW1aUKGRbmAuLAXgRKT12MpQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 15:14:01 -0700
Message-ID: <CAADnVQ+ACNzxC5GsEPKXBgpbBBr9zZyp62gUmzpKWAWchfO+zg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add _GNU_SOURCE for reallocarray to ringbuf.c
To:     Song Liu <song@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 1:36 PM Song Liu <song@kernel.org> wrote:
>
> On Mon, Jun 1, 2020 at 1:26 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > On systems with recent enough glibc, reallocarray compat won't kick in, so
> > reallocarray() itself has to come from stdlib.h include. But _GNU_SOURCE is
> > necessary to enable it. So add it.
> >
> > Fixes: 4cff2ba58bf1 ("libbpf: Add BPF ring buffer support")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>

Applied. Thanks
