Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557B239507D
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 12:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhE3Kux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 06:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhE3Kuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 06:50:52 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2069DC061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 03:49:13 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lz27so12087608ejb.11
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 03:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+FkjhQC32yrsg7HxjUG5H1t5QdKbYe6r9Ev1B8lg5bQ=;
        b=mfOi9YVv47yAxXOqSN9Cw1XCZ8N4uh1k7gocAHFE2T/hT4aOiVSajVIx/TblLUsXzE
         5GXvs1+iPEJg6qXipDyBn4/xPohWJBFZl9EM7hhb4uyWtMCkjfVQ5J8FLnUeQbVBfmma
         7rF4kL2Kn2f11mI2Knp2sT/kvHjIKq3OJLbz7+jnvrL+j6lx4vCPPQrjBnBNCqz61rIy
         18NXPL39w62TAkeIoMBkdx7/l57fU1a9IUlerj9pNoibE8R8eyy8DoiH9carD77NDxol
         xep8F1wzLmEjBlfkc1mCT7K4CGIoncMlFiiSeJ3PhcX0JXv8Bn2Z6mesP0WrxkIiio/7
         Gx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+FkjhQC32yrsg7HxjUG5H1t5QdKbYe6r9Ev1B8lg5bQ=;
        b=uCzwr0XKijxnsZW/E/bFyAVUkMnkW66BC5/oKUZEnyiFTw+kNDDSqzqrduGeSklZC5
         i16Y7VYunj2tE1kij2w7McVPXI34sjBuy3sO8qlnZpLr0AsRNqIZ/WQEmh8oEEiH2TkR
         DBvx4EPd0lmxWAEV4gSV9NF/4jSQWzLfB6gypJGA698rXHh7ZwfAN+u8DV05X2Wdxu3g
         2CCvgdZsFZGWVk7Wg1/MGYSOxREVN0/wnGxFjf0aFmhWrrhffFiZi/vBw6je8IIJ6wpH
         UKwfhYHw85/t+npTS0aJs+QUq+BuHZ5F2FGjjHbx95UNgZRKzjcQpivGbEzQB/DG/AKh
         CzCQ==
X-Gm-Message-State: AOAM53081R1IaJrONR09Ei4e/C2guBXzYdEik+wMkuZYGY3p4i//8ySU
        xTUCoDyF8dYZys3zh/GvbfA6+87k03k=
X-Google-Smtp-Source: ABdhPJw6dYzj1SRkA9l/mVt1e8yU9yrrjjq3YJxoGcQDONci3Gm9Vf77LU3408FUYkBMyNjAA5RnfQ==
X-Received: by 2002:a17:906:488f:: with SMTP id v15mr6803805ejq.428.1622371751724;
        Sun, 30 May 2021 03:49:11 -0700 (PDT)
Received: from [192.168.0.108] ([77.124.85.114])
        by smtp.gmail.com with ESMTPSA id u15sm318269edy.29.2021.05.30.03.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 May 2021 03:49:11 -0700 (PDT)
Subject: Re: [RFC PATCH 0/6] BOND TLS flags fixes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
 <20210526174714.1328af13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8182c05b-03ab-1052-79b8-3cdf7ab467b5@gmail.com>
 <20210527105034.5e11ebef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <ee795e24-b430-a5f4-39c4-8586f2dc45a6@gmail.com>
Date:   Sun, 30 May 2021 13:49:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210527105034.5e11ebef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2021 8:56 PM, Jakub Kicinski wrote:
> On Thu, 27 May 2021 17:07:06 +0300 Tariq Toukan wrote:
>> On 5/27/2021 3:47 AM, Jakub Kicinski wrote:
>>> On Wed, 26 May 2021 12:57:41 +0300 Tariq Toukan wrote:
>>>> This RFC series suggests a solution for the following problem:
>>>>
>>>> Bond interface and lower interface are both up with TLS RX/TX offloads on.
>>>> TX/RX csum offload is turned off for the upper, hence RX/TX TLS is turned off
>>>> for it as well.
>>>> Yet, although it indicates that feature is disabled, new connections are still
>>>> offloaded by the lower, as Bond has no way to impact that:
>>>> Return value of bond_sk_get_lower_dev() is agnostic to this change.
>>>>
>>>> One way to solve this issue, is to bring back the Bond TLS operations callbacks,
>>>> i.e. provide implementation for struct tlsdev_ops in Bond.
>>>> This gives full control for the Bond over its features, making it aware of every
>>>> new TLS connection offload request.
>>>> This direction was proposed in the original Bond TLS implementation, but dropped
>>>> during ML review. Probably it's right to re-consider now.
>>>>
>>>> Here I suggest another solution, which requires generic changes out of the bond
>>>> driver.
>>>>
>>>> Fixes in patches 1 and 4 are needed anyway, independently to which solution
>>>> we choose. I'll probably submit them separately soon.
>>>
>>> No opinions here, semantics of bond features were always clear
>>> as mud to me. What does it mean that bond survived 20 years without
>>> rx-csum? And it so why would TLS offload be different from what one
>>> may presume the semantics of rx-csum are today?
>>
>> Advanced device offloads have basic logical dependencies, that are
>> applied for all kind of netdevs, agnostic to internal details of each
>> netdev.
>>
>> Nothing special with TLS really.
>> TLS device offload behaves similarly to TSO (needs HW_CSUM), and GRO_HW
>> (needs RXCSUM).
>> [...]
> 
> Right, the inter-dependency between features is obvious enough.
> What makes a feature be part of UPPER_DISABLES though?
> 

Regarding UPPER_DISABLES:
I propose using it here as an attempt to give the bond device some 
control over kTLS offloaded connections, to avoid cases where:
(*) UPPER.ktls_device_offload==OFF
(*) LOWER.ktls_device_offload==ON
(*) Newly created connections are offloaded!! Simply ignoring and 
bypassing the UPPER device state (this is how .ndo_sk_get_lower_dev works).

This is not my preferred solution though.
I think we should reconsider introducing bond implementation for "struct 
tlsdev_ops" callbacks, which gives bond interface full control and 
awareness to new TLS connections.
