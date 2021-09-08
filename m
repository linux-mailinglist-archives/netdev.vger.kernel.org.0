Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7105A403D69
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 18:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347729AbhIHQN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 12:13:28 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:36405 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhIHQN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 12:13:27 -0400
Received: by mail-wr1-f42.google.com with SMTP id g16so4135908wrb.3;
        Wed, 08 Sep 2021 09:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R1V00rL3dMr2J4zT62rZi14Y7GO7EsmbyQDqyX63/HM=;
        b=7Xeb0cdPwAiRdkB6mtPPiEj9MbBPmGVbx+LzknxUNRO37gb2FbcIC2iEI4w5gCwfx7
         SfwryGKtyZfaAZH2Oo9cls1+0TbL8EtzaD8DSOiYwKukcbcMazAwbo5aBQuqfLF7TBap
         iwLZ2/39c8ldVr/mtB1XJP6FpR8tN8i3OMJPv78Dkr6Hr1GVEKADBZJ3/PFoka5cmgPG
         1i5GWtiq0ebBrDXyPnU9dAwIoZPz8GYsvykx4Y6nvHpNDnSQEpmOlnEZaMREUvkcjAio
         CJvmLeDVMDzJx1cTrfEY4T84+juNiYpYt2UGVFSN8xUN3BtAuanYYHhx8JdpkAJ2rQkw
         V1Lw==
X-Gm-Message-State: AOAM531t7HVoDnnP/NZh1P50hK2ZRgXbl9FtvcFQheA1HdECqDLyY5an
        oDAo0AkHN823V9RrcFRoZAI=
X-Google-Smtp-Source: ABdhPJzp9ogCF+MFeecKDsCzXJOLtuxlq+uxNf8hwf+v4+O6b1Jwh6UK8cA2zlupPlyKZO23JSh6rg==
X-Received: by 2002:adf:f507:: with SMTP id q7mr4971172wro.7.1631117538860;
        Wed, 08 Sep 2021 09:12:18 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id p5sm2795750wrd.25.2021.09.08.09.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 09:12:18 -0700 (PDT)
Date:   Wed, 8 Sep 2021 16:12:16 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Wei Liu <wei.liu@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
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
Message-ID: <20210908161216.jn3ppqslnavhjr4z@liuwe-devbox-debian-v2>
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <20210908100304.oknxj4v436sbg3nb@liuwe-devbox-debian-v2>
 <CAHk-=wgMyCaFMybdQRJYJLbbbv5S2UHsU3oQ+CBRyYkvjmR=hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgMyCaFMybdQRJYJLbbbv5S2UHsU3oQ+CBRyYkvjmR=hA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 08:59:36AM -0700, Linus Torvalds wrote:
> On Wed, Sep 8, 2021 at 3:03 AM Wei Liu <wei.liu@kernel.org> wrote:
> >
> > Thanks for the heads-up. I found one instance of this bad practice in
> > hv_apic.c. Presumably that's the one you were referring to.
> 
> Yeah, that must have been the one I saw.
> 
> > However calling into the allocator from that IPI path seems very heavy
> > weight. I will discuss with fellow engineers on how to fix it properly.
> 
> In other places, the options have been fairly straightforward:
> 
>  (a) avoid the allocation entirely.
> 
> I think the main reason hyperv does it is because it wants to clear
> the "current cpu" from the cpumask for the ALL_BUT_SELF case, and if
> you can just instead keep track of that "all but self" bit separately
> and pass it down the call chain, you may not need that allocation at
> all.
[..]
> 
> That said, if you are already just iterating over the mask, doing (a)
> may be trivial. No allocation at all is even better than a percpu one.
> 

Yep. I just wrote two patches for this approach.

Wei.
