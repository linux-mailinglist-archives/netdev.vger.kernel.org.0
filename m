Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060D6381A08
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 18:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhEOQ7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 12:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhEOQ7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 12:59:47 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F071CC061573;
        Sat, 15 May 2021 09:58:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k10so2982020ejj.8;
        Sat, 15 May 2021 09:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=on/6xZCIaJvpMROmrp4eRzeLAabPNhtVrx6dFCuT2lk=;
        b=e8/vbb43yCbzHOadD5bO8RpHIe1t+OA+zJrcpmlbbZwQ+wW5rLk1JJnTbIxHhCV6FG
         XSblTExamToYMXLT2kguSziT1YpaNO8U64M5cGNSehhZhzSHU5WhNaEsq1JYwPvNmDd5
         Wc0Dhq9dLKw+bpRW8KAzSbNZLBd5HL1L6aOp18vkLEq2r/A8XAO4/m/HEBZwC7GpOlJb
         874yMAA2ReY+htqQv2biA0IgTSfdNZvU4P+IDyqKDwtTiMEvYISfrk4LkRp+hgPVQVYy
         82uSs1+jiiUfOgS4l+LH+pZE4w0k4j0NBxDFBzorgKT92MXPq3cg1eoPsM4nrAQ9vgot
         LOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=on/6xZCIaJvpMROmrp4eRzeLAabPNhtVrx6dFCuT2lk=;
        b=owZ2Seja/81SZhk1XryxHNnwxpZdCOvTS5qX9TnOhNomHkOqrtv/sQo3iOFCIFFmpe
         mCSnPbbTonVymvbPeaJTMrdaWKpW/Qt7IaItJdae9Wldnd5K2SFqAdfBDjA0GSyzVmKx
         pKF/XQgoedJMTZxFE83qMshEt21hxl9Q1d2rth2Idedk1Kvft+2ouFsrX4puHxe/mTSj
         G5POt6A8ioCOkncBWOTevJa4vWD37SHjdpI9JWkEBKwI/eTCEuAL/Epb6QjpHo4xrkzy
         Q7UGXzB58FkLr1HR7ACnTdyS96sYsmWxER9GN9wHCIeyesqqJzgD1gWqPBS2uQ3MAOTF
         VdiA==
X-Gm-Message-State: AOAM532Uuh8d479iMrMYiHTWO8EM4BzWt97mWGp+K20TmBoL12l4lHUa
        REQ03vWJfJxTGkXqbw3oyQU=
X-Google-Smtp-Source: ABdhPJwhthevKP5yGoOzZj4wlifyRwLYXyNGAErQk8mjcxmNXjfNVYR+EE8Mph1cBInnfRn9fsDKPQ==
X-Received: by 2002:a17:906:64c3:: with SMTP id p3mr24496673ejn.351.1621097911671;
        Sat, 15 May 2021 09:58:31 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id i8sm7291715edu.64.2021.05.15.09.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 09:58:30 -0700 (PDT)
Date:   Sat, 15 May 2021 18:58:28 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        Peter Korsgaard <peter@korsgaard.com>
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YJ/9tBaZmw4UkI2t@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508064925.8045-1-heiko.thiery@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

[ Cc Petr (Buildroot maintainer) ]
> With commit d5e6ee0dac64 the usage of functions name_to_handle_at() and
> open_by_handle_at() are introduced. But these function are not available
> e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> availability in the configure script and in case of absence do a direct
> syscall.

> Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
> Cc: Dmitry Yakunin <zeil@yandex-team.ru>
> Cc: Petr Vorel <petr.vorel@gmail.com>
> Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> ---
> v3:
>  - use correct syscall number (thanks to Petr Vorel)
>  - add #include <sys/syscall.h> (thanks to Petr Vorel)
>  - remove bogus parameters (thanks to Petr Vorel)
>  - fix #ifdef (thanks to Petr Vorel)
>  - added Fixes tag (thanks to David Ahern)
>  - build test with buildroot 2020.08.3 using uclibc 1.0.34
I tested it to some extent. I was not able to test it on buildroot uclibc:
$ ss -a --cgroup # I put debugging printf
ss.c:3336 inet_show_sock(): tb[INET_DIAG_CGROUP_ID]: (nil), INET_DIAG_CGROUP_ID: 21

I tried mount both cgroup (with cgroupfs-mount) and cgroup2 (using mount).

But it's hard to trigger this code also on regular linux distro with glibc:

$ ss --cgroup -a >/dev/null
Failed to open cgroup2 by ID
Failed to open cgroup2 by ID
Failed to open cgroup2 by ID
Failed to open cgroup2 by ID
Failed to open cgroup2 by ID
Failed to open cgroup2 by ID

Debugging when replacing glibc wrapper with these functions calling raw syscall
it works the same (i.e. "Failed to open cgroup2 by ID")

Thus:
Tested-by: Petr Vorel <petr.vorel@gmail.com>
(to my previous Reviewed-by: tag).

Hope David Ahern send his patch for config.mk dependency to configure,
as his fragment [1] LGTM.

Kind regards,
Petr

[1] https://lore.kernel.org/netdev/82c9159f-0644-40af-fb4c-cc8507456719@gmail.com/
