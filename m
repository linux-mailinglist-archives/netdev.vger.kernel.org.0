Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF4D20BC2B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgFZWI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZWI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:08:28 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B4DC03E979;
        Fri, 26 Jun 2020 15:08:28 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id r22so10194519qke.13;
        Fri, 26 Jun 2020 15:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jSyZN+dV0nAYzwU081VEFTTvnV6h68dpjUa3tPmR2iI=;
        b=uRu+tq8ooghzwrB4BruK1jM88p8wFJuKDA1bVkNPLuAPgHTcugvq/2jsFRTREjIFCA
         KJkyI6sLaykVP0QYIQzR9zkg+FmekSXNll0+iGBqqqVVBszDJ4c+uVzsKRs/B2r/y0Ka
         ed+INsBfk2Ef8L8LZ9Zl1tuWZMyyx84i49/+JEpjwjKc2GgE1ZVr1BChJpZ+0BwGW+zY
         ylmLmelskbrb82wJS+DwrAaCD6p2eEtlASnV+lQvHnWe5qC2iQFDcblSorkKGr6wkFqb
         AqqggXsP27M3ZKGFZjg7soioHJxpmrMSbOyUV/moZn9e+cEA1KcX0KXXyoQsEMbG+HoH
         6aFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jSyZN+dV0nAYzwU081VEFTTvnV6h68dpjUa3tPmR2iI=;
        b=c4hyeZLrjUtuDsiNqmfdTdtgw6x9XfuE13Qlj4xenLJRcexvVVM1ur9JGQaH0xrvey
         rlieZp71vHaa8NTtURDHsq5RkSkqFmXO3mqTXkXdsEyajq0SjoMcAB1m9ulExK+nOeCo
         JW0qbTxe0H+ybCspyzRfkvcnh0y8nOWvNC2GsSxZJ3FxlpwCoG/dtU/k/IBretCCTI6j
         FHf112ZhP3XqxRhu6htGa9UJrJZw0P6OGi0brmy97fkYC/jMcO6wXFNZrt1qz6x7u2F4
         dBQe6SlbB2hEXcz8mV8wGBK1C3mX3mp4JXV3BMEfYJS3IaidS0zPymX8e40etsvCNeQK
         LwrA==
X-Gm-Message-State: AOAM532UhFfWSFF9FxCiw0ACCKiL0Sl+OVS6rPsNf2iUkXxHku1UopL6
        DPI5uqYfBGIpvEjYBnXbgn4EwyMmTywci6q6AW4=
X-Google-Smtp-Source: ABdhPJwgbV1eXnTeh5ihNuvCABTzSmHnfA12tptV3k3C5KbRXhB+TQrgs3KS9A32QEPXlpbxDe9g2dMTPtViHO9aYZc=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr5037420qkl.437.1593209307928;
 Fri, 26 Jun 2020 15:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200626165231.672001-1-sdf@google.com> <20200626165231.672001-2-sdf@google.com>
In-Reply-To: <20200626165231.672001-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 15:08:17 -0700
Message-ID: <CAEf4BzYWUZhgK-XpOxV76bzk1pnVzKgyu3AtCRtdVbW2ix4D7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] libbpf: add support for BPF_CGROUP_INET_SOCK_RELEASE
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

On Fri, Jun 26, 2020 at 10:22 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Add auto-detection for the cgroup/sock_release programs.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Left a bunch of comments on v1 of this series, oops.

But where is the cover letter? Did I miss it?

>  tools/include/uapi/linux/bpf.h | 1 +
>  tools/lib/bpf/libbpf.c         | 2 ++
>  2 files changed, 3 insertions(+)
>

[...]
