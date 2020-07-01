Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A32114AA
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGAVBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgGAVBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 17:01:46 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29261C08C5C1;
        Wed,  1 Jul 2020 14:01:46 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q198so23652206qka.2;
        Wed, 01 Jul 2020 14:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cv1qWtdIHk6JW4Iunzcfp64wRfinXuR+NLvwEzIeGNA=;
        b=MsKI+T/0B1ze0fkfBB3uNsgHwUV/PLo+QV69vfHe+tZRwHgq/ikY2FgE7fd1WUCebH
         jcNo/+K09/a7pcDa+gicNwI5Fy6qtxoZHCBpN/+kGwe7x13AaLttYAmLc29rSEJ4otp3
         Nt094J26zKu8Q4rhMWmxkHknvM4CtSMCXx8fZEM90gQWQHNT0TFi4HwvFsHGuc4KD1zG
         tDnkNG6FNwl84prS1iehbdNa9jx9YsQnMCi4i7n+BlKxGYrjaMTNNIMJZZe5XSF0+XE8
         crZKEga+W2D+8GkgkVlEQnoY2qo/40hhBrfEFlO6SKnGwwnReRORm5X1Y/N+EY1IZgre
         ZWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cv1qWtdIHk6JW4Iunzcfp64wRfinXuR+NLvwEzIeGNA=;
        b=BM34TTLFrWsWgd78R4E0vu3PzoZzqNijEOhav6dVywXE2lYf5pBen+lrQBHoLoaAOB
         iL7ez+D51xrjJkH7QT9SWxFKlWXqPN115SoKveB7pLLaMsA7KYT+TwCDoH1rlApOB05e
         AgzTXdg5ASzECDf3+7DjTBCFffW3Ibk7AJaYh/mDHu+7vRR60f8YINFGO0HeicuTG5Xc
         SMtr11CVWnuHksqpSPhWKlQ97ACPGFvYzSS+d2dI1EhRyAKnx2HgivoAdRKJ3GfQUcHN
         ipfK57G/YbVlVplG9TTMjWvpH3yYzSai/Xyyw+n2R/HdO51T+BcBBeZJ5A/dj/yDxsI0
         yilw==
X-Gm-Message-State: AOAM532YvbS0gl7O1LklpPWW1/9dkZqlIf6/Iyhwf/ONUPGhtPFEKX7z
        /KT2Y+YXbzzaANhUlmB0izpsT0EjwHgmDbBEvQc=
X-Google-Smtp-Source: ABdhPJxTcpwTMt/KLTYCUbvLu7v3m13+3jDiE9Ba9mO7RK3OjHX082axuIcBjdPqx/fmrWkQ3psvZbhA07zNL8tl3Bc=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr16389103qkg.437.1593637305448;
 Wed, 01 Jul 2020 14:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200701201307.855717-1-sdf@google.com> <20200701201307.855717-4-sdf@google.com>
In-Reply-To: <20200701201307.855717-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jul 2020 14:01:34 -0700
Message-ID: <CAEf4BzaiGS9TqrLTr-ss0Zm7VXzzz4A9zy8KHPZnfGwZ3p=+Pw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/4] bpftool: add support for BPF_CGROUP_INET_SOCK_RELEASE
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

On Wed, Jul 1, 2020 at 1:13 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Support attaching to BPF_CGROUP_INET_SOCK_RELEASE and properly
> display attach type upon prog dump.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/common.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index 18e5604fe260..29f4e7611ae8 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -33,6 +33,7 @@ const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
>         [BPF_CGROUP_INET_INGRESS]       = "ingress",
>         [BPF_CGROUP_INET_EGRESS]        = "egress",
>         [BPF_CGROUP_INET_SOCK_CREATE]   = "sock_create",
> +       [BPF_CGROUP_INET_SOCK_RELEASE]  = "sock_release",
>         [BPF_CGROUP_SOCK_OPS]           = "sock_ops",
>         [BPF_CGROUP_DEVICE]             = "device",
>         [BPF_CGROUP_INET4_BIND]         = "bind4",
> --
> 2.27.0.212.ge8ba1cc988-goog
>
