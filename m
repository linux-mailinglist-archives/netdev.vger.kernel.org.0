Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA3465947
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353606AbhLAWez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353632AbhLAWef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 17:34:35 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C49C061574;
        Wed,  1 Dec 2021 14:31:12 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v138so67875177ybb.8;
        Wed, 01 Dec 2021 14:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E3jOCA6XzToDg8ZlfTZ3eGsABoN8CM2rnYNWMRgMrzk=;
        b=HOEIgKwteYTFP0259sjPTjW8p3JbhVNRfhvh+9Jhz/m4rn3NohF0Rxd2g0///iXiLa
         P3EepHhWvJXBTvu3u2hJ7I2l9C3sB+jlsiZjJZ8OyiSW65acN2XBzQazaf68imcacEGu
         0g3LFqamnuNnE9i8bCnjtBnpgPSIe+qqsktBYF369wSb+yrOb8eN+QA6yhUkeL/SvHgH
         SiLlASCg6zQgle/P8vcIbGG2ATNVxOih+RugcagCxY72oO/inXA0xzDFfZD4bTV4ueKf
         6L+wH68R2ILAl08MxsRFBNhGMzPzwEKV6NElMVzeJ9AzYO9Cf3iw9srcVoB8S7W5AQ8o
         yx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3jOCA6XzToDg8ZlfTZ3eGsABoN8CM2rnYNWMRgMrzk=;
        b=LV5y3nP7bGbiXicy/XSY77LtjSWylGJ2zt/IppsVxZaA3IDjbdG8QAYqSJFrrDFikj
         eqJXbO8tWLQSyGd9DhxgrmjiQAjaIAxbDggjkT4rhzf5yvieGz5UFvPmfeej+bD1y8u/
         LTi70w66LaCmyZHHj8GOEkWyi4ESjHu1K8AVF52VSyrFnF+gn8YHtfHhYeipOdjGVdYb
         JoEZEilWKOxwlADWMxTLYTM0sYulIbemB57uREND4sTCiu35cSFBVa9TnB5Bcd17UxcA
         /tvV0fmMmqD+5wXWYw98qyLa3pPZWcwr1iYbJFfuaEvuh9iJOKsUumxuN1wFL07IzqY7
         +q0A==
X-Gm-Message-State: AOAM532wD4qn96tliRxDFUENM/Dzr3/qFZkHROfLkT4vtJxYos3WPZAh
        PM7xYFmeHDOJQPCINZXYc5KoeYdPuv4+RNRTabI=
X-Google-Smtp-Source: ABdhPJxJMz1sH2AdahfAuGRURSdKD+QHhb6t8Pa4kk0Ha/CBh90gwUa6BzYqDYbqVgdZPtoY1JcwUdkRIksyDMggU7M=
X-Received: by 2002:a25:84c1:: with SMTP id x1mr11376590ybm.690.1638397871960;
 Wed, 01 Dec 2021 14:31:11 -0800 (PST)
MIME-Version: 1.0
References: <20211201164931.47357-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211201164931.47357-1-alexandr.lobakin@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Dec 2021 14:31:00 -0800
Message-ID: <CAEf4BzZOTmmhmiNoHUCVB215t8c_AaCJJkYAkA930NLCzM_Otg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: fix conflicting types in fds_example
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 8:50 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> Fix the following samples/bpf build error appeared after the
> introduction of bpf_map_create() in libbpf:
>
>   CC  samples/bpf/fds_example.o
> samples/bpf/fds_example.c:49:12: error: static declaration of 'bpf_map_create' follows non-static declaration
> static int bpf_map_create(void)
>            ^
> samples/bpf/libbpf/include/bpf/bpf.h:55:16: note: previous declaration is here
> LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
>                ^
> samples/bpf/fds_example.c:82:23: error: too few arguments to function call, expected 6, have 0
>                 fd = bpf_map_create();
>                      ~~~~~~~~~~~~~~ ^
> samples/bpf/libbpf/include/bpf/bpf.h:55:16: note: 'bpf_map_create' declared here
> LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
>                ^
> 2 errors generated.
>
> fds_example by accident has a static function with the same name.
> It's not worth it to separate a single call into its own function,
> so just embed it.
>
> Fixes: 992c4225419a ("libbpf: Unify low-level map creation APIs w/ new bpf_map_create()")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  samples/bpf/fds_example.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/samples/bpf/fds_example.c b/samples/bpf/fds_example.c
> index 59f45fef5110..9a7c1fd7a4a8 100644
> --- a/samples/bpf/fds_example.c
> +++ b/samples/bpf/fds_example.c
> @@ -46,12 +46,6 @@ static void usage(void)
>         printf("       -h          Display this help.\n");
>  }
>
> -static int bpf_map_create(void)
> -{
> -       return bpf_create_map(BPF_MAP_TYPE_ARRAY, sizeof(uint32_t),
> -                             sizeof(uint32_t), 1024, 0);
> -}
> -
>  static int bpf_prog_create(const char *object)
>  {
>         static struct bpf_insn insns[] = {
> @@ -79,7 +73,8 @@ static int bpf_do_map(const char *file, uint32_t flags, uint32_t key,
>         int fd, ret;
>
>         if (flags & BPF_F_PIN) {
> -               fd = bpf_map_create();
> +               fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, sizeof(uint32_t),
> +                                   sizeof(uint32_t), 1024, 0);

Would be even better to use bpf_map_create() API instead, but that's
fine, I'm sending a big clean up patch for this and other uses of
deprecated APIs in samples/bpf. Applied to bpf-next.

>                 printf("bpf: map fd:%d (%s)\n", fd, strerror(errno));
>                 assert(fd > 0);
>
> --
> 2.33.1
>
