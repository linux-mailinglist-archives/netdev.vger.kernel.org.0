Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521FA4A47D3
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378076AbiAaNMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358421AbiAaNMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 08:12:21 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05198C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 05:12:21 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id k9so12667286qvv.9
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 05:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yk/hZJEK5aH8a04vWqCu+2I5aOFFiRB2QsnueOnHzl0=;
        b=l/E8NxnHxWIQMf5LX1/ZrvmSk35Np6ocVnQJoyJZtCUDotTRT74b9N903QoEktT11A
         0rV7/Vkf4Sjxcu8qi3HtPLy2Gdw9KRV/kcVbyLZSUO0h5Sln3lB0J2PAOCTT2tgkiZ4W
         HkpuBKPp2ZAxDysZmpzy4YIVe0miCaUkr1mKlL1dxQBOemDI+moU1wKYgDr5m+Amisz1
         SyTd02rY9fYWyL+m+rvZ1A/KeEsy1KdmehjO+IFHAbne3gq8bgXrZ8Mx14NxYvOTu8cC
         fuFb7GOm0mbKla8aLojHYD/RVa5CcNiOR5uIFz0bLnooY15tPW/IP1tP4pMi7loxQMnr
         QDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yk/hZJEK5aH8a04vWqCu+2I5aOFFiRB2QsnueOnHzl0=;
        b=zQWJZ8lYlK0hyC/PjCo6HQjJjHJpCdTP36mLms4wOPVXaY5kCeMJLPitLAkiksGc34
         oUg5jh5VMlfDpyOSITj99Rlf/ojuFAu7gcpfJ+M1gfm0RfZPosrRxmCWw1Qu7LW7wsod
         VeQzV9mCa1PSiQXR9nz20mnGVmIeosfJ2TBLTtZqlyBk6LSl+R1d4IxXTsGm+xLBi47G
         RwnxbLVSBoay+fZn3SNke3ml0BAA8K1Pe1+7hAdkU0zyCTxfrE1WOipfgmg76F5gN/40
         +bB9fXBksIk1Mj73mrTAIr8sBLtuMHyF4Nm1KTb4KjOiM8LfLKXyF9Aqk8Ac+7Fxs5cq
         rCfQ==
X-Gm-Message-State: AOAM532HAqMpalxgtd12DL6x8ma0EDRDIA5z6McXcG9IOENwx2lnLfAj
        9r9fuBgpnC7bL9G8kk4g8qF5wg==
X-Google-Smtp-Source: ABdhPJxXM6i4nOiOMis1ZjihvfUEaeKtrwcZRBNbMqMJGbmuATsPKJWAjYSyVMhAwfKKICiHaLlziA==
X-Received: by 2002:a05:6214:d6a:: with SMTP id 10mr17213162qvs.59.1643634740124;
        Mon, 31 Jan 2022 05:12:20 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id w14sm8841481qtc.29.2022.01.31.05.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 05:12:19 -0800 (PST)
Message-ID: <a2ecd27f-f5b5-0de4-19df-9c30671f4a9f@mojatatu.com>
Date:   Mon, 31 Jan 2022 08:12:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
Content-Language: en-US
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com>
 <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-26 14:52, Cong Wang wrote:
> You really should just use eBPF, with eBPF code you don't even need
> to send anything to upstream, you can do whatever you want without
> arguing with anyone. It is a win-win.

Cong,

This doesnt work in some environments. Example:

1) Some data centres (telco large and medium sized enteprises that
i have personally encountered) dont allow for anything that requires
compilation to be introduced (including ebpf).
They depend on upstream - if something is already in the kernel and
requires a script it becomes an operational issue which is a simpler
process.
This is unlike large organizations who have staff of developers
dedicated to coding stuff. Most of the folks i am talking about
have zero developers in house. But even if they did have a few,
introducing code into the kernel that has to be vetted by a
multitude of internal organizations tends to be a very
long process.

2) In some cases adding new code voids the distro vendor's
support warranty and you have to pay the distro vendor to
vet and put your changes via their regression testing.
Most of these organizations are tied to one or other distro
vendor and they dont want to mess with the warranty or pay
extra fees which causes more work for them (a lot of them
have their own vetting process after the distro vendors vetting).

I am not sure what the OP's situation is - but what i described
above is _real_. If there is some extension to existing features like
skbedit and there is a good use case IMO we should allow for it.

cheers,
jamal
