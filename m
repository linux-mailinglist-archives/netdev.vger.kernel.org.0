Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E352938D2AB
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 02:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhEVAtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 20:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhEVAtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 20:49:52 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94D9C061574;
        Fri, 21 May 2021 17:48:27 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id g38so29780119ybi.12;
        Fri, 21 May 2021 17:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Opkg+FRkVCkZvC29Z5nXDDi9OwE3akN5/fnsR1XnwUk=;
        b=SOnbHgRZV2f41rzY5t4crajjI3gNTvwldOcKA1XcmNZ2cUf6WTUuVZKBIatlcvtiJP
         FSCatGD3uGApFYmqaWChDLrkbR6ewXkthxmOh5Jv1FULPPFqLSSURFrtQP1hsE6pU/sx
         VdLJwmZ1Pm9AEQcUNyd4vx3DltQZOUDKlhWz0R4MCZZV3FMwdOZbmUGslcmB/f3FzzGn
         thGvkHQq3Hlpmsl8SERipF1IVJyuxw6NYH8Vv3PAbGF4iCUtgtmUaoHMQT1Dm3e0gSg0
         iyz155SdlCcAL+3p2CdJO/l24/JhqFDj2VLL+uMUd/K68oFIbaKX8s+3Bx7wKdPn4r2v
         276A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Opkg+FRkVCkZvC29Z5nXDDi9OwE3akN5/fnsR1XnwUk=;
        b=lr0RsIEe45FCOxrHnDfhP7NIB73NTPYjsY4lm1Hma3ZcFt1sD7Oz43IPiW0XIBSM3b
         XgzBo47JBpbdp4IzLFC1zp8lVsvrZ6AT9pYeijXYgd+ZDt3StydmZ8suKKy4qMF+/Pxj
         /ucI3ImR9fwNyFQBfc2o6YRtMnb0/Fc+eqCiFqeHRVo3u7ncug4YCF7240Bmnrt86vTu
         cf5rPZbHjJAkSy0/h+7BqP+El84hgQPCwGwv5/VO64gvoXVV5fjURfNAsTZKcOuPjUCv
         IRMEWaRcC6xyUGObsMPbsccB9bDYAM9mCsFJ2ZeFriuKBWo6gD2+ehg5Qp9NInAy+Ya7
         d2bQ==
X-Gm-Message-State: AOAM530vSyUq8WBv5lbFep9b328eaO9ZZfpOoG/y9j331iCra6aplN//
        z6TGDOS9O1HFuzwon5ezkD/er5VNKzkpqoEbz7S5TyNELrA=
X-Google-Smtp-Source: ABdhPJzk0LWuA8tRdBb2Yf+xQAKzckkUS1DfLqahObkGHLlnGHkNnwJMQ3oer+07Mwu03Ugf0nk0bsaWOTX8LBINbIc=
X-Received: by 2002:a25:1455:: with SMTP id 82mr18600079ybu.403.1621644507107;
 Fri, 21 May 2021 17:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtvmr09BwE79QzNxiauQtUD7tZhCAbVVH3Vv=anaqt-yA@mail.gmail.com>
In-Reply-To: <CA+G9fYtvmr09BwE79QzNxiauQtUD7tZhCAbVVH3Vv=anaqt-yA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 May 2021 17:48:16 -0700
Message-ID: <CAEf4BzY8q9FZoudxan1aHoL0uw86-itfq0+QsSsn=Q_vRpKtNQ@mail.gmail.com>
Subject: Re: bbpf_internal.h:102:22: error: format '%ld' expects argument of
 type 'long int', but argument 3 has type 'int' [-Werror=format=]
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 6:51 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> The perf build failed on i386 on Linux next-20210519 and next-20210520 tag
>  with gcc-7.3 due to below warnings / errors.

Thanks, being addressed in [0].

  [0] https://lore.kernel.org/bpf/20210521162041.GH8544@kitsune.suse.cz/

>
> In file included from libbpf.c:55:0:
> libbpf.c: In function 'init_map_slots':
> libbpf_internal.h:102:22: error: format '%ld' expects argument of type
> 'long int', but argument 3 has type 'int' [-Werror=format=]
>   libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
>                       ^
> libbpf_internal.h:105:27: note: in expansion of macro '__pr'
>  #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
>                            ^~~~
> libbpf.c:4568:4: note: in expansion of macro 'pr_warn'
>     pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
>     ^~~~~~~
> libbpf.c:4568:44: note: format string is defined here
>     pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
>                                           ~~^
>                                           %d
> In file included from libbpf.c:55:0:
> libbpf_internal.h:102:22: error: format '%ld' expects argument of type
> 'long int', but argument 5 has type 'int' [-Werror=format=]
>   libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
>                       ^
> libbpf_internal.h:105:27: note: in expansion of macro '__pr'
>  #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
>                            ^~~~
> libbpf.c:4568:4: note: in expansion of macro 'pr_warn'
>     pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
>     ^~~~~~~
> libbpf.c:4568:70: note: format string is defined here
>     pr_warn("// TODO map_update_elem: idx %ld key %d value==map_idx %ld\n",
>                                                                     ~~^
>                                                                     %d
>   CC      /srv/oe/build/tmp-lkft-glibc/work/intel_core2_32-linaro-linux/perf/1.0-r9/perf-1.0/cpu.o
> In file included from libbpf.c:55:0:
> libbpf.c: In function 'bpf_core_apply_relo':
> libbpf_internal.h:102:22: error: format '%ld' expects argument of type
> 'long int', but argument 3 has type 'int' [-Werror=format=]
>   libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
>                       ^
> libbpf_internal.h:105:27: note: in expansion of macro '__pr'
>  #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
>                            ^~~~
> libbpf.c:6192:3: note: in expansion of macro 'pr_warn'
>    pr_warn("// TODO core_relo: prog %ld insn[%d] %s %s kind %d\n",
>    ^~~~~~~
> libbpf.c:6192:38: note: format string is defined here
>    pr_warn("// TODO core_relo: prog %ld insn[%d] %s %s kind %d\n",
>                                     ~~^
>                                     %d
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=lkft,MACHINE=intel-core2-32,label=docker-buster-lkft/1030/consoleText
>
> --
> Linaro LKFT
> https://lkft.linaro.org
