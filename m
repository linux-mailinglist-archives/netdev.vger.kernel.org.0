Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A41C403772
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbhIHKEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:04:44 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:45888 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbhIHKEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 06:04:15 -0400
Received: by mail-wr1-f41.google.com with SMTP id n5so2348720wro.12;
        Wed, 08 Sep 2021 03:03:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bppKmbeT5omixDkAwV5VX75Oyw3uE5XXr6lcDeM/RCw=;
        b=xcbX9Dyg3+xFkD2aiVwosIlG4MtzaAbD7QHPye1eqk1OwhhwWLGUi+/Rgig0BWGUza
         lGY/nF4CID2ijgtXHCGES/Go1YsYwDjTE4KvfPWM1M0h+1M8B893bxY1/jpiKznRAnr7
         4KvwAHBGbBC2T6KyuHJZ7d4sYmVNxoTZE1nT0bk2+obzDNsM5jsh+QJKiiUBmSsSbj9/
         9SM/1TOf5BU51zNnUUOMBtT3dqYatS84sKSNl44PqVc7jhM2OPP8sCCiG0XLfKSprkZz
         gsvYSNjIr940Y+HGI9tltuQze6576m28nuIhGzCejdGZtLeOJL4FUBEw3PzlJynaitKf
         xpZQ==
X-Gm-Message-State: AOAM531RWe2j7nC9KrRNIJmL4wKim3jv/phfs8zmj19jvR2Nw5tQModC
        cGY9EE2N+6bxqRFts9xW9Ymx1ofHvWE=
X-Google-Smtp-Source: ABdhPJwKMGsPUGI/psvQhbpr9QV5aFSDEK3FisaHG5BysW/q2LSnCyMwpS3nudif41VBV7Ci/RKZmg==
X-Received: by 2002:adf:ea90:: with SMTP id s16mr3040095wrm.235.1631095386823;
        Wed, 08 Sep 2021 03:03:06 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id x11sm1648796wro.83.2021.09.08.03.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 03:03:06 -0700 (PDT)
Date:   Wed, 8 Sep 2021 10:03:04 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
Message-ID: <20210908100304.oknxj4v436sbg3nb@liuwe-devbox-debian-v2>
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 07, 2021 at 04:14:24PM -0700, Linus Torvalds wrote:
> [ Added maintainers for various bits and pieces, since I spent the
> time trying to look at why those bits and pieces wasted stack-space
> and caused problems ]
> 
> On Tue, Sep 7, 2021 at 3:16 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
[...]
> 
> There are many more of these cases. I've seen Hyper-V allocate 'struct
> cpumask' on the stack, which is once again an absolute no-no that
> people have apparently just ignored the warning for. When you have
> NR_CPUS being the maximum of 8k, those bits add up, and a single
> cpumask is 1kB in size. Which is why you should never do that on
> stack, and instead use '
> 
>        cpumask_var_t mask;
>        alloc_cpumask_var(&mask,..)
> 
> which will do a much more reasonable job. But the reason I call out
> hyperv is that as far as I know, hyperv itself doesn't actually
> support 8192 CPU's. So all that apic noise with 'struct cpumask' that
> uses 1kB of data when NR_CPUS is set to 8192 is just wasted. Maybe I'm
> wrong. Adding hyperv people to the cc too.
> 
> A lot of the stack frame size warnings are hidden by the fact that our
> default value for warning about stack usage is 2kB for 64-bit builds.
> 
> Probably exactly because people did things like that cpumask thing,
> and have these arrays of structures that are often even bigger in the
> 64-bit world.
> 

Thanks for the heads-up. I found one instance of this bad practice in
hv_apic.c. Presumably that's the one you were referring to.

However calling into the allocator from that IPI path seems very heavy
weight. I will discuss with fellow engineers on how to fix it properly.

Wei.

>                 Linus
