Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1A939CF70
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 16:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFFOF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 10:05:56 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:41846 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbhFFOFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 10:05:54 -0400
Received: by mail-ed1-f45.google.com with SMTP id g18so14899836edq.8
        for <netdev@vger.kernel.org>; Sun, 06 Jun 2021 07:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b4c747gVVUeFGvEkL88SOA88WVgLdSzPl8IcZCu5wHI=;
        b=Fghh0OseWdvguktw7ng08F+5hjKMi1WZDm1vbtqgmgOC7V5qVrVHo3V3B1uaXTe/+Z
         eljehm1vkz5n3F8XTid920Q8eiyvTYUFPkx1rujXASuTMi/68Rufo1s5dqLvrpOoMmFd
         LXKQtdEuc7r9sEfUTTzxhQNggOmiJX9/IQtC/gYtQN+vTrJTVfp+EbpyIJp9kumZHa8J
         RTMY89U9yWPm90Vyh+xBEAbhNYpVghE47Zcp5WJgXSTHO8lLv+Suih06HhooZZKZSawu
         IRhdFOV4+9qXEDy9a1WHFJsbVxWrGG+HXwEUOTeDm5R718VbZ7eYzHdSYC5ZYLjvBnzu
         ZvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b4c747gVVUeFGvEkL88SOA88WVgLdSzPl8IcZCu5wHI=;
        b=K01PzTDlB83wpwpwKmTXYaYv/tQAcN+Reop6KNBlAXp9CD4qbs2+QTR9pkBrJNuhhD
         zTRVUXf9IfsGef6AjwZopMjupblJO8BTH4jGYMeJVtLssLT6yVzC54LM3Fo8MaPHy3S/
         mSqK1IlpxhYdvbgzb9YDVbwoPQ+mynKtE6WZyYE/GW47fGiybXuU2oMIeGfcET+hqANa
         InAe2JnRw/Nq7gDUvSMajeVE68vfb/eH7N0ynHOjDSAS4FpJ10YgdnWeZKhSbrBPVlot
         1gUrj2O9k2xaLwxP8fM7ob8Lguhks12l5KExioSjoKlRXlNS/C2oWlEezKSgojhJbv7h
         FAhg==
X-Gm-Message-State: AOAM533EkJo2RbDeMUB2/o/rnKaty4gJy3w3ES2FXCJHwXB3ObTcILlF
        TmgU/8rN2+uyJ+0H0sF4sOA=
X-Google-Smtp-Source: ABdhPJxEtSUy2jxNx3Zy+uIGWHAI/NJ+1VvjiXXjJGjq/0efe67htA3WKzQb0MWqm24nZJyPhQzyJw==
X-Received: by 2002:a05:6402:175b:: with SMTP id v27mr15289055edx.61.1622988171740;
        Sun, 06 Jun 2021 07:02:51 -0700 (PDT)
Received: from [192.168.0.108] ([77.124.85.114])
        by smtp.gmail.com with ESMTPSA id q4sm6372899edv.24.2021.06.06.07.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 07:02:51 -0700 (PDT)
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
 <ee795e24-b430-a5f4-39c4-8586f2dc45a6@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <fe48e571-7936-9c92-fdeb-9e83a1e27133@gmail.com>
Date:   Sun, 6 Jun 2021 17:02:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <ee795e24-b430-a5f4-39c4-8586f2dc45a6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2021 1:49 PM, Tariq Toukan wrote:
> 
> 
> On 5/27/2021 8:56 PM, Jakub Kicinski wrote:
>> On Thu, 27 May 2021 17:07:06 +0300 Tariq Toukan wrote:
>>> On 5/27/2021 3:47 AM, Jakub Kicinski wrote:
>>>> On Wed, 26 May 2021 12:57:41 +0300 Tariq Toukan wrote:
>>>>> This RFC series suggests a solution for the following problem:
>>>>>
>>>>> Bond interface and lower interface are both up with TLS RX/TX 
>>>>> offloads on.
>>>>> TX/RX csum offload is turned off for the upper, hence RX/TX TLS is 
>>>>> turned off
>>>>> for it as well.
>>>>> Yet, although it indicates that feature is disabled, new 
>>>>> connections are still
>>>>> offloaded by the lower, as Bond has no way to impact that:
>>>>> Return value of bond_sk_get_lower_dev() is agnostic to this change.
>>>>>
>>>>> One way to solve this issue, is to bring back the Bond TLS 
>>>>> operations callbacks,
>>>>> i.e. provide implementation for struct tlsdev_ops in Bond.
>>>>> This gives full control for the Bond over its features, making it 
>>>>> aware of every
>>>>> new TLS connection offload request.
>>>>> This direction was proposed in the original Bond TLS 
>>>>> implementation, but dropped
>>>>> during ML review. Probably it's right to re-consider now.
>>>>>
>>>>> Here I suggest another solution, which requires generic changes out 
>>>>> of the bond
>>>>> driver.
>>>>>
>>>>> Fixes in patches 1 and 4 are needed anyway, independently to which 
>>>>> solution
>>>>> we choose. I'll probably submit them separately soon.
>>>>
>>>> No opinions here, semantics of bond features were always clear
>>>> as mud to me. What does it mean that bond survived 20 years without
>>>> rx-csum? And it so why would TLS offload be different from what one
>>>> may presume the semantics of rx-csum are today?
>>>
>>> Advanced device offloads have basic logical dependencies, that are
>>> applied for all kind of netdevs, agnostic to internal details of each
>>> netdev.
>>>
>>> Nothing special with TLS really.
>>> TLS device offload behaves similarly to TSO (needs HW_CSUM), and GRO_HW
>>> (needs RXCSUM).
>>> [...]
>>
>> Right, the inter-dependency between features is obvious enough.
>> What makes a feature be part of UPPER_DISABLES though?
>>
> 
> Regarding UPPER_DISABLES:
> I propose using it here as an attempt to give the bond device some 
> control over kTLS offloaded connections, to avoid cases where:
> (*) UPPER.ktls_device_offload==OFF
> (*) LOWER.ktls_device_offload==ON
> (*) Newly created connections are offloaded!! Simply ignoring and 
> bypassing the UPPER device state (this is how .ndo_sk_get_lower_dev works).
> 
> This is not my preferred solution though.
> I think we should reconsider introducing bond implementation for "struct 
> tlsdev_ops" callbacks, which gives bond interface full control and 
> awareness to new TLS connections.

If you're fine with the direction, I can prepare a new series that adds 
"struct tlsdev_ops" callbacks implementation for bond, instead of the 
"UPPER_DISABLES solution" above.

What do you think?
