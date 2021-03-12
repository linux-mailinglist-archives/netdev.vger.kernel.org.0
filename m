Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DD8338FA0
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhCLOQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhCLOPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:15:54 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE7DC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:15:54 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id j2so4886159wrx.9
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gjPoNMZNSTzPXrAXZmjnLajknbd1LUti8Ev0FxxPAyE=;
        b=qRUlSd/fAe0tlUdL3YGDnfi4Q1pwqp1h0Qj3wmKd2V4BqBRdEdxUaqiIDXBLbaAsLo
         WkkgYFlEOxWzlfpf+fiRnRVrrMtMDwvd71CvUZUZwKbb42B/S5xLNi5m8jMLHgU9OfJw
         uZ5NrHvjgFQqLxGa4oB5lZZqesdMBEjkamm+2RBqAf2lfRg3HN8/yQaQCKspE+zbhNvp
         iR7rFepyZphJG8c9sXCWRwqcwRxEfTJ105ghCVN00Gc+fPT5qJd7OLs6jSyQzkolvJEl
         hxtl+jKBkY37/HukIZII+Ig9KQMb8Sx5pB0bYlexCOdMD0wlaB3FH79Ld5vrIvKsvwmM
         pjZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gjPoNMZNSTzPXrAXZmjnLajknbd1LUti8Ev0FxxPAyE=;
        b=MeSr4Hfdpgr08B7xlzesm5/3/M4t1xc9c5q+9Uqam0yG882Co38FGAub2aARBwDY4w
         p2+yD4mnysFrmSSvETpETF9Qge7EDbMDYZq1qXhsdnD6ehDJyU23e7R0eLQ3zXDUVVgy
         YyTqjuwrA5EWzxHglRV81oZzYedfsH2vGZfSkdSuhGwMrmwYHgkKDly55rwnkekkcXAa
         GLHL3/Y1lYQUyZiP4a+SS9mYfp2aIe7yBSwoA1NryytoiFymE9AHPeIUqsbhyF3rWN+x
         kjrqSCjrZt0ZVWX4QbF1L8lJXMhWRGilPWgcCoHQ+6d2mq56cgKs37pTBnWOB8exnAoV
         Dt8A==
X-Gm-Message-State: AOAM532NRoHxpuhuUcRJdQvxGfMQE4ZZO72e6lA9g0+m1s9ICKAyjaaJ
        4MY66O+6ngn3tI2sZV/tzV0=
X-Google-Smtp-Source: ABdhPJxqpfeAgwxtvHCKPGL+S2iu9NpdZr/Z3+03AtAPKp/EM44tifmeeSMt+WXUUExhH5+EeNXNLA==
X-Received: by 2002:a5d:4e83:: with SMTP id e3mr14345155wru.82.1615558553141;
        Fri, 12 Mar 2021 06:15:53 -0800 (PST)
Received: from [192.168.1.101] ([37.173.73.116])
        by smtp.gmail.com with ESMTPSA id c8sm579659wmb.34.2021.03.12.06.15.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 06:15:52 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: sock: simplify tw proto registration
To:     patchwork-bot+netdevbpf@kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, alexanderduyck@fb.com
References: <20210311025736.77235-1-xiangxia.m.yue@gmail.com>
 <161550780854.9767.12432124529018963233.git-patchwork-notify@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <30bd9ce2-24b7-d643-17aa-7a687652d30d@gmail.com>
Date:   Fri, 12 Mar 2021 15:15:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161550780854.9767.12432124529018963233.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/12/21 1:10 AM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (refs/heads/master):
> 
> On Thu, 11 Mar 2021 10:57:36 +0800 you wrote:
>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>
>> Introduce the new function tw_prot_init (inspired by
>> req_prot_init) to simplify "proto_register" function.
>>
>> tw_prot_cleanup will take care of a partially initialized
>> timewait_sock_ops.
>>
>> [...]
> 
> Here is the summary with links:
>   - [net-next,v2] net: sock: simplify tw proto registration
>     https://git.kernel.org/netdev/net/c/b80350f39370
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 

For some reason I see the patch in net tree, not in net-next

I wonder what happened.
