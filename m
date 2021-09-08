Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89908403B3D
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 16:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348819AbhIHOMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 10:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbhIHOMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 10:12:46 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96326C061757
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 07:11:38 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id v16so2443385ilo.10
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 07:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h56N23KkijtRAG3ZoT0nWhy4eiurQamwjgFR6Q1Zg+4=;
        b=NOKQw41L5DOfpZAyRQKlcUeEgFvpXXMaWD//HYPx92A6Krj6OyBec9XvpKkZxxoIph
         U7ovtYxRF9YVOEtVZDBCOV8IWwdG4tMzL33AvhgD+LWu3967ogjFQbJNd37mhadh9W6E
         vczqWIwdigVtZhKjmb5iPfQJ+15JtKbK3tCng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h56N23KkijtRAG3ZoT0nWhy4eiurQamwjgFR6Q1Zg+4=;
        b=X6o0SISMJnyp8SBHSxmo6Qr7b72jSdYlBp/j00tNRvWiMpYGBObNfm8jejUVEByz7c
         y17GP0SDa0aDbnH+wkEzsvRVNOSlemU6/6sZL1hWFNfPHyZr085Gn+RkLpWrF4+HGNS7
         5OsJDHuv7ti0+TqJx/7Www7zr8ijF0BuRSNOlxhABerGvytPFpjvWmaFCabZeb2Yr7ph
         W1B2uCNEmdILfj4MCFbJz/fiLrpq/r0LBTwHvnptTfbpgXT22GZ0vtfNT510wlCQnQg/
         Cw2vIDa1J0ix79v5o15T/YzAv5yGBAO4tn10OMBxVZUr/zD3cbPxme1bQAWB3ElR67Qi
         1JWw==
X-Gm-Message-State: AOAM530Mmxb8oyQl5wVPzMJFuBbh5dRV4K3R75O5BdKBmylQbtGYf0Vt
        6xIuL2EZDy/ir2X+vVfalf9tBw==
X-Google-Smtp-Source: ABdhPJwIyKVaszB6vLEwTNN4bmc0KXCTddEw/AV2QK1CkXp+6dxaZ0tiGoQA7j+had8rESU69jxe6Q==
X-Received: by 2002:a05:6e02:78d:: with SMTP id q13mr53233ils.262.1631110297834;
        Wed, 08 Sep 2021 07:11:37 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id p11sm1171267ilm.61.2021.09.08.07.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 07:11:37 -0700 (PDT)
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
Date:   Wed, 8 Sep 2021 08:11:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/21 5:14 PM, Linus Torvalds wrote:
> [ Added maintainers for various bits and pieces, since I spent the
> time trying to look at why those bits and pieces wasted stack-space
> and caused problems ]
> 
> On Tue, Sep 7, 2021 at 3:16 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> None of these seem to be new.
> 
> That said, all but one of them seem to be (a) very much worth fixing
> and (b) easy to fix.
> 
> The do_tcp_getsockopt() one in tpc.c is a classic case of "lots of
> different case statements, many of them with their own struct
> allocations on stack, and all of them disjoint".
> 
> So the fix for that would be the traditional one of just making helper
> functions for the cases that aren't entirely trivial. We've done that
> before, and it not only fixes stack usage problems, it results in code
> that is easier to read, and generally actually performs better too
> (exactly because it avoids sparse stacks and extra D$ use)
> 
> The pe_test_uints() one is the same horrendous nasty Kunit pattern
> that I fixed in commit 4b93c544e90e ("thunderbolt: test: split up test
> cases in tb_test_credit_alloc_all") that had an even worse case.
> 
> The KUNIT macros create all these individually reasonably small
> initialized structures on stack, and when you have more than a small
> handful of them the KUNIT infrastructure just makes the stack space
> explode. Sometimes the compiler will be able to re-use the stack
> slots, but it seems to be an iffy proposition to depend on it - it
> seems to be a combination of luck and various config options.
> 

I have been concerned about these macros creeping in for a while.
I will take a closer look and work with Brendan to come with a plan
to address it.

> I detest code that exists for debugging or for testing, and that
> violates fundamental rules and causes more problems in the process.
> 

Having recently debugged a problem spinlock hold in an invalid context
related to debug code, I agree with you on this that test and debug code
shouldn't cause problems.

thanks,
-- Shuah

