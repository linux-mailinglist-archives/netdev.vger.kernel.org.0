Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F59E2CBD58
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387547AbgLBMvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgLBMvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:51:22 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A33C0613CF;
        Wed,  2 Dec 2020 04:50:41 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id o71so1506403ybc.2;
        Wed, 02 Dec 2020 04:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wZOsnLsRD15EE78n8bQEf+aUkvjzCWrGeOD2j6m7n7M=;
        b=Pz5K1LSqrNHi9j26JaHRbiUG9fIgZ88xbsQOpQuqNaY6to0gMZKA3gZJQkUb0wH5DZ
         m49l97B/Sqo285TY12ocrdpvuF1+g3C5wyRcsbz5oUmKsqn2e3S3KkpISid+6Jy9TPZJ
         Yhi5380lJNF1O7HhBn1xvlehBO23pu1N+bhGYtju8XUuq3mjQtYO7rQGT3bt/wyhJYu2
         nmqwt7PmuQulhc96znbjOdtX+q3UrUnUYeqP4ZRdx3XdbsSwYDKeQGZVsWKY8+j3ePUW
         6FnR5bBGkAJxjBXXLZqpT5MNdDiJQM0xvHspl+LDp7RWfzuVkEt8IC16/vlbOKXzJ2tq
         tkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wZOsnLsRD15EE78n8bQEf+aUkvjzCWrGeOD2j6m7n7M=;
        b=CmnNCMK67ydFsLA9BbYpFkJWXZoCHcqteHJmXxia+CbPGuDS2zvdFQEn/hX9wCxOCH
         bumwxa6Hh/jHeRw00dtgKM390Sq3yu4JhdJobYNit8kdoLZmVY2ck7oRpf5iuLF33Hnz
         ZXUt97vkWxGzwvEmmqugNOBAeSQ+cBkzE2/gTT01f4hTqclQoQZIHxXtGusYWMeo9qUO
         dS14rc6cU8FfkO6ytou2QlmCeYTKsprHENm0MtulM4LjADqcEls2Mh398WnHr9PMg+ud
         d4+1J+6MQz643X3mu37CbBPRgSat9jGGTQMAtd640FRs9ueWx7KGAWXg2gvZj+hL6ucp
         FH5g==
X-Gm-Message-State: AOAM5303PgBxLJNP0G4Mgv/DpeBv/GmpWmkwiHFcLWzzqrtFbuXcQmb9
        fxWr94Lfl+vrDcQUZXxLgSvLNMY+OPbFEl/yMZM=
X-Google-Smtp-Source: ABdhPJz8aVFXdWixZUHiWQB00VKrKgXW70L2NcuTpGtmUg1BcqQkFiV8/vapf4IM/PFZ+z2SfEViZMUjxnQAlGcdtd8=
X-Received: by 2002:a25:df55:: with SMTP id w82mr3065596ybg.135.1606913441319;
 Wed, 02 Dec 2020 04:50:41 -0800 (PST)
MIME-Version: 1.0
References: <20201128193335.219395-1-masahiroy@kernel.org>
In-Reply-To: <20201128193335.219395-1-masahiroy@kernel.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 2 Dec 2020 13:50:30 +0100
Message-ID: <CANiq72=WanQ0sqL14D3Keu0hT3L5GXBSV-znU5C9hhC1gjs=wA@mail.gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 8:34 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Revert commit cebc04ba9aeb ("add CONFIG_ENABLE_MUST_CHECK").
>
> A lot of warn_unused_result warnings existed in 2006, but until now
> they have been fixed thanks to people doing allmodconfig tests.
>
> Our goal is to always enable __must_check where appropriate, so this
> CONFIG option is no longer needed.
>
> I see a lot of defconfig (arch/*/configs/*_defconfig) files having:
>
>     # CONFIG_ENABLE_MUST_CHECK is not set
>
> I did not touch them for now since it would be a big churn. If arch
> maintainers want to clean them up, please go ahead.
>
> While I was here, I also moved __must_check to compiler_attributes.h
> from compiler_types.h
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Picked this new version with the Acks etc., plus I moved it within
compiler_attributes.h to keep it sorted (it's sorted by the second
column, rather than the first).

Thanks a lot!

Cheers,
Miguel
