Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81C41B9170
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 18:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgDZQIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 12:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725778AbgDZQIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 12:08:40 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3E1C061A0F;
        Sun, 26 Apr 2020 09:08:39 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id b2so14936542ljp.4;
        Sun, 26 Apr 2020 09:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b9kk4vl45+yZfIOFMLozV6PyfATmkyRQJ6xZ8G56ZKQ=;
        b=ZGfYaozgkdnfK55JvLARbIVWkAHmE+BnX1DiWw7pO/OUdvPkivcUUXX34rml3PDerf
         COC4ZHbfmlXquZla3mRNiKsRj0Gbq4XL9RgJyikfhdd9LUJx9WVhLnLjU+U7vM2QpUJr
         4BMSDqO/el4LTSF+8W7wWlm5wlCjfet1sMvt+wZ1HvCNWA8e6LE0tUVC2yOLYMHh5tpj
         6Z6q/rP6YjYCz79/6pEtklfRKQaybAEbkgEklM7i1XoRexDF+Pa5zRecyM87wKhc4q+V
         o+ei78RZqBcpYahe/rxjlpyFgUgBrKq0uZmEHwj+Aj/4zUGWeUgS5StjtMGq44rHYEeB
         Tn/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b9kk4vl45+yZfIOFMLozV6PyfATmkyRQJ6xZ8G56ZKQ=;
        b=KIjYyFuMrvPvz7GOvQybUPwNdGSr/zuZi0/bvwLDTXzJ670urICOkngBE9zBAvEySu
         tcwf57vPfhAIARosIJz7rSELKdNoWmet0QnLPgEBi4tifxTGP40r8BGDrBh/XTNAIG1z
         WKbJ/44jX5VwRpz7LvRlZgngsqx8R+kkcDS1py3KZcKM7Og1BJotMULr3Bl0DBvzMeFl
         HiuWRupNzOLF8LnwR7z5wvrHjT/QjaPEkMai2UAxGzcbX+ut6OVv4dROiQBK+hbq3bNl
         AgfCUwJtHfyOYuFC4GQfUsdCss5M6BeUWKkPI86nlJ7L1eZcWHt8WfQrXxbFSi8Q4iPR
         +jhg==
X-Gm-Message-State: AGi0PuZcj6Mq1Yj6p/BNOzybpr7uC/fn33RRPpIQ/bKfX2+H7tSH0XJZ
        2xWI35IC3ykiShbSprfqulx2NaC0dELgArPnmWc=
X-Google-Smtp-Source: APiQypKqBU3rGhiEO1mO9gk9syX6teWk3R7poC2ly0NQL2QkCZd3eU185uQRC4yn6mfzJkbQZW5KzYDcy7klPauIAXc=
X-Received: by 2002:a2e:b80b:: with SMTP id u11mr11911427ljo.212.1587917317736;
 Sun, 26 Apr 2020 09:08:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200420184750.218489-1-zenczykowski@gmail.com>
In-Reply-To: <20200420184750.218489-1-zenczykowski@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 26 Apr 2020 09:08:26 -0700
Message-ID: <CAADnVQ+oVnmpMbmt482pUs+Nb8tny3_WGPbqTtWvVpCJZsbEKQ@mail.gmail.com>
Subject: Re: [PATCH] net: bpf: make bpf_ktime_get_ns() available to non GPL programs
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:47 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> The entire implementation is in kernel/bpf/helpers.c:
>
> BPF_CALL_0(bpf_ktime_get_ns) {
>        /* NMI safe access to clock monotonic */
>        return ktime_get_mono_fast_ns();
> }
>
> const struct bpf_func_proto bpf_ktime_get_ns_proto =3D {
>        .func           =3D bpf_ktime_get_ns,
>        .gpl_only       =3D false,
>        .ret_type       =3D RET_INTEGER,
> };
>
> and this was presumably marked GPL due to kernel/time/timekeeping.c:
>   EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);
>
> and while that may make sense for kernel modules (although even that
> is doubtful), there is currently AFAICT no other source of time
> available to ebpf.
>
> Furthermore this is really just equivalent to clock_gettime(CLOCK_MONOTON=
IC)
> which is exposed to userspace (via vdso even to make it performant)...
>
> As such, I see no reason to keep the GPL restriction.
> (In the future I'd like to have access to time from Apache licensed ebpf =
code)
>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

The issue of compatibility with apache licensed bpf progs was
brought up few times in the past.
The patch indeed will clear this hurdle.
Applied.
