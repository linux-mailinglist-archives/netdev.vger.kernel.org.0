Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48F2216275
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgGFXmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGFXmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:42:39 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3396C061755;
        Mon,  6 Jul 2020 16:42:38 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 80so36591081qko.7;
        Mon, 06 Jul 2020 16:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bB5FFY1o1SXMaSePC8AGyXpJZPodQHMMWB1Mxiqik+g=;
        b=kmpD1ucBCvDwX5WMw8iuYIr097nfIBET4WQz5CzMtw+BNhWNK78SKEj2eF4RA/DIBi
         yCmdIHcTM4bLN9/9dK9WQzRHa8qb2ylknZwV6gu205Du96CChK6WfvS9R4DcZTuWAhOT
         ScQBFRLq4BFD2dBrPmExkvWc5Fdibd38kIKRYAbJIiPjoOt6FvV1GKiaWgtMYlZIYmNb
         qVZBsjoaVLSX7Jx19NiZthF0UBChdNpg2E5szRGhis+bP5IFQtu2HJLlD5bYlSi3mak1
         n+tgPE0DroNCpstcDQ8FloFf2iC1ZmLVHlqbGkO/JT5EQrAXU61l6gmFcX3ZopnojMs5
         8cLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bB5FFY1o1SXMaSePC8AGyXpJZPodQHMMWB1Mxiqik+g=;
        b=KW1K3q0GEL8s5/iX86+TemXkaeqq3/T+UktktAZOXH8AweCgpo6WKGzcyCRtnO5Iov
         DcHBbgD0c5dUA732Qz8o8OBxIlqFQwbLW33xm4AE60hCy4bXK4b5kpp3mOMD9g02b5+W
         uF/IrfCr3gQypg4rx5qAM6UmwEs+efrc/cB+U6aLgZUv3hrux/c43aViqqPLFqrESJER
         7U6JWGaj520TKgoAwfvZWau4kXLtygOGJ4LoUoaBix8GL5H/KO4lYQ987Hr9l30I0dvV
         pJJms3RROTHfA8fxdKJxp4iBT7dDTnHJiXluj0OZZ8IqX3cz3N7xaqjZycnMK3o1H9tr
         YwZA==
X-Gm-Message-State: AOAM532tJ9JDtqRzVbaRLuyPahK3jiFxPg9r4eVp3Zk780SvIEqxbi4Q
        eGOcG+rXIaDoQET2aR0zdNyqQ6OMSc1kHPefBaA=
X-Google-Smtp-Source: ABdhPJzD6EKkYIf0iGkE+p/F00LIb6GcvMegdgZskHX1BjQ1sHeualFXr5q8LeE5iWw8izwmfK+LR91hB1c7ICLabok=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr51414960qkn.36.1594078958173;
 Mon, 06 Jul 2020 16:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200706230128.4073544-1-sdf@google.com> <20200706230128.4073544-2-sdf@google.com>
In-Reply-To: <20200706230128.4073544-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 16:42:27 -0700
Message-ID: <CAEf4Bzb=vHUC2dgxNEE2fvCZrk9+crmZAp+6kb5U1wLF293cHQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/4] bpf: add BPF_CGROUP_INET_SOCK_RELEASE hook
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 4:02 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Implement BPF_CGROUP_INET_SOCK_RELEASE hook that triggers
> on inet socket release. It triggers only for userspace
> sockets, the same semantics as existing BPF_CGROUP_INET_SOCK_CREATE.
>
> The only questionable part here is the sock->sk check
> in the inet_release. Looking at the places where we
> do 'sock->sk = NULL', I don't understand how it can race
> with inet_release and why the check is there (it's been
> there since the initial git import). Otherwise, the
> change itself is pretty simple, we add a BPF hook
> to the inet_release and avoid calling it for kernel
> sockets.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup.h | 4 ++++
>  include/uapi/linux/bpf.h   | 1 +
>  kernel/bpf/syscall.c       | 3 +++
>  net/core/filter.c          | 1 +
>  net/ipv4/af_inet.c         | 3 +++
>  5 files changed, 12 insertions(+)
>

Looks good overall, but I have no idea about sock->sk NULL case.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index c66c545e161a..2c6f26670acc 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h

[...]
