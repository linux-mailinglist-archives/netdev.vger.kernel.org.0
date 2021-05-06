Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8E737542E
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 14:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhEFMzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 08:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhEFMz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 08:55:27 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDB8C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 05:54:29 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y32so4620395pga.11
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 05:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uqc1vLxpLPh61AnaojSMTi5WoOVCxWnFuOFiSHf5HI4=;
        b=p0ZjNxDrp6DQMcHp5BlfkCfnviNzPukWcCrOy5/uCwUZO5pPwiq1O6rIgxvcI08mSP
         SNEbAPdnCe/Pr9Or6Hk0+HbvE7hQUOGvRSkR5Mh3UdmWIzwuHctYSo5/l/1dPUuZJUN4
         CY0N1eqe+k5qBbzNTVUCQ4i4y+17E/CobU8O4KunF9oj+FPGku0iOnU3jrDziqknwdPA
         lTttiFPU95zeDe5+BcInnqo8xtqq86qUi/mjPGsjjRWzKFodMZAB42AGCDsP3MD+3H3n
         UMMzckE27FcfTnoJ5QJDLhnDuCGYqHNspu6HPi1hP7bUcko/tcwecOdpFznZHcqnLezh
         GpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uqc1vLxpLPh61AnaojSMTi5WoOVCxWnFuOFiSHf5HI4=;
        b=csWaRglUJezF7CtduUGn0kttGDxmMLByPVZQ7eCI8YDCb95LS29a3VmIn8kThbRnCV
         jG1VTCFa0gT9z4fgXMZPLIz6y3IYIxdxkYHCmMURjYSkmfV/Yy/LHPWutLnWDOoMqLfu
         rxDuDqZ7+AElOgQJtis9l4Tz0tQPsx4ZOIMtnWL5ctsk3gGa3vandka0H7KLSnWOPrjz
         B6DYXMj8pDsJnp113dXmlklmNFWd2lYETpPQl2HUIFxBD0g10B06wdgkJ7fxavNgEQR5
         AJ3+WLwn0fCufX426C65Mz0Xam3mT5UbgF4iUgZ9HuDz9R6zKTrFRGA5+tuzg6Ijjonf
         BoPw==
X-Gm-Message-State: AOAM533bMZS+JYr9zQKaLKFes94ewnL3GYlIKF4SXE1O3DiUr443OGXl
        MVOzrgevg6MjBfvxNyKNvy39IhQlZrjMH6FOCUw=
X-Google-Smtp-Source: ABdhPJz0OMT9qDSzsxb+HyrA4hnva/F+LbTRpjknaqvHRLzUNCzxmwI2N86CAgGoE8TTLnwtDbNJY8nmIZuZKKoZMnk=
X-Received: by 2002:a62:6544:0:b029:261:14cc:b11d with SMTP id
 z65-20020a6265440000b029026114ccb11dmr4387602pfb.12.1620305669186; Thu, 06
 May 2021 05:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210506231158.250926-1-yanjun.zhu@intel.com>
In-Reply-To: <20210506231158.250926-1-yanjun.zhu@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 6 May 2021 14:54:18 +0200
Message-ID: <CAJ8uoz2gd8xKd46Fq8numxS25Q68Gv-jtLqbWywLaztFCf=_jg@mail.gmail.com>
Subject: Re: [PATCH 1/1] samples: bpf: fix the compiling error
To:     Zhu Yanjun <yanjun.zhu@intel.com>
Cc:     Mariusz Dudek <mariuszx.dudek@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 8:47 AM Zhu Yanjun <yanjun.zhu@intel.com> wrote:
>
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
>
> When compiling, the following error will appear.
>
> "
> samples/bpf//xdpsock_user.c:27:10: fatal error: sys/capability.h:
>  No such file or directory
> "

On my system, I get a compilation error if I include
linux/capability.h as it does not have capget().

NAME
       capget, capset - set/get capabilities of thread(s)

SYNOPSIS
       #include <sys/capability.h>

       int capget(cap_user_header_t hdrp, cap_user_data_t datap);

Have you installed libcap? It contains the sys/capability.h header
file that you need.

> Now capability.h is in linux directory.
>
> Fixes: 3627d9702d78 ("samples/bpf: Sample application for eBPF load and socket creation split")
> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> ---
>  samples/bpf/xdpsock_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index aa696854be78..44200aa694cb 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -24,7 +24,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> -#include <sys/capability.h>
> +#include <linux/capability.h>
>  #include <sys/mman.h>
>  #include <sys/resource.h>
>  #include <sys/socket.h>
> --
> 2.27.0
>
